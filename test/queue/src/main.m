// test/pre0/src/main.m

include "libc/ctypes64"
include "libc/math"
include "libc/stdio"

import "./byteQueue128" as bq
import "./byteRing16" as br


var bq0: bq.Word8Queue128
var br0: br.Word8Ring16


var ii: Int32
func padd(n: Int) {
	var i = 0
	while i < n {
		if bq.isFull(&bq0) {
			printf("queue is full\n")
			break
		}

		printf("bq.put(%d)\n", ii)
		bq.put(&bq0, unsafe Word8 ii)
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

		var x: Word8
		let res = bq.get(&bq0, &x)
		printf("bq.get = %d\n", Int x)
		++i
	}
}


@nodecorate
public func main() -> Int {
	bq.init(&bq0)

	padd(3)
	fetch(7)
	padd(12)
	fetch(7)
	padd(22)
	fetch(7)

	return 0
}


