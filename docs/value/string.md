# String value expression

String value literal is a form of array with type GenericArray of GenericChar.

```zig
"Hello World!"
```

There is no special type for string, but you can construct an *array* or *pointer to array* from literal string value.
Also there is three built-in named type aliases for convenient usage of strings:
```zig
// built-in type aliases:
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
var str_array32: []Char32 = literalString
```


Creating three pointer to arrays of Char from string literal

```zig
const literalString = "I am a string literal"

var ptr_to_str8: *[]Char8 = literalString
var ptr_to_str16: *[]Char16 = literalString
var ptr_to_str32: *[]Char32 = literalString
```

Or (the same):

```zig
const literalString = "I am a string literal"

var ptr_to_str8: *Str8 = literalString
var ptr_to_str16: *Str16 = literalString
var ptr_to_str32: *Str32 = literalString
```



```zig
import "libc/stdio.hm"

func main () -> Int32 {
    // creating local variable with type *[]Char8 (aka *Str8)
    var string: *Str8

    // implicit cast string literal
    // (GenericArray of GenericChar) to *Str8 
    string = "Hello World!"

    // print string via printf
    printf("string = \"%s\"\n", string)

    return 0
}

```
> Result: `s = "Hello World!"`
