# BUGS

Open compiler bugs. Found 2026-07-09 while checking `docs/EBNF.txt` against
the parser; every item below is reproduced with `mcc -mbackend=c11`.

## 1. `record { ... }` type form is rejected (and the error is followed by a crash)

**Status: fixed 2026-07-09** (`check_is_type` recognizes `record` + `{`; semantic
guards `type X = <nothing/bad>` with a diagnostic instead of a crash).

```modest
type R = record {
	x: Int32
}
```

Gives `error: expected type expr`, then an unhandled `TypeError` traceback in
`semantic.py` (`do_type` receives `None`).

- Cause: in `check_is_type` (`src/parser.py`), the lowercase-identifier branch
  returns `False` from inside its `while` loop before the
  `return token in ['record']` line can ever run — that line is dead code.
- Expected: `record { ... }` parses the same as bare `{ ... }`
  (EBNF: `['record'] '{' [fields] '}'`). Also `type X = <bad type>` should
  recover with a diagnostic instead of crashing.

## 2. `let a, b = v` silently drops every identifier after the first

**Status: fixed 2026-07-09** (`stmt_let` / `parse_def_const` now declare the
whole id list, symmetric with `var a, b: T`).

```modest
let x, y = 5
// compiles; y is undefined below, no diagnostic at the let
```

- Cause: `stmt_let` and `parse_def_const` take `parse_stmt_field()[0]`,
  discarding the rest of the id list that `parse_stmt_field` parsed.
- Expected: declare all listed ids (as `var a, b: Int32` does) or report an
  error at the comma.

## 3. Postfix operators after a slice are silently dropped

```modest
let x = arr[1:3][0]
// compiles; x becomes the slice, [0] vanishes
```

- Cause: `expr_value_11` returns immediately after parsing a slice instead of
  continuing the postfix loop; the trailing `[0]` is then parsed as a
  standalone array-literal statement and discarded by codegen.
- Expected: postfix ops after a slice apply to the slice result (or are
  rejected with a diagnostic).

## 4. Full slice `arr[:]` is a parse error

**Status: fixed 2026-07-09** (both bounds independently optional; an open
upper bound — `[i:]`, `[:]` — now defaults to the array length when it is
known, which also un-breaks `arr[i:]` in `let`/`var` bindings).

```modest
let s = arr[:]
// error: unexpected token ']'
```

- Cause: in `expr_value_11`, when the lower bound is omitted the upper bound
  is parsed unconditionally, so `[:]` never matches.
- Expected: both bounds independently optional — `[:]` copies the whole
  array and completes the family `[i:j]`, `[i:]`, `[:j]`, `[:]`
  (EBNF already allows it).

## 5. Unterminated record type hangs the compiler

```modest
type Broken = {
	x: Int32
// EOF here — mcc spins forever, no diagnostic
```

- Cause: the field loop in `parse_type_record` (`src/parser.py`) has no
  end-of-input check; at EOF `parse_stmt_field` keeps producing empty
  identifiers without consuming anything.
- Expected: `error: expected '}'` (unexpected end of file) and exit.

## 6. Fields of function-local record types are inaccessible (needs triage)

```modest
func main () -> Int32 {
	type L = { a: Int32 }
	var v: L
	v.a = 7        // error: access to private field of record
	return v.a
}
```

The same record defined at module level works fine. Possibly the
access-level check ties the local definition to the wrong scope.

