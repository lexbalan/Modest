
@c_include "stdio.h"
include "libc/stdio"


type Node record {
	next: *Node
	data: *DataHolder
}

type DataHolder record {
	data: Int32
}
var funcs: [2]*() -> Unit = [&init, &foo]
var a: *() -> Unit = &init
var b: *(a: Int32, b: Int32) -> Int32 = &add

type SonrState Int32
func xx(x: *SonrState) -> Unit {

}
public func main() -> Int32 {
	init()
	foo()

	var n: Node

	return 0
}
func init() -> Unit {
	printf("init()\n")
}
func foo() -> Unit {
	printf("foo()\n")
}
func add(a: Int32, b: Int32) -> Int32 {
	return a + b
}

