
include "libc/stdio"
include "libc/stdlib"
include "libc/string"


@extern("C")
func xxx () -> Unit


type Point = record {
	x: Int32
	y: Int32
}


var points: []Point = [
	{x=0, y=0}
	{x=1, y=1}
	{x=2, y=2}
]


public func main () -> Int32 {
	printf("test2\n")
	return 0
}


