// libc/stdio.hm

pragma do_not_include
pragma c_no_print

// TODO: как он их печатает без префикса если нет module_no_decorate?
// тут какая то лажа

pragma c_include "stdio.h"


include "./ctypes64"


public type Opaque *Nat8

@set("id.c", "FILE")
public type File Opaque

@set("id.c", "fpos_t")
public type FposT Opaque

@set("id.c", "char *")
public type CharStr Str

@set("id.c", "const char *")
public type ConstCharStr CharStr


// TODO:
// @stdin = external global ptr, align 8
public extern const stdin: *File
public extern const stdout: *File
public extern const stderr: *File


@set("id.c", "EOF")
public const c_EOF = -1

@set("id.c", "SEEK_SET")
public const seekSet = 0
@set("id.c", "SEEK_CUR")
public const seekCur = 1
@set("id.c", "SEEK_END")
public const seekEnd = 2

public func fclose(f: *File) -> @unused Int
public func feof(f: *File) -> Int
public func ferror(f: *File) -> Int
public func fflush(f: *File) -> @unused Int
public func fgetpos(f: *File, pos: *FposT) -> @unused Int
public func fopen(fname: *ConstCharStr, mode: *ConstCharStr) -> *File
public func fread(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> @unused SizeT
public func fwrite(buf: Ptr, size: SizeT, count: SizeT, f: *File) -> @unused SizeT
public func freopen(filename: *ConstCharStr, mode: *ConstCharStr, f: *File) -> *File
public func fseek(stream: *File, offset: LongInt, whence: Int) -> @unused Int

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


public func printf(s: *ConstCharStr, ...) -> @unused Int
public func scanf(s: *ConstCharStr, ...) -> @unused Int
public func fprintf(stream: *File, format: *Str, ...) -> @unused Int
public func fscanf(f: *File, format: *ConstCharStr, ...) -> @unused Int
public func sscanf(buf: *ConstCharStr, format: *ConstCharStr, ...) -> @unused Int
public func sprintf(buf: *CharStr, format: *ConstCharStr, ...) -> @unused Int


public func vfprintf(f: *File, format: *ConstCharStr, args: __VA_List) -> Int
public func vprintf(format: *ConstCharStr, args: __VA_List) -> Int
public func vsprintf(str: *CharStr, format: *ConstCharStr, args: __VA_List) -> Int
public func vsnprintf(str: *CharStr, n: SizeT, format: *ConstCharStr, args: __VA_List) -> Int
public func __vsnprintf_chk (dest:*CharStr, len:SizeT, flags:Int, dstlen:SizeT, format:*ConstCharStr, arg: __VA_List) -> Int


public func fgetc(f: *File) -> Int
public func fputc(char: Int, f: *File) -> Int

public func fgets(str: *CharStr, n: Int, f: *File) -> *CharStr
public func fputs(str: *ConstCharStr, f: *File) -> @unused Int

public func getc(f: *File) -> Int
public func getchar() -> Int
public func gets(str: *CharStr) -> *CharStr
public func putc(char: Int, f: *File) -> @unused Int
public func putchar(char: Int) -> @unused Int
public func puts(str: *ConstCharStr) -> @unused Int
public func ungetc(char: Int, f: *File) -> Int
public func perror(str: *ConstCharStr) -> Unit


