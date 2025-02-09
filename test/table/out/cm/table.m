
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"


public type Table record {
	public header: *[]*Str8
	public data: *[][]*Str8
	public nRows: Nat32
	public nCols: Nat32
	public separate: Bool
}


// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
public func print(table: *Table) -> Unit {
	var i: Nat32
	var j: Nat32

	// construct pointer to closed VLA array
	let table_data = *[table.nRows][table.nCols]*Str8 table.data

	// array of size of columns (in characters)
	var sz: [table.nCols]Nat32 = []

	//
	// calculate max length (in chars) of column
	//

	if table.header != nil {
		i = 0
		while i < table.nCols {
			let str = table.header[i]
			let len = Nat32 string.strlen(str)
			if len > sz[i] {
				sz[i] = len
			}
			i = i + 1
		}
	}

	i = 0
	while i < table.nRows {
		j = 0
		while j < table.nCols {
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
	while i < table.nCols {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2
		i = i + 1
	}

	//
	// print table
	//

	// top border
	printSep(&sz, table.nCols)

	if table.header != nil {
		printRow(table.header, &sz, table.nCols)
		printSep(&sz, table.nCols)
	}

	i = 0
	while i < table.nRows {
		printRow(&(table_data[i]), &sz, table.nCols)
		i = i + 1

		if table.separate and i < table.nRows {
			printSep(&sz, table.nCols)
		}
	}

	// bottom border
	printSep(&sz, table.nCols)
}


func printRow(raw_row: *[]*Str8, sz: *[]Nat32, nCols: Nat32) -> Unit {
	let row = *[nCols]*Str8 raw_row

	var j: Nat32 = Nat32 0
	while j < nCols {
		stdio.printf("|")
		let s = row[j]
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
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
func printSep(sz: *[]Nat32, m: Nat32) -> Unit {
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

