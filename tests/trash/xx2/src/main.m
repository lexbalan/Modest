// tests/xxx/src/main.m

include "libc/stdio"
include "libc/string"
import "libc/errno"


func mod (x: *Context) -> *Context

type Context = {
	x: Int32 = 32
	y: Int32 = 32
}

type Context2 = Context

func f0(c: Context) -> Unit {
	Unit c
}

func f1(c: Context2) -> Unit {
	Unit c
}

func main () -> Int32 {
	let e = errno.get()
	f0({x=0, y=0})
	f1({x=0, y=0})
	return 0
}


