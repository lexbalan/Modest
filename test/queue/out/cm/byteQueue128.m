
import "queue" as queue


public const cap = 16


public type Queue128Word8 record {
	queue: queue.Queue
	data: [cap]Word8
}


public func init(q: *Queue128Word8) -> Unit {
	queue.init(&(q.queue), capacity = cap)
	q.data = []
}


public func capacity(q: *Queue128Word8) -> Nat32 {
	return queue.capacity(&(q.queue))
}


public func size(q: *Queue128Word8) -> Nat32 {
	return queue.size(&(q.queue))
}


public func isFull(q: *Queue128Word8) -> Bool {
	return queue.isFull(&(q.queue))
}


public func isEmpty(q: *Queue128Word8) -> Bool {
	return queue.isEmpty(&(q.queue))
}


public func put(q: *Queue128Word8, b: Word8) -> Bool {
	if queue.isFull(&(q.queue)) {
		return false
	}

	let p = queue.getPutPosition(&(q.queue))
	q.data[p] = b

	return true
}


public func get(q: *Queue128Word8, b: *Word8) -> Bool {
	if queue.isEmpty(&(q.queue)) {
		return false
	}

	let g = queue.getGetPosition(&(q.queue))
	*b = q.data[g]

	return true
}

