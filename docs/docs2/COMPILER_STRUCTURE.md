# Modest Compiler — Project Structure

## Overview

Modest is a compiled language that transpiles to **C11** or **LLVM IR** via a Python-based compiler.

**Pipeline**: `source.m` → Lexer → Parser → HLIR → Backend (C11 / LLVM IR) → clang/gcc

```
Source Code (.m)
       │
       ▼
   ┌────────┐
   │ Lexer  │  lexer.py — tokenization
   └───┬────┘
       ▼
   ┌────────┐
   │ Parser │  parser.py — syntax analysis, AST (Python dicts)
   └───┬────┘
       ▼
   ┌────────────┐
   │ Translator │  trans.py — semantic analysis, type checking, HLIR generation
   └───┬────────┘
       │  ┌──────────┐  ┌──────────┐
       ├──│ Symtab   │  │ common   │  symtab.py, common.py
       │  └──────────┘  └──────────┘
       ▼
   ┌──────────┐
   │ Backends │
   ├──────────┤
   │ C11      │  backend/c11.py + backend/c11_1.py  → .c
   │ LLVM IR  │  backend/llvm.py                    → .ll
   │ Modest   │  backend/modest.py                  → .m (pretty printer)
   └──────────┘
```


## Top-Level Files

| File | Purpose |
|------|---------|
| `mcc` | Compiler entry point (bash wrapper around `src/main.py`) |
| `README.md` | Project overview |
| `LICENSE` | MIT License |
| `requirements.txt` | Python dependencies |
| `configure.sh` | Configuration script |
| `install.sh` | Installation script |
| `check.sh` | Verification script |


## `src/` — Compiler Source

### Core Modules

| File | Purpose |
|------|---------|
| `main.py` | Entry point: CLI argument parsing, config loading, build orchestration |
| `lexer.py` | Tokenization: source code → tokens with position info |
| `parser.py` | Syntax analysis: tokens → AST (nested Python dicts) |
| `trans.py` | Translation: AST → HLIR (semantic analysis, type-checked IR) |
| `symtab.py` | Symbol table: tracks types and values in scopes |
| `common.py` | Global `settings` dict and `features` list (populated from config) |
| `error.py` | Error reporting: `error()`, `warning()`, `info()`, `fatal()` with colored output |
| `util.py` | Utility functions: alignment, bit ops, numeric helpers |
| `unicode.py` | Unicode handling: UTF-8/16/32 conversion |

### `src/hlir/` — High-Level Intermediate Representation

| File | Purpose |
|------|---------|
| `__init__.py` | Package exports (re-exports from types + defs) |
| `types.py` | All HLIR class definitions: `Type*`, `Value*`, `Stmt*`, `Module`, `Id`, `Field`, op constants |
| `defs.py` | Predefined type singletons (`typeInt8`…`typeFloat64`, `typeBool`, `typeUnit`, etc.) and factory functions |

### `src/backend/` — Code Generation

| File | Purpose |
|------|---------|
| `c11.py` | C11 backend: HLIR → C11 source code (imports helpers from `c11_1.py`) |
| `c11_1.py` | C11 backend helpers (split out from `c11.py`) |
| `llvm.py` | LLVM IR backend: HLIR → LLVM intermediate representation |
| `modest.py` | Modest backend: HLIR → Modest source code (pretty printer / self-hosted output) |

> `c11_old.py` and `c11_old_backend_test.py` are legacy files, not used in the current pipeline.

### `src/value/` — Compile-Time Value Operations

Implements compile-time evaluation and type construction per type:

| File | Type | Purpose |
|------|------|---------|
| `bool.py` | Bool | Boolean value operations |
| `integer.py` | Integer | Generic integer literal creation and conversion |
| `int.py` | Int | Signed integer operations |
| `nat.py` | Nat | Unsigned integer operations |
| `word.py` | Word | Bitwise word operations |
| `float.py` | Float | Floating-point operations |
| `fixed.py` | Fixed | Fixed-point operations |
| `rational.py` | Rational | Rational number (float literal) operations |
| `char.py` | Char | Character handling (UTF-8/16/32) |
| `string.py` | String | String value operations |
| `array.py` | Array | Array creation and element access |
| `record.py` | Record | Record (struct) value creation |
| `pointer.py` | Pointer | Pointer dereference and conversions |
| `cons.py` | — | Type construction dispatcher (routes to the right type handler) |
| `bad.py` | Bad | Error/bad value creation |


## `cfg/` — Configuration

| File | Purpose |
|------|---------|
| `default.toml` | Default target config: architecture, bit widths, backend selection |

Key settings: target name/machine, endianness, ABI, word/pointer/integer/float/char widths, compile-time precision, backend engine, LLVM target triple, feature flags.


## `lib/` — Standard Library

### `lib/libc/` — C Standard Library Bindings

