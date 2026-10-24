# docs/

Planning, specs, and decision records for myblog. Kept lean so humans and AI
agents can scan it cheaply.

## Layout

```
docs/
├── README.md         # this file
├── specs/            # feature/tooling specs (intent + EARS acceptance criteria)
│   └── TEMPLATE.md   # copy this to start a new spec
├── decisions/        # Architecture Decision Records (short "why" notes)
│   └── README.md     # ADR index + format
└── archive/          # shipped specs/plans (frozen)
    └── INDEX.md       # catalog of what shipped and when
```

## Lifecycle

1. **Spec** a non-trivial change in `specs/<slug>.md` (copy `TEMPLATE.md`).
   Trivial fixes (typos, broken links) skip this.
2. **Build** against the spec; verify with `make publish` / `make devserver`.
3. **Ship** by merging to `main` (the publish workflow deploys `gh-pages`).
4. **Archive** the spec to `archive/` and add a row to `archive/INDEX.md`.
   Capture any durable "why" as an ADR in `decisions/`.

See `../CODE_CONDUCT.md` for the full working rules.
