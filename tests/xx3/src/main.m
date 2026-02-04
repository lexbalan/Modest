// tests/xx3/src/main.m

include "libc/stdio"
include "libc/string"


type ContextHandler = (x: *Context) -> *Context


type X = record {c: *Context}

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
	return 0
}


