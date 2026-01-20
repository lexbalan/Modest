include "stdio"



const unit = {}

/*@deprecated*/
type Point = record {
	x: Int32 = 32
	y: Int32 = 32
}

const p00 = {x = 5, y = 5}
const p01 = {x = 5}


@deprecated
const mY = 5


@used
func returnPoint () -> Point {
	var p: Point
	p.x = 10
	return p
}

// Двойная инициализация (!) ??
//func main() -> Int32 {
//	return 0
//}

public func main () -> Int32 {
	printf("Hello World!\n")
	var p: Point = unit
	// Конструируем Point из записи в которой нет ни одного поля
	// 1. implicit cons Point from {} (здесь мы создаем ValueCons Point с default полями)
	p = p00
	p = p01

	type MyInt = Int32
	var myInt32: MyInt

	//var a: []record {a: Int32}
	var b: Int64
	var c: Int32
	//a = a * b + c
	//offsetof(Point.y)
	//p.z
	//a = (2 + 2)
	//var j: jey.Jey
	return 0
}


// Unit
//public func xxx () -> record {} {
//	return {}
//}

