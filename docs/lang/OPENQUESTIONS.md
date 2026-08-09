# Open Questions

Language design decisions that have not been made yet — places where the
compiler already does *something*, but the language has not said what the
right thing is.

This is deliberately separate from the two other lists:

| List | Holds |
| :-- | :-- |
| [`BUGS.md`](../BUGS.md) | the compiler does not do what the language says |
| [`DOUBTS.md`](../DOUBTS.md) | the implementation works but is the wrong shape inside |
| here | the **language** has not decided, so there is nothing to be wrong about yet |

A question leaves this page when it is answered: the answer goes into the
reference page it belongs to, and whatever the compiler does differently
becomes an ordinary entry in `BUGS.md`.

Unlike the reference pages, entries here are not Form/Semantics/Examples.
Each one states the question, what the compiler happens to do today, the
options with their consequences, and what an answer would touch.

---

## 1. Should a function return something by default?

**Question.** Must every non-`Unit` function return a value on every path,
or is falling off the end legal — with the language supplying a default
value?

`Unit` functions are not in question: they may end without `return`, and
that is settled.

### Where it stands today

A missing `return` is a **warning** (`expected return operator at end`),
and the backends then disagree about what the function gives back:

```modest
func maybe (a: Int32) -> Int32 {
	if a > 0 {
		return 111
	}
}

printf("%d\n", maybe(0))    // c11: -1910964223    llvm: 0
```

Three things about the current state are worth knowing before deciding,
because each of them is a consequence of not having decided:

- **The check is syntactic, not flow-based.** It asks whether the last
  statement of the body is a `return`, nothing more. So a function whose
  every path demonstrably returns still gets the warning:

  ```modest
  func sign (a: Int32) -> Int32 {
      if a > 0 {
          return 1
      } else {
          return 0
      }
  }                          // warning, though no path falls through

  func spin () -> Int32 {
      while true {
          return 1
      }
  }                          // warning, though the body cannot be left
  ```

- **Only one backend fills the gap.** The LLVM backend appends a default
  `return` when the body does not end in one — which is what keeps its
  output valid — and the C backend appends nothing, letting the function
  run off its end, which is undefined behaviour in C. See
  [`BUGS.md`](../BUGS.md) #16.

- **Not every type has a default to fall back on.** Record return types
  get nothing, and the emitted IR stops mid-function:

  ```modest
  type Point = {
      x: Int32
      y: Int32
  }

  func makePoint () -> Point {
  }              // warning: expected return operator at end
  ```

  ```llvm
  %Point = type {
      %Int32,
      %Int32
  };

  define internal %Point @makePoint() {
  ```
  ```
  error: found end of file when expecting more instructions
  ```

  The file ends there — no body, no closing brace. Which return types are
  covered today:

  | Return type | Default `return` |
  | :-- | :-- |
  | `Int32`, `Bool`, `Float64` | `ret %Int32 0`, `ret %Bool 0`, ... |
  | pointer | `ret %Int32* null` |
  | array | not needed — returned through hidden storage, body is filled |
  | **record** | **none — output truncated**, any size |

  This one is not filed as a bug on purpose: whether it is a defect at all
  depends on the answer below. Under option A the program stops being
  legal and there is nothing to fix; under option B it becomes a plain
  gap in the default-value rules.

### Options

**A. Make it an error.** Every non-`Unit` function must return on every
path. Nothing falls off the end, so backends have nothing to disagree
about and no default value is ever needed.

- Fits a language that already refuses to guess elsewhere: no implicit
  numeric conversion, no implicit `Bool`, no implicit widening.
- Costs nothing at runtime.
- Requires the check to become real reachability analysis. The two
  examples above must stop warning, or the error would reject correct
  programs — this is the actual work in this option.

**B. Make the default explicit and legal.** Falling off the end returns
the type's default value, as a defined language rule.

