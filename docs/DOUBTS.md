# Doubts

Questionable design/implementation choices worth revisiting — not confirmed
bugs (those go in `BUGS.md`), just spots where the current approach feels
like the wrong shape and might be worth a redesign discussion.

## 1. `@immutable` piggybacks on the generic attribute bag instead of being a first-class flag

`Value` already tracks immutability as a dedicated field, `is_immutable`
(`src/hlir/types.py:1777`), propagated explicitly through binary-op codegen
(`src/semantic.py:1322,1406,1474`). But `@immutable` itself is wired up as
just another entry in the generic `attributes` dict
(`src/semantic.py:3127-3129`, `add_att(x, "immutable")` +
`x.value.addAttribute("immutable")`), and `isValueImmutable()`
(`src/hlir/types.py:1858`) has to OR the two together:

```python
return (not self.isLvalue()) or self.is_immutable or self.hasAttribute('immutable')
```

Two overlapping ways to say "this value can't be reassigned," only joined
at the one check site. Everywhere else that touches immutability has to
remember both exist.

- Symptom: the self-print backend (`-mbackend=modest`) silently drops
  `@immutable` when reprinting — see `tests/in_y_minutes/out/cm/main.m`,
  where `@immutable var locked: Int32 = 40` comes back out as plain
  `var locked: Int32 = 40` merged onto the previous `let` line, no
  diagnostic. Generic attributes clearly aren't being carried through the
  printer with the same care as `is_immutable` is through codegen.
- Open question: should `@immutable` just set `is_immutable` directly on
  the def's value instead of going through the attribute bag, so there's
  one source of truth and the printer doesn't need special-case handling
  to preserve it?
