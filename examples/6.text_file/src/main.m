// examples/6.text_file/main.cm

//include "libc/ctypes64"
//include "libc/stdio"
include "libc/libc"


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
		if ch == c_EOF {
			break
		}
		putchar(ch)
	}

	fclose(fp)
}


public func main() -> Int {
	printf("text_file example\n")
	write_example()
	read_example()
	return 0
}
