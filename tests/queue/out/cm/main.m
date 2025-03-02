
@c_include "math.h"
@c_include "stdio.h"
import "./byteQueue128" as bq
//import "./byteRing16" as br


var bq0: byteQueue128.Queue128Word8
//var br0: br.Word8Ring16


var ii: Int32
func padd(n: ctypes64.Int) -> Unit {
	var i: Int32 = 0
	while i < n {
		if byteQueue128.isFull(&bq0) {
			stdio.printf("queue is full\n")
			break
		}

		stdio.printf("bq.put(%d)\n", ii)
		byteQueue128.put(&bq0, Word8 ii)
		i = i + 1
		ii = ii + 1
	}
}


// выгребаем все и печатаем в консоль
func fetch(n: ctypes64.Int) -> Unit {
	var i: Int32 = 0
	while i < n {
		if byteQueue128.isEmpty(&bq0) {
			stdio.printf("queue is empty\n")
			break
		}

		var x: Word8
		let res = byteQueue128.get(&bq0, &x)
		stdio.printf("bq.get = %d\n", ctypes64.Int x)
		i = i + 1
	}
}



public func main() -> ctypes64.Int {
	byteQueue128.init(&bq0)

	padd(3)
	fetch(7)
	padd(12)
	fetch(7)
	padd(3)
	fetch(7)

	return 0
}

