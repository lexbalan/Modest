
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
	printf("run write_example\n")

	let fp = fopen(filename, "w")

	if fp == nil {
		printf("error: cannot create file '%s'", filename)
		return
	}

	fprintf(fp, "some text.\n")

	fclose(fp)
}


func read_example() -> Unit {
	printf("run read_example\n")

	let fp = fopen(filename, "r")

	if fp == nil {
		printf("error: cannot open file '%s'", filename)
		return
	}

	printf("file '%s' contains: ", filename)
	while true {
		let ch = fgetc(fp)
		if ch == stdio.c_EOF {
			break
		}
		putchar(ch)
	}

	fclose(fp)
}


public func main() -> ctypes64.Int {
	printf("text_file example\n")
	write_example()
	read_example()
	return 0
}

