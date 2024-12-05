
import "queue"
public const cap = 16


public type Word8Ring16 record {
	queue: Queue
	data: [cap]Word8
}
public func init(q: *Word8Ring16) -> Unit {
	queue.init(&q.queue, capacity = cap)
	q.data = []  // right size = 16
}
public func capacity(q: *Word8Ring16) -> Nat32 {
	return queue.capacity(&q.queue)
}
public func size(q: *Word8Ring16) -> Nat32 {
	return queue.size(&q.queue)
}
public func isFull(q: *Word8Ring16) -> Bool {
	return queue.isFull(&q.queue)
}
public func isEmpty(q: *Word8Ring16) -> Bool {
	return queue.isEmpty(&q.queue)
}
public func put(q: *Word8Ring16, b: Word8) -> Bool {
	/*if queue.isFull(&q.queue) {
		return false
	}*/

	let p = queue.getPutPosition(&q.queue)
	q.data[p] = b

	return true
}
public func get(q: *Word8Ring16, b: *Word8) -> Bool {
	if queue.isEmpty(&q.queue) {
		return false
	}

	let g = queue.getGetPosition(&q.queue)
	*b = q.data[g]

	return true
}

