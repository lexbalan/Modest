
# Lightfood library

## Memory
```zig
func memzero(mem: Pointer, len: Nat64) -> Unit
func memcopy(dst: Pointer, src: Pointer, len: Nat64) -> Unit
func memeq(dst: Pointer, src: Pointer, len: Nat64) -> Bool
```

## Delay
```zig
func delay_us(us: Nat64)
func delay_ms(ms: Nat64)
func delay_s(s: Nat64)
```

## String
```zig
func str8_len(cstr: *Str8) -> Nat64
func str16_len(cstr: *Str16) -> Nat64
func str32_len(cstr: *Str32) -> Nat64
```

## Print
```zig
func lf_printf(str: *[]Char8, va_list: VA_List)
```
