// tests/xxx/src/main.m

include "libc/stdio"
include "libc/string"


type ContextHandler = (x: *Context) -> *Context


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


