
include "libc/stdio"
include "libc/stdlib"


@property("type.generic", true)
type DataPtr *Int32

type Node record {
	next: *Node
	prev: *Node
	data: DataPtr
}


func create() -> *Node {
	let n: *Node = malloc(sizeof(Node))
	return n
}


public func main() -> Int32 {
	let n: *Node = create()

	var e: *Int16 = DataPtr nil

	if n == nil {
		printf("error: cannot allocate memory\n")
		return -1
	}

	n.data = malloc(sizeof([10][10]Int32))

	if n.data == nil {
		printf("error: cannot allocate memory\n")
		return -1
	}

	return 0
}


