
include "libc/ctypes64"
include "libc/stdlib"
include "libc/stdio"


export type Node record {
	next: *Node
	prev: *Node
	data: Ptr
}

export type List record {
	head: *Node
	tail: *Node
	size: Nat32
}
export func create() -> *List {
	let list = malloc(sizeof(List))

	if list == nil {
		return nil
	}

	*list = {}

	return list
}
export func size_get(list: *List) -> Nat32 {
	if list == nil {
		return 0
	}

	return list.size
}
export func first_node_get(list: *List) -> *Node {
	if list == nil {
		return nil
	}

	return list.head
}
export func last_node_get(list: *List) -> *Node {
	if list == nil {
		return nil
	}

	return list.tail
}
export func node_first(list: *List, new_node: *Node) -> *Node {
	if list == nil or new_node == nil {
		return nil
	}

	list.head = new_node
	list.tail = new_node

	list.size = list.size + 1

	return new_node
}
export func node_create() -> *Node {
	let node = malloc(sizeof(Node))

	if node == nil {
		return nil
	}

	*node = {}

	return node
}
export func node_next_get(node: *Node) -> *Node {
	if node == nil {
		return nil
	}

	return node.next
}
export func node_prev_get(node: *Node) -> *Node {
	if node == nil {
		return nil
	}

	return node.prev
}
export func node_data_get(node: *Node) -> Ptr {
	if node == nil {
		return nil
	}

	return node.data
}
export func node_insert_right(left: *Node, new_right: *Node) -> Unit {
	printf("node_insert_right\n")

	let old_right = left.next
	left.next = new_right

	if old_right != nil {
		old_right.prev = new_right
	}

	new_right.next = old_right
	new_right.prev = left
}
export func node_get(list: *List, pos: Int32) -> *Node {
	if list == nil or list.size == 0 {
		return nil
	}

	printf("node_get(%d)\n", pos)
	var node: *Node

	if pos >= 0 {
		// go forward
		node = list.head
		let n = Nat32 pos

		if n > list.size {
			return nil
		}

		var i: Nat32 = Nat32 0
		while i < n {
			node = node.next
			i = i + 1
		}
	} else {
		// go backward
		node = list.tail
		let n = Nat32 -pos - 1

		if n > list.size {
			return nil
		}

		var i: Nat32 = Nat32 0
		while i < n {
			node = node.prev
			i = i + 1
		}
	}

	return node
}
export func node_insert(list: *List, pos: Int32, new_node: *Node) -> *Node {
	if list == nil or new_node == nil {
		return nil
	}

	printf("node_insert(%d)\n", pos)


	let n = node_get(list, pos)

	if n == nil {
		return nil
	}

	let nod = node_prev_get(n)

	if nod == nil {
		return nil
	}

	node_insert_right(nod, new_node)
	list.size = list.size + 1

	return new_node
}
export func node_append(list: *List, new_node: *Node) -> *Node {
	if list == nil or new_node == nil {
		return nil
	}

	if list.tail == nil {
		list.head = new_node
	} else {
		node_insert_right(list.tail, new_node)
	}

	list.tail = new_node

	list.size = list.size + 1

	return new_node
}
export func insert(list: *List, pos: Int32, data: Ptr) -> *Node {
	let new_node = node_create()

	if new_node == nil {
		return nil
	}

	new_node.data = data

	return node_insert(list, pos, new_node)
}
export func append(list: *List, data: Ptr) -> *Node {
	if list == nil {
		return nil
	}

	let new_node = node_create()

	if new_node == nil {
		return nil
	}

	new_node.data = data

	let node = node_append(list, new_node)

	if node == nil {
		free(new_node)
	}

	return node
}

