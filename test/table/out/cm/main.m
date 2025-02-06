
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"


// [row, col]
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


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
func tableSepPrint(sz: *[]Nat32, m: Int32) -> Unit {
	stdio.printf("+")
	var i: Int32 = 0
	while i < m {
		var j: Nat32 = Nat32 0
		while j < sz[i] {
			stdio.printf("-")
			j = j + 1
		}
		stdio.printf("+")
		i = i + 1
	}
}

// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
func tablePrint(tablex: *[][]*Str8, m: Int32, n: Int32, headline: Bool) -> Unit {
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
			let slen = Nat32 string.strlen(table[i][j])
			if slen > sz[j] {
				sz[j] = slen
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
		// pirint `+----+` separator
		if i < 2 or notheadline {
			tableSepPrint(&sz, n)
			stdio.printf("\n")
		}

		stdio.printf("|")

		j = 0
		while j < n {
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

			stdio.printf("|")
			j = j + 1
		}
		stdio.printf("\n")
		i = i + 1
	}
	tableSepPrint(&sz, n)
	stdio.printf("\n")
}


public func main() -> Int32 {
	tablePrint(&table0, lengthof(table0), lengthof(table0[0]), headline = true)
	tablePrint(&table1, lengthof(table1), lengthof(table1[0]), headline = true)
	return 0
}

