# Top Level Definitions

*Top level definitions* create a top level entity (type alias, constant, variable or function). You can learn more about top-level definitions by clicking on the link below.

  * [type definition](./type.md)
  * [constant definition](./const.md)
  * [variable definition](./var.md)
  * [function definition](./func.md)


## Short Examples

#### Type Definition
```swift
type AxisType Int32
type MyArray [10]Int32
type MyPoint2D record {x: AxisType, y: AxisType}
type MyPoint3D record {
    x: AxisType
    y: AxisType
    z: AxisType
}
```

#### Constant Definition
```golang
const myConst = 2 + 2
const anotherConst = myConst + 2 * 2
const greetingText = "Hello!"
```

#### Variable Definition
```swift
var myCounter: MyInt
var pointerToMyCounter: *MyInt = &myCounter
var myPoint2D: Point2D = {x = 0, y = 0}
var pointerToMyPoint3D: *Point3D
```

#### Function Definition
```swift
func show_greeting () {
    printf("%s\n", greetingText)
}

func main () -> Int {
    show_greeting()
    return 0
}
```

