
# Attributes

Attribute can be added to defined new entity.

```zig
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

**c-no-print** - entity must not be printed in C output

**dispensable** - means that result of function call can be ignored

**extern** - add C "extern"

**static** - add C "extern"

**volatile** - add C "extern"

**global** - do not add "static" to top-level variable (by default - static)



Property `gnu_att`
```
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
