# Top Level Definitions

*Top level definitions* create a top level entity (type alias, constant, variable or function). You can learn more about top-level definitions by clicking on the link below.

  * [type definition](./type.md)
  * [constant definition](./const.md)
  * [variable definition](./var.md)
  * [function definition](./func.md)


## Short Examples

#### Type Definition
```swift
type MyInt Int32
type MyArray [10]Int32
type MyPoint2D record {x: Int64, y: Int64}
type MyPoint3D record {
    x: Int64
    y: Int64
    z: Int64
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
var myPoint2D: Point2D
var pointerToMyPoint3D: *Point2D
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

