private import "builtin"
private import "list"
include "ctypes64"
include "stdlib"
include "stdio"

import "list" as list


// wrap around linked list for list.List Nat32
func nat32_list_insert (lst: *List, x: Nat32) -> Unit {
	let p_nat32 = *Nat32 malloc(sizeof(Nat32))
	*p_nat32 = x
	append(lst, p_nat32)
}


// show list conent from first item to last
func list_print_forward (lst: *List) -> Unit {
	printf("list_print_forward:\n")
	var pn: *Node = first_node_get(lst)
	while pn != nil {
		let x = *Nat32 node_data_get(pn)
		printf("v = %u\n", *x)
		pn = node_next_get(pn)
	}
}


// show list conent from last item to first
func list_print_backward (lst: *List) -> Unit {
	printf("list_print_backward:\n")
	var pn: *Node = last_node_get(lst)
	while pn != nil {
		let x = *Nat32 node_data_get(pn)
		printf("v = %u\n", *x)
		pn = node_prev_get(pn)
	}
}


@nonstatic
func main () -> Int {
	printf("linked list example\n")

	let list0: *List = create()

	if list0 == nil {
		printf("error: cannot create list")
		return 1
	}
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
	let list_size: Nat32 = size_get(list0)
	printf("linked list size: %u\n", list_size)
	list_print_forward(list0)
	list_print_backward(list0)


	printf("\nlist.node_get(list, n) test\n")
	var i: Int32 = 0
	while i >= -12 {
		let node: *Node = node_get(list0, i)

		if node == nil {
			printf("node %i not exist\n", i)
			i = i - 1
			again
		}

		let px = *Nat32 node_data_get(node)
		printf("list(%i) = %i\n", i, *px)
		i = i - 1
	}

	printf("-----------------------------------------\n")

	i = 0
	while i <= 12 {
		let node: *Node = node_get(list0, i)

		if node == nil {
			printf("node %i not exist\n", i)
			i = i + 1
			again
		}

		let px = *Nat32 node_data_get(node)
		printf("list(%i) = %i\n", i, *px)
		i = i + 1
	}

	printf("-----------------------------------------\n")


	let p_nat32 = *Nat32 malloc(sizeof(Nat32))
	*p_nat32 = 1234
	insert(list0, pos=4, data=p_nat32)

	list_print_forward(list0)

	return 0
}

