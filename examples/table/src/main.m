
include "libc/stdio"
include "libc/stdlib"
include "libc/string"

import "table"


var table_header0: []*Str8 = [
	"#", "Header0", "Header1"
]

var tableData0: [][]*Str8 = [
	["0", "Alef",    "Betha"]
	["1", "Clock",   "Depth"]
	["2", "Earth",   "Fight"]
]


var table_header1: []*Str8 = [
	"#", "Header0", "Header1", "Header2"
]

var tableData1: [][]*Str8 = [
	["0",  "Alef",    "Betha",   "Clock"]
	["1",  "Depth",   "Emma",    "Free"]
	["2",  "Ink",     "Julia",   "Keyword"]
	["3",  "Ultra",   "Video",   "Word"]
]


var table00 = table.Table {
	header = nil
	data = &tableData0
	nRows = lengthof(tableData0)
	nCols = lengthof(tableData0[0])
	separate = false
}

var table01 = table.Table {
	header = &table_header0
	data = &tableData0
	nRows = lengthof(tableData0)
	nCols = lengthof(tableData0[0])
	separate = false
}

var table02 = table.Table {
	header = nil
	data = &tableData0
	nRows = lengthof(tableData0)
	nCols = lengthof(tableData0[0])
	separate = true
}

var table03 = table.Table {
	header = &table_header0
	data = &tableData0
	nRows = lengthof(tableData0)
	nCols = lengthof(tableData0[0])
	separate = true
}

var table10 = table.Table {
	header = &table_header1
	data = &tableData1
	nRows = lengthof(tableData1)
	nCols = lengthof(tableData1[0])
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


