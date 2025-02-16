
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"
import "table" as table


var table_header0: [3]*Str8 = [
	"#", "Header0", "Header1"
]

var table_data0: [3][3]*Str8 = [
	["0", "Alef", "Betha"]
	["1", "Clock", "Depth"]
	["2", "Earth", "Fight"]
]


var table_header1: [4]*Str8 = [
	"#", "Header0", "Header1", "Header2"
]

var table_data1: [4][4]*Str8 = [
	["0", "Alef", "Betha", "Emma"]
	["1", "Clock", "Depth", "Free"]
	["2", "Ink", "Julia", "Keyword"]
	["3", "Ultra", "Video", "Word"]
]


var table00: table.Table = table.Table {
	header = nil
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = false
}

var table01: table.Table = table.Table {
	header = &table_header0
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = false
}

var table02: table.Table = table.Table {
	header = nil
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = true
}

var table03: table.Table = table.Table {
	header = &table_header0
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = true
}

var table10: table.Table = table.Table {
	header = &table_header1
	data = &table_data1
	nRows = lengthof(table_data1)
	nCols = lengthof(table_data1[0])
	separate = true
}


public func main() -> Int32 {
	let tab = new table.Table {}

	if tab == nil {
		stdio.printf("cannot create object\n")
	}

	*tab = table00

	table.print(&table00)
	stdio.printf("\n")

	table.print(&table01)
	stdio.printf("\n")

	table.print(&table02)
	stdio.printf("\n")

	table.print(&table03)
	stdio.printf("\n")

	table.print(&table10)
	stdio.printf("\n")

	return 0
}

