import "./byteQueue"
import "./byteRing"
include "ctypes64"
include "math"
include "stdio"

import "./byteQueue" as bq
import "./byteRing" as br


var bq0: QueueWord8
var br0: RingWord8


var ii: Int32
func padd(n: Int) -> Unit {
	var i: Int32 = 0
	while i < n {
		if bq.isFull(&bq0) {
			printf("<queue is full>\n")
			break
		}

		printf("bq.put(%d)\n", ii)
		bq.put(&bq0, Word8 ii)
		i = i + 1
		ii = ii + 1
	}
}
func fetch(n: Int) -> Unit {
	var i: Int32 = 0
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


public func main() -> Int {
	bq.init(&bq0, &qbuf, qsize)

	padd(3)
	fetch(7)
	padd(12)
	fetch(7)
	padd(3)
	fetch(7)

	return 0
}

