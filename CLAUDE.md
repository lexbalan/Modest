# Modest

Modest is a Swift/Go-inspired compiled language for medium-level system
programming and embedded development. Python-based compiler (`src/`),
transpiles `.m` sources to C11 or LLVM IR.

## Language reference — READ THIS

The language cheatsheet is imported below. **Always follow it when writing,
reviewing or explaining Modest code** — Modest looks like Swift/Go but
differs in important ways (no `for`, no `switch`, `again` instead of
`continue`, bitwise ops only on `Word*` types, value construction instead
of casts).

read docs/CHEATSHEET.md before writing Modest code

## Deeper docs

- `docs/agents/claude/context.md` — task-oriented guide: where to look for each task type
- `docs/agents/claude/hlir-internals.md` — HLIR Type/Value/Stmt classes with fields
- `docs/lang/` — per-feature language documentation
- `docs/EBNF.txt` — grammar

## Build & test

- Compile: `./mcc -o <out> -mbackend=c11|llvm|modest <file.m>` (needs `MODEST_DIR`, `MODEST_LIB` env vars)
- Tests: `./tests/run.py` (one `.m` file per test; expectations in its header — see `tests/README.md`)
- Config: `cfg/*.toml` (target arch, type widths, backend)
