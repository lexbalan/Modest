
import "queue"

public type ByteQueue128 record {
	queue: Queue
	data: [128]Byte
}
public func init(q: *ByteQueue128) -> Unit {
	queue.init(&q.queue, capacity = 128)
	q.data = []  // right size = 128
}
public func capacity(q: *ByteQueue128) -> Nat32 {
	return queue.capacity(&q.queue)
}
public func size(q: *ByteQueue128) -> Nat32 {
	return queue.size(&q.queue)
}
public func isFull(q: *ByteQueue128) -> Bool {
	return queue.isFull(&q.queue)
}
public func isEmpty(q: *ByteQueue128) -> Bool {
	return queue.isEmpty(&q.queue)
}
public func put(q: *ByteQueue128, b: Byte) -> Bool {
	if queue.isFull(&q.queue) {
		return false
	}

	let p = queue.putPosition(&q.queue)
	q.data[p] = b

	return true
}
public func get(q: *ByteQueue128, b: *Byte) -> Bool {
	if queue.isEmpty(&q.queue) {
		return false
	}

	let g = queue.getPosition(&q.queue)
	*b = q.data[g]

	return true
}

