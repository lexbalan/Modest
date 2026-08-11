# The Modest Compiler

`mcc` is a Python-based compiler that translates Modest (`.modest`) sources
to C11, LLVM IR, or back to Modest.

| Page | Contents |
| :-- | :-- |
| [usage](./usage.md) | invocation, flags, config, testing |
| [overview](./overview.md) | pipeline: lexer → parser → translator → backends; where to make a change |
| [structure](./STRUCTURE.md) | directory & file map of the repo |
| [modules](./modules.md) | module responsibilities, layers, dependency graph, state ownership |

Related:
- [Language reference](../lang/README.md)
- [HLIR internals](../agents/claude/hlir-internals.md) — all
  `Type*` / `Value*` / `Stmt*` classes with fields
- [Task-oriented index](../agents/claude/context.md) — where to look
  for each task type
- [Known bugs](../BUGS.md) · [Design TODO](../todo/TODO.md)

