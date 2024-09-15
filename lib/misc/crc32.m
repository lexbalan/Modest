// crc32.m

$pragma do_not_include

//include "libc/ctypes64"
//include "libc/ctypes"
//include "libc/stdio"

/*
  Name  : CRC-32
  Poly  : 0x04C11DB7    xxor32 + xxor26 + xxor23 + xxor22 + xxor16 + xxor12 + xxor11
                       + xxor10 + xxor8 + xxor7 + xxor5 + xxor4 + xxor2 + x + 1
  Init  : 0xFFFFFFFF
  Revert: true
  XorOut: 0xFFFFFFFF
  Check : 0xCBF43926 ("123456789")
  MaxLen: 268 435 455 байт (2 147 483 647 бит) - обнаружение
   одинарных, двойных, пакетных и всех нечетных ошибок
*/
export func doHash(buf: *[]Byte, len: Nat32) -> Nat32 {
	let tableSize = 256
	var crc_table: [tableSize]Nat32
	var crc: Nat32

	//
	// create table before
	//

	var i = Nat32 0
	while i < tableSize {
		crc = i
		var j = Nat32 0
		while j < 8 {
			if (crc and 1) != 0 {
				crc = (crc >> 1) xor 0xEDB88320
			} else {
				crc = crc >> 1
			}

			++j
		}
		crc_table[i] = crc
		++i
    }

	//
	// calculate CRC32
	//

    crc = 0xFFFFFFFF

	i = 0
	while i < len {
		let yy = (crc xor Nat32 buf[i]) and 0xFF
		crc = crc_table[yy] xor (crc >> 8)
		++i
	}

	return crc xor 0xFFFFFFFF
}

