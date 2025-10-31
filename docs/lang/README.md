# Modest language

- [Comments](./comments.md)
- [Access Modifiers](./access_modifiers.md)
- [Identifiers](./identifier.md)
<!--- [Fields](./fields.md)-->
- [Import](./import.md)
- [Definitions](./def/README.md)
  * [Type](./def/type.md)
  * [Constant](./def/let.md)
  * [Variable](./def/var.md)
  * [Function](./def/func.md)

- [Types](./type/README.md)
  * [Generic](./type/generic.md)
  * [Base](./type/base.md)
  * [Array](./type/array.md)
  * [Record](./type/record.md)
  * [Function](./type/func.md)
  * [Pointer](./type/pointer.md)

- [Values](./value/README.md)
  * [Literal](./value/literal.md)
  * [Cons](./value/cons.md)
  * [Binary](./value/binary.md)
  * [Unary](./value/unary.md)
  * [Call](./value/call.md)
  * [Access](./value/access.md)
  * [Index](./value/_index.md)
  * [Slice](./value/slice.md)
  * [Sizeof](./value/sizeof.md)

- [Statements](./stmt/README.md)
  * [Var](./stmt/var.md)
  * [Let](./stmt/let.md)
  * [If](./stmt/if.md)
  * [While](./stmt/while.md)
  * [Return](./stmt/return.md)
  * [Value evaluation](./stmt/eval.md)
  * [Variable assignation](./stmt/assign.md)
  * [Block statement](./stmt/block.md)
  * [Asm statement](./stmt/asm_inline.md)

### Misc
  * [Directives](./directive.md)
  * [Attributes](./attribute.md)
  * [Builtin constants](./builtin_constants.md)
  * [Variadic functions](./va_arg.md)


### Keywords
[`import`](./import.md), [`type`](./def/type.md), [`let`](./def/let.md), [`var`](./def/var.md), [`func`](./def/func.md), [`if`](./stmt/if.md), [`while`](./stmt/while.md), [`break`](./stmt/while.md#break), [`again`](./stmt/while.md#again), [`return`](./stmt/return.md)


### Example

```swift
// fast language example

import "libc/stdio"

type Number = Int32

const minNumber = Number 0
const maxNumber = Number 10

public func main () -> Int32 {
	let number = get_number(minNumber, maxNumber)

	let n = Number 5

	if number < n {
		printf("entered number (%i) is less than %i\n", number, n)
	} else if number > n {
		printf("entered number (%i) is greater than %i\n", number, n)
	} else {
		printf("entered number (%i) is equal with %i\n", number, n)
	}

	return 0
}


func get_number (min: Number, max: Number) -> Number {
	var number: Number
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



