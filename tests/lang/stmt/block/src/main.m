// tests/lang/stmt/block/src/main.m

func testIfScope () -> Int32 {
	var x: Int32 = 1
	if true {
		var y: Int32 = 2
		x = x + y
	}
	return x
}

func testNestedIfScope () -> Int32 {
	var result: Int32 = 0
	if true {
		var a: Int32 = 1
		if true {
			var b: Int32 = 2
			if true {
				var c: Int32 = 3
				result = a + b + c
			}
		}
	}
	return result
}

func testWhileScope () -> Int32 {
	var sum: Int32 = 0
	var i: Int32 = 0
	while i < 3 {
		var temp: Int32 = i * 2
		sum = sum + temp
		i = i + 1
	}
	return sum
}

func main () -> Int32 {
	var a = testIfScope()
	var b = testNestedIfScope()
	var c = testWhileScope()
	return 0
}
