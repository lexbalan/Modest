// test: while statement

func sum (n: Int32) -> Int32 {
	var s: Int32 = 0
	var i: Int32 = 0
	while i < n {
		s = s + i
		i = i + 1
	}
	return s
}

func countDown (n: Int32) -> Int32 {
	var x = n
	while x > 0 {
		x = x - 1
	}
	return x
}

func factorial (n: Int32) -> Int32 {
	var result: Int32 = 1
	var i: Int32 = 1
	while i <= n {
		result = result * i
		i = i + 1
	}
	return result
}

func nestedWhile () -> Int32 {
	var sum: Int32 = 0
	var i: Int32 = 0
	while i < 3 {
		var j: Int32 = 0
		while j < 3 {
			sum = sum + 1
			j = j + 1
		}
		i = i + 1
	}
	return sum
}

public func main () -> Int32 {
	var a = sum(10)
	var b = countDown(5)
	var c = factorial(5)
	var d = nestedWhile()
	return 0
}
