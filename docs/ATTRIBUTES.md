
# Attributes

Attribute can be added to defined new entity.

```golang
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
**arghack** - function allows extra arguments
**dispensable** - means that result of function call can be ignored