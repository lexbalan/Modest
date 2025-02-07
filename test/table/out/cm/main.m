
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"



var table0: [3][3]*Str8 = [
	["#", "Header0", "Header1"]
	["0", "Alef", "Betha"]
	["1", "Clock", "Depth"]
]

var table1: [5][4]*Str8 = [
	["#", "Header0", "Header1", "Header2"]
	["0", "Alef", "Betha", "Emma"]
	["1", "Clock", "Depth", "Free"]
	["2", "Ink", "Julia", "Keyword"]
	["3", "Ultra", "Video", "Word"]
]


// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
func tablePrint(tablex: *[][]*Str8, m: Int32, n: Int32, headline: Bool) -> Unit {
	var i: Int32
	var j: Int32

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
			let len = Nat32 string.strlen(str)
			if len > sz[j] {
				sz[j] = len
			}
			j = j + 1
		}
		i = i + 1
	}

	i = 0
	while i < n {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2
		i = i + 1
	}

	i = 0
	while i < m {
		// pirint `+--+--+` separator
		if i < 2 or notheadline {
			printTableSep(&sz, n)
			stdio.printf("\n")
		}

		j = 0
		while j < n {
			stdio.printf("|")
			let s = table[i][j]
			var len: Nat32 = Nat32 string.strlen(s)
			if s[0] != "\x0" {
				len = len + 1
				stdio.printf(" %s", s)
			}

			var k: Nat32 = Nat32 0
			while k < sz[j] - len {
				stdio.printf(" ")
				k = k + 1
			}
			j = j + 1
		}
		stdio.printf("|\n")
		i = i + 1
	}
	printTableSep(&sz, n)
	stdio.printf("\n")
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
func printTableSep(sz: *[]Nat32, m: Int32) -> Unit {
	var i: Int32 = 0
	while i < m {
		stdio.printf("+")
		var j: Nat32 = Nat32 0
		while j < sz[i] {
			stdio.printf("-")
			j = j + 1
		}
		i = i + 1
	}
	stdio.printf("+")
}


public func main() -> Int32 {
	stdio.printf("sizeof(table0) = %d\n", Nat32 sizeof table0)
	stdio.printf("sizeof(table1) = %d\n", Nat32 sizeof table1)

	tablePrint(&table0, lengthof(table0), lengthof(table0[0]), headline = true)
	tablePrint(&table1, lengthof(table1), lengthof(table1[0]), headline = true)

	return 0
}

