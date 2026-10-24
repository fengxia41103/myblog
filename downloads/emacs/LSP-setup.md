# Emacs LSP setup

Captured 2026-10-24. This documents how Language Server Protocol (LSP)
support is wired in `emacs_setup.org`, which servers back each language,
and how to reproduce the setup on a fresh machine.

## Architecture

```
  emacs buffer (js2/python/java/c/css/html/web/yaml)
        |  mode hook -> lsp-deferred / lsp
        v
  lsp-mode  ----- talks JSON-RPC ----->  external language server
     |                                   (typescript-language-server,
     |  UI/eldoc/sideline                 pylsp, jdtls, clangd, ...)
     +--> lsp-ui (hover docs, imenu)
     +--> company (completion frontend)
     +--> flycheck (diagnostics)
     +--> lsp-treemacs (symbols/errors tree)
     +--> which-key (keymap discovery)
```

- `lsp-mode` is the core client. It starts **deferred** (`lsp-deferred`)
  from each language's mode hook, so a server only launches when you
  open a relevant file.
- Completion is via `company`; diagnostics via `flycheck`; richer UI
  (hover docs, imenu, sideline) via `lsp-ui`.
- `lsp-treemacs` gives a tree view of symbols/errors; `dap-mode` (Java
  debugging) is currently **commented out** in the config.

## Emacs packages (installed via use-package `:ensure`)

| Package       | Role                                            |
|---------------|-------------------------------------------------|
| lsp-mode      | core LSP client                                 |
| lsp-ui        | hover docs, imenu, sideline (sideline disabled) |
| lsp-treemacs  | symbol/error tree integration                   |
| lsp-java      | Java support (JDT language server, auto-install)|
| company       | completion frontend                             |
| flycheck      | on-the-fly diagnostics                          |
| which-key     | shows available `C-c l ...` bindings            |
| dap-mode      | debugger (currently disabled/commented out)     |

## Keybindings

| Key        | Command                  | Scope            |
|------------|--------------------------|------------------|
| `C-c l`    | lsp command prefix       | lsp-mode buffers |
| `M-<RET>`  | lsp-execute-code-action  | lsp-mode-map     |
| `C-c i`    | lsp-ui-imenu             | lsp-ui-mode-map  |
| `C-c d`    | lsp-ui-doc-glance        | js2-mode-map     |

`which-key` will surface the full `C-c l` menu (rename, find refs,
format, etc.) when you press the prefix.

## Containerized servers (lsp-docker) — current approach

As of 2026-10-24 the language servers run from a **single pinned Docker
image** instead of host installs, via the `lsp-docker` package. This keeps
`$HOME` clean and makes the servers **immune to `nvm use <version>`** (the
JS/TS/CSS/HTML servers run on the image's own pinned Node, so switching the
host Node no longer breaks LSP).

- **Image source:** `~/workspace/me/dev/lsp/` (Dockerfile + `docker-compose.yml`
  + `jdtls-stdio` wrapper). Build with `docker compose build` in that folder;
  the image is tagged `lsp-langservers:1`. See that folder's `README.md`.
- **Emacs config:** section *lsp-docker (containerized language servers)* in
  `emacs_setup.org`, right after `** lsp`. It calls `lsp-docker-init-clients`
  with:
  - `:docker-image-id "lsp-langservers:1"`,
  - `:path-mappings` using an **identical** host/container path
    (`~/workspace/me/dev`) so `file://` URIs resolve,
  - modern server commands overriding lsp-docker's stale
    `css-languageserver` / `html-languageserver` defaults,
  - a `jdtls` client (lsp-docker ships none) calling `jdtls-stdio`.
- **Toggle:** set `my/lsp-use-docker` to `nil` to fall back to host servers.
- **Servers in image (verified via LSP `initialize` handshake):** pylsp 1.12.0,
  typescript-language-server 5.1.3, vscode-css/html/json/eslint-language-server,
  jdtls 1.49.0 (JDK 17), bash-language-server.

