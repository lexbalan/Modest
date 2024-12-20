
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"


public type Queue record {
	capacity: Nat32
	size: Nat32
	p: Nat32
	g: Nat32
}



public func init(q: *Queue, capacity: Nat32) -> Unit {
	*q = {}
	q.capacity = capacity
}



public func capacity(q: *Queue) -> Nat32 {
	return q.capacity
}



public func size(q: *Queue) -> Nat32 {
	return q.size
}



public func isEmpty(q: *Queue) -> Bool {
	return q.size == 0
}



public func isFull(q: *Queue) -> Bool {
	return q.size == q.capacity
}
// you must check isFull(queue) before call 'getPutPosition'

public func getPutPosition(q: *Queue) -> Nat32 {
	let pos = q.p
	q.p = next(q.capacity, q.p)
	if q.size < q.capacity - 1 {
		q.size = q.size + 1
	}
	return pos
}
// you must check isEmpty(queue) before call 'getGetPosition'

public func getGetPosition(q: *Queue) -> Nat32 {
	let pos = q.g
	q.g = next(q.capacity, q.g)
	if q.size > 0 {
		q.size = q.size - 1
	}
	return pos
}



func next(capacity: Nat32, x: Nat32) -> Nat32 {
	if x < capacity - 1 {
		return x + 1
	}
	return 0
}

