// test/pre0/src/main.cm

include "console"
include "inttypes"

import "queue"


var q0: queue.Queue

var ii: Int32
func padd(n: Int) {
	var i = 0
	while i < n {
		if queue.isFull(&q0) {
			printf("queue is full\n")
			break
		}

		printf("queue.put(%d)\n", Int ii)
		queue.put(&q0, unsafe Byte ii)
		++i
		++ii
	}
}


// выгребаем все и печатаем в консоль
func fetch(n: Int) -> Unit {
	var i = 0
	while i < n {
		if queue.isEmpty(&q0) {
			printf("queue is empty\n")
			break
		}

		let x = queue.get(&q0)
		printf("queue.get = %d\n", Int x)
		++i
	}
}

// test

@nodecorate
export func main() -> Int {
	init()

	queue.init(&q0)

	padd(3)

	fetch(7)

	padd(12)

	fetch(7)

	padd(22)

	fetch(7)

	return 0
}


func init() {
	printf("init!\n")
}


