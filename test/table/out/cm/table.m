
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"


public type Table record {
	public header: *[]*Str8
	public data: *[][]*Str8
	public rows: Nat32
	public cols: Nat32
	public separate: Bool
}


// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
public func print(table: *Table) -> Unit {
	var i: Nat32
	var j: Nat32

	let rows = table.rows
	let cols = table.cols
	// construct pointer to closed VLA array
	let table_data = *[rows][cols]*Str8 table.data

	// array of size of columns (in characters)
	var sz: [cols]Nat32 = []

	// calculate max length (in chars) of column

	if table.header != nil {
		i = 0
		while i < cols {
			let str = table.header[i]
			let len = Nat32 string.strlen(str)
			if len > sz[i] {
				sz[i] = len
			}
			i = i + 1
		}
	}

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

	// top border
	printSep(&sz, table.cols)

	if table.header != nil {
		printRow(table.header, &sz, table.cols)
		printSep(&sz, table.cols)
	}

	i = 0
	while i < table.rows {
		printRow(&(table_data[i]), &sz, table.cols)
		i = i + 1

		// print `+--+--+` separator line
		if table.separate and i < table.rows {
			printSep(&sz, table.cols)
		}
	}

	// bottom border
	printSep(&sz, table.cols)
}


func printRow(raw_row: *[]*Str8, sz: *[]Nat32, ncols: Nat32) -> Unit {
	let row = *[ncols]*Str8 raw_row

	var j: Nat32 = Nat32 0
	while j < ncols {
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

