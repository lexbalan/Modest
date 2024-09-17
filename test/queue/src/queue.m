
include "libc/ctypes64"
include "libc/ctypes"
include "libc/stdio"


// (!) реально полезный размер такой очереди bufVolume - 1
// это следствие того что q.g != q.p (!)

// BUG: Queue зависит от bufVolume но он
export let bufVolume = 4

export type Queue record {
	data: [bufVolume]Byte
	p: Int32  // put index
	g: Int32  // get index
	@private size: Nat32
}


export func init(q: *Queue) {
	q.data = []
	q.size = 0
	q.p = 0
	q.g = 0
}

@inline
export func getSize(q: *Queue) -> Nat32 {
	return q.size
}

@inline
export func isEmpty(q: *Queue) -> Bool {
	return q.size == 0
}

@inline
export func isFull(q: *Queue) -> Bool {
	return q.size == bufVolume
}


export func put(q: *Queue, b: Byte) -> Bool {
	if isFull(q) {
		return false
	}

	q.data[q.p] = b
	q.p = next(q.p)
	++q.size
	return true
}


// you need check isEmpty(&queue) before call 'get'
export func get(q: *Queue) -> Byte {
	if isEmpty(q) {
		return 0
	}

	let x = q.data[q.g]
	q.g = next(q.g)
	--q.size
	return x
}


@inline
func next(x: Int32) -> Int32 {
	if x < bufVolume - 1 {
		return x + 1
	}
	return 0
}


