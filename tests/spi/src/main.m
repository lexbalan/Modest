// examples/spi/src/main.m

module "endianess/main"

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"



var data_line: Bool

func clock_set (x: Bool) -> Unit {
	//
}

func data_set (x: Bool) -> Unit {
	data_line = x
}

func data_get () -> Bool {
	return data_line
}

func delay (x: Nat32) -> Unit {}


func spi_exchange (x: Word8, cpol: Nat8) -> Word8 {
	let clkActive = cpol == 0
	var retval = Word8 0
	var i = Nat8 7
	while true {
		data_set((x and (Word8 1 << i)) != 0)
		delay(1)
		let b = data_get()
		retval = retval or (unsafe Word8 b << i)
		clock_set(clkActive)
		delay(1)
		clock_set(not clkActive)
		if i == 0 {
			break
		}
		--i
	}
	return retval
}



public func main () -> Int {
	let x = spi_exchange(0x1D, cpol=0)
	printf("x = 0x%02x\n", x)
	return 0
}

