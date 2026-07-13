# Asm Statement

Embeds target assembly into a function body. Maps directly to GCC
extended asm (`__asm__ volatile` in the C backend, `call asm` in LLVM).

## Form

```
__asm(<#asm_text#>)
__asm(<#asm_text#>, <#outputs#>, <#inputs#>, <#clobbers#>)

outputs, inputs:   [[<#constraint#>, <#value#>], ...]
clobbers:          [<#name#>, ...]
```

## Semantics

- A statement — produces no value. Only the asm text is mandatory.
- `%0`, `%1`, ... in the text refer to the operands in order: outputs
  first, then inputs.
- Constraint strings are the GCC ones: `"r"` — register, `"=r"` —
  written register, `"=&r"` — early-clobber output; clobbers list what
  else the code touches (`"cc"`, `"memory"`, register names).
- An output operand counts as initializing its variable — an
  uninitialized `var` written by `__asm` may be read afterwards.
- The asm text is target assembly: it must match the configured
  architecture (`cfg/*.toml`), the compiler does not inspect it.

## Examples

```modest
__asm("nop")
```

```modest
// AArch64
func sum64 (a: Int64, b: Int64) -> Int64 {
	var sum: Int64
	__asm("add %0, %1, %2", [["=r", sum]], [["r", a], ["r", b]], ["cc"])
	return sum
}
```

emitted C:

```c
__asm__ volatile ("add %0, %1, %2" : "=r" (sum) : "r" (a), "r" (b) : "cc");
```

## See also

- [Function definition](../def/func.md)
