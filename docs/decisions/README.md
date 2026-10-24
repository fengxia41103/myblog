# Decision Records

Short "why" notes (ADRs) for durable design decisions in myblog. Each ADR
captures the context, the decision, and the consequences so the reasoning
survives after the code changes.

## Format

Copy this skeleton into `docs/decisions/<slug>.md`:

```markdown
# <Decision title>

- **Status:** Accepted | Superseded by <link>
- **Date:** <YYYY-MM-DD>

## Context
What problem/constraint forced a choice?

## Decision
What we chose.

## Consequences
Trade-offs, follow-ups, what this rules out.
```

## Index

| Decision | File |
|----------|------|
| [Optimize images on build output, not source](./optimize-images-on-output.md) | `optimize-images-on-output.md` |
