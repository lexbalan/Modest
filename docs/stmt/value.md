# Value evaluation statement

#### Common view

```golang
  1
```

#### Examples

```golang
func just () -> Unit {
  // you can eval value expression without result saving
  // it is senseless but you can
  2 + 2
  
  // this function call also returns value we discard
  // because we need only side effect (print line to stdout)
  printf("Hi there!\n")
}
```
