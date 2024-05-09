# Modest language

- [Comments](./comments.md)
- [Identifiers](./identifier.md)
<!--- [Fields](./fields.md)-->
- [Import](./import.md)
- [Definitions](./def/README.md)
  * [Type](./def/type.md)
  * [Constant](./def/const.md)
  * [Variable](./def/var.md)
  * [Function](./def/func.md)

- [Types](./type/README.md)
  * [Generic](./type/generic.md)
  * [Base](./type/base.md)
  * [Array](./type/array.md)
  * [Record](./type/record.md)
  * [Function](./type/func.md)
  * [Pointer](./type/pointer.md)
  * [VA_List](./type/va_list.md)

- [Values](./value/README.md)
  <!--* [Numeric](./value/numeric.md)-->
  <!--* [String](./value/string.md)-->
  * [Literal](./value/literal.md)
  * [Cons](./value/cons.md)
  * [Binary](./value/binary.md)
  * [Unary](./value/unary.md)
  * [Call](./value/call.md)
  * [Index](./value/_index.md)
  * [Access](./value/access.md)
  * [Sizeof](./value/sizeof.md)

- [Statements](./stmt/README.md)
  * [If](./stmt/if.md)
  * [While](./stmt/while.md)
  * [Return](./stmt/return.md)
  * [Local variable definiiton](./stmt/var.md)
  * [Local constant definiiton](./stmt/let.md)
  * [Value evaluation](./stmt/eval.md)
  * [Variable assignation](./stmt/assign.md)
  * [Block statement](./stmt/block.md)
  * [Asm statement](./stmt/asm_inline.md)

### Misc
  * [Directives](./directive.md)
  * [Attributes](./attribute.md)
  * [Builtin constants](./builtin_constants.md)


### Keywords
[`import`](./import.md), [`type`](./def/type.md), [`const`](./def/const.md), [`var`](./def/var.md), [`func`](./def/func.md), [`let`](./stmt/let.md), [`if`](./stmt/if.md), [`while`](./stmt/while.md), [`break`](./stmt/while.md#break), [`again`](./stmt/while.md#again), [`return`](./stmt/return.md)


### Example

```swift
// examples/demo1/src/main.cm

import "libc/stdio"


let minNumber = 0
let maxNumber = 10


func get_number(min: Int32, max: Int32) -> Int32


func main() -> Int32 {
	let number = get_number(minNumber, maxNumber)

	let n = Int32 5

	if number < n {
		printf("entered number (%i) is less than %i\n", number, n)
	} else if number > n {
		printf("entered number (%i) is greater than %i\n", number, n)
	} else {
		printf("entered number (%i) is equal with %i\n", number, n)
	}

	return 0
}


func get_number(min: Int32, max: Int32) -> Int32 {
	var number: Int32
	number = 0

	while true {
		printf("enter a number (%i .. %i): ", min, max)
		scanf("%d", &number)

		if number < min {
			printf("number must be greater than %i, try again\n", min)
			again
		} else if number > max {
			printf("number must be less than %i, try again\n", max)
			again
		} else {
			break
		}
	}

	return number
}

```



