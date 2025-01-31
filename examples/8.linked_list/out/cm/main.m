
@c_include "stdlib.h"
@c_include "stdio.h"
import "list" as list


// wrap around linked list for list.List Nat32
func nat32_list_insert(lst: *list.List, x: Nat32) -> Unit {
	// alloc memory for Nat32 value
	let p_nat32 = stdlib.malloc(sizeof(Nat32))
	*p_nat32 = x
	list.append(lst, p_nat32)
}


// show list conent from first item to last
func list_print_forward(lst: *list.List) -> Unit {
	stdio.printf("list_print_forward:\n")
	var pn: *list.Node = list.first_node_get(lst)
	while pn != nil {
		let x = list.node_data_get(pn)
		stdio.printf("v = %u\n", *x)
		pn = list.node_next_get(pn)
	}
}


// show list conent from last item to first
func list_print_backward(lst: *list.List) -> Unit {
	stdio.printf("list_print_backward:\n")
	var pn: *list.Node = list.last_node_get(lst)
	while pn != nil {
		let x = list.node_data_get(pn)
		stdio.printf("v = %u\n", *x)
		pn = list.node_prev_get(pn)
	}
}


public func main() -> ctypes64.Int {
	stdio.printf("linked list example\n")

	let list0 = list.create()

	//list0.size  // access to private field of record

	if list0 == nil {
		stdio.printf("error: cannot create list")
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
	stdio.printf("linked list size: %u\n", list_size)

	// print list forward
	list_print_forward(list0)

	// print list backward
	list_print_backward(list0)


	stdio.printf("\nlist.node_get(list, n) test\n")

	// test list.node_get
	var i: Int32 = 0
	while i >= -12 {
		let node = list.node_get(list0, i)

		if node == nil {
			stdio.printf("node %i not exist\n", i)
			i = i - 1
			again
		}

		let px = list.node_data_get(node)
		stdio.printf("list(%i) = %i\n", i, *px)
		i = i - 1
	}

	stdio.printf("-----------------------------------------\n")

	i = 0
	while i <= 12 {
		let node = list.node_get(list0, i)

		if node == nil {
			stdio.printf("node %i not exist\n", i)
			i = i + 1
			again
		}

		let px = list.node_data_get(node)
		stdio.printf("list(%i) = %i\n", i, *px)
		i = i + 1
	}

	stdio.printf("-----------------------------------------\n")


	let p_nat32 = stdlib.malloc(sizeof(Nat32))
	*p_nat32 = 1234
	list.insert(list0, pos = 4, data = p_nat32)

	list_print_forward(list0)

	return 0
}

