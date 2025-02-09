
include "libc/stdio"
include "libc/stdlib"
include "libc/string"

import "table"


var table_header0: []*Str8 = [
	"#", "Header0", "Header1"
]

var table_data0: [][]*Str8 = [
	["0", "Alef",    "Betha"]
	["1", "Clock",   "Depth"]
	["2", "Earth",   "Fight"]
]


var table_header1: []*Str8 = [
	"#", "Header0", "Header1", "Header2"
]

var table_data1: [][]*Str8 = [
	["0", "Alef",    "Betha",   "Emma"]
	["1", "Clock",   "Depth",   "Free"]
	["2", "Ink",     "Julia",   "Keyword"]
	["3", "Ultra",   "Video",   "Word"]
]


var table00 = table.Table {
	header = nil
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = false
}

var table01 = table.Table {
	header = &table_header0
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = false
}

var table02 = table.Table {
	header = nil
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = true
}

var table03 = table.Table {
	header = &table_header0
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = true
}


public func main() -> Int32 {
	table.print(&table00)
	printf("\n")
	table.print(&table01)
	printf("\n")
	table.print(&table02)
	printf("\n")
	table.print(&table03)
	printf("\n")

	return 0
}


