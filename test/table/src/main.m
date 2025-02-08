
include "libc/stdio"
include "libc/stdlib"
include "libc/string"


type Table record {
	data: *[][]*Str8
	rows: Nat32
	cols: Nat32
	headline: Bool
	separate: Bool
}


var table_data0: [][]*Str8 = [
	["#", "Header0", "Header1"]
	["0", "Alef",    "Betha"]
	["1", "Clock",   "Depth"]
]

var table_data1: [][]*Str8 = [
	["#", "Header0", "Header1", "Header2"]
	["0", "Alef",    "Betha",   "Emma"]
	["1", "Clock",   "Depth",   "Free"]
	["2", "Ink",     "Julia",   "Keyword"]
	["3", "Ultra",   "Video",   "Word"]
]

var table00 = Table {
	data = &table_data0
	rows = lengthof(table_data0)
	cols = lengthof(table_data0[0])
	headline = false
	separate = false
}

var table01 = Table {
	data = &table_data0
	rows = lengthof(table_data0)
	cols = lengthof(table_data0[0])
	headline = true
	separate = false
}

var table02 = Table {
	data = &table_data0
	rows = lengthof(table_data0)
	cols = lengthof(table_data0[0])
	headline = false
	separate = true
}

var table03 = Table {
	data = &table_data0
	rows = lengthof(table_data0)
	cols = lengthof(table_data0[0])
	headline = true
	separate = true
}

// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
func tablePrint(table: *Table) {
	var i, j: Nat32

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
			let len = unsafe Nat32 strlen(str)
			if len > sz[j] {
				sz[j] = len
			}
			++j
		}
		++i
	}

	i = 0
	while i < table.cols {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2
		++i
	}

	// begin border
	printTableSep(&sz, table.cols)

	i = 0
	while i < table.rows {
		j = 0
		while j < table.cols {
			printf("|")
			let s = table_data[i][j]
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

		// print `+--+--+` separator line
		if (table.separate and i < table.rows) or (table.headline and i <= 1) {
			printTableSep(&sz, table.cols)
		}
	}

	// end border
	printTableSep(&sz, table.cols)
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
func printTableSep(sz: *[]Nat32, m: Nat32) {
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


public func main() -> Int32 {
	//printf("sizeof(table0) = %d\n", Nat32 sizeof(table0))
	//printf("sizeof(table1) = %d\n", Nat32 sizeof(table1))

	tablePrint(&table00)
	printf("\n")
	tablePrint(&table01)
	printf("\n")
	tablePrint(&table02)
	printf("\n")
	tablePrint(&table03)
	printf("\n")

	return 0
}


