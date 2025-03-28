include "ctypes64"
include "string"
include "stdio"



// FIXIT: not worked LLVM result (!)

const filename = *Str8 "file.bin"


// chunk of data for read/write operations in file
type Chunk record {
	id: [100]Char
	data: [1024]Char
}


func write_example() -> Unit {
	stdio.printf("run write_example\n")

	let fp = stdio.fopen(filename, "wb")

	if fp == nil {
		stdio.printf("error: cannot create file '%s'", filename)
		return
	}

	var chunk: Chunk

	// pointers casting requires -funsafe translator option
	// (see Makefile)
	string.strcpy(&chunk.id, *[]Char "id")
	string.strcpy(&chunk.data, *[]Char "data")

	// write chunk to file
	stdio.fwrite(&chunk, sizeof(Chunk), 1, fp)

	stdio.fclose(fp)
}


func read_example() -> Unit {
	stdio.printf("run read_example\n")

	let fp = stdio.fopen(filename, "rb")

	if fp == nil {
		stdio.printf("error: cannot open file '%s'", filename)
		return
	}

	var chunk: Chunk
	stdio.fread(&chunk, sizeof(Chunk), 1, fp)

	stdio.printf("file \"%s\" contains:\n", filename)
	stdio.printf("chunk.id: \"%s\"\n", &chunk.id)
	stdio.printf("chunk.data: \"%s\"\n", &chunk.data)

	stdio.fclose(fp)
}


public func main() -> Int {
	stdio.printf("binary file example\n")
	write_example()
	read_example()
	return 0
}