> The per-machine host-install table below is retained for reference / the
> non-container fallback path.

## Per-language status

Hooks in `lsp-mode`'s `:hook` enable LSP for: css, html, web, js2,
c/c++, java.

| Language        | Server (expected)            | Installed? (2026-10-24) |
|-----------------|------------------------------|-------------------------|
| JS/TS (js2)     | typescript-language-server   | yes (nvm node v20)      |
| Python          | pylsp (python-lsp-server)    | yes (/usr/bin/pylsp)    |
| Java            | Eclipse JDT (jdtls)          | yes (auto-downloaded to ~/.emacs.d/eclipse.jdt.ls) |
| Bash            | bash-language-server         | yes (snap)              |
| C/C++           | clangd                       | NO — install `clang-tools` |
| CSS             | vscode-css-language-server   | NO — `npm i -g vscode-langservers-extracted` |
| HTML/web        | vscode-html-language-server  | NO — `npm i -g vscode-langservers-extracted` |
| YAML            | yaml-language-server         | NO — and `lsp-yaml` pkg missing (see Issues) |

## Java specifics

- `lsp-java` auto-downloads the Eclipse JDT language server into
  `~/.emacs.d/eclipse.jdt.ls` on first `java-mode` use.
- `my/java-mode-hook` sets 2-space indent, no tabs.
- A `lsp-java-lombok` helper is embedded in the config to optionally add
  the Lombok javaagent (disabled by default:
  `lsp-java-lombok/enabled` is nil). It downloads lombok.jar into
  `~/.emacs.d/` when enabled.
- `dap-mode`/`dap-java` debugging blocks are present but commented out.

## Reproduce on a fresh machine

1. Emacs packages install automatically from `emacs_setup.org`
   (`use-package :ensure`).
2. Install the external language servers you need:
   ```sh
   # JS/TS (needs node; this repo uses nvm node v20)
   npm install -g typescript typescript-language-server
   # CSS + HTML
   npm install -g vscode-langservers-extracted
   # YAML
   npm install -g yaml-language-server
   # Python
   pipx install python-lsp-server        # or: apt install python3-pylsp
   # Bash
   npm install -g bash-language-server   # or snap
   # C/C++
   sudo apt install clang-tools          # provides clangd
   ```
3. Java: open any `.java` file; `lsp-java` downloads JDT on first run.
4. Verify in a buffer: `M-x lsp` then `M-x lsp-describe-session`.

## Fixed in this pass

- `:hook` double-suffix bug: entries like `(css-mode-hook . lsp-deferred)`
  expanded to `css-mode-hook-hook` (use-package appends `-hook`), so LSP
  was NOT auto-starting for css/html/web/js2/c/c++/java-via-main-block,
  and lsp-ui/which-key integration never fired. Changed to the bare mode
  names (`css-mode`, `js2-mode`, ...). Java still worked before only
  because of a separate correct `add-hook` in the Java section.
- `lsp-yaml` package block (referenced a non-installed package) replaced
  with the built-in approach: `(add-hook 'yaml-mode-hook #'lsp-deferred)`
  plus the external `yaml-language-server` binary.

## Remaining advisories / cleanup

1. Missing external servers for languages that are hooked: `clangd`
   (C/C++), `vscode-css-language-server` / `vscode-html-language-server`
   (CSS/HTML), `yaml-language-server` (YAML). Install per the
   "Reproduce" section if you use those languages.
2. Duplicate/stale elpa versions: `lsp-mode-8.0.0` alongside
   `lsp-mode-20231018.1322`, and `flycheck-32` alongside `flycheck-34.1`.
   Clean with `M-x package-autoremove` or delete the old dirs.
3. The Java section re-declares several `use-package` forms (lsp-mode,
   lsp-ui, company, flycheck, which-key, dap-mode, lsp-treemacs) already
   configured in the main `** lsp` block. Redundant; the stray dap-mode
   declaration also activates a mode the main block intentionally left
   off. Consider consolidating into the main block.

