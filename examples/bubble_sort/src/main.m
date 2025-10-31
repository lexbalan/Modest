// examples/demo1/src/main.m

include "libc/ctypes64"
include "libc/stdio"


var testArray: []Int32 = [
	-3, -5, 2, 1, -1, 0, -2, 3, -4, 4
	11, 9, 6, -7, -8, 5, 7, 10, 8, -6, -9
]


// returns true if was swap
func bubble_sort32_iter (array: *[]Int32, len: Nat32) -> Bool {
	var i: Nat32 = 0
	while i < (len-1) {
		let left = array[i]
		let right = array[i+1]
		if left > right {
			// swap
			array[i] = right
			array[i+1] = left
			return true
		}
		++i
	}
	return false
}


@noinline
func bubble_sort32 (array: *[]Int32, len: Nat32) -> Unit {
	while bubble_sort32_iter (array, len) {
		// continue iterations while is's necessary
	}
}


public func main() -> Int32 {
	printf("array before:\n")
	print_array(&testArray, lengthof(testArray))
	printf("\n")

	// do sort
	bubble_sort32(&testArray, lengthof(testArray))

	printf("array after:\n")
	print_array(&testArray, lengthof(testArray))
	printf("\n")

	return 0
}


func print_array (array: *[]Int32, len: Nat32) -> Unit {
	printf("\n")
	var i: Nat32 = 0
	while i < len {
		printf("array[%i] = %i\n", i, array[i])
		++i
	}
}


