
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


// [col, row]
var table: [3][3]*Str8 = [
	["A", "B", "E"]
	["C", "D", "F"]
	["I", "J", ""]
]


func tableSepPrint(m: Int32) {
	printf("+")
	var i = 0
	while i < m {
		printf("-+")
		++i
	}
}

func tablePrint(table: *[]*Str8, n: Int32, m: Int32) {
	var i = 0
	while i < n {
		tableSepPrint(m)
		printf("\n|")
		var j = 0
		while j < m {
			let s = table[i*n + j]
			if s[0] != "\0" {
				printf("%s", s)
			} else {
				printf(' ')
			}
			printf("|")
			++j
		}
		printf("\n")
		++i
	}
	tableSepPrint(m)
	printf("\n")
}

public func main() -> Int32 {

	tablePrint(unsafe *[]*Str8 &table, 3, 3)

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


