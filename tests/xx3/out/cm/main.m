include "stdio"
include "string"



type ContextHandler = (x: *Context) -> *Context


type X = record {
	c: *Context
}

// си не позволяет создавать укзаатель на массив с элементами неполного типа
// вообще странно - но вот так
//type A = *[1]Context
//var a: *[1]Context

var p: *Context

type Context = record {
	x: Int32 = 32
	y: Int32 = 32
	f: *ContextHandler
}

type ZX = record {
	x: Int32
	c: Context
	f: *ContextHandler
}


const xx = (1 / 3) * 3


public func main () -> Int32 {
	//3.1415926535897932384626433832795028841971693993751058209749445923
	let f = 3.1415926535897932384626433832795028841971693993751058209749445923
	var fx: Float64 = (1 / 7) * 7
	fx = f / 3
	fx = f * 2
	fx = 2
	var k = Float64 (2 / 3)
	printf("%f\n", Float64 k)
	return 0
}

