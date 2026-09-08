# Modest

 Swift-like programming language, created for medium level system programming and embedded development.

* Modern syntax for clear and readable code
* Strong type system protects your code from occasional bugs
* Medium level language (like C) - makes it suitable for system and embedded development

Strong typed, concise syntax, medium level programming language, that you can translate to LLVM IR or C language output (just choose preferred backend).
Now language and compiler on research & development stage.

If you are interested with the project, write to me what you thought about it.
You can contact me by telegram: t.me/@alexbalan.


## Documentation

| Where | What |
| :-- | :-- |
| `lang/` | [Language reference](https://lexbalan.github.io/Modest/lang/) — one page per construct: Form, Semantics, Examples |
| `CHEATSHEET.md` | [Cheat sheet](https://lexbalan.github.io/Modest/CHEATSHEET.html) — the whole language on one page |
| `EBNF.txt` | [the grammar](https://lexbalan.github.io/Modest/EBNF.txt), kept in step with the parser |
| `INSTALL.md` | [Installation](https://lexbalan.github.io/Modest/INSTALL.html) — Python 3.11, Clang, environment |
| `USAGE.md` | [Usage](https://lexbalan.github.io/Modest/USAGE.html) — invoking `modest`, flags, backends, config |
| `compiler/` | [How the compiler works](https://lexbalan.github.io/Modest/compiler/) — pipeline, module map, where to make a change |
| `todo/` | [Design TODO](https://lexbalan.github.io/Modest/todo/TODO.html) — planned work, not yet decided in code |
| `agents/claude/` | notes for AI assistants: task index and HLIR internals |

### What is not settled yet

The project is at the research stage, and three lists say what is unfinished —
each entry carries a tag you can copy into a search:

| Where | What | Tag |
| :-- | :-- | :-- |
| [`BUGS.md`](https://lexbalan.github.io/Modest/BUGS.html) | the compiler does not do what the language says | `BUG#20` |
| [`lang/QUESTIONS.md`](https://lexbalan.github.io/Modest/lang/QUESTIONS.html) | the language has not decided, so there is nothing to be wrong about yet | `QUESTION#4` |
| [`DOUBTS.md`](https://lexbalan.github.io/Modest/DOUBTS.html) | it works, but the shape inside is wrong | `DOUBT#2` |


