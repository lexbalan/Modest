include "ctypes64"
include "stdio"



var fp: *File


func parseFile (filename: *Str) -> Unit {
	fp = fopen(filename, "r")

	if fp == nil {
		printf("error: cannot open file '%s'", filename)
		return
	}

	printf("file '%s' contains: ", filename)
	while true {
		let ch: Int = fgetc(fp)
		if ch == c_EOF {
			break
		}
		putchar(ch)
	}

	fclose(fp)
}


public func main () -> Int {
	parseFile("example.s")

	return 0
}

