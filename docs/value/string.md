# String value expression

String value literal is a form of array with type GenericArray of GenericChar.

```zig
"Hello World!"
```

There is no special type for string, but you can construct an array or pointer to array from literal string value.
Also there is three built-in named type aliases for convenient usage of strings:
```
// built-in type aliases
// type Str8 []Char8
// type Str16 []Char16
// type Str32 []Char32
```


#### Exmples

Creating three arrays of Char from string literal

```zig
const literalString = "I am a string literal"

var str_array8: []Char8 = literalString
var str_array16: []Char16 = literalString
var str_array32: []Char16 = literalString
```


Creating three pointer to arrays of Char from string literal

```
const literalString = "I am a string literal"

var ptr_to_str8: *[]Char8 = literalString
var ptr_to_str16: *[]Char16 = literalString
var ptr_to_str32: *[]Char32 = literalString
```

Or (the same):

```
const literalString = "I am a string literal"

var ptr_to_str8: *Str8 = literalString
var ptr_to_str16: *Str16 = literalString
var ptr_to_str32: *Str32 = literalString
```



```zig
import "libc/stdio.hm"

func main () -> Unit {
  var s: *Str8
  s = "Hello \"World!\""
  printf("s = %s\n", s)
}

```
> Result: `s = "Hello World!"`
