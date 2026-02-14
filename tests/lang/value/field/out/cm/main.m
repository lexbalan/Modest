

type Point = {
	x: Int32
	y: Int32
}
type Line = {
	a: Point
	b: Point
}

var origin: Point = {x = 0, y = 0}

func readField () -> Int32 {
	return origin.x
}

func writeField () -> {} {
	origin.x = 42
}

func nestedField () -> Int32 {
	var line: Line = {a = {x = 1, y = 2}, b = {x = 3, y = 4}}
	return line.a.x
}

func fieldViaPointer (p: *Point) -> Int32 {
	return p.x
}

func writeFieldViaPointer (p: *Point) -> {} {
	p.x = 99
}

func localRecord () -> Int32 {
	var p = {x = 10, y = 20}
	return p.y
}

public func main () -> Int32 {
	var a: Int32 = readField()
	writeField()
	var b: Int32 = nestedField()
	var c: Int32 = fieldViaPointer(&origin)
	writeFieldViaPointer(&origin)
	var d: Int32 = localRecord()
	return 0
}

