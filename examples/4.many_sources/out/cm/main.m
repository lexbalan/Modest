import "lib"
include "ctypes64"
include "stdio"
// examples/4.many_sources/main.m
import "lib" as lib


public func main () -> Int {
	printf("hello from main\n")
	lib.foo()
	return 0
}

