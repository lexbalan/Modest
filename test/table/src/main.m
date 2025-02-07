
include "libc/stdio"
include "libc/stdlib"
include "libc/string"



var table0: [][]*Str8 = [
	["#", "Header0", "Header1"]
	["0", "Alef",    "Betha"]
	["1", "Clock",   "Depth"]
]

var table1: [][]*Str8 = [
	["#", "Header0", "Header1", "Header2"]
	["0", "Alef",    "Betha",   "Emma"]
	["1", "Clock",   "Depth",   "Free"]
	["2", "Ink",     "Julia",   "Keyword"]
	["3", "Ultra",   "Video",   "Word"]
]


// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
func tablePrint(tablex: *[][]*Str8, m: Int32, n: Int32, headline: Bool) {
	var i, j: Int32

	// construct pointer to closed array
	let table = *[m][n]*Str8 tablex

	// array of size of columns (in characters)
	var sz: [n]Nat32 = []

	// calculate max length (in chars) of column
	i = 0
	while i < m {
		j = 0
		while j < n {
			let str = table[i][j]
			let len = unsafe Nat32 strlen(str)
			if len > sz[j] {
				sz[j] = len
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
		// pirint `+--+--+` separator
		if i < 2 or not headline {
			printTableSep(&sz, n)
			printf("\n")
		}

		j = 0
		while j < n {
			printf("|")
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
			++j
		}
		printf("|\n")
		++i
	}
	printTableSep(&sz, n)
	printf("\n")
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
func printTableSep(sz: *[]Nat32, m: Int32) {
	var i = 0
	while i < m {
		printf("+")
		var j = Nat32 0
		while j < sz[i] {
			printf("-")
			++j
		}
		++i
	}
	printf("+")
}


public func main() -> Int32 {
	printf("sizeof(table0) = %d\n", Nat32 sizeof(table0))
	printf("sizeof(table1) = %d\n", Nat32 sizeof(table1))

	tablePrint(&table0, lengthof(table0), lengthof(table0[0]), headline=true)
	tablePrint(&table1, lengthof(table1), lengthof(table1[0]), headline=true)

	return 0
}


