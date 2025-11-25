include "ctypes64"
include "string"
include "stdio"



const filename = *Str8 "file.bin"


type Chunk = record {
	id: [100]Char
	data: [1024]Char
}


func writeExample () -> Unit {
	printf("run writeExample()\n")

	let fp: *File = fopen(filename, "wb")
	if fp == nil {
		printf("error: cannot create file '%s'", filename)
		return
	}

	var chunk: Chunk = {
		id = [100]Char "id"
		data = [1024]Char "data"
	}

	// write chunk to file
	fwrite(&chunk, sizeof(Chunk), 1, fp)

	fclose(fp)
}


func readExample () -> Unit {
	printf("run readExample()\n")

	let fp: *File = fopen(filename, "rb")
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


public func main () -> Int {
	printf("binary file example\n")
	writeExample()
	readExample()
	return 0
}

