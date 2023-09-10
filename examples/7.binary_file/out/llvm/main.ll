
target triple = "arm64-apple-darwin21.6.0"

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Char = type i8
%ConstChar = type i8
%SignedChar = type i8
%UnsignedChar = type i8
%Short = type i16
%UnsignedShort = type i16
%Int = type i32
%UnsignedInt = type i32
%LongInt = type i64
%UnsignedLongInt = type i64
%Long = type i64
%UnsignedLong = type i64
%LongLong = type i64
%UnsignedLongLong = type i64
%LongLongInt = type i64
%UnsignedLongLongInt = type i64
%Float = type double
%Double = type double
%LongDouble = type double
%SizeT = type i64
%SSizeT = type i64

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%OffT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(i64)
declare i8* @memset(i8*, i32, i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @memcmp(i8*, i8*, i64)
declare void @free(i8*)
declare i32 @strncmp(i8*, i8*, i64)
declare i32 @strcmp(i8*, i8*)
declare i8* @strcpy(i8*, i8*)
declare i64 @strlen(i8*)


declare i32 @ftruncate(i32, i32)
















declare i32 @creat([0 x i8]*, i32)
declare i32 @open([0 x i8]*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir([0 x i8]*)
declare i32 @closedir(%DIR*)


declare [0 x i8]* @getcwd([0 x i8]*, i64)
declare [0 x i8]* @getenv([0 x i8]*)

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*

declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr)
declare i32 @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)


declare i32 @setvbuf(%FILE*, %CharStr, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare i32 @printf(%ConstCharStr, ...)
declare i32 @scanf(%ConstCharStr, ...)
declare i32 @fprintf(%FILE*, [0 x i8]*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr, ...)
declare i32 @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare i32 @sprintf(%CharStr, %ConstCharStr, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr @fgets(%CharStr, i32, %FILE*)
declare i32 @fputs(%ConstCharStr, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr @gets(%CharStr)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr)

; -- MODULE: /Users/alexbalan/p/Modest/examples/7.binary_file/src/main.cm

@str_1 = private constant [9 x i8] c"file.bin\00"
@str_2 = private constant [19 x i8] c"run write_example\0A\00"
@str_3 = private constant [3 x i8] c"wb\00"
@str_4 = private constant [31 x i8] c"error: cannot create file \27%s\27\00"
@str_5 = private constant [3 x i8] c"id\00"
@str_6 = private constant [5 x i8] c"data\00"
@str_7 = private constant [18 x i8] c"run read_example\0A\00"
@str_8 = private constant [3 x i8] c"rb\00"
@str_9 = private constant [29 x i8] c"error: cannot open file \27%s\27\00"
@str_10 = private constant [21 x i8] c"file \27%s\27 contains:\0A\00"
@str_11 = private constant [14 x i8] c"chunk.id: %s\0A\00"
@str_12 = private constant [16 x i8] c"chunk.data: %s\0A\00"
@str_13 = private constant [19 x i8] c"text_file example\0A\00"





%Chunk = type {
	[100 x i8],
	[1024 x i8]
}

define void @write_example() {
  %1 = bitcast [19 x i8]* @str_2 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %3 = bitcast [9 x i8]* @str_1 to %ConstCharStr
  %4 = bitcast [3 x i8]* @str_3 to %ConstCharStr
  %5 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr %3, %ConstCharStr %4)
  %6 = icmp eq %FILE* %5, null
  br i1 %6 , label %then_0, label %endif_0
then_0:
  %7 = bitcast [31 x i8]* @str_4 to %ConstCharStr
  %8 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %7, [9 x i8]* @str_1)
  ret void
  br label %endif_0
endif_0:
  %chunk = alloca %Chunk
; pointers casting requires -funsafe translator option
; (see Makefile)
  %10 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
  %11 = bitcast [100 x i8]* %10 to i8*
  %12 = bitcast [3 x i8]* @str_5 to i8*
  %13 = call i8*(i8*, i8*) @strcpy (i8* %11, i8* %12)
  %14 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
  %15 = bitcast [1024 x i8]* %14 to i8*
  %16 = bitcast [5 x i8]* @str_6 to i8*
  %17 = call i8*(i8*, i8*) @strcpy (i8* %15, i8* %16)
; write chunk to file
  %18 = bitcast %Chunk* %chunk to i8*
  %19 = call i64(i8*, i64, i64, %FILE*) @fwrite (i8* %18, i64 0, i64 1, %FILE* %5)
  %20 = call i32(%FILE*) @fclose (%FILE* %5)
  ret void
}

define void @read_example() {
  %1 = bitcast [18 x i8]* @str_7 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %3 = bitcast [9 x i8]* @str_1 to %ConstCharStr
  %4 = bitcast [3 x i8]* @str_8 to %ConstCharStr
  %5 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr %3, %ConstCharStr %4)
  %6 = icmp eq %FILE* %5, null
  br i1 %6 , label %then_0, label %endif_0
then_0:
  %7 = bitcast [29 x i8]* @str_9 to %ConstCharStr
  %8 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %7, [9 x i8]* @str_1)
  ret void
  br label %endif_0
endif_0:
  %chunk = alloca %Chunk
  %10 = bitcast %Chunk* %chunk to i8*
  %11 = call i64(i8*, i64, i64, %FILE*) @fread (i8* %10, i64 0, i64 1, %FILE* %5)
  %12 = bitcast [21 x i8]* @str_10 to %ConstCharStr
  %13 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %12, [9 x i8]* @str_1)
  %14 = bitcast [14 x i8]* @str_11 to %ConstCharStr
  %15 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
  %16 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %14, [100 x i8]* %15)
  %17 = bitcast [16 x i8]* @str_12 to %ConstCharStr
  %18 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
  %19 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %17, [1024 x i8]* %18)
  %20 = call i32(%FILE*) @fclose (%FILE* %5)
  ret void
}

define i32 @main() {
  %1 = bitcast [19 x i8]* @str_13 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  call void() @write_example ()
  call void() @read_example ()
  ret i32 0
}


