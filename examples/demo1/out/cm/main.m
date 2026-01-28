include "stdio"



const minNumber = 0
const maxNumber = 10


public func main () -> Int32 {
	let number: Int32 = get_number(minNumber, maxNumber)

	let n = Int32 5

	if number < n {
		printf("entered number (%i) is less than %i\n", Int32 number, Int32 n)
	} else if number > n {
		printf("entered number (%i) is greater than %i\n", Int32 number, Int32 n)
	} else {
		printf("entered number (%i) is equal with %i\n", Int32 number, Int32 n)
	}

	return 0
}


func get_number (min: Int32, max: Int32) -> Int32 {
	var number: Int32
	number = 0

	while true {
		printf("enter a number (%i .. %i): ", Int32 min, Int32 max)
		scanf("%d", *Int32 &number)

		if number < min {
			printf("number must be greater than %i, try again\n", Int32 min)
			again
		} else if number > max {
			printf("number must be less than %i, try again\n", Int32 max)
			again
		} else {
			break
		}
	}

	return number
}

