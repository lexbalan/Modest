# Top Level Definitions

*Top level definition* create a global entity (*type alias*, *constant*, *variable* or *function*). You can learn more about top-level definitions by clicking on the link below.

  * [Type definition](./type.md)
  * [Constant definition](./const.md)
  * [Variable definition](./var.md)
  * [Function definition](./func.md)


## Fast Examples

#### [Type Definition](./type.md)
```swift
type AxisType = Int64
type MyArray = [10]Int32
type MyPoint2D = record {x: AxisType, y: AxisType}
type MyPoint3D = record {
	x: AxisType
	y: AxisType
	z: AxisType
}
```

#### [Constant Definition](./const.md)
```golang
const one = 1
const two = one + 1
const greetingText = "Hello!"
```

#### [Variable Definition](./var.md)
```swift
var myCounter: MyInt
var pointerToMyCounter: *MyInt = &myCounter
var myPoint2D: Point2D = {x = 0, y = 0}
var pointerToMyPoint3D: *Point3D
```

#### [Function Definition](./func.md)
```swift
func show_greeting (text: *Str8) -> Unit {
	printf("%s\n", text)
}

func sum64 (a: Int64, b: Int64) -> Int64 {
	return a + b
}

public func main () -> Int32 {
	show_greeting(greetingText)

	let a = 10
	let b = 20
	let s = sum64(a, b)
	printf("sum64(%i, %i) -> %i\n", a, b, s)

	return 0
}
```

