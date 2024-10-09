// module: sub.m
//

public const name = "sub"

public type MyInt Int64


public func add(a: Int32, b: Int32) -> Int32 {
	return a + b
}


public func sub(a: Int32, b: Int32) -> Int32 {
	return a - b
}

@inline
public func mid(a: Int32, b: Int32) -> Int32 {
	return (a + b) / 2
}