| File | Wraps |
|------|-------|
| `libc.m` | Main libc aggregator |
| `stdio.m` | Standard I/O (`printf`, `scanf`, `fopen`, `fclose`, …) |
| `stdlib.m` | Standard utilities (`malloc`, `free`, `exit`, …) |
| `string.m` | String functions (`strcpy`, `strlen`, `memcpy`, …) |
| `math.m` | Math functions (`sin`, `cos`, `sqrt`, `pow`, …) |
| `ctype.m` | Character classification |
| `ctypes.m` / `ctypes32.m` / `ctypes64.m` | C type aliases (arch variants) |
| `errno.m` / `errno_abi.m` | Error codes |
| `assert.m` | Assertions |
| `fcntl.m` | File control |
| `stat.m` | File status |
| `time.m` | Time functions |
| `unistd.m` | POSIX API (`read`, `write`, `close`, …) |
| `socket.m` | Network sockets |
| `arpa/inet.m` | TCP/IP protocol definitions |

### `lib/lightfood/` — Higher-Level Libraries

| File | Purpose |
|------|---------|
| `console.m` | Console I/O |
| `memory.m` | Memory management helpers |
| `str.m` | String utilities |
| `datetime.m` | Date/time utilities |
| `delay.m` | Delay/sleep operations |

### `lib/misc/` — Miscellaneous

| File | Purpose |
|------|---------|
| `sha256.m` | SHA-256 hashing |
| `aes256.m` | AES-256 encryption |
| `chacha20.m` | ChaCha20 stream cipher |
| `crc32.m` | CRC32 checksum |
| `bit.m` | Bit manipulation utilities |
| `lohi.m` | Low/high word operations |
| `minmax.m` | Min/max utilities |
| `pthread.m` | POSIX threads |
| `queue.m` | Generic queue |
| `queueWord8.m` | Byte queue |
| `termios.m` | Terminal I/O control |
| `utf.m` | UTF encoding utilities |

### Standalone Modules

| File | Purpose |
|------|---------|
| `std.m` | Standard module aggregator |
| `limits.m` | System limits |
| `dirent.m` | Directory entries |


## `examples/` — Example Programs

| Directory | Description |
|-----------|-------------|
| `1.hello_world/` | Basic "Hello, World!" |
| `3.multiply_table/` | Multiplication table |
| `4.many_sources/` | Multi-file project |
| `5.records/` | Record/struct usage |
| `6.text_file/` | Text file I/O |
| `7.binary_file/` | Binary file operations |
| `8.linked_list/` | Linked list data structure |
| `9.fsm/` | Finite state machine |
| `10.sockets/` | Network socket programming |
| `annotations/` | Compiler annotations |
| `asm/` | Inline assembly |
| `bubble_sort/` | Sorting algorithm |
| `demo1/` | General demo |
| `m328p_blink/` | AVR microcontroller (ATmega328P) LED blink |
| `sha256/` | SHA-256 hashing |
| `stmt_if/` | Conditional statements |
| `stmt_while/` | Loop statements |
| `table/` | Table structures |
| `web/` | Web operations |

Each example contains: `src/` (source), `out/` (generated output), `Makefile`.


## `tests/` — Test Suite

| Directory | Purpose |
|-----------|---------|
| `hello_world/` | Basic compilation smoke test |
| `lang/` | Language feature tests |
| `arr/` | Array operations |
| `builtin/` | Built-in operations (sizeof, alignof, …) |
| `eq/` | Equality and comparison |
| `fixed/` | Fixed-point arithmetic |
| `fs/` | File system operations |
| `literals/` | Literal parsing |
| `modules/` | Module import/include |
| `nested_func/` | Nested function definitions |
| `shift/` | Bitwise shift operations |
| `sizeof/` | sizeof / alignof / offsetof |
| `test_record/` | Record types |
| `vol/` | VLA and volume tests |
| `zarray/` | Zero-terminated arrays (Str8/16/32) |
| `structural_type_system/` | Structural typing validation |
| `limits/` | System limits / boundary tests |
| `aes256/` | AES-256 encryption tests |
| `chacha20/` | ChaCha20 cipher tests |
| `crc32/` | CRC32 checksum tests |
| `sha256/` | SHA-256 hashing tests |

Each test contains: `src/main.m`, `Makefile`, `out/{c,cm,llvm}/`.


## Error Codes

Errors are categorized by compiler phase:
- **0xx** — OS & environment errors
- **1xx** — Lexer errors
- **2xx** — Parser errors
- **3xx** — Translation errors
- **4xx** — Backend errors


## Build & Environment

| Variable | Purpose |
|----------|---------|
| `MODEST_DIR` | Compiler root directory |
| `MODEST_LIB` | Library search path |

**CLI**: `mcc -i <input> -o <output> --config=<cfg.toml> -funsafe`

**Backends**: selected via config `backend = "llvm"` or `backend = "c11"`
