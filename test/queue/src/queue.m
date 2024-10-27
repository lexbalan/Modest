//module queue

include "libc/ctypes64"
include "libc/stdio"


public type Queue record {
	capacity: Nat32  // Number of items queue can hold up
	size: Nat32      // Number of items in queue now
	p: Nat32         // put index
	g: Nat32         // get index
}


@inlinehint
public func init(q: *Queue, capacity: Nat32) {
	*q = {}
	q.capacity = capacity
}


@inlinehint
public func capacity(q: *Queue) -> Nat32 {
	return q.capacity
}


@inlinehint
public func size(q: *Queue) -> Nat32 {
	return q.size
}


@inlinehint
public func isEmpty(q: *Queue) -> Bool {
	return q.size == 0
}


@inlinehint
public func isFull(q: *Queue) -> Bool {
	return q.size == q.capacity
}


// you must check isFull(queue) before call 'getPutPosition'
@inlinehint
public func getPutPosition(q: *Queue) -> Nat32 {
	let pos = q.p
	q.p = next(q.capacity, q.p)
	if q.size < (q.capacity - 1) {
		++q.size
	}
	return pos
}


// you must check isEmpty(queue) before call 'getGetPosition'
@inlinehint
public func getGetPosition(q: *Queue) -> Nat32 {
	let pos = q.g
	q.g = next(q.capacity, q.g)
	if q.size > 0 {
		--q.size
	}
	return pos
}


@inline
func next(capacity: Nat32, x: Nat32) -> Nat32 {
	if x < capacity - 1 {
		return x + 1
	}
	return 0
}


