# Claude Agent Context — Modest Compiler

Quick orientation for working on this codebase without re-reading everything.

## Where things live

| Task | Files to look at |
|------|-----------------|
| Language syntax / grammar | `docs/EBNF.txt`, `src/lexer.py`, `src/parser.py` |
| Type system rules | `src/type.py`, `src/hlir/types.py` |
| Semantic analysis / new statement | `src/trans.py` |
| HLIR node definitions | `src/hlir/types.py` (Types + Values + Stmts all in one file) |
| Predefined type singletons | `src/hlir/defs.py` |
| C11 output | `src/backend/c11.py` |
| LLVM IR output | `src/backend/llvm.py` |
| Modest pretty-print | `src/backend/modest.py` |
| Value-level compile-time ops | `src/value/*.py` |
| Error reporting | `src/error.py` — use `error(msg, ti)` / `warn(msg, ti)` |
| Symbol table | `src/symtab.py` — `symtab.value_get(id)`, `symtab.type_get(id)` |

## Common tasks

### Add a new statement (e.g. `foreach`)
1. Add token(s) in `src/lexer.py`
2. Parse it in `src/parser.py` → return an AST dict
3. Translate in `src/trans.py` → return a `StmtXxx` HLIR node (define in `src/hlir/types.py`)
4. Emit in `src/backend/c11.py` and `src/backend/llvm.py`

### Add a new binary operator
1. Add `HLIR_VALUE_OP_XXX` constant in `src/hlir/types.py`
2. Add it to the allowed ops tuple for the relevant types (e.g. `INT_OPS`)
3. Parse in `src/parser.py` (find `parse_binary` or similar)
4. Translate in `src/trans.py` → return `ValueBin(type, op, left, right, ti)`
5. Emit in both backends

### Add a new builtin type
1. Add `type_xxx_create(width)` in `src/hlir/defs.py`
2. Add a singleton (`typeXxx = ...`) in `defs.py`
3. Register in `src/trans.py` initial symbol table setup

### Fix a type-check error
- Type equality: `Type.eq(a, b)` — structural, brand-aware
- Type compatibility for assignment: see `src/type.py` `can_assign()` or similar
- Common type selection: `Type.select_common_type(a, b, ti)` in `src/hlir/types.py`

## Pipeline flow

```
source.m
  └─ lexer.py        → token list
  └─ parser.py       → AST (nested Python dicts)
  └─ trans.py        → HLIR (typed Python objects: Stmt*, Value*, Type*)
       ├─ symtab.py  (scope stack for type/value lookup)
       └─ type.py    (type checking helpers)
  └─ backend/c11.py  → .c  (walks HLIR, prints C)
  └─ backend/llvm.py → .ll (walks HLIR, prints LLVM IR)
```

## Key conventions

- `ti` everywhere = `TextInfo` — source position, always thread it through for errors
- `ValueBad` / `TypeBad` = error sentinel; propagates silently to avoid error cascades
- `generic=True` on a type = compile-time-only (Integer, Rational, GenericArray, etc.)
- `stage`: `COMPILETIME` = known at compile time, `RUNTIME` = not
- `is_lvalue` on Value = can appear on left side of assignment
- Backends never call `error()` — all errors come from `trans.py`
- `Id` has per-backend aliases: `id.c`, `id.llvm`, `id.cm` — set all three when creating a new named entity

## Existing docs (language-level)

- Language cheatsheet: `docs/docs2/CHEATSHEET.md`
- Compiler structure overview: `docs/docs2/COMPILER_STRUCTURE.md`
- Full language reference: `docs/lang/`
- HLIR internals (types, values, stmts): `docs/agents/claude/hlir-internals.md`
