# Module Architecture

Who owns what, and who depends on whom.

This page is about *responsibility and coupling*. For the file map see
[STRUCTURE.md](./STRUCTURE.md); for the flow of one compilation see
[overview.md](./overview.md).

## Layer map

Arrows point from dependent to dependency (load-time imports only —
the back-edges are listed [below](#cycles-and-deferred-imports)).

```
  layer 6   main.py ──────────────────────────┐  dynamic import:
              │                               │  settings['backend']
              ▼                               ▼
  layer 5   semantic.py             backend/c11.py   ──► cshape (external)
              │                     backend/llvm.py
              │                     backend/modest.py
              ▼                               │
  layer 4   lexer.py  parser.py  symtab.py  value/*.py
              │                               │
              ▼                               │
  layer 3   error.py ◄────────────────────────┘
              │
              ▼
  layer 2   hlir/  (__init__ → types.py → defs.py)
              │
              ▼
  layer 1   common.py    util.py    unicode.py
```

Two things are worth reading off this picture:

- **`hlir` is the hub.** Every module above layer 2 does
  `from hlir import *`. It is the shared vocabulary — change a field
  name there and all four consumers (semantic, the three backends,
  value/) move with it.
- **The backends are leaves.** Nothing imports them statically; `main`
  loads one by name. Adding a fourth backend touches no existing
  module. (One exception: `hlir/types.py` reaches into
  `backend.modest.str_type` to render a type inside a diagnostic.)

## Modules

### Layer 1 — foundation (no internal imports)

| Module | Responsibility | Public surface |
| :-- | :-- | :-- |
| `common.py` | Global configuration. Two mutable objects, filled by `main` from `cfg/*.toml`, `--config` and `-m` / `-f` flags. | `settings` (dict), `features` (list) |
| `util.py` | Pure numeric & decoding helpers: alignment, bit widths, int packing, decimal/fraction formatting, UTF-x → UTF-32. | `align_bits_up`, `nbits_for_num`, `int_zext`, `pack_int`, `str_fractional`, `utfx_chars_to_utf32_chars` |
| `unicode.py` | The encoding direction: UTF-32 → UTF-8/16/32 code units. | `chars_to_utf8/16/32`, `utf32_chars_to_utfx_cc` |

> The `util` / `unicode` split is by *direction* (decode vs encode), not
> by domain — a name asymmetry worth remembering when looking for a
> conversion function.

### Layer 2 — `hlir/` — the data model

| File | Responsibility |
| :-- | :-- |
| `types.py` | Every HLIR class: `Entity` base, `Module`, `Id`, `Field`, `Initializer`, ~25 `Stmt*`, ~13 `Type*`, ~40 `Value*`, the `HLIR_*` constants, plus `TokenInfo` / `TextInfo`, `types.init(pointer_width)` and the `@branded` counter. |
| `defs.py` | Target-independent builtins: factories (`type_int_create`, `type_nat_create`, `type_float_create`, …), singletons (`typeBool`, `typeUnit`, `typeInteger`, `typeNil`, `typeByte`, `type__VA_List`, `builtin_ti`), selectors (`type_select_int/nat/char`, `type_integer_for`). |
| `__init__.py` | Re-exports both, so `from hlir import *` is the single entry. |

Depends only on `util`. Field-level documentation:
[hlir-internals.md](../agents/claude/hlir-internals.md).

### Layer 3 — `error.py`

Diagnostics and the error budget: `note` / `info` / `warning` / `error`
/ `fatal`, warning and error counters, `MAX_ERRORS = 10` hard stop, ANSI
coloring, source-line extraction with caret highlighting, and the
verbose `log` / `log_push` / `log_pop` trace used by `semantic`.

Depends on `common` (the `paranoid` feature promotes info → warning →
error) and on `hlir` — but only for `TokenInfo` / `TextInfo`.

### Layer 4 — front end and compile-time values

| Module | Responsibility | Entry point |
| :-- | :-- | :-- |
| `lexer.py` | `Lexer` rule engine + the `CmLexer` rule table. Newlines are tokens; capitalized identifiers get their own token class, so the parser can tell types from values lexically. | `CmLexer().run(filename)` → `[(class, text, TokenInfo)]` |
| `parser.py` | Recursive descent with backtracking (`getpos` / `setpos`). Precedence is the call chain `expr_value_1` (loosest) … `expr_value_11` (postfix). Emits plain dicts, not classes. | `Parser().parse(tokens)` → AST |
| `symtab.py` | A scope chain with two namespaces per scope — `types` and `values` — and parent lookup. 53 lines, no logic beyond that. | `Symtab(parent)`, `type_get`, `value_get`, `type_add`, `value_add` |
| `value/*.py` | Compile-time semantics per type: is a construction legal, and what does it produce. | see below |

`parser.py` does **not** import `lexer.py` — it consumes the token list
structurally. The two are coupled only through the token tuple shape.

#### `value/` — the construction rules

Every type module exposes the same pair, which is the reason this
directory is uniform:

| Function | Question it answers |
| :-- | :-- |
| `value_<t>_can(to, from_type, method, ti)` | may a value of `from_type` become a `<t>` under this method? |
| `value_<t>_cons(t, v, method, ti)` | do it — fold literals, widen, warn, or emit a runtime conversion |

`cons.py` is the dispatcher: it holds the one table mapping a target
type kind to its handler, and exports `value_cons_implicit`,
`value_cons_implicit_check`, `value_cons_explicit`, `value_cons_default`.
**This is where the type-conversion rules live** — `semantic.py` asks,
`cons.py` routes, the per-type module decides.

`bool` · `integer` · `rational` · `int` · `nat` · `word` · `char` ·
`float` · `fixed` · `string` · `array` · `record` · `pointer` ·
`variant` · `bad`. Several also export a `value_<t>_create` used by
`semantic` to build literals.

### Layer 5 — `semantic.py` and the backends

**`semantic.py`** — the translator, and by far the largest module
(3 236 lines). It owns:

| Area | Functions |
| :-- | :-- |
| Startup | `init()` — reads `settings`, arms `types.init(pointer_width)`, picks the target-dependent `typeSys*` types, builds the `builtin`, `builtin/target` and `builtin/compiler` modules via `create_builtin_module()` |
| Driving | `translate(abspath)` — lex → parse → `process_module` |
| Two-phase module processing | `def_phase1` declares module-level types and functions as incomplete prototypes (enables forward references and recursive types); `def_phase2` defines them |
| Node translation | one `do_*` per AST kind: `do_type_*`, `do_value_*`, `do_stmt_*`, `def_*` |
| Modules | `do_import`, `get_import_abspath`, the `modules` cache and `import_stack` |
| Decoration | `def_add_annotations`, `do_directive_pragma`, unused-symbol checks |

**`backend/*`** — each backend is a plugin with a two-function contract:

```python
name = get_setting('backend.default')
backend = importlib.import_module("backend." + name)
backend.init(backend_settings(name))         # cache target parameters
backend.run(module, outname)    # walk the HLIR module, write files
```

| Backend | Output | Notes |
| :-- | :-- | :-- |
| `c11.py` | `.c` + `.h` | Builds a `cshape` C AST and renders it. Header skipped for `main` or with the `no-h-file` feature. The only backend with an external dependency and the only one reading `common.features`. |
| `llvm.py` | `.ll` | Direct textual emission with its own register counter and SSA bookkeeping; takes `target_triple` / `target_datalayout` / `size_width` from settings. |
| `modest.py` | `.modest` | Pretty-printer. Also exports `str_type`, reused by diagnostics. |

### Layer 6 — `main.py`

CLI and orchestration, 123 lines: `argparse`, layered TOML config
(`cfg/default.toml` → `--config` → `-m key=value`, where the key may be a
dotted path: `-mbackend.encoding=cp1251`), `MODEST_DIR` /
`MODEST_LIB`, then per input file:

```
semantic.init() → semantic.translate(src) → error gate → backend.init() → backend.run() → error gate
```

## Dependency edges

### Load-time (top-level imports)

| Module | Imports |
| :-- | :-- |
| `main.py` | `error`, `semantic`, `common` (+ `backend.*` dynamically) |
| `semantic.py` | `hlir`, `error`, `lexer`, `parser`, `symtab`, `common`, `util`, `value.{bool,integer,rational,string,array,record,word,cons}` |
| `lexer.py` | `error`, `hlir` |
| `parser.py` | `hlir`, `error`, `util` |
| `symtab.py` | `hlir` |
| `error.py` | `common`, `hlir` |
| `hlir/types.py` | `util` |
| `hlir/defs.py` | `hlir.types` |
| `value/cons.py` | `hlir`, `error`, `util` + all sibling `value.*` modules |
| `value/*.py` | `hlir`, `error`, and some of `util`, `unicode`, `common`, `value.char`, `hlir.defs` |
| `backend/c11.py` | `hlir`, `error`, `util`, `unicode`, `common`, **`cshape`** |
| `backend/llvm.py` | `hlir`, `error`, `util` |
| `backend/modest.py` | `hlir`, `error`, `util` |
| `common.py`, `util.py`, `unicode.py` | — (stdlib only) |

### Cycles and deferred imports

Four cycles exist. All are broken the same way — a function-local
`import` at the point of use. Grepping for `from … import` *inside*
function bodies is therefore a map of where the layering is violated:

| Cycle | Back-edge | Why |
| :-- | :-- | :-- |
| `hlir.types` ↔ `semantic` | `from semantic import typeSysSize, typeSysInt` | `ValueSizeof*` / `ValueLengthof*` need the target-dependent `Size` and `Int` types, which only exist after `semantic.init()` has read the config |
| `hlir.types` ↔ `backend.modest` | `from backend.modest import str_type` | rendering a type inside an error message |
| `hlir.types` ↔ `value.array` / `value.record` | `from value.array import value_array_create` | `create_default_value(t)` must build aggregate defaults |
| `value.*` ↔ `semantic` | `cmodule_use`, `cmodule_strings_add`, `is_unsafe_mode`, `typeSys*` | compile-time value code needs current-module context and the unsafe-mode flag |

`hlir.types` also imports `error` lazily, and `value.int` / `value.nat`
pull `common.settings` at call time.

## State ownership

The compiler is a single-pass, single-threaded process built on module
globals. Who owns what:

| Owner | State | Reset by |
| :-- | :-- | :-- |
| `common` | `settings`, `features` | never — set up once by `main` |
| `error` | `errcnt`, `warncnt`, `verbose_mode`, `log_ind` | never (counters accumulate across input files) |
| `hlir.types` | `pointer_width`, `brand_cnt` | `types.init(pwidth)` |
| `semantic` | `cmodule`, `csymtab`, `cdef`, `cfunc`, `modules`, `import_stack`, `typeSys*`, `builtin_module`, `global_prefix`, uid counters | `semantic.init()` per input file |
| `backend.c11` | `csettings`, context stack | `init(settings)` |
| `backend.llvm` | target strings, register counter, locals stack, output handle | `init(settings)` + `run()` |
| `backend.modest` | `cmodule`, indent level, output handle | `run()` |

Consequence: **one process compiles one program.** `semantic.translate`
is recursive over imports but not reentrant across programs, and the
error counters are process-wide.

## Where a change lands

| Change | Modules touched, in order |
| :-- | :-- |
| New token | `lexer.py` |
| New syntax | `lexer.py` → `parser.py` (+ dispatch in `stmt_block`) → `semantic.py` → new `Stmt*` in `hlir/types.py` → every backend |
| New operator | `hlir/types.py` (op constant + per-type op tuple) → `parser.py` → `semantic.py` `do_value_bin_op` → `value/*.py` → backends |
| New builtin type | `hlir/defs.py` (factory + singleton) → `semantic.py` `init` / `create_builtin_module` → `value/<t>.py` → `value/cons.py` → backends |
| Conversion rule | `value/cons.py` + the target type's `value/<t>.py` |
| New annotation | `semantic.py` `def_add_annotations` → backend handling |
| New pragma | `semantic.py` `do_directive_pragma` |
| New backend | one file in `src/backend/` exporting `init(settings)` and `run(module, outname)`; nothing else changes |
| C output shape | `backend/c11.py`, or the external `cshape` package |

## Structural observations

- **`TokenInfo` / `TextInfo` sit in `hlir/types.py`** although they are
  lexer-level concepts. That single detail is what forces the
  `error → hlir` edge; moving them to their own layer-1 module would
  drop `error` to the foundation layer and shorten the graph.
- **`semantic.py` is the only module that knows the target.** Everything
  target-dependent (`typeSys*`, widths) is resolved there, which is why
  `hlir` and `value/` have to reach back into it.
- **The backend contract is genuinely narrow** (two functions, one
  argument each) — the cleanest seam in the compiler.
- **`cons.py` is the second clean seam**: 15 type modules behind one
  uniform `can` / `cons` pair.
