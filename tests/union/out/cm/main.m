import "builtin"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"


type RGBA_Components = {
	red: Nat8
	green: Nat8
	blue: Nat8
	alpha: Nat8
}

type RGBA = @layout {
	code: Nat32
	components: RGBA_Components
}


@nonstatic
func main () -> Int {
	var c: RGBA
	c.components.red = 255
	c.components.green = 128
	c.components.blue = 64
	c.components.alpha = 32

	printf("code = %08x\n", c.code)

	return 0
}

