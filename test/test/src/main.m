
include "libc/stdio"

// 1. Сначала проходит по всем сущностям и создает type_undefined/value_undefined


type Node record {
	next: *Node
	data: *Unit
}


var funcs = [&init]


public func main() -> Int32 {
	init()

	var n: Node

	return 0
}


func init() {
	printf("init()\n")
}
