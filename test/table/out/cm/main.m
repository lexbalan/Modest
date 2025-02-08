
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"


type Table record {
	data: *[][]*Str8
	rows: Nat32
	cols: Nat32
	headline: Bool
	separate: Bool
}


var table_data0: [3][3]*[]Char8 = [
	["#", "Header0", "Header1"]
	["0", "Alef", "Betha"]
	["1", "Clock", "Depth"]
]

var table_data1: [5][4]*[]Char8 = [
	["#", "Header0", "Header1", "Header2"]
	["0", "Alef", "Betha", "Emma"]
	["1", "Clock", "Depth", "Free"]
	["2", "Ink", "Julia", "Keyword"]
	["3", "Ultra", "Video", "Word"]
]

var table00: Table = Table {
	data = &table_data0
	rows = lengthof(table_data0)
	cols = lengthof(table_data0[0])
	headline = false
	separate = false
}

var table01: Table = Table {
	data = &table_data0
	rows = lengthof(table_data0)
	cols = lengthof(table_data0[0])
	headline = true
	separate = false
}

var table02: Table = Table {
	data = &table_data0
	rows = lengthof(table_data0)
	cols = lengthof(table_data0[0])
	headline = false
	separate = true
}

var table03: Table = Table {
	data = &table_data0
	rows = lengthof(table_data0)
	cols = lengthof(table_data0[0])
	headline = true
	separate = true
}

// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
func tablePrint(table: *Table) -> Unit {
	var i: Nat32
	var j: Nat32

	let rows = table.rows
	let cols = table.cols
	// construct pointer to closed VLA array
	let table_data = *[rows][cols]*Str8 table.data

	// array of size of columns (in characters)
	var sz: [cols]Nat32 = []

	// calculate max length (in chars) of column
	i = 0
	while i < table.rows {
		j = 0
		while j < table.cols {
			let str = table_data[i][j]
			let len = Nat32 string.strlen(str)
			if len > sz[j] {
				sz[j] = len
			}
			j = j + 1
		}
		i = i + 1
	}

	i = 0
	while i < table.cols {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2
		i = i + 1
	}

	// begin border
	printTableSep(&sz, table.cols)

	i = 0
	while i < table.rows {
		j = 0
		while j < table.cols {
			stdio.printf("|")
			let s = table_data[i][j]
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

		// print `+--+--+` separator line
		if table.separate and i < table.rows or table.headline and i <= 1 {
			printTableSep(&sz, table.cols)
		}
	}

	// end border
	printTableSep(&sz, table.cols)
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
func printTableSep(sz: *[]Nat32, m: Nat32) -> Unit {
	var i: Nat32 = Nat32 0
	while i < m {
		stdio.printf("+")
		var j: Nat32 = Nat32 0
		while j < sz[i] {
			stdio.printf("-")
			j = j + 1
		}
		i = i + 1
	}
	stdio.printf("+\n")
}


public func main() -> Int32 {
	//printf("sizeof(table0) = %d\n", Nat32 sizeof(table0))
	//printf("sizeof(table1) = %d\n", Nat32 sizeof(table1))

	tablePrint(&table00)
	stdio.printf("\n")
	tablePrint(&table01)
	stdio.printf("\n")
	tablePrint(&table02)
	stdio.printf("\n")
	tablePrint(&table03)
	stdio.printf("\n")

	return 0
}

