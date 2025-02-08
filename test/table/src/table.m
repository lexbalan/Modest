
include "libc/stdio"
include "libc/stdlib"
include "libc/string"


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
public func print(table: *Table) {
	var i, j: Nat32

	let nRows = table.nRows
	let nCols = table.nCols
	// construct pointer to closed VLA array
	let table_data = *[nRows][nCols]*Str8 table.data

	// array of size of columns (in characters)
	var sz: [nCols]Nat32 = []

	//
	// calculate max length (in chars) of column
	//

	if table.header != nil {
		i = 0
		while i < nCols {
			let str = table.header[i]
			let len = unsafe Nat32 strlen(str)
			if len > sz[i] {
				sz[i] = len
			}
			++i
		}
	}

	i = 0
	while i < table.nRows {
		j = 0
		while j < table.nCols {
			let str = table_data[i][j]
			let len = unsafe Nat32 strlen(str)
			if len > sz[j] {
				sz[j] = len
			}
			++j
		}
		++i
	}

	i = 0
	while i < table.nCols {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2
		++i
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
		printRow(&table_data[i], &sz, table.nCols)
		++i

		if (table.separate and i < table.nRows) {
			printSep(&sz, table.nCols)
		}
	}

	// bottom border
	printSep(&sz, table.nCols)
}


func printRow(raw_row: *[]*Str8, sz: *[]Nat32, nnCols: Nat32) {
	let row = unsafe *[nnCols]*Str8 raw_row

	var j = Nat32 0
	while j < nnCols {
		printf("|")
		let s = row[j]
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
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
func printSep(sz: *[]Nat32, m: Nat32) {
	var i = Nat32 0
	while i < m {
		printf("+")
		var j = Nat32 0
		while j < sz[i] {
			printf("-")
			++j
		}
		++i
	}
	printf("+\n")
}


