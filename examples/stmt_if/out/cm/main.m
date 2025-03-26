
@c_include "stdio.h"


public func main() -> Int {
	stdio.("if statement example\n")

	var a: Int32
	var b: Int32

	stdio.("enter a: ")
	stdio.("%d", &a)
	stdio.("enter b: ")
	stdio.("%d", &b)

	if a > b {
		stdio.("a > b\n")
	} else if a < b {
		stdio.("a < b\n")
	} else {
		stdio.("a == b\n")
	}

	return 0
}

