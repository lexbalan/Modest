
include "libc/ctypes64"
include "libc/math"
include "libc/stdio"
import "./byteQueue128"
var bq0: ByteQueue128
var ii: Int32
func padd(n: Int) -> Unit {
	var i: Int32 = 0
	while i < n {
		if byteQueue128.isFull(&bq0) {
			printf("queue is full\n")
			break
		}

		printf("bq.put(%d)\n", ii)
		byteQueue128.put(&bq0, Byte ii)
		i = i + 1
		ii = ii + 1
	}
}
func fetch(n: Int) -> Unit {
	var i: Int32 = 0
	while i < n {
		if byteQueue128.isEmpty(&bq0) {
			printf("queue is empty\n")
			break
		}

		var x: Byte
		let res = byteQueue128.get(&bq0, &x)
		printf("bq.get = %d\n", Int x)
		i = i + 1
	}
}
public public func main() -> Int {
	byteQueue128.init(&bq0)

	padd(3)
	fetch(7)
	padd(12)
	fetch(7)
	padd(22)
	fetch(7)

	return 0
}

