include "stdio"
include "string"



//type ContextHandler = (x: Context) -> Context

type ZX = record {
	x: Int32
	c: Context
}

type Context = record {
	x: Int32 = 32
	y: Int32 = 32
	z: *ZX
}


public func main () -> Int32 {
	return 0
}

