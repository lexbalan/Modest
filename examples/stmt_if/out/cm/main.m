include "ctypes64"
include "stdio"



public func main() -> Int {
	stdio.printf("if statement example\n")

	var a: Int32
	var b: Int32

	stdio.printf("enter a: ")
	stdio.scanf("%d", &a)
	stdio.printf("enter b: ")
	stdio.scanf("%d", &b)

	if a > b {
		stdio.printf("a > b\n")
	} else if a < b {
		stdio.printf("a < b\n")
	} else {
		stdio.printf("a == b\n")
	}

	return 0
}

