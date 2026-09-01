# Project Structure

Directory and file map of the repository. How the compiler *works* is
described in [README.md](./README.md).

## Top-Level Files

| File | Purpose |
|------|---------|
| `mcc` | Compiler entry point (bash wrapper around `src/main.py`) |
| `mcc.bat` | Same, for Windows `cmd.exe` |
| `README.md` | Project overview |
| `LICENSE` | MIT License |
| `requirements.txt` | Python dependencies |
| `bootstrap.sh` | Setup: creates the `venv/`, installs deps, sets the environment variables (Unix) |
| `bootstrap.bat` | Same, for Windows `cmd.exe` |
| `check.sh` | Runs the test suite and builds all examples |


## `src/` — Compiler Source

### Core Modules

| File | Purpose |
|------|---------|
| `main.py` | Entry point: CLI argument parsing, config loading, build orchestration |
| `lexer.py` | Tokenization: source code → tokens with position info |
| `parser.py` | Syntax analysis: tokens → AST (nested Python dicts) |
| `semantic.py` | Translation: AST → HLIR (semantic analysis, type-checked IR) |
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
| `c11.py` | C11 backend: HLIR → C11 source (lowering; builds a tree from the external `cshape` package) |
| `llvm.py` | LLVM IR backend: HLIR → LLVM intermediate representation |
| `modest.py` | Modest backend: HLIR → Modest source code (pretty printer / self-hosted output) |

> `c11_old.py` and `c11_old_backend_test.py` are legacy files, not used in the current pipeline.

`c11.py` builds C source via [`cshape`](https://pypi.org/project/cshape/) —
a standalone, dependency-free C AST + printer (`CType*`/`CValue*`/`CStmt*`
→ C11 text) split out of this repo so it can be reused outside Modest.
Installed from PyPI as an ordinary dependency (see `requirements.txt`);
`bootstrap.sh` / `bootstrap.bat` pull it into the project's venv.

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
| `libc.modest` | Main libc aggregator |
| `stdio.modest` | Standard I/O (`printf`, `scanf`, `fopen`, `fclose`, …) |
| `stdlib.modest` | Standard utilities (`malloc`, `free`, `exit`, …) |
| `string.modest` | String functions (`strcpy`, `strlen`, `memcpy`, …) |
| `math.modest` | Math functions (`sin`, `cos`, `sqrt`, `pow`, …) |
| `ctype.modest` | Character classification |
| `ctypes.modest` / `ctypes32.modest` / `ctypes64.modest` | C type aliases (arch variants) |
| `errno.modest` / `errno_abi.modest` | Error codes |
| `assert.modest` | Assertions |
| `fcntl.modest` | File control |
| `stat.modest` | File status |
| `time.modest` | Time functions |
| `unistd.modest` | POSIX API (`read`, `write`, `close`, …) |
| `socket.modest` | Network sockets |
| `arpa/inet.modest` | TCP/IP protocol definitions |

### `lib/lightfood/` — Higher-Level Libraries

| File | Purpose |
|------|---------|
| `console.modest` | Console I/O |
| `memory.modest` | Memory management helpers |
| `str.modest` | String utilities |
| `datetime.modest` | Date/time utilities |
| `delay.modest` | Delay/sleep operations |

### `lib/misc/` — Miscellaneous

| File | Purpose |
|------|---------|
| `sha256.modest` | SHA-256 hashing |
| `aes256.modest` | AES-256 encryption |
| `chacha20.modest` | ChaCha20 stream cipher |
| `crc32.modest` | CRC32 checksum |
| `bit.modest` | Bit manipulation utilities |
| `lohi.modest` | Low/high word operations |
| `minmax.modest` | Min/max utilities |
| `pthread.modest` | POSIX threads |
| `queue.modest` | Generic queue |
| `queueWord8.modest` | Byte queue |
| `termios.modest` | Terminal I/O control |
| `utf.modest` | UTF encoding utilities |


## `examples/` — Example Programs

From `1.hello_world` to network sockets (`10.sockets`), inline assembly
(`asm`), AVR microcontroller blink (`m328p_blink`) and SHA-256. Each
example contains `src/`, `out/` (generated output) and a `Makefile`.
See [examples/README.md](../../examples/README.md).


## `tests/` — Test Suite

Each test is a directory with `src/main.modest`, a `Makefile` (`make test`)
and `out/{c,cm,llvm}/`. The active set is listed in `tests/run.sh`;
crypto tests (`sha256`, `aes256`, `chacha20`, `crc32`) verify end-to-end
semantics against known vectors.


## `misc/` — Everything Around the Compiler

`misc/editors/vscode/` — the VS Code extension: syntax highlighting for
`.modest` files, plus `install.sh` / `install.bat` that link it into the editor's
extensions directory. See
[misc/editors/vscode/README.md](../../misc/editors/vscode/README.md).


## Error Categories

The first digit of an error code identifies the compiler phase:
**0** OS & environment, **1** lexer, **2** parser, **3** translation,
**4** backend.


## Environment

| Variable | Purpose |
|----------|---------|
| `MODEST_DIR` | Compiler root directory |
| `MODEST_LIB` | Library search path |
