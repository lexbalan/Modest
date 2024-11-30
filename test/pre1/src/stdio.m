// libc/stdio.hm

$pragma do_not_include
$pragma c_no_print

// TODO: как он их печатает без префикса если нет module_no_decorate?
// тут какая то лажа

$pragma c_include "stdio.h"


include "./ctypes64"


public type Opaque *Nat8

@property("type.id.c", "FILE")
public type File Opaque

@property("type.id.c", "fpos_t")
public type FposT Opaque

@property("type.id.c", "char *")
public type CharStr Str

@property("type.id.c", "const char *")
public type ConstCharStr CharStr


@property("value.id.c", "EOF")
public const c_EOF = -1

@property("value.id.c", "SEEK_SET")
public const c_SEEK_SET = 0
@property("value.id.c", "SEEK_CUR")
public const c_SEEK_CUR = 1
@property("value.id.c", "SEEK_END")
public const c_SEEK_END = 2

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
public func freopen(filename: *ConstCharStr, mode: *ConstCharStr, f: *File) -> *File

@unused_result
public func fseek(stream: *File, offset: LongInt, whence: Int) -> Int

public func fsetpos(f: *File, pos: *FposT) -> Int
public func ftell(f: *File) -> LongInt
public func remove(filename: *ConstCharStr) -> Int
public func rename(old_filename: *ConstCharStr, new_filename: *ConstCharStr) -> Int
public func rewind(f: *File) -> Unit
public func setbuf(f: *File, buffer: *CharStr) -> Unit
//int setvbuf(FILE *stream, char *buffer, int mode, size_t size)
public func setvbuf(f: *File, buffer: *CharStr, mode: Int, size: SizeT) -> Int
public func tmpfile() -> *File
public func tmpnam(str: *CharStr) -> *CharStr


@unused_result
public func printf(s: *ConstCharStr, ...) -> Int

@unused_result
public func scanf(s: *ConstCharStr, ...) -> Int

@unused_result
public func fprintf(stream: *File, format: *Str, ...) -> Int

@unused_result
public func fscanf(f: *File, format: *ConstCharStr, ...) -> Int

@unused_result
public func sscanf(buf: *ConstCharStr, format: *ConstCharStr, ...) -> Int

@unused_result
public func sprintf(buf: *CharStr, format: *ConstCharStr, ...) -> Int


public func vfprintf(f: *File, format: *ConstCharStr, args: VA_List) -> Int
public func vprintf(format: *ConstCharStr, args: VA_List) -> Int
public func vsprintf(str: *CharStr, format: *ConstCharStr, args: VA_List) -> Int
public func vsnprintf(str: *CharStr, n: SizeT, format: *ConstCharStr, args: VA_List) -> Int
public func __vsnprintf_chk (dest:*CharStr, len:SizeT, flags:Int, dstlen:SizeT, format:*ConstCharStr, arg: VA_List) -> Int


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


