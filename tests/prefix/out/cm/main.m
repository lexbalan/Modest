import "lib"
include "stdio"
// examples/prefix/src/main.m
import "lib" as lib


public func main () -> Int {
	printf("Hello!\n")
	lib.foo()
	return 0
}