- Requires the language to define a default for *every* return type —
  including records, branded types, arrays, and pointers to functions —
  and to say so in the reference.
- Requires the C backend to emit the same value the LLVM backend does.
- Makes a silently incomplete function a legal thing to write, which is
  the part worth weighing: the warning exists because that is usually a
  mistake.

**C. Keep the warning, just make the backends agree.** The smallest
change: pick one behaviour and implement it in both.

- Closes the divergence without deciding anything.
- Leaves a construct that is undefined-ish by policy and only warned
  about — the state this list exists to get out of.

### What an answer touches

- [`stmt/return.md`](./stmt/return.md) — currently documents the warning
- the default-value rules, if option B
- the end-of-body check in `semantic.py`, if option A
- both backends, under any option

### Related

- [`BUGS.md`](../BUGS.md) #16 — the divergence itself

---

## 2. In what order are call arguments evaluated?

**Question.** Is the evaluation order of arguments part of the language,
or left unspecified as it is in C? Left to right is the expected answer —
but left to right *of what*: the order the arguments are **written**, or
the order the parameters are **declared**? The two differ as soon as
named arguments are used out of order.

### Where it stands today

Every combination tried evaluates left to right, and nothing disagrees:

```modest
func mark (id: Int32) -> Int32 {        // records that it ran, returns id
	...
}

take3(mark(1), mark(2), mark(3))        // 1 2 3 everywhere
```

| | order observed |
| :-- | :-- |
| `-mbackend=llvm` | 1 2 3 |
| `-mbackend=c11` + clang 14, `-O0` and `-O2` | 1 2 3 |
| `-mbackend=c11` + gcc 14 | 1 2 3 |

Two things about that agreement are worth knowing before leaning on it.

- **Only one backend actually pins the order.** The LLVM backend emits
  the calls as a sequence of `call` instructions, so the order is fixed
  by construction. The C backend emits the arguments as expressions
  inside the C call —

  ```c
  (void)take3(mark(1), mark(2), mark(3));
  ```

  — and argument evaluation order is *unspecified* in C. The table above
  records what two compilers happen to do on one target; it is not a
  guarantee the language can offer.

- **Named arguments already answer the second half — as parameter
  order.** They are rewritten into declaration order before emission:

  ```modest
  area(h = mark(1), w = mark(2))    // written: h first
  ```
  ```c
  area(mark(2), mark(1));           // emitted: w first
  ```

  So `mark(2)` runs first, and the de-facto rule today is "left to right
  through the parameter list", not "left to right across the source
  line". Whichever way this is settled, that behaviour is either the
  answer or a bug.

### Options

**A. Left to right in parameter order** — a guarantee, matching what
happens today.

- The C backend has to stop delegating: arguments would be evaluated into
  temporaries in order, then passed.
- That costs readability in the C output, which is a stated goal of the
  project — a plain `f(g(), h())` becomes two locals and a call. Whether
  to pay it always, or only when an argument can have side effects, is
  part of this option.

**B. Left to right in written order.** Same cost as A, plus named
arguments must stop being reordered.

- Arguably the more surprising rule: `f(b = g(), a = h())` would run
  `g()` first, and a reader checking against the signature sees the
  opposite.

**C. Leave it unspecified**, as C does.

- Costs nothing and keeps the C output plain.
- But the same program could then legitimately behave differently under
  `-mbackend=c11` and `-mbackend=llvm` — the shape of problem this
  project keeps having to chase down (see [`BUGS.md`](../BUGS.md) #16).
  "Unspecified" is a cheap answer that gets expensive later.

### What an answer touches

- [`value/call.md`](./value/call.md) — says nothing about order today
- the C backend, under options A and B
- a test: the order is observable, so it can be pinned down like any
  other behaviour

### Related

- [`value/call.md`](./value/call.md) — argument passing and named arguments
- [`BUGS.md`](../BUGS.md) #16 — backends disagreeing on unspecified behaviour
