# Compiler Overview

How a `.m` file becomes C, LLVM IR or pretty-printed Modest.

```
source.m → Lexer → Parser → Translator → Backend → out.c / out.ll / out.m
           tokens   AST       HLIR
```

## 1. Lexer — `src/lexer.py`

Rule-based tokenizer. Produces a flat list of tuples
`(class, text, TokenInfo)` where class is `id` / `Id` (capitalized —
type identifiers are distinguished lexically) / `num` / `str` / `op` /
`nl` / `annotation` (`@x`) / `directive` (`$x`) / `tag` (`#x`) /
comments. `TokenInfo` carries file/line/position for diagnostics.
Newlines are tokens — they terminate statements.

## 2. Parser — `src/parser.py`

Hand-written recursive descent with backtracking (`getpos`/`setpos`).
Produces an AST of plain Python dicts: `{'isa': 'ast_value', 'kind':
'add', ...}`. Operator precedence is encoded in the call chain
`expr_value_1` (loosest, `or`) … `expr_value_11` (postfix). The
type-vs-value ambiguity (`Int32 x` is construction) is resolved by
lookahead (`is_type_before_value`).

## 3. Translator — `src/semantic.py`

The semantic core: AST → HLIR (typed, classed objects from
`src/hlir/`). Per module it runs **two passes**:

1. *declare* — all module-level names enter the symbol table
   (incomplete types), enabling forward references and recursive types;
2. *define* — definitions are processed, expressions get types,
   compile-time values fold.

Key collaborators:

- `src/symtab.py` — scoped symbol tables (types and values);
- `src/value/*.py` — per-type compile-time operations and the
  construction rules (`cons.py` dispatches `value_cons_implicit` /
  `..._explicit` to the target type's `*_can` / `*_cons` functions —
  **this is where the type-conversion rules live**);
- `src/error.py` — diagnostics with source highlighting; categories:
  0 system, 1 lexer, 2 parser, 3 translation, 4 backend.

State is module-level globals (`cmodule`, `csymtab`, `cfunc`, ...) —
the translator is single-threaded and non-reentrant.

## 4. Backends — `src/backend/`

Each backend walks HLIR modules and prints output:

| Backend | Output | Notes |
| :-- | :-- | :-- |
| `c11.py` (+ `c11_1.py`) | `.c` + `.h` | primary backend; readable C11 |
| `llvm.py` | `.ll` | LLVM IR, compiled with clang |
| `modest.py` | `.m` | pretty-printer (self-output) |

`c11_old.py` and `c11_old_backend_test.py` are legacy, not in the
pipeline.

## Where to make a change

| Task | Start at |
| :-- | :-- |
| new syntax | `parser.py` (+ statement dispatch in `stmt_block`) |
| new operator semantics | `semantic.py` `do_value_bin_op` + `value/*.py` |
| conversion rules | `value/cons.py` and the target type's `value/*.py` |
| new annotation | `semantic.py` `def_add_annotations` + backend handling |
| new pragma | `semantic.py` `do_directive_pragma` |
| C output details | `backend/c11.py` |
| new builtin type | `hlir/defs.py` + registration in `semantic.py` `init` |

A task-oriented index lives in
[../agents/claude/context.md](../agents/claude/context.md).
