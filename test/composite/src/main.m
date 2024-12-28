// test/composite
//

include "libc/stdio"


var a0: [5]Int32
var a1: [5]*Int32
var a2: [5]**Int32
var a3: [5]*()->Unit
var a4: [5][10]Int
var a5: [5]*[10]Int
var a6: [2][5]*[10]Int
var a7: [2][5]*[10]*Int
var a8: [2][5]*[10]*(a: Int) -> Int
var a9: [5]*[10]*[2]*(a: Int) -> Int

var f0: *() -> Unit
var f1: *(x: Int32) -> Int32
var f2: *(a: Int32, b: Int32) -> Int32
var f3: *() -> *Int32
var f4: *(x: Int32) -> [10]Int32
var f5: *(a: [32]Int32) -> [32]Int32
var f6: *(a: *[32]Int32) -> *[32]Int32
var f7: *(f: *()->Unit) -> Unit
var f8: *(f: *()->Unit) -> *()->Unit
var f9: *(f: *()->Unit) -> **()->Unit
var f10: *(f: **()->Unit) -> **()->Unit
var f11: *(f: **(a: Int32, b: *Int32)->*[10]Int32) -> **()->Unit

var p0: *Int32
var p1: **Int32
var p2: *[5]Int32
var p3: **[5]Int32  // <--


type RGB24 record {
	red: Nat8
	green: Nat8
	blue: Nat8
}

var rgb0 = [2]RGB24 [
	{red = 200, green = 0, blue = 0}
	{red = 200, green = 0, blue = 0}
]

type AnimationPoint record {
	color: RGB24
	time: Nat32
}

var ap = AnimationPoint {
	color = {
		red = 200
		green = 0
		blue = 0
	}
	time = 3000
}


var animation0_points = []AnimationPoint [
	// testing select_common_record_type()
	{color = {red = 200, green = 0, blue = 0}, time = 3}
	{color = {red = 0, green = 200, blue = 0}, time = 30}
	{color = {red = 100, green = 100, blue = 0}, time = 300}
	{color = {red = 254, green = 254, blue = 0}, time = 20}
	{color = {red = 0, green = 0, blue = 255}, time = 3000}
]

var animation1_points = []AnimationPoint [
	// testing select_common_record_type()
	{color = {red = 200, green = 0, blue = 0}, time = 3}
	{color = {red = 0, green = 200, blue = 0}, time = 30}
	{color = {red = 100, green = 100, blue = 0}, time = 300}
	{color = {red = 254, green = 254, blue = 0}, time = 20}
	{color = {red = 0, green = 0, blue = 255}, time = 3000}
]

var animation2_points = []AnimationPoint [
	// testing select_common_record_type()
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

var wrap0 = Wrap {
	fhi=&hi
	fop=&add
}

var awrap = [&wrap0, &wrap0]

public func main() -> Int32 {
	xy({x=10, y=20})

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

	var i = 0
	while i < 3 {
		var j = 0
		while j < 3 {
			printf("arrr[%d][%d] = %d\n", i, j, arrr[i][j])
			++j
		}
		++i
	}

	let _add = farr[0](5, 7)
	printf("farr[0](5, 7) = %d\n", _add)
	let _sub = farr[1](5, 7)
	printf("farr[1](5, 7) = %d\n", _sub)

	i = 0
	while i < 10 {
		hiarr[i]("LOL")
		++i
	}

	awrap[0].fhi("World")

	return 0
}

