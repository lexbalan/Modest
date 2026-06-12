# Array Type

An *array* is a fixed-length, contiguous sequence of elements of one
type, indexed from zero. An array is an ordinary value type — unlike C,
there is **no array decay**.

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
- **By value, everywhere**: arrays are passed to functions, returned
  from functions and assigned by value — the whole content is copied,
  the size is part of the type. An array never silently turns into a
  pointer. To share storage instead of copying, pass `*[N]T` / `*[]T`
  explicitly.
- Generic array literals convert implicitly at equal length; explicit
  construction to a longer array zero-fills the tail; `= []` zero-fills
  entirely (see [generic](./generic.md)).

## Strings

String types are built-in aliases for open char arrays:

```modest
// built-in definitions
type Str8  = []Char8
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
let c = s[0]              // Char8 'H'
```

## Examples

```modest
func sum (v: *[]Int32, n: Nat32) -> Int32 {   // explicit by-reference
	var s: Int32 = 0
	var k: Nat32 = 0
	while k < n { s = s + v[k]; ++k }
	return s
}

func makeTriple (x: Int32) -> [3]Int32 {      // returned by value
	var r: [3]Int32 = [x, x + 1, x + 2]
	return r
}

func main () -> Int {
	var a: [5]Int32 = [1, 2, 3, 4, 5]
	a[0] = 10
	printf("sum = %d\n", sum(&a, lengthof(a)))

	var t: [3]Int32 = makeTriple(10)  // t = [10, 11, 12]

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

static void makeTriple(int32_t x, int32_t *__out) {
	int32_t r[3];
	__builtin_memcpy(&r, &(int32_t [3]){x, x + 1, x + 2}, sizeof(int32_t [3]));
	__builtin_memcpy(__out, &r, sizeof(int32_t [3]));
}

int main(void) {
	int32_t a[5] = {1, 2, 3, 4, 5};
	a[0] = 10;
	printf("sum = %d\n", sum(a, LENGTHOF(a)));
	int32_t t[3];
	makeTriple(10, t);
	int32_t b[5] = {0};
	__builtin_memcpy(&b, &a, sizeof(int32_t [5]));
	return 0;
}
```

Note how the *value semantics* survives the translation: array return
becomes an out-parameter + `memcpy`, assignment becomes `memcpy` — the
copying is real, only expressed in C terms.

</details>

## See also

- [Slice](../value/slice.md), [Index](../value/access.md)
- [sizeof / lengthof](../value/sizeof.md)
