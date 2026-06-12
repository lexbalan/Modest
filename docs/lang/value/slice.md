# Slice

Selects a contiguous sub-array `[from, to)`.

> Slices are an experimental feature; see `docs/BUGS.md` for known
> codegen issues with slice assignment.

## Form

```
<#array_value#>[<#from#> : <#to#>]
<#pointer_to_array#>[<#from#> : <#to#>]
```

## Semantics

- `a[i:j]` denotes elements `i` .. `j-1`; its length is `j - i`.
- Works on arrays and pointers to arrays (auto-deref).
- A slice can be an assignment target: `a[1:4] = [3]Int32 [1, 2, 3]`
  copies elements into the range.
- An open array of open arrays cannot be sliced
  (`cannot slice array of an open array`).

## Examples

```modest
var a: [5]Int32 = [1, 2, 3, 4, 5]
let mid = a[1:4]              // [2, 3, 4]
a[0:2] = [2]Int32 [9, 9]
```

## See also

- [Index](./_index.md), [Array type](../type/array.md)
