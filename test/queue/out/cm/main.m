
include "libc/ctypes64"
@c_include "math.h"
include "libc/math"
@c_include "stdio.h"
include "libc/stdio"
import "./byteQueue128"
import "./byteRing16"
var bq0: Word8Queue128
var br0: Word8Ring16
var ii: Int32
func padd(n: Int) -> Unit {
	var i: Int32 = 0
	while i < n {
		if byteQueue128.isFull(&bq0) {
			printf("queue is full\n")
			break
		}

		printf("bq.put(%d)\n", ii)
		byteQueue128.put(&bq0, Word8 ii)
		i = i + 1
		ii = ii + 1
	}
}
// выгребаем все и печатаем в консоль
func fetch(n: Int) -> Unit {
	var i: Int32 = 0
	while i < n {
		if byteQueue128.isEmpty(&bq0) {
			printf("queue is empty\n")
			break
		}

		var x: Word8
		let res = byteQueue128.get(&bq0, &x)
		printf("bq.get = %d\n", Int x)
		i = i + 1
	}
}
public func main() -> Int {
	byteQueue128.init(&bq0)

	padd(3)
	fetch(7)
	padd(12)
	fetch(7)
	padd(22)
	fetch(7)

	return 0
}

