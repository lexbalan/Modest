
include "libc/stdio"
include "libc/stdlib"
include "libc/string"


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


type TableCell record {
	text: *Str8
}

// [col, row]
var table: [3][3]*Str8 = [
	["Alef", "Betha", "Emma"]
	["Clock", "Depth", "Free"]
	["Ink", "Julia", "Keyword"]
]


func tableSepPrint(sz: *[]Nat32, m: Int32) {
	printf("+")
	var i = 0
	while i < m {
		var j = Nat32 0
		while j < sz[i] {
			printf("-")
			++j
		}
		printf("+")
		++i
	}
}


func max(a: Nat32, b: Nat32) -> Nat32 {
	if b > a {
		return b
	}
	return a
}

func tablePrint(table: *[]*Str8, n: Int32, m: Int32) {
	var i, j: Int32
	var sz: [m]Nat32 = []

	// calculate max length of col
	i = 0
	while i < n {
		j = 0
		while j < m {
			let slen = unsafe Nat32 strlen(table[i*n + j])
			sz[j] = max(slen, sz[j])
			++j
		}
		++i
	}

	i = 0
	while i < m {
		// добавляем 1 пробел слева и один справа
		// для красивого отступа
		sz[i] = sz[i] + 2
		++i
	}

	i = 0
	while i < n {
		tableSepPrint(&sz, m)
		printf("\n|")
		j = 0
		while j < m {
			let s = table[i*n + j]
			var len = unsafe Nat32 strlen(s)
			if s[0] != "\0" {
				len = len + 1
				printf(" %s", s)
			}

			var k = Nat32 0
			while k < (sz[j] - len) {
				printf(" ")
				++k
			}

			printf("|")
			++j
		}
		printf("\n")
		++i
	}
	tableSepPrint(&sz, m)
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


