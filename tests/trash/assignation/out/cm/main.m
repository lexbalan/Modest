private import "builtin"
include "ctypes64"
include "stdio"



// Simply record for records assignation test
type Point = {
	x: Int32
	y: Int32
}


var glb_i0: Int32 = 0
var glb_i1: Int32 = 321

var glb_r0: Point = {}
var glb_r1: Point = {x = 20, y = 10}

var glb_a0: [10]Int32 = []
var glb_a1 = [10]Int32 [64, 53, 42]


@nonstatic()
func main () -> Int {
	printf("test assignation\n")
	glb_i0 = glb_i1
	printf("glb_i0 = %i\n", glb_i0)
	glb_a0 = glb_a1

	printf("glb_a0[0] = %i\n", glb_a0[0])
	printf("glb_a0[1] = %i\n", glb_a0[1])
	printf("glb_a0[2] = %i\n", glb_a0[2])
	glb_r0 = glb_r1

	printf("glb_r0.x = %i\n", glb_r0.x)
	printf("glb_r0.y = %i\n", glb_r0.y)
	var loc_i0: Int32 = 0
	var loc_i1: Int32 = 123

	loc_i0 = loc_i1

	printf("loc_i0 = %i\n", loc_i0)
	var loc_a0: [10]Int32 = []
	var loc_a1 = [10]Int32 [42, 53, 64]

	loc_a0 = loc_a1

	printf("loc_a0[0] = %i\n", loc_a0[0])
	printf("loc_a0[1] = %i\n", loc_a0[1])
	printf("loc_a0[2] = %i\n", loc_a0[2])
	var loc_r0: Point = {}
	var loc_r1: Point = {x = 10, y = 20}

	loc_r0 = loc_r1

	printf("loc_r0.x = %i\n", loc_r0.x)
	printf("loc_r0.y = %i\n", loc_r0.y)


	return 0
}

