
@c_include "stdlib.h"
@c_include "stdio.h"
import "list" as list


// wrap around linked list for list.List Nat32
func nat32_list_insert(lst: *List, x: Nat32) -> Unit {
	// alloc memory for Nat32 value
	let p_nat32 = stdlib.(sizeof(Nat32))
	*p_nat32 = x
	list.(lst, p_nat32)
}


// show list conent from first item to last
func list_print_forward(lst: *List) -> Unit {
	stdio.("list_print_forward:\n")
	var pn: *Node = list.(lst)
	while pn != nil {
		let x = list.(pn)
		stdio.("v = %u\n", *x)
		pn = list.(pn)
	}
}


// show list conent from last item to first
func list_print_backward(lst: *List) -> Unit {
	stdio.("list_print_backward:\n")
	var pn: *Node = list.(lst)
	while pn != nil {
		let x = list.(pn)
		stdio.("v = %u\n", *x)
		pn = list.(pn)
	}
}


public func main() -> Int {
	stdio.("linked list example\n")

	let list0 = list.()

	//list0.size  // access to private field of record

	if list0 == nil {
		stdio.("error: cannot create list")
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
	let list_size = list.(list0)
	stdio.("linked list size: %u\n", list_size)

	// print list forward
	list_print_forward(list0)

	// print list backward
	list_print_backward(list0)


	stdio.("\nlist.node_get(list, n) test\n")

	// test list.node_get
	var i: Int32 = 0
	while i >= -12 {
		let node = list.(list0, i)

		if node == nil {
			stdio.("node %i not exist\n", i)
			i = i - 1
			again
		}

		let px = list.(node)
		stdio.("list(%i) = %i\n", i, *px)
		i = i - 1
	}

	stdio.("-----------------------------------------\n")

	i = 0
	while i <= 12 {
		let node = list.(list0, i)

		if node == nil {
			stdio.("node %i not exist\n", i)
			i = i + 1
			again
		}

		let px = list.(node)
		stdio.("list(%i) = %i\n", i, *px)
		i = i + 1
	}

	stdio.("-----------------------------------------\n")


	let p_nat32 = stdlib.(sizeof(Nat32))
	*p_nat32 = 1234
	list.(list0, pos = 4, data = p_nat32)

	list_print_forward(list0)

	return 0
}

