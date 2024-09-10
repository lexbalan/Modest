// libc/stdio.hm

$pragma do_not_include
$pragma c_include "stdio.h"

include "libc/ctypes64"
include "libc/ctypes"


@property("type.id.c", "FILE")
export type File Unit

@property("type.id.c", "fpos_t")
export type FposT Unit

@property("type.id.c", "char *")
export type CharStr Str

@property("type.id.c", "const char *")
export type ConstCharStr CharStr


@property("value.id.c", "EOF")
export let c_EOF = -1

@property("value.id.c", "SEEK_SET")
export let c_SEEK_SET = 0
@property("value.id.c", "SEEK_CUR")
export let c_SEEK_CUR = 1
@property("value.id.c", "SEEK_END")
export let c_SEEK_END = 2


@attribute("value.type.to:dispensable")
export func fclose(f: *File) -> Int
export func feof(f: *File) -> Int
export func ferror(f: *File) -> Int
@attribute("value.type.to:dispensable")
export func fflush(f: *File) -> Int
@attribute("value.type.to:dispensable")
export func fgetpos(f: *File, pos: *FposT) -> Int
export func fopen(fname: *ConstCharStr, mode: *ConstCharStr) -> *File
@attribute("value.type.to:dispensable")
export func fread(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> SizeT
@attribute("value.type.to:dispensable")
export func fwrite(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> SizeT
export func freopen(filename: *ConstCharStr, mode: *ConstCharStr, f: *File) -> *File

@attribute("value.type.to:dispensable")
export func fseek(stream: *File, offset: LongInt, whence: Int) -> Int

export func fsetpos(f: *File, pos: *FposT) -> Int
export func ftell(f: *File) -> LongInt
export func remove(filename: *ConstCharStr) -> Int
export func rename(old_filename: *ConstCharStr, new_filename: *ConstCharStr) -> Int
export func rewind(f: *File) -> Unit
export func setbuf(f: *File, buffer: *CharStr) -> Unit
//int setvbuf(FILE *stream, char *buffer, int mode, size_t size)
export func setvbuf(f: *File, buffer: *CharStr, mode: Int, size: SizeT) -> Int
export func tmpfile() -> *File
export func tmpnam(str: *CharStr) -> *CharStr


@nodecorate
@attribute("value.type.to:dispensable")
export func printf(s: *ConstCharStr, ...) -> Int

@attribute("value.type.to:dispensable")
export func scanf(s: *ConstCharStr, ...) -> Int

@attribute("value.type.to:dispensable")
export func fprintf(stream: *File, format: *Str, ...) -> Int

@attribute("value.type.to:dispensable")
export func fscanf(f: *File, format: *ConstCharStr, ...) -> Int

@attribute("value.type.to:dispensable")
export func sscanf(buf: *ConstCharStr, format: *ConstCharStr, ...) -> Int

@attribute("value.type.to:dispensable")
export func sprintf(buf: *CharStr, format: *ConstCharStr, ...) -> Int


export func vfprintf(f: *File, format: *ConstCharStr, args: VA_List) -> Int
export func vprintf(format: *ConstCharStr, args: VA_List) -> Int
export func vsprintf(str: *CharStr, format: *ConstCharStr, args: VA_List) -> Int
export func vsnprintf(str: *CharStr, n: SizeT, format: *ConstCharStr, args: VA_List) -> Int
export func __vsnprintf_chk (dest:*CharStr, len:SizeT, flags:Int, dstlen:SizeT, format:*ConstCharStr, arg: VA_List) -> Int


export func fgetc(f: *File) -> Int
export func fputc(char: Int, f: *File) -> Int

export func fgets(str: *CharStr, n: Int, f: *File) -> *CharStr
export func fputs(str: *ConstCharStr, f: *File) -> Int

export func getc(f: *File) -> Int
export func getchar() -> Int
export func gets(str: *CharStr) -> *CharStr
@attribute("value.type.to:dispensable")
export func putc(char: Int, f: *File) -> Int
@attribute("value.type.to:dispensable")
export func putchar(char: Int) -> Int
@attribute("value.type.to:dispensable")
export func puts(str: *ConstCharStr) -> Int
export func ungetc(char: Int, f: *File) -> Int
export func perror(str: *ConstCharStr) -> Unit


