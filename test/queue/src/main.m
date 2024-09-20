// test/pre0/src/main.cm

include "libc/ctypes64"
include "libc/ctypes"
include "libc/math"
include "libc/stdio"

import "./byteQueue128" as bq


var bq0: bq.ByteQueue128


var ii: Int32
func padd(n: Int) {
	var i = 0
	while i < n {
		if bq.isFull(&bq0) {
			printf("queue is full\n")
			break
		}

		printf("bq.put(%d)\n", ii)
		bq.put(&bq0, unsafe Byte ii)
		++i
		++ii
	}
}


// выгребаем все и печатаем в консоль
func fetch(n: Int) -> Unit {
	var i = 0
	while i < n {
		if bq.isEmpty(&bq0) {
			printf("queue is empty\n")
			break
		}

		var x: Byte
		let res = bq.get(&bq0, &x)
		printf("bq.get = %d\n", Int x)
		++i
	}
}


@nodecorate
export func main() -> Int {
	bq.init(&bq0)

	padd(3)
	fetch(7)
	padd(12)
	fetch(7)
	padd(22)
	fetch(7)

	return 0
}


