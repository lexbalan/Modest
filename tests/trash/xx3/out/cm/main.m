include "stdio"
include "string"
include "ext"


type ContextHandler = (x: *Context) -> *Context


type X = {
	c: *Context
}

// си не позволяет создавать укзаатель на массив с элементами неполного типа
// вообще странно - но вот так
//type A = *[1]Context
//var a: *[1]Context

var p: *Context


@alias()
type Context = @public {
	x: Int32 = 32
	y: Int32 = 32
	f: *ContextHandler
	pz: *ZX
}

type ZX = {
	x: Int32
	c: Context
	f: *ContextHandler
	pz: *ZX
}

type ZZ = ZX


var dir: *Dir

public func init (d: *Dir) -> Unit {
	//
}

const x = 1.5
const xx = (x / 333333) * 333333
const y = Integer x

func main () -> Int32 {
	var c: Context
	var x: ZX
	var z: ZZ

	printf("xx = %f\n", Float64 xx)
	printf("y = %d\n", Int32 y)

	// 3.1415926535897932384626433832795028841971693993751058209749445923
	let f = 3.1415926535897932384626433832795028841971693993751058209749445923
	var fx: Float64 = (1.0 / 7) * 7
	printf("fx = %f\n", fx)
	fx = f / 3
	fx = f * 2
	fx = 2
	var k = Float64 (2.0 / 3)
	printf("%f\n", k)
	return 0
}

