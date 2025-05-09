include "stdio"
include "stdlib"
include "string"



public type Row record {}

public type Table record {
	public header: *[]*Str8
	public data: *[][]*Str8
	public nRows: Nat32
	public nCols: Nat32
	public separate: Bool
}
public func print (table: *Table) -> Unit {
	var i: Nat32
	var j: Nat32

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
			let len: Nat32 = Nat32 strlen(table.header[i])
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
			let len: Nat32 = Nat32 strlen(data[i][j])
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
	separator(&sz, table.nCols)

	if table.header != nil {
		printRow(table.header, &sz, table.nCols)
		separator(&sz, table.nCols)
	}

	i = 0
	while i < table.nRows {
		printRow(&data[i], &sz, table.nCols)
		i = i + 1

		if table.separate and i < table.nRows {
			separator(&sz, table.nCols)
		}
	}

	// bottom border
	separator(&sz, table.nCols)
}


func printRow (raw_row: *[]*Str8, sz: *[]Nat32, nCols: Nat32) -> Unit {
	let row: *[nCols]*Str8 = *[nCols]*Str8 raw_row

	var j = Nat32 0
	while j < nCols {
		printf("|")
		let s: *Str8 = row[j]
		var len: Nat32 = Nat32 strlen(s)
		if s[0] != "\x0" {
			len = len + 1
			printf(" %s", s)
		}

		var k = Nat32 0
		while k < (sz[j] - len) {
			printf(" ")
			k = k + 1
		}
		j = j + 1
	}
	printf("|\n")
}
func separator (sz: *[]Nat32, n: Nat32) -> Unit {
	var i = Nat32 0
	while i < n {
		printf("+")
		var j = Nat32 0
		while j < sz[i] {
			printf("-")
			j = j + 1
		}
		i = i + 1
	}
	printf("+\n")
}

