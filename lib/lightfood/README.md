
# Lightfood library

## Memory
```zig
func memzero(memPtr, len: Nat64) -> Unit
func memcopy(dstPtr, srcPtr, len: Nat64) -> Unit
func memeq(dstPtr, srcPtr, len: Nat64) -> Bool
```

## Delay
```zig
func delay_us(us: Nat64)
func delay_ms(ms: Nat64)
func delay_s(s: Nat64)
```

## String
```zig
func str8_len(str: *Str8) -> Nat64
func str16_len(str: *Str16) -> Nat64
func str32_len(str: *Str32) -> Nat64
```

## Print
```zig
func lf_printf(str: *Str8, ...)
```
