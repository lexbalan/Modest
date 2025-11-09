# Compiler Directives

> OBSOLETE

## Conditional Compilation

*Conditional compilation* directives allows to activate/deactivate top level code dependently of some conditions. This conditions must be immediate value expressions with Bool type.

### Common form

```
$if (<# value_expression #>)
	// code activated
	// when value_expression is true
$endif
```

```
$if (<# value_expression #>)
	// code activated
	// when value_expression is true
$else
	// code activated
	// when value_expression is false
$endif
```

```
$if (<# value_expression_1 #>)
	// code activated
	// when value_expression_1 is true
$elseif (<# value_expression_2 #>)
	// code activated
	// when value_expression_1 is false
	// and value_expression_2 is true
$endif
```

```
$if (<# value_expression_1 #>)
	// code activated
	// when value_expression_1 is true
$elseif (<# value_expression_2 #>)
	// code activated
	// when value_expression_1 is false
	// and value_expression_2 is true
...
$elseif (<# value_expression_n #>)
	// code activated
	// when all value_expressions before are false
	// and value_expression_n is true
$else
	// code activated
	// when all value_expressions are false
$endif
```

### Examples

```swift
let systemWidth = 64

$if (systemWidth == 32)
import "./system32"
$elseif (systemWidth == 64)
import "./system64"
$elseif (systemWidth == 128)
import "./system128"
$else
@error("system not supported")
$endif


// using built-in 'function' __defined(id: String) -> Bool
$if (not __defined("version"))
let version = "0.1"
$endif
```


## Compiler messages

```swift
@info("this is an info message")
```
```swift
@warning("this is a warning message")
```
```swift
@error("this is an error message")
```


## Undef

```swift
var x: Int32

$if (__defined("x"))
@undef("x")
var x: Nat32
$endif
```


## Attributes & Properties

```swift
var byteFromUart: @volatile Word8
```

```swift
@alias("c", "int")
type Int Int32
```


## Pragmas

```swift
// this pragma makes compiler to
// not print include directive (only for C backend) for this file
pragma do_not_include
```

## Compiler Feature
Directive *feature* enables compiler feature for curent source file (analog of *-f* compiler option)
```swift
@feature("unsafe")
@feature("unsafe-downcast")
@feature("unsafe-int-to-ptr")
@feature("unsafe-ptr-to-int")
...
```


