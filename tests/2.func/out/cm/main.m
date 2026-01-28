include "ctypes64"
include "stdio"



func func1 () -> Unit {
	printf("func1 was called\n")
}


func print_ab (a: Int32, b: Int32) -> Unit {
	printf("print_ab(a=%i, b=%i)\n", Int32 a, Int32 b)
}


func sum (a: Int32, b: Int32) -> Int32 {
	return a + b
}


// define function main
public func main () -> Int {
	printf("test func\n")

	// call declared & defined functions
	func0()
	func1()

	// call function with two arguments
	print_ab(10, 20)

	// call function with two arguments and return value
	let arg_a = Int32 1
	let arg_b = Int32 2
	let sum_result: Int32 = sum(arg_a, arg_b)
	printf("sum(%i, %i) == %i\n", Int32 arg_a, Int32 arg_b, Int32 sum_result)


	var fptr: *(a: Int32, b: Int32) -> Int32 = &sum
	// call function with two arguments and return value
	let arg_a2 = Int32 1
	let arg_b2 = Int32 2
	let fptr_result: Int32 = fptr(arg_a2, arg_b2)
	printf("fptr(%i, %i) == %i\n", Int32 arg_a2, Int32 arg_b2, Int32 fptr_result)

	return 0
}


func func0 () -> Unit {
	printf("func0 was called\n")
}

