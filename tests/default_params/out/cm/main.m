include "ctypes64"
include "stdio"




func func1 (x: Int32 = 10) -> Int32 {
	return x
}


func func2 (a: Int32 = 10, b: Int32 = 20) -> Int32 {
	return a + b
}


//func func3 (a: Int32 = 10, b: Int32) -> Int32 {
//	return a + b
//}


func test1 () -> Bool {
	let c0: Bool = func1(x=10) == 10
	let c1: Bool = func1(10) == 10
	let c2: Bool = func1(x=10) == 10
	let c3: Bool = func1(20) == 20
	let c4: Bool = func1(x=20) == 20
	return c0 and c1 and c2 and c3 and c4
}


func test2 () -> Bool {
	let c0: Bool = func2(a=10, b=20) == 30
	let c1: Bool = func2(10, 20) == 30
	let c2: Bool = func2(a=10, b=20) == 30
	let c3: Bool = func2(a=10, b=20) == 30
	let c4: Bool = func2(a=10, b=20) == 30
	let c5: Bool = func2(a=20, b=10) == 30
	let c6: Bool = func2(a=20, b=10) == 30
	return c0 and c1 and c2 and c3 and c4 and c5 and c6
}


public func main () -> Int {
	printf("test default parameters\n")

	//func2(b=10, 10)  // error: positional argument follows keyword argument
	//func3(4)         // error: undefined parameter 'b'

	let test1_passed: Bool = test1()
	if test1_passed {
		printf("test1 passed\n")
	} else {
		printf("test1 failed\n")
	}

	let test2_passed: Bool = test2()
	if test2_passed {
		printf("test2 passed\n")
	} else {
		printf("test2 failed\n")
	}

	return 0
}

