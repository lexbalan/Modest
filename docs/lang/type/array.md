# Array Type

An *array* is a fixed-length, contiguous sequence of elements of one
type, indexed from zero.

## Form

```
[<#length#>]<#element_type#>     // fixed array; length is a compile-time constant
[]<#element_type#>               // open array: length not part of the type
```

```modest
[10]Int32         // ten Int32
[2][3]Int32       // 2 x 3 matrix (array of arrays)
[]Char8           // open array of bytes/chars
*[]Int32          // pointer to open array
```

## Semantics

- Indexing: `a[i]`; slicing: `a[i:j]` (see [slice](../value/slice.md));
  element count: `lengthof(a)`.
- Multi-dimensional arrays are arrays of arrays: `m[1][2]`.
- An *open* array `[]T` has no length, so a variable of such type cannot
  be created — open arrays live behind pointers (`*[]T`) and as the
  pointed-to type of slices and strings.
- A pointer to array auto-derefs on indexing: with `p: *[10]Int32`,
  write `p[3]`, not `(*p)[3]` (see [pointer](./pointer.md)).
- Array parameters and assignments copy **by value**.
  Pass `*[N]T` / `*[]T` to share storage instead of copying.
- Generic array literals convert implicitly at equal length; explicit
  construction to a longer array zero-fills the tail; `= []` zero-fills
  entirely (see [generic](./generic.md)).

## Strings

String types are built-in aliases for open char arrays:

```modest
type Str8  = []Char8     // built-in
type Str16 = []Char16
type Str32 = []Char32
```

A string literal is a `[N]CharX` array value containing exactly the
characters written. Zero-termination is a property of the string *types*
(`@zarray`, see `docs/TODO.md`), appended when a string value is
constructed — not part of the literal itself. A string is normally
handled through a pointer:

```modest
var s: *Str8 = "Hello World!\n"
printf(s)
let c = s[0]              // 'H'
```

## Examples

```modest
func sum (v: *[]Int32, n: Nat32) -> Int32 {   // by reference
	var s: Int32 = 0
	var k: Nat32 = 0
	while k < n { s = s + v[k]; ++k }
	return s
}

func main () -> Int {
	var a: [5]Int32 = [1, 2, 3, 4, 5]
	a[0] = 10

	var i: Nat32 = 0
	while i < lengthof(a) {
		printf("%d\n", a[i])
		++i
	}

	var m: [2][3]Int32 = [[1, 2, 3], [4, 5, 6]]
	printf("%d\n", m[1][2])           // 6

	var b: [5]Int32 = []              // zero-filled
	b = a                             // copy by value
	return 0
}
```

<details>
<summary>C output (c11 backend)</summary>

```c
static int32_t sum(int32_t *v, uint32_t n) {
	int32_t s = 0;
	uint32_t k = 0;
	while (k < n) {
		s = s + v[k];
		k = k + 1;
	}
	return s;
}

int main(void) {
	int32_t a[5] = {1, 2, 3, 4, 5};
	a[0] = 10;
	uint32_t i = 0;
	while (i < LENGTHOF(a)) {
		printf("%d\n", a[i]);
		i = i + 1;
	}
	int32_t m[2][3] = {{1, 2, 3}, {4, 5, 6}};
	printf("%d\n", m[1][2]);
	int32_t b[5] = {0};
	__builtin_memcpy(&b, &a, sizeof(int32_t [5]));
	return 0;
}
```

</details>

## See also

- [Slice](../value/slice.md), [Index](../value/access.md)
- [sizeof / lengthof](../value/sizeof.md)
