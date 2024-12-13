
include "libc/stdio"


type Node record {
	next: *Node
	data: *Unit
}


var funcs: []*()->Unit = [&init, &foo]


public func main() -> Int32 {
	init()
	foo()

	var n: Node

	return 0
}


func init() {
	printf("init()\n")
}


func foo() {
	printf("foo()\n")
}


func add(a: Int32, b: Int32) -> Int32 {
	return a + b
}


