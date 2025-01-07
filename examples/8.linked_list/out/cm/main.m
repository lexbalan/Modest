
include "libc/ctypes64"
@c_include "stdlib.h"
include "libc/stdlib"
@c_include "stdio.h"
include "libc/stdio"
import "list"





// wrap around linked list for list.List Nat32
func nat32_list_insert(list: *List, x: Nat32) -> Unit {
	// alloc memory for Nat32 value
	let p_nat32 = malloc(sizeof(Nat32))
	*p_nat32 = x
	list.append(list, p_nat32)
}





// show list conent from first item to last
func list_print_forward(list: *List) -> Unit {
	printf("list_print_forward:\n")
	var pn: *Node = list.first_node_get(list)
	while pn != nil {
		let x = list.node_data_get(pn)
		printf("v = %u\n", *x)
		pn = list.node_next_get(pn)
	}
}





// show list conent from last item to first
func list_print_backward(list: *List) -> Unit {
	printf("list_print_backward:\n")
	var pn: *Node = list.last_node_get(list)
	while pn != nil {
		let x = list.node_data_get(pn)
		printf("v = %u\n", *x)
		pn = list.node_prev_get(pn)
	}
}


public func main() -> Int {
	printf("linked list example\n")

	let list0 = list.create()

	//list0.size  // access to private field of record

	if list0 == nil {
		printf("error: cannot create list")
		return 1
	}

	// add some Nat32 values to list
	nat32_list_insert(list0, 0)
	nat32_list_insert(list0, 10)
	nat32_list_insert(list0, 20)
	nat32_list_insert(list0, 30)
	nat32_list_insert(list0, 40)
	nat32_list_insert(list0, 50)
	nat32_list_insert(list0, 60)
	nat32_list_insert(list0, 70)
	nat32_list_insert(list0, 80)
	nat32_list_insert(list0, 90)
	nat32_list_insert(list0, 100)

	// print list size
	let list_size = list.size_get(list0)
	printf("linked list size: %u\n", list_size)

	// print list forward
	list_print_forward(list0)

	// print list backward
	list_print_backward(list0)


	printf("\nlist.node_get(list, n) test\n")

	// test list.node_get
	var i: Int32 = 0
	while i >= -12 {
		let node = list.node_get(list0, i)

		if node == nil {
			printf("node %i not exist\n", i)
			i = i - 1
			again
		}

		let px = list.node_data_get(node)
		printf("list(%i) = %i\n", i, *px)
		i = i - 1
	}

	printf("-----------------------------------------\n")

	i = 0
	while i <= 12 {
		let node = list.node_get(list0, i)

		if node == nil {
			printf("node %i not exist\n", i)
			i = i + 1
			again
		}

		let px = list.node_data_get(node)
		printf("list(%i) = %i\n", i, *px)
		i = i + 1
	}

	printf("-----------------------------------------\n")


	let p_nat32 = malloc(sizeof(Nat32))
	*p_nat32 = 1234
	list.insert(list0, pos = 4, data = p_nat32)

	list_print_forward(list0)

	return 0
}

