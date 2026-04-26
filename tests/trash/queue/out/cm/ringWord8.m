private import "builtin"
private import "queue"

import "queue" as queue



public type RingWord8 = {
	queue: Queue
	data: *[]Word8
}


public func init (q: *RingWord8, buf: *[]Word8, capacity: Nat32) -> Unit {
	init(&q.queue, capacity=capacity)
	q.data = buf
}


public func capacity (q: *RingWord8) -> Nat32 {
	return capacity(&q.queue)
}


public func size (q: *RingWord8) -> Nat32 {
	return size(&q.queue)
}


public func isFull (q: *RingWord8) -> Bool {
	return isFull(&q.queue)
}


public func isEmpty (q: *RingWord8) -> Bool {
	return isEmpty(&q.queue)
}


public func put (q: *RingWord8, b: Word8) -> @unused Bool {

	let p: Nat32 = getPutPosition(&q.queue)
	q.data[p] = b

	return true
}


public func get (q: *RingWord8, b: *Word8) -> @unused Bool {
	if isEmpty(&q.queue) {
		return false
	}

	let g: Nat32 = getGetPosition(&q.queue)
	*b = q.data[g]

	return true
}

