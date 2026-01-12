// examples/spi/src/main.m

module "spi/main"

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

func delay (x: Nat32) -> Unit {
	//
}


public func spi_exchange (x: Word8, cpol: Nat8, hperiod: Nat32) -> Word8 {
	let clkActive = cpol == 0
	var retval = Word8 0
	var i = Nat8 7
	while true {
		let b = (x and (Word8 1 << i)) != 0
		data_set(b)
		delay(hperiod)
		let p = data_get()
		retval = retval or (unsafe Word8 p << i)
		clock_set(clkActive)
		delay(hperiod)
		clock_set(not clkActive)
		if i == 0 {
			break
		}
		--i
	}
	return retval
}



func data_out (x: Word8) -> Unit {
	//
}

func port_write (x: Word8) -> Unit {
	data_out(x)
	delay(1)
	clock_set(true)
	delay(1)
	clock_set(false)
}


public func main () -> Int {
	let x = spi_exchange(0x1D, cpol=0, hperiod=1)
	printf("x = 0x%02x\n", x)
	return 0
}

