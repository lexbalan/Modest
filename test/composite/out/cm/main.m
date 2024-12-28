
@c_include "stdio.h"
include "libc/stdio"


type RGB24 record {
	red: Nat8
	green: Nat8
	blue: Nat8
}

var rgb0: [2]RGB24 = [2]RGB24 [
	{red = 200, green = 0, blue = 0}
	{red = 200, green = 0, blue = 0}
]

type AnimationPoint record {
	color: RGB24
	time: Nat32
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

var animation2_points: [5]AnimationPoint = [5]AnimationPoint [
	{color = {red = 200, green = 0, blue = 0}, time = 3}
	{color = {red = 0, green = 200, blue = 0}, time = 30}
	{color = {red = 100, green = 100, blue = 0}, time = 300}
	{color = {red = 255, green = 254, blue = 0}, time = 20}
	{color = {red = 0, green = 0, blue = 255}, time = 3000}
]


func xy(x: record {x: Int32, y: Int32}) -> Unit {

}


var arrr: [3][3]Int32 = [
	[1, 2, 3]
	[4, 5, 6]
	[7, 8, 9]
]

var f0: *() -> Unit
var arry: [3][3]*() -> Unit


func add(a: Int32, b: Int32) -> Int32 {
	return a + b
}

func sub(a: Int32, b: Int32) -> Int32 {
	return a - b
}


var farr: [2]*(a: Int32, b: Int32) -> Int32 = [
	&add, &sub
]

func hi(x: *Str8) -> Unit {
	printf("Hi %s!\n", x)
}

var hiarr: [10]*(x: *Str8) -> Unit = [
	&hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi
]

type Wrap record {
	fhi: *(x: *Str8) -> Unit
	fop: *(a: Int32, b: Int32) -> Int32
}

var wrap0: Wrap = Wrap {
	fhi = &hi
	fop = &add
}

var awrap: [2]*Wrap = [&wrap0, &wrap0]

public func main() -> Int32 {
	xy({x = 10, y = 20})

	printf("test1 (eq): ")
	if animation0_points == animation1_points {
		printf("eq\n")
	} else {
		printf("ne\n")
	}

	printf("test2 (ne): ")
	if animation1_points == animation2_points {
		printf("eq\n")
	} else {
		printf("ne\n")
	}

	var i: Int32 = 0
	while i < 3 {
		var j: Int32 = 0
		while j < 3 {
			printf("arrr[%d][%d] = %d\n", i, j, arrr[i][j])
			j = j + 1
		}
		i = i + 1
	}

	let _add = farr[0](5, 7)
	printf("farr[0](5, 7) = %d\n", _add)
	let _sub = farr[1](5, 7)
	printf("farr[1](5, 7) = %d\n", _sub)

	i = 0
	while i < 10 {
		hiarr[i]("LOL")
		i = i + 1
	}

	awrap[0].fhi("World")

	return 0
}

