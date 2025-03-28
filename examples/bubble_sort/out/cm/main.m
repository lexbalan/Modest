include "ctypes64"
include "stdio"


var array: [21]Int32 = [
	-3, -5, 2, 1, -1, 0, -2, 3, -4, 4
	11, 9, 6, -7, -8, 5, 7, 10, 8, -6, -9
]


func bubble_sort32(array: *[]Int32, len: Int32) -> Unit {
	var need_to_sort: Bool = true
	while need_to_sort {
		need_to_sort = false
		var i: Int32 = 0
		while i < (len - 1) {
			let i0 = array[i]
			let i1 = array[i + 1]

			if i0 > i1 {
				// swap
				array[i] = i1
				array[i + 1] = i0
				need_to_sort = true
				break
			}

			i = i + 1
		}
	}
}


public func main() -> Int32 {
	//fill_array(&array, lengthof(array))

	stdio.printf("array before:\n")
	print_array(&array, lengthof(array))
	stdio.printf("\n")

	bubble_sort32(&array, lengthof(array))

	stdio.printf("array after:\n")
	print_array(&array, lengthof(array))
	stdio.printf("\n")

	return 0
}


func print_array(array: *[]Int32, len: Int32) -> Unit {
	stdio.printf("\n")
	var i: Int32 = 0
	while i < len {
		stdio.printf("array[%i] = %i\n", i, array[i])
		i = i + 1
	}
}


func fill_array(array: *[]Int32, len: Int32) -> Unit {
	let min = -1000
	let max = 1000
	var i: Int32 = 0
	while i < len {
		stdio.printf("[%i] ", i)
		let x = get_number(min, max)
		array[i] = x
		i = i + 1
	}
}


func get_number(min: Int32, max: Int32) -> Int32 {
	var number: Int32 = Int32 0

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

