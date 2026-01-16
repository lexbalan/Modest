include "stdio"


type Point = @deprecated record {
	x: Int32
	y: Int32
}


@deprecated
const mY = 5

public func main () -> Int32 {
	printf("Hello World!\n")
	var p: Point = {x = 0, y = 0}
	mY
	"{"
	return 0
}

