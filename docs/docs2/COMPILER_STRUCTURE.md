# Modest Compiler - Project Structure

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
   │ Parser │  parser.py — syntax analysis, AST
   └───┬────┘
       ▼
   ┌────────────┐
   │ Translator │  trans.py — semantic analysis, HLIR generation
   └───┬────────┘
       │  ┌──────────┐  ┌──────────┐
       ├──│ Symtab   │  │ Type     │  symtab.py, type.py
       │  └──────────┘  └──────────┘
       ▼
   ┌──────────┐
   │ Backends │
   ├──────────┤
   │ C11      │  backend/c11.py   → .c
   │ LLVM IR  │  backend/llvm.py  → .ll
   │ Modest   │  backend/modest.py → .m (pretty printer)
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
| `parser.py` | Syntax analysis: tokens → AST |
| `trans.py` | Translation: AST → HLIR (semantic analysis, type-checked IR) |
| `symtab.py` | Symbol table: tracks types and values in scopes |
| `type.py` | Type system: checking, inference, conversion rules |
| `common.py` | Global settings and feature flags |
| `error.py` | Error reporting with colored output |
| `util.py` | Utility functions (alignment, bit ops, numeric helpers) |
| `unicode.py` | Unicode handling (UTF-8/16/32 conversion) |
| `test.py` | Test framework integration |

### `src/hlir/` — High-Level Intermediate Representation

| File | Purpose |
|------|---------|
| `__init__.py` | Package exports (combines types, defs, utils) |
| `types.py` | HLIR type definitions (`TypeInteger`, `TypeRational`, `TypeString`, etc.) |
| `defs.py` | HLIR type constructors and predefined types (`typeInt8`..`typeInt128`, `typeBool`, etc.) |
| `utils.py` | HLIR utility functions (type selection by size) |

### `src/backend/` — Code Generation

| File | Purpose |
|------|---------|
| `common.py` | Shared backend utilities (output management, indentation) |
| `c11.py` | C11 backend: HLIR → C11 source code |
| `llvm.py` | LLVM IR backend: HLIR → LLVM intermediate representation |
| `modest.py` | Modest backend: HLIR → Modest source code (pretty printer / self-hosted output) |

### `src/value/` — Value Representations

Implements compile-time and runtime value handling per type:

| File | Type | Purpose |
|------|------|---------|
| `value.py` | Base | Core value class hierarchy |
| `bool.py` | Bool | Boolean value operations |
| `integer.py` | Integer | Integer value creation and conversion |
| `int.py` | Int | Signed integer operations |
| `nat.py` | Nat | Unsigned integer operations |
| `word.py` | Word | Bitwise word operations |
| `float.py` | Float | Floating-point operations |
| `rational.py` | Rational | Rational number operations |
| `char.py` | Char | Character handling (UTF-8/16/32) |
| `string.py` | String | String value operations |
| `array.py` | Array | Array creation and element access |
| `record.py` | Record | Record (struct) value creation |
| `pointer.py` | Pointer | Pointer dereference and conversions |
| `unit.py` | Unit | Unit (void) value |
| `cons.py` | Cons | Value constructors |
| `tag.py` | Tag | Tagged values |
| `tor.py` | Tor | Tagged union constructors |
| `bad.py` | Bad | Error/bad value representation |


## `cfg/` — Configuration

| File | Purpose |
|------|---------|
| `default.toml` | Default target config: architecture, bit widths, backend selection |

Key settings: target name/machine, endianness, ABI, word/pointer/integer/float/char widths, compile-time precision, backend engine, LLVM target triple, feature flags.


## `lib/` — Standard Library

### `lib/libc/` — C Standard Library Bindings

| File | Wraps |
|------|-------|
| `libc.m` | Main libc header |
| `stdio.m` | Standard I/O |
| `stdlib.m` | Standard utilities |
| `string.m` | String functions |
| `math.m` | Math functions |
| `ctype.m` | Character classification |
| `ctypes.m`, `ctypes32.m`, `ctypes64.m` | C type definitions (arch variants) |
| `errno.m`, `errno_abi.m` | Error handling |
| `assert.m` | Assertions |
| `fcntl.m` | File control |
| `stat.m` | File status |
| `time.m` | Time functions |
| `unistd.m` | POSIX API |
| `socket.m` | Network sockets |
| `arpa/inet.m` | TCP/IP protocol definitions |

### `lib/lightfood/` — Higher-Level Libraries

| File | Purpose |
|------|---------|
| `console.m` | Console I/O |
| `memory.m` | Memory management |
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
| `pthread.m`, `pthread2.m` | POSIX threads |
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
| `lang/` | Language feature tests (def, stmt, type, value) |
| `aes256/` | AES-256 encryption tests |
| `chacha20/` | ChaCha20 cipher tests |
| `crc32/` | CRC32 checksum tests |
| `sha256/` | SHA-256 hashing tests |
| `limits/` | System limits / boundary tests |
| `structural_type_system/` | Structural typing validation |

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

**CLI**: `mcc -i <input> -o <output> --config=<cfg.toml> -f unsafe`

**Backends**: selected via config `backend = "llvm"` or `backend = "c11"`
