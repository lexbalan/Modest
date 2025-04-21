// libc/stdio.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "stdio.h"

include "libc/ctypes64"


@property("id.c", "FILE")
public type File Nat8

@property("id.c", "fpos_t")
public type FposT Nat8

@property("id.c", "char *")
public type CharStr Str

@property("id.c", "const char *")
public type ConstCharStr CharStr

@property("id.c", "stdin")
public var stdin: *File
@property("id.c", "stdout")
public var stdout: *File
@property("id.c", "stderr")
public var stderr: *File


@property("id.c", "EOF")
public const c_EOF = -1

@property("id.c", "SEEK_SET")
public const seekSet = 0
@property("id.c", "SEEK_CUR")
public const seekCur = 1
@property("id.c", "SEEK_END")
public const seekEnd = 2

@unused_result
public func fclose(f: *File) -> Int
public func feof(f: *File) -> Int
public func ferror(f: *File) -> Int
@unused_result
public func fflush(f: *File) -> Int
@unused_result
public func fgetpos(f: *File, pos: *FposT) -> Int

public func fopen(fname: *ConstCharStr, mode: *ConstCharStr) -> *File
@unused_result
public func fread(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> SizeT
@unused_result
public func fwrite(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> SizeT
public func freopen(fname: *ConstCharStr, mode: *ConstCharStr, f: *File) -> *File

@unused_result
public func fseek(f: *File, offset: LongInt, whence: Int) -> Int

public func fsetpos(f: *File, pos: *FposT) -> Int
public func ftell(f: *File) -> LongInt
public func remove(fname: *ConstCharStr) -> Int
public func rename(old_filename: *ConstCharStr, new_filename: *ConstCharStr) -> Int
public func rewind(f: *File) -> Unit
public func setbuf(f: *File, buf: *CharStr) -> Unit
	//func setvbuf(f: *File, buf: *[]Char, mode: Int, size: SizeT) -> Int
public func setvbuf(f: *File, buf: *CharStr, mode: Int, size: SizeT) -> Int
public func tmpfile() -> *File
public func tmpnam(str: *CharStr) -> *CharStr

	//@unused_result
@unused_result
public func printf(s: *ConstCharStr, ...) -> Int

@unused_result
public func scanf(s: *ConstCharStr, ...) -> Int

@unused_result
public func fprintf(f: *File, format: *Str, ...) -> Int

@unused_result
public func fscanf(f: *File, format: *ConstCharStr, ...) -> Int

@unused_result
public func sscanf(buf: *ConstCharStr, format: *ConstCharStr, ...) -> Int

@unused_result
public func sprintf(buf: *CharStr, format: *ConstCharStr, ...) -> Int

@unused_result
public func vfprintf(f: *File, format: *ConstCharStr, args: __VA_List) -> Int
public func vprintf(format: *ConstCharStr, args: __VA_List) -> Int
public func vsprintf(str: *CharStr, format: *ConstCharStr, args: __VA_List) -> Int
public func vsnprintf(str: *CharStr, n: SizeT, format: *ConstCharStr, args: __VA_List) -> Int
public func __vsnprintf_chk (dest:*CharStr, len:SizeT, flags:Int, dstlen:SizeT, format:*ConstCharStr, arg: __VA_List) -> Int


public func fgetc(f: *File) -> Int
public func fputc(char: Int, f: *File) -> Int

public func fgets(str: *CharStr, n: Int, f: *File) -> *CharStr
public func fputs(str: *ConstCharStr, f: *File) -> Int

public func getc(f: *File) -> Int
public func getchar() -> Int
public func gets(str: *CharStr) -> *CharStr
@unused_result
public func putc(char: Int, f: *File) -> Int
@unused_result
public func putchar(char: Int) -> Int
@unused_result
public func puts(str: *ConstCharStr) -> Int
public func ungetc(char: Int, f: *File) -> Int
public func perror(str: *ConstCharStr) -> Unit

