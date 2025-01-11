
@c_include "stdio.h"
include "libc/stdio"
@c_include "stdlib.h"
include "libc/stdlib"
@c_include "string.h"
include "libc/string"




// [row, col]
const nRows = 5
const nCols = 4
var table: [5][4]*Str8 = [
	["#", "Header0", "Header1", "Header2"]
	["0", "Alef", "Betha", "Emma"]
	["1", "Clock", "Depth", "Free"]
	["2", "Ink", "Julia", "Keyword"]
	["3", "Ultra", "Video", "Word"]
]



func max(a: Nat32, b: Nat32) -> Nat32 {
	if b > a {
		return b
	}
	return a
}


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


func tablePrint(table: *[]*Str8, n: Int32, m: Int32, headline: Bool) -> Unit {
	var i: Int32
	var j: Int32
	var sz: [m]Nat32 = []

	// calculate max length of col
	i = 0
	while i < n {
		j = 0
		while j < m {
			let index = i * (n - 1) + j
			let slen = Nat32 (strlen(table[index]))
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

		// pirint `+----+` separator
		if i < 2 or notheadline {
			tableSepPrint(&sz, m)
			printf("\n|")
		} else {
			printf("|")
		}

		j = 0
		while j < m {
			let index = i * (n - 1) + j
			let s = table[index]
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
	tablePrint(*[]*Str8 (&table), nRows, nCols, headline = true)

	return 0
}

