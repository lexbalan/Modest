/*
 * table.m
 */

pragma unsafe

include "libc/stdio"
include "libc/stdlib"
include "libc/string"


public type Row = []*Str8

public type Table = @public record {
	header: *[]*Str8
	data: *[]Row
	nRows: Nat32
	nCols: Nat32
	separate: Bool
}


// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
public func print (table: *Table) -> Unit {
	var i, j: Nat32

	// construct pointer to closed VLA array
	let data = *[table.nRows][table.nCols]*Str8 table.data

	// array of size of columns (in characters)
	var sz: [table.nCols]Nat32 = []

	//
	// calculate max length (in chars) of column
	//

	if table.header != nil {
		i = 0
		while i < table.nCols {
			let len = unsafe Nat32 strlen(table.header[i])
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
			let len = unsafe Nat32 strlen(data[i][j])
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
	separator(&sz, table.nCols)

	if table.header != nil {
		printRow(table.header, &sz, table.nCols)
		separator(&sz, table.nCols)
	}

	i = 0
	while i < table.nRows {
		printRow(&data[i], &sz, table.nCols)

		if table.separate and i < table.nRows - 1 {
			separator(&sz, table.nCols)
		}

		++i
	}

	// bottom border
	separator(&sz, table.nCols)
}


func printRow (raw_row: *[]*Str8, sz: *[]Nat32, nCols: Nat32) -> Unit {
	let row = unsafe *[nCols]*Str8 raw_row
	var j = Nat32 0
	while j < nCols {
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


// печатает строку +---+---+ отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
func separator (sz: *[]Nat32, n: Nat32) -> Unit {
	var i = Nat32 0
	while i < n {
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


