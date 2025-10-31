// libc/stdio.m

pragma do_not_include
pragma module_nodecorate
pragma c_include "stdio.h"

include "libc/ctypes64"


@calias("FILE")
public type File = record {}

@calias("fpos_t")
public type FposT = Nat8

@calias("char *")
public type CharStr = Str

@calias("const char *")
public type ConstCharStr = CharStr

@calias("stdin")
public const stdin: *File
@calias("stdout")
public const stdout: *File
@calias("stderr")
public const stderr: *File


@calias("EOF")
public const c_EOF = -1

@calias("SEEK_SET")
public const c_SEEK_SET = 0
@calias("SEEK_CUR")
public const c_SEEK_CUR = 1
@calias("SEEK_END")
public const c_SEEK_END = 2


public func fclose (f: *File) -> @unused Int
public func feof (f: *File) -> Int
public func ferror (f: *File) -> Int
public func fflush (f: *File) -> @unused Int
public func fgetpos (f: *File, pos: *FposT) -> @unused Int

public func fopen (fname: *ConstCharStr, mode: *ConstCharStr) -> *File
public func fread (buf: Ptr, size: SizeT, count: SizeT, f: *File) -> @unused SizeT
public func fwrite (buf: Ptr, size: SizeT, count: SizeT, f: *File) -> @unused SizeT
public func freopen (fname: *ConstCharStr, mode: *ConstCharStr, f: *File) -> *File

public func fseek (f: *File, offset: LongInt, whence: Int) -> @unused Int

public func fsetpos (f: *File, pos: *FposT) -> Int
public func ftell (f: *File) -> LongInt
public func remove (fname: *ConstCharStr) -> Int
public func rename (old_filename: *ConstCharStr, new_filename: *ConstCharStr) -> Int
public func rewind (f: *File) -> Unit
public func setbuf (f: *File, buf: *CharStr) -> Unit
//func setvbuf (f: *File, buf: *[]Char, mode: Int, size: SizeT) -> Int
public func setvbuf (f: *File, buf: *CharStr, mode: Int, size: SizeT) -> Int
public func tmpfile () -> *File
public func tmpnam (str: *CharStr) -> *CharStr

public func printf (str: *ConstCharStr, ...) -> @unused Int
public func scanf (str: *ConstCharStr, ...) -> @unused Int
public func fprintf (f: *File, format: *Str, ...) -> @unused Int
public func fscanf (f: *File, format: *ConstCharStr, ...) -> @unused Int
public func sscanf (buf: *ConstCharStr, format: *ConstCharStr, ...) -> @unused Int
public func sprintf (buf: *CharStr, format: *ConstCharStr, ...) -> @unused Int
public func vfprintf (f: *File, format: *ConstCharStr, args: __VA_List) -> @unused Int
public func vprintf (format: *ConstCharStr, args: __VA_List) -> @unused Int
public func vsprintf (str: *CharStr, format: *ConstCharStr, args: __VA_List) -> @unused Int
public func vsnprintf (str: *CharStr, n: SizeT, format: *ConstCharStr, args: __VA_List) -> @unused Int
public func __vsnprintf_chk (dest:*CharStr, len:SizeT, flags:Int, dstlen:SizeT, format:*ConstCharStr, arg: __VA_List) -> @unused Int


public func fgetc (f: *File) -> Int
public func fputc (char: Int, f: *File) -> Int

public func fgets (str: *CharStr, n: Int, f: *File) -> @unused *CharStr
public func fputs (str: *ConstCharStr, f: *File) -> @unused Int

public func getc (f: *File) -> Int
public func getchar () -> Int
public func gets (str: *CharStr) -> *CharStr
public func putc (char: Int, f: *File) -> @unused Int
public func putchar (char: Int) -> @unused Int
public func puts (str: *ConstCharStr) -> @unused Int
public func ungetc (char: Int, f: *File) -> Int
public func perror (str: *ConstCharStr) -> Unit


