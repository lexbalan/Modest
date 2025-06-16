# Value evaluation statement

#### Common form

```
<# value_expression #>
```

#### Examples

```swift
public func main () -> Int32 {
	// usually we discard printf return value
	// because we need only side its effect (print line to stdout)
	printf("Hi there!\n")

	// you can eval value expression without result saving
	// it is senseless (and will cause compiler warning), but you can
	2 + 2

	return 0
}
```
