
include "libc/ctypes64"
include "libc/stdio"
func next(capacity: Nat32, x: Nat32) -> Nat32 {
	if x < capacity - 1 {
		return x + 1
	}
	return 0
}



export type Queue record {
	capacity: Nat32
	size: Nat32
	p: Nat32
	g: Nat32
}
export func init(q: *Queue, capacity: Nat32) -> Unit {
	*q = {}
	q.capacity = capacity
}
export func capacity(q: *Queue) -> Nat32 {
	return q.capacity
}
export func size(q: *Queue) -> Nat32 {
	return q.size
}
export func isEmpty(q: *Queue) -> Bool {
	return q.size == 0
}
export func isFull(q: *Queue) -> Bool {
	return q.size == q.capacity
}
export func putPosition(q: *Queue) -> Nat32 {
	let pos = q.p
	q.p = next(q.capacity, q.p)
	if q.size < q.capacity - 1 {
		q.size = q.size + 1
	}
	return pos
}
export func getPosition(q: *Queue) -> Nat32 {
	let pos = q.g
	q.g = next(q.capacity, q.g)
	if q.size > 0 {
		q.size = q.size - 1
	}
	return pos
}

