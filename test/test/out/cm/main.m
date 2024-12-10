
@c_include "stdio.h"
include "libc/stdio"
// 1. Сначала проходит по всем сущностям и создает type_undefined/value_undefined


type Node record {
	next: *Node
	data: Ptr
}
public func main() -> Int32 {
	init()

	var n: Node

	return 0
}
func init() -> Unit {
	printf("init()\n")
}

