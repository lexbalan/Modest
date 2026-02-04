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


public func main () -> Int32 {
	let f = 3.14
	var fx: Float64 = f
	fx = f / 3
	fx = f * 2
	printf("%f\n", Float64 Float64 (2.0 / 3))
	return 0
}

