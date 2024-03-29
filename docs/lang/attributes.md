
# Attributes

Attributes are a way to change (or add) meta information of defined entities. Using the attribute mechanism allows you to influence the compilation process

```swift
@attribute("dispensable")
func my_func () -> Int {
  return 0
}

func main () {
  // Here we ignore my_func return value,
  // but there is no warning,
  // because my_func defined with attribute "dispensable"
  my_func()
}
```

**c-no-print** - entity definition must not be printed by C printer

**dispensable** - means that result of function call can be ignored

**extern** - add C "extern" modifier

**static** - add C "static" modifier

**volatile** - add C "volatile" modifier

**global** - do not add "static" to top-level variable (by default - static)



Property `gnu_att`
```swift
@property("gnu_att", "interrupt(\"WCH-Interrupt-fast\")")
func wch_systick_interrupt() {
    //
}
```

will be translated into

```
__attribute__((interrupt("WCH-Interrupt-fast")))
void wch_systick_interrupt()
{
    //
}
```
