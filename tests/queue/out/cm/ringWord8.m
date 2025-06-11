import "queue"

import "queue" as queue



public type RingWord8 = record {
	queue: Queue
	data: *[]Word8
}


public func init (q: *RingWord8, buf: *[]Word8, capacity: Nat32) -> Unit {
	queue.init(&q.queue, capacity=capacity)
	q.data = buf
}


public func capacity (q: *RingWord8) -> Nat32 {
	return queue.capacity(&q.queue)
}


public func size (q: *RingWord8) -> Nat32 {
	return queue.size(&q.queue)
}


public func isFull (q: *RingWord8) -> Bool {
	return queue.isFull(&q.queue)
}


public func isEmpty (q: *RingWord8) -> Bool {
	return queue.isEmpty(&q.queue)
}


public func put (q: *RingWord8, b: Word8) -> Bool {
	/*
	if queue.isFull(&q.queue) {
		return false
	}
	*/

	let p: Nat32 = queue.getPutPosition(&q.queue)
	q.data[p] = b

	return true
}


public func get (q: *RingWord8, b: *Word8) -> Bool {
	if queue.isEmpty(&q.queue) {
		return false
	}

	let g: Nat32 = queue.getGetPosition(&q.queue)
	*b = q.data[g]

	return true
}

