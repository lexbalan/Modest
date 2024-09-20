import "queue"

export {
	let capacity = 128

	type ByteQueue128 record {
		queue: queue.Queue
		data: [capacity]Byte
	}


	func init(q: *ByteQueue128) -> Unit {
		queue.init(&q.queue, capacity=capacity)
		q.data = []
	}

	func getSize(q: *ByteQueue128) -> Nat32 {
		return queue.getSize(&q.queue)
	}

	func isFull(q: *ByteQueue128) -> Bool {
		return queue.isFull(&q.queue)
	}

	func isEmpty(q: *ByteQueue128) -> Bool {
		return queue.isEmpty(&q.queue)
	}

	func put(q: *ByteQueue128, b: Byte) -> Bool {
		if queue.isFull(&q.queue) {
			return false
		}

		let p = queue.putPosition(&q.queue)
		q.data[p] = b

		return true
	}

	func get(q: *ByteQueue128, b: *Byte) -> Bool {
		if queue.isEmpty(&q.queue) {
			return false
		}

		let g = queue.getPosition(&q.queue)
		*b = q.data[g]

		return true
	}
}


