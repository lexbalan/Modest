
@c_include "string.h"
@c_include "stdio.h"


// FIXIT: not worked LLVM result (!)

const filename = *Str8 "file.bin"


// chunk of data for read/write operations in file
type Chunk record {
	id: [<str_value>]Char
	data: [<str_value>]Char
}


func write_example() -> Unit {
	stdio.("run write_example\n")

	let fp = stdio.(filename, "wb")

	if fp == nil {
		stdio.("error: cannot create file '%s'", filename)
		return
	}

	var chunk: Chunk

	// pointers casting requires -funsafe translator option
	// (see Makefile)
	string.(&(chunk.id), *[]Char "id")
	string.(&(chunk.data), *[]Char "data")

	// write chunk to file
	stdio.(&chunk, sizeof(Chunk), 1, fp)

	stdio.(fp)
}


func read_example() -> Unit {
	stdio.("run read_example\n")

	let fp = stdio.(filename, "rb")

	if fp == nil {
		stdio.("error: cannot open file '%s'", filename)
		return
	}

	var chunk: Chunk
	stdio.(&chunk, sizeof(Chunk), 1, fp)

	stdio.("file \"%s\" contains:\n", filename)
	stdio.("chunk.id: \"%s\"\n", &(chunk.id))
	stdio.("chunk.data: \"%s\"\n", &(chunk.data))

	stdio.(fp)
}


public func main() -> Int {
	stdio.("binary file example\n")
	write_example()
	read_example()
	return 0
}

