
include "libc/stdio"
include "libc/stdlib"
include "libc/string"


// [row, col]
const nRows = 5
const nCols = 4
var table: [5][4]*Str8 = [
	["#", "Header0", "Header1", "Header2"]
	["0", "Alef",  "Betha", "Emma"]
	["1", "Clock", "Depth", "Free"]
	["2", "Ink",   "Julia", "Keyword"]
	["3", "Ultra", "Video", "Word"]
]



func max(a: Nat32, b: Nat32) -> Nat32 {
	if b > a {
		return b
	}
	return a
}


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


func tablePrint(tablex: *[][]*Str8, n: Int32, m: Int32, headline: Bool) {
	var i, j: Int32
	var sz: [m]Nat32 = []

	var table = unsafe *[]*Str8 tablex

	// calculate max length of col
	i = 0
	while i < n {
		j = 0
		while j < m {
			let index = i * (n-1) + j
			let slen = unsafe Nat32 strlen(table[index])
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
		// pirint `+----+` separator
		if i < 2 or not headline {
			tableSepPrint(&sz, m)
			printf("\n|")
		} else {
			printf("|")
		}

		j = 0
		while j < m {
			let index = i * (n-1) + j
			let s = table[index]
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
	//
	tablePrint(&table, nRows, nCols, headline=true)

	return 0
}


