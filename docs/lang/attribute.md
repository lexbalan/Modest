
# Attributes

Attributes are a way to change (or add) meta information to entities. Using the attribute mechanism allows you to influence the translation process

```swift
func my_func () -> @unused Int {
	return 0
}

public func main () -> Unit {
	// Here we ignore my_func return value,
	// but there is no warning,
	// because my_func return type declared with attribute "unused"
	my_func()
}
```

**no_print** - entity definition must not be printed

**c_no_print** - entity definition must not be printed by C printer

**ll_no_print** - entity definition must not be printed by LLVM printer

**dispensable** - means that result of function call can be ignored

**extern** - add C "extern" modifier

**static** - add C "static" modifier

**volatile** - add C "volatile" modifier

**global** - do not add "static" to top-level variable (by default - static)



Property `gnu_att`
```swift
@set("gnu_att", "interrupt(\"WCH-Interrupt-fast\")")
func wch_systick_interrupt () -> Unit {
	//
}
```

will be translated into

```
__attribute__((interrupt("WCH-Interrupt-fast")))
void wch_systick_interrupt() {
	//
}
```
