
@c_include "stdio.h"
include "libc/stdio"
// 1. Сначала проходит по всем сущностям и создает type_undefined/value_undefined


type Node record {
	next: *Node
	data: Ptr
}
//: []()->Unit
//var a: []Int32 = [10, "&add", 20, 30, "sd"]
var funcs: [2]*() -> Unit = [&init, &foo]
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

