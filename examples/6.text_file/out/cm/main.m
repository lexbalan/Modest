
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"
@c_include "time.h"
@c_include "unistd.h"
@c_include "math.h"

//include "libc/ctypes64"
//include "libc/stdio"


const filename = *Str8 "file.txt"


func write_example() -> Unit {
	stdio.("run write_example\n")

	let fp = stdio.(filename, "w")

	if fp == nil {
		stdio.("error: cannot create file '%s'", filename)
		return
	}

	stdio.(fp, "some text.\n")

	stdio.(fp)
}


func read_example() -> Unit {
	stdio.("run read_example\n")

	let fp = stdio.(filename, "r")

	if fp == nil {
		stdio.("error: cannot open file '%s'", filename)
		return
	}

	stdio.("file '%s' contains: ", filename)
	while true {
		let ch = stdio.(fp)
		if ch == stdio. {
			break
		}
		stdio.(ch)
	}

	stdio.(fp)
}


public func main() -> Int {
	stdio.("text_file example\n")
	write_example()
	read_example()
	return 0
}

