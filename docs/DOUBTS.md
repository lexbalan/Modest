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
`x.value.addAttribute("immutable")`), and `is_immutable()`
(`src/hlir/types.py:1858`) has to OR the two together:

```python
return (not self.isLvalue()) or self.is_immutable or self.hasAttribute('immutable')
```

Two overlapping ways to say "this value can't be reassigned," only joined
at the one check site. Everywhere else that touches immutability has to
remember both exist.

- Symptom: the self-print backend (`-mbackend=modest`) silently drops
  `@immutable` when reprinting — see `tests/in_y_minutes/out/cm/main.modest`,
  where `@immutable var locked: Int32 = 40` comes back out as plain
  `var locked: Int32 = 40` merged onto the previous `let` line, no
  diagnostic. Generic attributes clearly aren't being carried through the
  printer with the same care as `is_immutable` is through codegen.
- Open question: should `@immutable` just set `is_immutable` directly on
  the def's value instead of going through the attribute bag, so there's
  one source of truth and the printer doesn't need special-case handling
  to preserve it?

## 2. An array-returning call zeroes its buffer before the callee fills it

A function that returns an array is compiled with an sret parameter and
gives that same pointer back, so the call stays an expression
(`src/backend/c11.py:189`). Where the call stands in a value position there
is no storage to lend it, and the backend supplies one with a compound
literal (`do_cvalue_call`, `src/backend/c11.py:1067`):

```c
__builtin_memcmp(makeVec((Vec3){0}), &v, sizeof(Vec3)) == 0
```

C has no compound literal without an initializer, so `(Vec3){0}` zeroes the
buffer immediately before the callee overwrites every byte of it.

- Cost: real, and it survives optimization. With a 1024-element array and a
  callee the optimizer cannot see into, clang at `-O2` emits a `bzero` of
  4 KiB and then the call that fills the same memory. For the small arrays
  in the tree today it is noise; it scales with the array.
- The shape that has no such cost is an uninitialized temporary declared at
  the top of the enclosing C block, used through the comma operator:
  `(makeVec(__tmp1), __tmp1)`. That needs a small pool of block-scoped
  temporaries in the function context — machinery the C backend does not
  have at all today, which is the only reason it is not doing this.
- Whatever replaces the literal must keep the call **inside** the
  expression. Hoisting it into a statement before the expression would make
  it unconditional as the right operand of `and` / `or`, and C's `&&` / `||`
  is the only reason this backend short-circuits — see
  `OPENQUESTIONS.md` #4. Declaring the temporary is fine; moving the call
  is not.
- The same compound-literal trick gives a record returned by a call an
  address for `memcmp` (`do_cvalue_as_ptr`, `src/backend/c11.py:2694`), and
  there the initializer is the call itself — no wasted store. Only the
  array path pays.
- Open question: introduce block-scoped temporaries and use them for both,
  or keep the literal and accept the zeroing for what are, in practice,
  small arrays?
- Where it stands: the literal stays, deliberately (2026-08-27). Nothing in
  the tree returns an array big enough for the zeroing to matter, and the
  temporaries are a machinery the backend would carry forever for a cost
  nobody is paying yet. What would reopen it: an array-returning function
  whose result is measurably large, or a second place in the backend that
  needs a temporary anyway — at that point the pool earns itself twice.
