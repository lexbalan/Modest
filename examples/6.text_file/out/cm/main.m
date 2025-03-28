include "libc"


//include "libc/ctypes64"
//include "libc/stdio"


const filename = *Str8 "file.txt"


func write_example() -> Unit {
	stdio.printf("run write_example\n")

	let fp = stdio.fopen(filename, "w")

	if fp == nil {
		stdio.printf("error: cannot create file '%s'", filename)
		return
	}

	stdio.fprintf(fp, "some text.\n")

	stdio.fclose(fp)
}


func read_example() -> Unit {
	stdio.printf("run read_example\n")

	let fp = stdio.fopen(filename, "r")

	if fp == nil {
		stdio.printf("error: cannot open file '%s'", filename)
		return
	}

	stdio.printf("file '%s' contains: ", filename)
	while true {
		let ch = stdio.fgetc(fp)
		if ch == stdio.c_EOF {
			break
		}
		stdio.putchar(ch)
	}

	stdio.fclose(fp)
}


public func main() -> Int {
	stdio.printf("text_file example\n")
	write_example()
	read_example()
	return 0
}

