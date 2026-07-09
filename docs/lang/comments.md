# Comments

Comments are for the reader — they do not affect compilation.

## Form

```
// <#text — to end of line#>
/* <#any text#> */
```

## Semantics

- `//` extends to the end of the line; the newline itself still
  terminates the statement.
- `/* ... */` may span several lines. Block comments do **not** nest —
  the first `*/` closes the comment.
- Comments are not carried into the output. Exception: the `modest`
  pretty-printer backend preserves module-level `//` comments.
  (Planned: full pass-through for the `c11` and `modest` backends —
  see [TODO](../todo/TODO.md).)
- Unicode is allowed in comments (and string literals) — but not in
  [identifiers](./identifier.md).

## Examples

```modest
// about main
func main () -> Int {
	/* block
	   comment */
	return 0  // inline comment — two spaces before //
}
```

## See also

- [Code style](../CHEATSHEET.md#code-style)
