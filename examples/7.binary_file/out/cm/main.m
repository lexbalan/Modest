
include "libc/ctypes64"
@c_include "string.h"
include "libc/string"
@c_include "stdio.h"
include "libc/stdio"
type Chunk record {
	id: [100]Char
	data: [1024]Char
}
const filename = *Str8 "file.bin"
func write_example() -> Unit {
	printf("run write_example\n")

	let fp = fopen(filename, "wb")

	if fp == nil {
		printf("error: cannot create file '%s'", filename)
		return
	}

	var chunk: Chunk

	// pointers casting requires -funsafe translator option
	// (see Makefile)
	strcpy(&chunk.id, *[]Char "id")
	strcpy(&chunk.data, *[]Char "data")

	// write chunk to file
	fwrite(&chunk, sizeof(Chunk), 1, fp)

	fclose(fp)
}
func read_example() -> Unit {
	printf("run read_example\n")

	let fp = fopen(filename, "rb")

	if fp == nil {
		printf("error: cannot open file '%s'", filename)
		return
	}

	var chunk: Chunk
	fread(&chunk, sizeof(Chunk), 1, fp)

	printf("file \"%s\" contains:\n", filename)
	printf("chunk.id: \"%s\"\n", &chunk.id)
	printf("chunk.data: \"%s\"\n", &chunk.data)

	fclose(fp)
}
public func main() -> Int {
	printf("binary file example\n")
	write_example()
	read_example()
	return 0
}
