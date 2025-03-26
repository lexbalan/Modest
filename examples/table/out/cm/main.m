
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"
import "table" as table


var table_header0: [<str_value>]*Str8 = [
	"#", "Header0", "Header1"
]

var table_data0: [<str_value>][<str_value>]*Str8 = [
	["0", "Alef", "Betha"]
	["1", "Clock", "Depth"]
	["2", "Earth", "Fight"]
]


var table_header1: [<str_value>]*Str8 = [
	"#", "Header0", "Header1", "Header2"
]

var table_data1: [<str_value>][<str_value>]*Str8 = [
	["0", "Alef", "Betha", "Emma"]
	["1", "Clock", "Depth", "Free"]
	["2", "Ink", "Julia", "Keyword"]
	["3", "Ultra", "Video", "Word"]
]


var table00: Table = Table {
	header = nil
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = false
}

var table01: Table = Table {
	header = &table_header0
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = false
}

var table02: Table = Table {
	header = nil
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = true
}

var table03: Table = Table {
	header = &table_header0
	data = &table_data0
	nRows = lengthof(table_data0)
	nCols = lengthof(table_data0[0])
	separate = true
}

var table10: Table = Table {
	header = &table_header1
	data = &table_data1
	nRows = lengthof(table_data1)
	nCols = lengthof(table_data1[0])
	separate = true
}


public func main() -> Int32 {
	let tab = new Table {}

	if tab == nil {
		stdio.("cannot create object\n")
	}

	*tab = table00

	table.(&table00)
	stdio.("\n")

	table.(&table01)
	stdio.("\n")

	table.(&table02)
	stdio.("\n")

	table.(&table03)
	stdio.("\n")

	table.(&table10)
	stdio.("\n")

	return 0
}

