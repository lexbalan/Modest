
@c_include "stdio.h"


const minNumber = 0
const maxNumber = 10


public func main() -> Int32 {
	let number = get_number(minNumber, maxNumber)

	let n = Int32 5

	if number < n {
		stdio.printf("entered number (%i) is less than %i\n", number, n)
	} else if number > n {
		stdio.printf("entered number (%i) is greater than %i\n", number, n)
	} else {
		stdio.printf("entered number (%i) is equal with %i\n", number, n)
	}

	return 0
}


func get_number(min: Int32, max: Int32) -> Int32 {
	var number: Int32
	number = 0

	while true {
		stdio.printf("enter a number (%i .. %i): ", min, max)
		stdio.scanf("%d", &number)

		if number < min {
			stdio.printf("number must be greater than %i, try again\n", min)
			again
		} else if number > max {
			stdio.printf("number must be less than %i, try again\n", max)
			again
		} else {
			break
		}
	}

	return number
}

