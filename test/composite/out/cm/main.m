
@c_include "stdio.h"
include "libc/stdio"



public type RGB24 record {
	public red: Nat8
	public green: Nat8
	public blue: Nat8
}

var rgb0: [2]RGB24 = [2]RGB24 [{red = 200, green = 0, blue = 0}, {red = 200, green = 0, blue = 0}]

type AnimationPoint record {
	public color: RGB24
	public time: Nat32
}

var ap: AnimationPoint = AnimationPoint {color = {red = 200, green = 0, blue = 0}, time = 3000}


var animation0_points: [5]AnimationPoint = [5]AnimationPoint [

	{color = {red = 200, green = 0, blue = 0}, time = 3}
	{color = {red = 0, green = 200, blue = 0}, time = 30}
	{color = {red = 100, green = 100, blue = 0}, time = 300}
	{color = {red = 254, green = 254, blue = 0}, time = 20}
	{color = {red = 0, green = 0, blue = 255}, time = 3000}
]

var animation1_points: [5]AnimationPoint = [5]AnimationPoint [

	{color = {red = 200, green = 0, blue = 0}, time = 3}
	{color = {red = 0, green = 200, blue = 0}, time = 30}
	{color = {red = 100, green = 100, blue = 0}, time = 300}
	{color = {red = 254, green = 254, blue = 0}, time = 20}
	{color = {red = 0, green = 0, blue = 255}, time = 3000}
]


public func main() -> Int32 {
	if animation0_points == animation1_points {
		printf("eq\n")
	} else {
		printf("ne\n")
	}
	return 0
}

