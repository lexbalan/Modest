import "table"
include "stdio"
include "stdlib"
include "string"

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


var table00 = Table {
	header = nil
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = false
}

var table01 = Table {
	header = &table_header0
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = false
}

var table02 = Table {
	header = nil
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = true
}

var table03 = Table {
	header = &table_header0
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = true
}

var table10 = Table {
	header = &table_header1
	data = &table_data1
	nRows = lengthof(table_data1)
	nCols = lengthof(table_data1[0])
	separate = true
}


public func main () -> Int32 {
	table.print(&table00)
	printf("\n")

	table.print(&table01)
	printf("\n")

	table.print(&table02)
	printf("\n")

	table.print(&table03)
	printf("\n")

	table.print(&table10)
	printf("\n")

	return 0
}

