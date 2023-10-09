
target triple = "arm64-apple-darwin21.6.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]*
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




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
















declare i32 @creat(%Str, i32)
declare i32 @open(%Str, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir(%Str)
declare i32 @closedir(%DIR*)


declare %Str @getcwd(%Str, i64)
declare %Str @getenv(%Str)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




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
declare i32 @fprintf(%FILE*, %Str, ...)
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

; -- SOURCE: src/main.cm

@str1.c8 = private constant [9 x i8] c"file.bin\00"
@str2.c8 = private constant [19 x i8] c"run write_example\0A\00"
@str3.c8 = private constant [3 x i8] c"wb\00"
@str4.c8 = private constant [31 x i8] c"error: cannot create file \27%s\27\00"
@str5.c8 = private constant [3 x i8] c"id\00"
@str6.c8 = private constant [5 x i8] c"data\00"
@str7.c8 = private constant [18 x i8] c"run read_example\0A\00"
@str8.c8 = private constant [3 x i8] c"rb\00"
@str9.c8 = private constant [29 x i8] c"error: cannot open file \27%s\27\00"
@str10.c8 = private constant [21 x i8] c"file \27%s\27 contains:\0A\00"
@str11.c8 = private constant [14 x i8] c"chunk.id: %s\0A\00"
@str12.c8 = private constant [16 x i8] c"chunk.data: %s\0A\00"
@str13.c8 = private constant [19 x i8] c"text_file example\0A\00"





%Chunk = type {
	[100 x i8],
	[1024 x i8]
}


define void @write_example() {
    %1 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str2.c8)
    %2 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr @str1.c8, %ConstCharStr @str3.c8)
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = bitcast i8* @str1.c8 to [0 x i8]*
    %5 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str4.c8, [0 x i8]* %4)
    ret void
    br label %endif_0
endif_0:
    %chunk = alloca %Chunk
; pointers casting requires -funsafe translator option
; (see Makefile)
    %7 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
    %8 = bitcast [100 x i8]* %7 to i8*
    %9 = bitcast i8* @str5.c8 to i8*
    %10 = call i8*(i8*, i8*) @strcpy (i8* %8, i8* %9)
    %11 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
    %12 = bitcast [1024 x i8]* %11 to i8*
    %13 = bitcast i8* @str6.c8 to i8*
    %14 = call i8*(i8*, i8*) @strcpy (i8* %12, i8* %13)
; write chunk to file
    %15 = bitcast %Chunk* %chunk to i8*
    %16 = call i64(i8*, i64, i64, %FILE*) @fwrite (i8* %15, i64 0, i64 1, %FILE* %2)
    %17 = call i32(%FILE*) @fclose (%FILE* %2)
    ret void
}

define void @read_example() {
    %1 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str7.c8)
    %2 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr @str1.c8, %ConstCharStr @str8.c8)
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = bitcast i8* @str1.c8 to [0 x i8]*
    %5 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str9.c8, [0 x i8]* %4)
    ret void
    br label %endif_0
endif_0:
    %chunk = alloca %Chunk
    %7 = bitcast %Chunk* %chunk to i8*
    %8 = call i64(i8*, i64, i64, %FILE*) @fread (i8* %7, i64 0, i64 1, %FILE* %2)
    %9 = bitcast i8* @str1.c8 to [0 x i8]*
    %10 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str10.c8, [0 x i8]* %9)
    %11 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
    %12 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str11.c8, [100 x i8]* %11)
    %13 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
    %14 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str12.c8, [1024 x i8]* %13)
    %15 = call i32(%FILE*) @fclose (%FILE* %2)
    ret void
}

define i32 @main() {
    %1 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str13.c8)
    call void() @write_example ()
    call void() @read_example ()
    ret i32 0
}


