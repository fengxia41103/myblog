#!/usr/bin/env python3
"""mail-cleanup — move "junk sender" emails to each account's trash, safely.

It queries messages via ``mu find``, moves each matched file into the SAME
account's ``trash/cur`` with the maildir ``T`` (trashed) flag, then re-indexes.
Because ``~/.mbsyncrc`` uses ``Expunge Both``, a later ``mbsync`` (or mu4e ``u``)
removes them from the Gmail/Hotmail servers too.

Senders are configured in an external YAML file (``mail-cleanup.yaml`` next to
this script by default, or ``--config PATH``), so you can add/remove rules
without editing code.

SAFETY
  * Default is DRY-RUN. Pass ``--apply`` to actually move files.
  * Refuses to run while a real ``mu server`` holds the DB lock
    (quit mu4e first: ``M-x mu4e-quit``). Until you sync & expunge, moved
    messages stay recoverable in each account's local trash.
  * Every applied run writes a timestamped recovery list of moved paths.

USAGE
  mail-cleanup.py                 # dry-run: show what WOULD move
  mail-cleanup.py --apply         # move + re-index
  mail-cleanup.py --list          # print configured rules and exit
  mail-cleanup.py --config PATH   # use a specific config file
"""
from __future__ import annotations

import argparse
import datetime as _dt
import os
import re
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("error: PyYAML is required (pip install pyyaml)")

HERE = Path(__file__).resolve().parent
DEFAULT_CONFIG = HERE / "mail-cleanup.yaml"

# Match any account's trash/deleted folder so already-trashed mail is skipped.
_TRASH_RE = re.compile(r"/(trash|Trash|Deleted[^/]*)/(cur|new|tmp)/")
# Extract the account name: .../Maildir/<account>/...
_ACCT_RE = re.compile(r".*/Maildir/([^/]+)/.*")


def load_config(path: Path) -> dict:
    if not path.exists():
        sys.exit(f"error: config not found: {path}")
    with path.open() as fh:
        data = yaml.safe_load(fh) or {}
    if "rules" not in data or not isinstance(data["rules"], list):
        sys.exit(f"error: config must contain a 'rules:' list — {path}")
    return data


def mu_server_running() -> bool:
    """True if a real ``mu server`` process is active (holds the DB lock).

    Match on the process *comm* (executable name) == 'mu', NOT the full
    command line, to avoid matching this script's own arguments.
    """
    try:
        out = subprocess.run(
            ["ps", "-eo", "comm,args"], capture_output=True, text=True, check=False
        ).stdout
    except FileNotFoundError:
        return False
    for line in out.splitlines():
        parts = line.split(None, 1)
        if len(parts) == 2 and parts[0] == "mu" and "server" in parts[1]:
            return True
    return False


def mu_find(mu_bin: str, query: str) -> list[str]:
    res = subprocess.run(
        [mu_bin, "find", query, "--fields", "l"],
        capture_output=True, text=True, check=False,
    )
    # mu exits non-zero when a query matches nothing; that's fine.
    if res.returncode not in (0, 4):
        # 4 == "no matches" in mu; anything else worth surfacing on stderr.
        if res.stderr.strip():
            print(f"  (mu warning for {query!r}: {res.stderr.strip()})",
                  file=sys.stderr)
    return [ln for ln in res.stdout.splitlines() if ln.strip()]


def collect(mu_bin: str, rules: list[str]) -> list[str]:
    seen: set[str] = set()
    for q in rules:
        for path in mu_find(mu_bin, q):
            if _TRASH_RE.search(path):
                continue
            seen.add(path)
    return sorted(seen)


def trash_target(maildir: Path, src: str) -> Path | None:
    m = _ACCT_RE.match(src)
    if not m:
        return None
    acct = m.group(1)
    base = os.path.basename(src)
    if ":2," in base:
        uniq, flags = base.split(":2,", 1)
    else:
        uniq, flags = base, ""
    # unique, sorted flag set including T
    newflags = "".join(sorted(set(flags + "T")))
    return maildir / acct / "trash" / "cur" / f"{uniq}:2,{newflags}"


def apply_moves(maildir: Path, files: list[str], log: Path) -> tuple[int, int, int]:
    moved = skipped = err = 0
    with log.open("w") as lf:
        for src in files:
            if not os.path.isfile(src):
                skipped += 1
                continue
            dest = trash_target(maildir, src)
            if dest is None:
                err += 1
                print(f"ERR (no account match): {src}", file=sys.stderr)
                continue
            dest.parent.mkdir(parents=True, exist_ok=True)
            if dest.exists():
                skipped += 1
                continue
            try:
                os.rename(src, dest)
                lf.write(f"{src}\t{dest}\n")
                moved += 1
            except OSError as e:
                err += 1
                print(f"ERR moving {src}: {e}", file=sys.stderr)
    return moved, skipped, err


def by_account(files: list[str]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for f in files:
        m = _ACCT_RE.match(f)
        acct = m.group(1) if m else "?"
        counts[acct] = counts.get(acct, 0) + 1
    return counts


def main() -> int:
    ap = argparse.ArgumentParser(description="Move junk-sender mail to trash safely.")
    ap.add_argument("--apply", action="store_true", help="actually move files (default: dry-run)")
    ap.add_argument("--list", action="store_true", help="print configured rules and exit")
    ap.add_argument("--config", type=Path, default=DEFAULT_CONFIG, help="path to YAML config")
    args = ap.parse_args()

    cfg = load_config(args.config)
    rules: list[str] = [str(r) for r in cfg["rules"]]

    if args.list:
        for r in rules:
            print(r)
        return 0

    mu_bin = str(cfg.get("mu_binary") or os.environ.get("MU_BIN", "/usr/local/bin/mu"))
    maildir = Path(os.path.expanduser(cfg.get("maildir") or os.environ.get("MAILDIR", "~/Maildir")))
    logdir = Path(os.path.expanduser(cfg.get("log_dir") or "~"))

    if mu_server_running():
        print("ERROR: a 'mu server' is running (mu4e holds the DB lock).", file=sys.stderr)
        print("       In Emacs run:  M-x mu4e-quit   then re-run this script.", file=sys.stderr)
        return 1

    files = collect(mu_bin, rules)
    total = len(files)
    print(f"Matched {total} message(s) across {len(rules)} rule(s).")
    if total:
        print("By account:")
        for acct, n in sorted(by_account(files).items()):
            print(f"  {n:>6}  {acct}")

    if total == 0:
        print("Nothing to do.")
        return 0

    if not args.apply:
        print("\nDRY-RUN. No files moved. Re-run with --apply to move them to trash.")
        return 0

    stamp = _dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = logdir / f"mail-cleanup-{stamp}.list"
    moved, skipped, err = apply_moves(maildir, files, log)
    print(f"Moved: {moved}   Skipped: {skipped}   Errors: {err}")
    print(f"Recovery list: {log}")

    print("Re-indexing...")
    subprocess.run([mu_bin, "index"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, check=False)
    print("Done. In mu4e press 'u' (or M-x mu4e-update-mail-and-index) to sync &")
    print("expunge from the servers. Until then, messages remain in local trash.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
