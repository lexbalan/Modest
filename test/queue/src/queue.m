
//module queue

include "libc/ctypes64"
include "libc/ctypes"
include "libc/stdio"

export {
	let bufVolume = 4

	type Queue record {
		capacity: Nat32
		size: Nat32
		p: Nat32  // put index
		g: Nat32  // get index
	}


	func init(q: *Queue, capacity: Nat32) {
		*q = {}
		q.capacity = capacity
	}

	@inline
	func getSize(q: *Queue) -> Nat32 {
		return q.size
	}

	@inline
	func isEmpty(q: *Queue) -> Bool {
		return q.size == 0
	}

	@inline
	func isFull(q: *Queue) -> Bool {
		return q.size == bufVolume
	}


	// you must check isFull(queue) before call 'putPosition'
	func putPosition(q: *Queue) -> Nat32 {
		let pos = q.p
		q.p = next(q.capacity, q.p)
		++q.size
		return pos
	}


	// you must check isEmpty(queue) before call 'getPosition'
	func getPosition(q: *Queue) -> Nat32 {
		let pos = q.g
		q.g = next(q.capacity, q.g)
		--q.size
		return pos
	}
}


@inline
func next(capacity: Nat32, x: Nat32) -> Nat32 {
	if x < bufVolume - 1 {
		return x + 1
	}
	return 0
}


