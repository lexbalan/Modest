
import "queue"

export type ByteQueue128 record {
	queue: Queue
	data: [128]Byte
}
export func init(q: *ByteQueue128) -> Unit {
	queue.init(&q.queue, capacity = 128)
	q.data = []  // right size = 128
}
export func capacity(q: *ByteQueue128) -> Nat32 {
	return queue.capacity(&q.queue)
}
export func size(q: *ByteQueue128) -> Nat32 {
	return queue.size(&q.queue)
}
export func isFull(q: *ByteQueue128) -> Bool {
	return queue.isFull(&q.queue)
}
export func isEmpty(q: *ByteQueue128) -> Bool {
	return queue.isEmpty(&q.queue)
}
export func put(q: *ByteQueue128, b: Byte) -> Bool {
	if queue.isFull(&q.queue) {
		return false
	}

	let p = queue.putPosition(&q.queue)
	q.data[p] = b

	return true
}
export func get(q: *ByteQueue128, b: *Byte) -> Bool {
	if queue.isEmpty(&q.queue) {
		return false
	}

	let g = queue.getPosition(&q.queue)
	*b = q.data[g]

	return true
}

