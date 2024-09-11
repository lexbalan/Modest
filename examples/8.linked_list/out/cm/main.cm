
include "libc/ctypes64"
include "libc/stdlib"
include "libc/stdio"
import "list"
func nat32_list_insert(list: *List, x: Nat32) -> Unit {
	// alloc memory for Nat32 value
	let p_nat32 = malloc(sizeof(Nat32))
	*p_nat32 = x
	list.append(list, p_nat32)
}
func list_print_forward(list: *List) -> Unit {
	printf("list_print_forward:\n")
	var pn: *Node = list.first_node_get(list)
	while pn != nil {
		let x = list.node_data_get(pn)
		printf("v = %u\n", *x)
		pn = list.node_next_get(pn)
	}
}
func list_print_backward(list: *List) -> Unit {
	printf("list_print_backward:\n")
	var pn: *Node = list.last_node_get(list)
	while pn != nil {
		let x = list.node_data_get(pn)
		printf("v = %u\n", *x)
		pn = list.node_prev_get(pn)
	}
}
func main() -> Int {
	printf("linked list example\n")

	let list = list.create()

	if list == nil {
		printf("error: cannot create list")
		return 1
	}

	// add some Nat32 values to list
	nat32_list_insert(list, 0)
	nat32_list_insert(list, 10)
	nat32_list_insert(list, 20)
	nat32_list_insert(list, 30)
	nat32_list_insert(list, 40)
	nat32_list_insert(list, 50)
	nat32_list_insert(list, 60)
	nat32_list_insert(list, 70)
	nat32_list_insert(list, 80)
	nat32_list_insert(list, 90)
	nat32_list_insert(list, 100)

	// print list size
	let list_size = list.size_get(list)
	printf("linked list size: %u\n", list_size)

	// print list forward
	list_print_forward(list)

	// print list backward
	list_print_backward(list)


	printf("\nlist.node_get(list, n) test\n")

	// test list.node_get
	var i: Int32 = 0
	while i >= -12 {
		let node = list.node_get(list, i)

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
		let node = list.node_get(list, i)

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
	list.insert(list, pos = 4, data = p_nat32)

	list_print_forward(list)

	return 0
}

