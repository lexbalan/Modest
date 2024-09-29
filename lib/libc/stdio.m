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

	@unused_result
	func fclose(f: *File) -> Int
	func feof(f: *File) -> Int
	func ferror(f: *File) -> Int
	@unused_result
	func fflush(f: *File) -> Int
	@unused_result
	func fgetpos(f: *File, pos: *FposT) -> Int

	func fopen(fname: *ConstCharStr, mode: *ConstCharStr) -> *File
	@unused_result
	func fread(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> SizeT
	@unused_result
	func fwrite(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> SizeT
	func freopen(fname: *ConstCharStr, mode: *ConstCharStr, f: *File) -> *File

	@unused_result
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

	//@unused_result
	@unused_result
	func printf(s: *ConstCharStr, ...) -> Int

	@unused_result
	func scanf(s: *ConstCharStr, ...) -> Int

	@unused_result
	func fprintf(f: *File, format: *Str, ...) -> Int

	@unused_result
	func fscanf(f: *File, format: *ConstCharStr, ...) -> Int

	@unused_result
	func sscanf(buf: *ConstCharStr, format: *ConstCharStr, ...) -> Int

	@unused_result
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
	@unused_result
	func putc(char: Int, f: *File) -> Int
	@unused_result
	func putchar(char: Int) -> Int
	@unused_result
	func puts(str: *ConstCharStr) -> Int
	func ungetc(char: Int, f: *File) -> Int
	func perror(str: *ConstCharStr) -> Unit
}

