# The Modest Compiler

`mcc` is a Python-based compiler that translates Modest (`.m`) sources
to C11, LLVM IR, or back to Modest.

```
compiler
├── usage       invocation, flags, config, testing ....... usage.md
├── overview    pipeline: lexer → parser → translator
│               → backends; where to make a change ....... overview.md
└── structure   directory & file map of the repo ......... STRUCTURE.md
```

Related:
- [Language reference](../lang/README.md)

- [HLIR internals](../agents/claude/hlir-internals.md) — all
  `Type*` / `Value*` / `Stmt*` classes with fields
- [Task-oriented index](../agents/claude/context.md) — where to look
  for each task type
- [Known bugs](../BUGS.md) · [Design TODO](../TODO.md)

