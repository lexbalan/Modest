// test/pre0/src/main.cm

include "console"
include "inttypes"

import "queue"


var q0: queue.Queue


// выгребаем все и печатаем в консоль
func fetch(n: Int) -> Unit {
	var i = 0
	while i < 7 {
		if queue.isEmpty(&q0) {
			printf("queue is empty\n")
			break
		}

		let x = queue.get(&q0)
		printf("x = %d\n", Int x)
		++i
	}
}

// test

@nodecorate
export func main() -> Int {
	init()


	queue.init(&q0)

	queue.put(&q0, 10)
	queue.put(&q0, 20)
	queue.put(&q0, 30)
	queue.put(&q0, 40)
	queue.put(&q0, 50)

	fetch(7)

	queue.put(&q0, 40)
	queue.put(&q0, 50)
	queue.put(&q0, 60)
	queue.put(&q0, 70)
	queue.put(&q0, 80)

	fetch(7)

	queue.put(&q0, 11)
	queue.put(&q0, 12)
	queue.put(&q0, 13)
	queue.put(&q0, 14)
	queue.put(&q0, 15)

	fetch(7)

	return 0
}


func init() {
	printf("init!\n")
}


