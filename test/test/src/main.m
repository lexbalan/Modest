
include "libc/stdio"

// 1. Сначала проходит по всем сущностям и создает type_undefined/value_undefined


type Node record {
	next: *Node
	data: *Unit
}


//: []()->Unit
//var a: []Int32 = [10, "&add", 20, 30, "sd"]
var funcs: []*()->Unit = [&init, &add]


public func main() -> Int32 {
	init()

	var n: Node

	return 0
}


func init() {
	printf("init()\n")
}


func add(a: Int32, b: Int32) -> Int32 {
	return a + b
}

