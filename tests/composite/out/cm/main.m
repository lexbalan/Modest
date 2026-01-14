include "stdio"


// Test for composite types

// Pointers
var p0: *Int32
var p1: **Int32


// Functions
func f0 () -> Unit {
	return
}

func f1 (x: Int32) -> Int32 {
	return x
}

func f2 (a: Int32, b: Int32) -> Int32 {
	return a + b
}

func f3 () -> *Int32 {
	return nil
}

func f4 (x: Int32) -> [10]Int32 {
	return [10]Int32 [1, 2, 3]
}

func f5 (a: [32]Int32) -> [32]Int32 {
	return a
}

func f6 (a: *[32]Int32) -> *[32]Int32 {
	return nil
}

func f7 (f: *() -> Unit) -> Unit {
	return
}

func f8 (f: *() -> Unit) -> *() -> Unit {
	return &f0
}

func f9 (f: *() -> Unit) -> **() -> Unit {
	return nil
}

func f10 (f: **() -> Unit) -> **() -> Unit {
	return f
}

func f11 (f: **(a: Int32, b: *Int32) -> *[10]Int32) -> **() -> Unit {
	return nil
}

func f12 (f: **(a: *[32]Int32, b: **[64]Int32) -> *[10]Int32) -> **() -> Unit {
	return nil
}

func f13 (f: **(a: *[32]*Int32, b: **[64]*Int32) -> *[10]Int32) -> **() -> Unit {
	return nil
}


// Pointers to function
var pf0: *() -> Unit = &f0
var pf1: *(x: Int32) -> Int32 = &f1
var pf2: *(a: Int32, b: Int32) -> Int32 = &f2
var pf3: *() -> *Int32 = &f3
var pf4: *(x: Int32) -> [10]Int32 = &f4
var pf5: *(a: [32]Int32) -> [32]Int32 = &f5
var pf6: *(a: *[32]Int32) -> *[32]Int32 = &f6
var pf7: *(f: *() -> Unit) -> Unit = &f7
var pf8: *(f: *() -> Unit) -> *() -> Unit = &f8
var pf9: *(f: *() -> Unit) -> **() -> Unit = &f9
var pf10: *(f: **() -> Unit) -> **() -> Unit = &f10
var pf11: *(f: **(a: Int32, b: *Int32) -> *[10]Int32) -> **() -> Unit = &f11
var pf12: *(f: **(a: *[32]Int32, b: **[64]Int32) -> *[10]Int32) -> **() -> Unit = &f12
var pf13: *(f: **(a: *[32]*Int32, b: **[64]*Int32) -> *[10]Int32) -> **() -> Unit = &f13


// Arrays
var a0: [5]Int32 = [0, 1, 2, 3, 4]
var a1: [5]*Int32 = [&a0[0], &a0[1], &a0[2], &a0[3], &a0[4]]
var a2: [5]**Int32 = [&a1[0], &a1[1], &a1[2], &a1[3], &a1[4]]
var a3 = [5]*() -> Unit [&f0]
var a4: [2][5]Int = [[0, 1, 2, 3, 4], [5, 6, 7, 8, 9]]
var a5: [2]*[5]Int = [&a4[0], &a4[1]]
// Проблема в том что мой getelementptr не умеет в цепь-молнию
// а здесь без нее никак... придется взяться за это и сделать наконец
//var a6: [2][5]*Int = [
//	[&a4[0][0], &a4[0][1], &a4[0][2], &a4[0][3], &a4[0][4]]
//	[&a4[1][0], &a4[1][1], &a4[1][2], &a4[1][3], &a4[1][4]]
//]

var a7: [2][5]*[5]Int = [
	[&a0, &a0, &a0, &a0, &a0]
	[&a0, &a0, &a0, &a0, &a0]
]

var a8: [2][5]*[2][5]*[5]Int = [
	[&a7, &a7, &a7, &a7, &a7]
	[&a7, &a7, &a7, &a7, &a7]
]

var a9: [5]*[10]*[2]*(a: Int) -> Int


//
var p2: *[5]Int32 = &a0
var p3: **[5]Int32 = &p2


type RGB24 = record {
	red: Nat8
	green: Nat8
	blue: Nat8
}

var rgb0 = [2]RGB24 [
	{red = 200, green = 0, blue = 0}
	{red = 200, green = 0, blue = 0}
]

type AnimationPoint = record {
	color: RGB24
	time: Nat32
}

var ap: AnimationPoint = AnimationPoint {
	color = {
		red = 200
		green = 0
		blue = 0
	}
	time = 3000
}


var animation0_points = [5]AnimationPoint [
	{color = {red = 200, green = 0, blue = 0}, time = 3}
	{color = {red = 0, green = 200, blue = 0}, time = 30}
	{color = {red = 100, green = 100, blue = 0}, time = 300}
	{color = {red = 254, green = 254, blue = 0}, time = 20}
	{color = {red = 0, green = 0, blue = 255}, time = 3000}
]

var animation1_points = [5]AnimationPoint [
	{color = {red = 200, green = 0, blue = 0}, time = 3}
	{color = {red = 0, green = 200, blue = 0}, time = 30}
	{color = {red = 100, green = 100, blue = 0}, time = 300}
	{color = {red = 254, green = 254, blue = 0}, time = 20}
	{color = {red = 0, green = 0, blue = 255}, time = 3000}
]

var animation2_points = [5]AnimationPoint [
	{color = {red = 200, green = 0, blue = 0}, time = 3}
	{color = {red = 0, green = 200, blue = 0}, time = 30}
	{color = {red = 100, green = 100, blue = 0}, time = 300}
	{color = {red = 255, green = 254, blue = 0}, time = 20}
	{color = {red = 0, green = 0, blue = 255}, time = 3000}
]


func xy (x: record {
	x: Int32
	y: Int32
}) -> Unit {
}


var arrr: [3][3]Int32 = [
	[1, 2, 3]
	[4, 5, 6]
	[7, 8, 9]
]


var arry: [3][3]*() -> Unit


func add (a: Int32, b: Int32) -> Int32 {
	return a + b
}

func sub (a: Int32, b: Int32) -> Int32 {
	return a - b
}


var farr: [2]*(a: Int32, b: Int32) -> Int32 = [
	&add, &sub
]


type He = () -> Unit


@used
func he (x: *He) -> Unit {
	Unit x
}

func hi (x: *Str8) -> Unit {
	printf("Hi %s!\n", x)
}

var hiarr: [10]*(x: *Str8) -> Unit = [
	&hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi, &hi
]

type Wrap = record {
	fhi: *(x: *Str8) -> Unit
	fop: *(a: Int32, b: Int32) -> Int32
}

var wrap0: Wrap = Wrap {
	fhi = &hi
	fop = &add
}

var awrap: [2]*Wrap = [&wrap0, &wrap0]

public func main () -> Int32 {
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

	var i: Nat32 = 0
	while i < 3 {
		var j: Nat32 = 0
		while j < 3 {
			printf("arrr[%d][%d] = %d\n", i, j, arrr[i][j])
			j = j + 1
		}
		i = i + 1
	}

	let _add: Int32 = farr[0](5, 7)
	printf("farr[0](5, 7) = %d\n", _add)
	let _sub: Int32 = farr[1](5, 7)
	printf("farr[1](5, 7) = %d\n", _sub)

	i = 0
	while i < 10 {
		hiarr[i]("LOL")
		i = i + 1
	}

	awrap[0].fhi("World")
	//let y = awrap[0]
	//y.fhi("World")

	return 0
}

