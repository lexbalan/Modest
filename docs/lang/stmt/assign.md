# Assignment Statement

Stores a value into an lvalue. Assignment is a statement, not an
expression — it produces no value and cannot be chained.

## Form

```
<#lvalue#> = <#value_expression#>
```

There are **no compound assignment operators** (`+=`, `-=`, ...); write
`x = x + 1`, or use `++x` / `--x` for increment and decrement.

## Lvalues

```modest
x = 10                   // variable
arr[i] = 10              // array element
arr[1:4] = [3]Int32 [1, 2, 3]   // slice (copies elements)
p.field = 10             // record field (auto-deref through pointer)
*p = 10                  // pointed-to value
```

The right-hand side is implicitly [constructed](../value/cons.md) to the
lvalue's type; incompatible types are an error.

## Increment / decrement

`++x` and `--x` are statements (prefix only):

```modest
var i: Nat32 = 0
while i < n {
	++i
}
```

## Notes

- `let` bindings, constants and function parameters are not assignable.
