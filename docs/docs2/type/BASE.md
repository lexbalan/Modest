# Base Types

Primitive types built into the language.

## Integer Types

| Type | Size | Range | Usage |
|------|------|-------|-------|
| `Int8` | 1 byte | -128 to 127 | Signed 8-bit |
| `Int16` | 2 bytes | -32,768 to 32,767 | Signed 16-bit |
| `Int32` | 4 bytes | -2^31 to 2^31-1 | Signed 32-bit (common) |
| `Int64` | 8 bytes | -2^63 to 2^63-1 | Signed 64-bit |
| `Nat8` | 1 byte | 0 to 255 | Unsigned 8-bit |
| `Nat16` | 2 bytes | 0 to 65,535 | Unsigned 16-bit |
| `Nat32` | 4 bytes | 0 to 2^32-1 | Unsigned 32-bit |
| `Nat64` | 8 bytes | 0 to 2^64-1 | Unsigned 64-bit |

**Example:**
```modest
var a: Int32 = -100
var b: Nat32 = 200
```

## Floating Point Types

| Type | Size | Usage |
|------|------|-------|
| `Float32` | 4 bytes | 32-bit IEEE 754 |
| `Float64` | 8 bytes | 64-bit IEEE 754 (common) |

**Example:**
```modest
var pi: Float64 = 3.14159
var x: Float32 = 2.5
```

## Boolean Type

```modest
var flag: Bool
flag = true
flag = false
```

## Character Types

| Type | Size | Usage |
|------|------|-------|
| `Char8` | 1 byte | 8-bit character |
| `Char16` | 2 bytes | 16-bit character (UTF-16) |
| `Char32` | 4 bytes | 32-bit character (UTF-32) |

**Example:**
```modest
var c: Char8 = "A"
```

## Void Type (Unit)

```modest
func no_return () -> Unit {
    // returns nothing
}
```

## Word Types (Bitwise Operations)

For bit manipulation:

```modest
var byte: Word8 = 0xFF
var word: Word32 = 0xDEADBEEF
```
