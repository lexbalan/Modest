// libc/stdio.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "stdio.h"

include "libc/ctypes64"

export {
	@property("type.id.c", "FILE")
	type File Nat8

	@property("type.id.c", "fpos_t")
	type FposT Nat8

	@property("type.id.c", "char *")
	type CharStr Str

	@property("type.id.c", "const char *")
	type ConstCharStr CharStr


	@property("value.id.c", "EOF")
	let c_EOF = -1

	@property("value.id.c", "SEEK_SET")
	let c_SEEK_SET = 0
	@property("value.id.c", "SEEK_CUR")
	let c_SEEK_CUR = 1
	@property("value.id.c", "SEEK_END")
	let c_SEEK_END = 2

	@attribute("value.type.to:dispensable")
	func fclose(f: *File) -> Int
	func feof(f: *File) -> Int
	func ferror(f: *File) -> Int
	@attribute("value.type.to:dispensable")
	func fflush(f: *File) -> Int
	@attribute("value.type.to:dispensable")
	func fgetpos(f: *File, pos: *FposT) -> Int

	func fopen(fname: *ConstCharStr, mode: *ConstCharStr) -> *File
	@attribute("value.type.to:dispensable")
	func fread(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> SizeT
	@attribute("value.type.to:dispensable")
	func fwrite(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> SizeT
	func freopen(fname: *ConstCharStr, mode: *ConstCharStr, f: *File) -> *File

	@attribute("value.type.to:dispensable")
	func fseek(f: *File, offset: LongInt, whence: Int) -> Int

	func fsetpos(f: *File, pos: *FposT) -> Int
	func ftell(f: *File) -> LongInt
	func remove(fname: *ConstCharStr) -> Int
	func rename(old_filename: *ConstCharStr, new_filename: *ConstCharStr) -> Int
	func rewind(f: *File) -> Unit
	func setbuf(f: *File, buf: *CharStr) -> Unit
	//func setvbuf(f: *File, buf: *[]Char, mode: Int, size: SizeT) -> Int
	func setvbuf(f: *File, buf: *CharStr, mode: Int, size: SizeT) -> Int
	func tmpfile() -> *File
	func tmpnam(str: *CharStr) -> *CharStr

	@attribute("value.type.to:dispensable")
	func printf(s: *ConstCharStr, ...) -> Int

	@attribute("value.type.to:dispensable")
	func scanf(s: *ConstCharStr, ...) -> Int

	@attribute("value.type.to:dispensable")
	func fprintf(f: *File, format: *Str, ...) -> Int

	@attribute("value.type.to:dispensable")
	func fscanf(f: *File, format: *ConstCharStr, ...) -> Int

	@attribute("value.type.to:dispensable")
	func sscanf(buf: *ConstCharStr, format: *ConstCharStr, ...) -> Int

	@attribute("value.type.to:dispensable")
	func sprintf(buf: *CharStr, format: *ConstCharStr, ...) -> Int


	func vfprintf(f: *File, format: *ConstCharStr, args: VA_List) -> Int
	func vprintf(format: *ConstCharStr, args: VA_List) -> Int
	func vsprintf(str: *CharStr, format: *ConstCharStr, args: VA_List) -> Int
	func vsnprintf(str: *CharStr, n: SizeT, format: *ConstCharStr, args: VA_List) -> Int
	func __vsnprintf_chk (dest:*CharStr, len:SizeT, flags:Int, dstlen:SizeT, format:*ConstCharStr, arg: VA_List) -> Int


	func fgetc(f: *File) -> Int
	func fputc(char: Int, f: *File) -> Int

	func fgets(str: *CharStr, n: Int, f: *File) -> *CharStr
	func fputs(str: *ConstCharStr, f: *File) -> Int

	func getc(f: *File) -> Int
	func getchar() -> Int
	func gets(str: *CharStr) -> *CharStr
	@attribute("value.type.to:dispensable")
	func putc(char: Int, f: *File) -> Int
	@attribute("value.type.to:dispensable")
	func putchar(char: Int) -> Int
	@attribute("value.type.to:dispensable")
	func puts(str: *ConstCharStr) -> Int
	func ungetc(char: Int, f: *File) -> Int
	func perror(str: *ConstCharStr) -> Unit
}

