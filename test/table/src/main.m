
include "libc/stdio"
include "libc/stdlib"
include "libc/string"


// [row, col]
const nRows0 = 3
const nCols0 = 3
var table0: [3][3]*Str8 = [
	["#", "Header0", "Header1"]
	["0", "Alef",  "Betha"]
	["1", "Clock", "Depth"]
]


const nRows1 = 5
const nCols1 = 4
var table1: [5][4]*Str8 = [
	["#", "Header0", "Header1", "Header2"]
	["0", "Alef",  "Betha", "Emma"]
	["1", "Clock", "Depth", "Free"]
	["2", "Ink",   "Julia", "Keyword"]
	["3", "Ultra", "Video", "Word"]
]


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
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

// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
func tablePrint(tablex: *[][]*Str8, m: Int32, n: Int32, headline: Bool) {
	var i: Int32
	var j: Int32

	// array of size of columns (in characters)
	var sz: [n]Nat32 = []

	// construct pointer to closed array
	let table = *[m][n]*Str8 tablex

	// calculate max length (in chars) of column
	i = 0
	while i < m {
		j = 0
		while j < n {
			let slen = unsafe Nat32 strlen(table[i][j])
			if slen > sz[j] {
				sz[j] = slen
			}
			++j
		}
		++i
	}

	i = 0
	while i < n {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2
		++i
	}

	i = 0
	while i < m {
		// pirint `+----+` separator
		if i < 2 or not headline {
			tableSepPrint(&sz, n)
			printf("\n")
		}

		printf("|")

		j = 0
		while j < n {
			let s = table[i][j]
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
	tableSepPrint(&sz, n)
	printf("\n")
}


public func main() -> Int32 {
	tablePrint(&table0, lengthof(table0), lengthof(table0[0]), headline=true)
	tablePrint(&table1, lengthof(table1), lengthof(table1[0]), headline=true)
	return 0
}


