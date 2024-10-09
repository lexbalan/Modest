//module queue

include "libc/ctypes64"
include "libc/stdio"


public type Queue record {
	capacity: Nat32
	size: Nat32
	p: Nat32  // put index
	g: Nat32  // get index
}


@inlinehint
public func init(q: *Queue, capacity: Nat32) {
	*q = {}
	q.capacity = capacity
}

@inline
public func capacity(q: *Queue) -> Nat32 {
	return q.capacity
}

@inline
public func size(q: *Queue) -> Nat32 {
	return q.size
}

@inline
public func isEmpty(q: *Queue) -> Bool {
	return q.size == 0
}

@inline
public func isFull(q: *Queue) -> Bool {
	return q.size == q.capacity
}

// you must check isFull(queue) before call 'putPosition'
@inlinehint
public func putPosition(q: *Queue) -> Nat32 {
	let pos = q.p
	q.p = next(q.capacity, q.p)
	if q.size < (q.capacity - 1) {
		++q.size
	}
	return pos
}

// you must check isEmpty(queue) before call 'getPosition'
@inlinehint
public func getPosition(q: *Queue) -> Nat32 {
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


