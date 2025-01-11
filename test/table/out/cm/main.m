
@c_include "stdio.h"
include "libc/stdio"
@c_include "stdlib.h"
include "libc/stdlib"
@c_include "string.h"
include "libc/string"


// [row, col]
var table: [3][3]*Str8 = [
	["Alef", "Betha", "Emma"]
	["Clock", "Depth", "Free"]
	["Ink", "Julia", "Keyword"]
]


func tableSepPrint(sz: *[]Nat32, m: Int32) -> Unit {
	printf("+")
	var i: Int32 = 0
	while i < m {
		var j: Nat32 = Nat32 0
		while j < sz[i] {
			printf("-")
			j = j + 1
		}
		printf("+")
		i = i + 1
	}
}


func max(a: Nat32, b: Nat32) -> Nat32 {
	if b > a {
		return b
	}
	return a
}


func tablePrint(table: *[]*Str8, n: Int32, m: Int32) -> Unit {
	var i: Int32
	var j: Int32
	var sz: [m]Nat32 = []

	// calculate max length of col
	i = 0
	while i < n {
		j = 0
		while j < m {
			let slen = Nat32 (strlen(table[i * n + j]))
			sz[j] = max(slen, sz[j])
			j = j + 1
		}
		i = i + 1
	}

	i = 0
	while i < m {
		// добавляем 1 пробел слева и один справа
		// для красивого отступа
		sz[i] = sz[i] + 2
		i = i + 1
	}

	i = 0
	while i < n {
		if i < 2 {
			tableSepPrint(&sz, m)
		}
		printf("\n|")
		j = 0
		while j < m {
			let s = table[i * n + j]
			var len: Nat32 = Nat32 (strlen(s))
			if s[0] != "\x0" {
				len = len + 1
				printf(" %s", s)
			}

			var k: Nat32 = Nat32 0
			while k < sz[j] - len {
				printf(" ")
				k = k + 1
			}

			printf("|")
			j = j + 1
		}
		printf("\n")
		i = i + 1
	}
	tableSepPrint(&sz, m)
	printf("\n")
}


public func main() -> Int32 {
	//
	tablePrint(*[]*Str8 (&table), 3, 3)

	return 0
}

