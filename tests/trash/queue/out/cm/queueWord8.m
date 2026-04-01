private import "builtin"
private import "queue"

import "queue" as queue



public type QueueWord8 = {
	queue: Queue
	data: *[]Word8
}


public func init (q: *QueueWord8, buf: *[]Word8, capacity: Nat32) -> Unit {
	init(&q.queue, capacity=capacity)
	q.data = buf
}


public func capacity (q: *QueueWord8) -> Nat32 {
	return capacity(&q.queue)
}


public func size (q: *QueueWord8) -> Nat32 {
	return size(&q.queue)
}


public func isFull (q: *QueueWord8) -> Bool {
	return isFull(&q.queue)
}


public func isEmpty (q: *QueueWord8) -> Bool {
	return isEmpty(&q.queue)
}


public func put (q: *QueueWord8, b: Word8) -> Bool {
	if isFull(&q.queue) {
		return false
	}

	let p: Nat32 = getPutPosition(&q.queue)
	q.data[p] = b

	return true
}


public func get (q: *QueueWord8, b: *Word8) -> Bool {
	if isEmpty(&q.queue) {
		return false
	}

	let g: Nat32 = getGetPosition(&q.queue)
	*b = q.data[g]

	return true
}



public func read (q: *QueueWord8, data: *[]Word8, len: Nat32) -> Nat32 {
	var n: Nat32 = 0
	while n < len {
		var x: Word8
		if not get(q, &x) {
			break
		}
		data[n] = x
		n = n + 1
	}
	return n
}


public func write (q: *QueueWord8, data: *[]Word8, len: Nat32) -> Nat32 {
	var n: Nat32 = 0
	while n < len {
		let x: Word8 = data[n]
		if not put(q, x) {
			break
		}
		n = n + 1
	}
	return n
}



public func clear (q: *QueueWord8) -> Unit {
	let pdata = *[capacity(&q.queue)]Word8 q.data
	*pdata = []
}

