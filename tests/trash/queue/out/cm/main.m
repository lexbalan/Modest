import "./queueWord8"
import "./ringWord8"
include "ctypes64"
include "math"
include "stdio"

import "./queueWord8" as bq
import "./ringWord8" as br


var bq0: QueueWord8
var br0: RingWord8


var ii: Int32
func fill (n: Nat32) -> Unit {
	var i: Nat32 = 0
	while i < n {
		if bq.isFull(&bq0) {
			printf("<queue is full>\n")
			break
		}

		printf("bq.put(%d)\n", ii)
		bq.put(&bq0, unsafe Word8 ii)
		i = i + 1
		ii = ii + 1
	}
}


// выгребаем и распечатываем n значений
func fetch (n: Nat32) -> Unit {
	var i: Nat32 = 0
	while i < n {
		if bq.isEmpty(&bq0) {
			printf("<queue is empty>\n")
			break
		}

		var x: Word8
		let res: Bool = bq.get(&bq0, &x)
		printf("bq.get = %d\n", Int x)
		i = i + 1
	}
}


const qsize = 10
var qbuf: [qsize]Word8


public func main () -> Int {
	bq.init(&bq0, &qbuf, qsize)

	fill(3)
	fetch(7)
	fill(12)
	fetch(7)
	fill(3)
	fetch(7)

	return 0
}

