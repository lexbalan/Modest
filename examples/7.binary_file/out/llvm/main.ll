
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]
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
declare i32 @strncmp([0 x i8]*, [0 x i8]*, i64)
declare i32 @strcmp([0 x i8]*, [0 x i8]*)
declare [0 x i8]* @strcpy([0 x i8]*, [0 x i8]*)
declare i64 @strlen([0 x i8]*)


declare i32 @ftruncate(i32, i32)
















declare i32 @creat(%Str*, i32)
declare i32 @open(%Str*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir(%Str*)
declare i32 @closedir(%DIR*)


declare %Str* @getcwd(%Str*, i64)
declare %Str* @getenv(%Str*)


declare void @bzero(i8*, i64)


declare void @bcopy(i8*, i8*, i64)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr*, %ConstCharStr*)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr*, %ConstCharStr*, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr*)
declare i32 @rename(%ConstCharStr*, %ConstCharStr*)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr*)


declare i32 @setvbuf(%FILE*, %CharStr*, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr*)
declare i32 @printf(%ConstCharStr*, ...)
declare i32 @scanf(%ConstCharStr*, ...)
declare i32 @fprintf(%FILE*, %Str*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr*, ...)
declare i32 @sscanf(%ConstCharStr*, %ConstCharStr*, ...)
declare i32 @sprintf(%CharStr*, %ConstCharStr*, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr* @fgets(%CharStr*, i32, %FILE*)
declare i32 @fputs(%ConstCharStr*, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr*)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr*)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr*)

; -- SOURCE: src/main.cm

@str1 = private constant [9 x i8] [i8 102, i8 105, i8 108, i8 101, i8 46, i8 98, i8 105, i8 110, i8 0]
@str2 = private constant [19 x i8] [i8 114, i8 117, i8 110, i8 32, i8 119, i8 114, i8 105, i8 116, i8 101, i8 95, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str3 = private constant [3 x i8] [i8 119, i8 98, i8 0]
@str4 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str5 = private constant [3 x i8] [i8 105, i8 100, i8 0]
@str6 = private constant [5 x i8] [i8 100, i8 97, i8 116, i8 97, i8 0]
@str7 = private constant [18 x i8] [i8 114, i8 117, i8 110, i8 32, i8 114, i8 101, i8 97, i8 100, i8 95, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str8 = private constant [3 x i8] [i8 114, i8 98, i8 0]
@str9 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str10 = private constant [21 x i8] [i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 32, i8 99, i8 111, i8 110, i8 116, i8 97, i8 105, i8 110, i8 115, i8 58, i8 10, i8 0]
@str11 = private constant [14 x i8] [i8 99, i8 104, i8 117, i8 110, i8 107, i8 46, i8 105, i8 100, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
@str12 = private constant [16 x i8] [i8 99, i8 104, i8 117, i8 110, i8 107, i8 46, i8 100, i8 97, i8 116, i8 97, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
@str13 = private constant [19 x i8] [i8 116, i8 101, i8 120, i8 116, i8 95, i8 102, i8 105, i8 108, i8 101, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]






%Chunk = type {
	[100 x i8],
	[1024 x i8]
}


define void @write_example() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*))
    %2 = call %FILE*(%ConstCharStr*, %ConstCharStr*) @fopen ([0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*))
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([31 x i8]* @str4 to [0 x i8]*), [0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*))
    ret void
    br label %endif_0
endif_0:
    %chunk = alloca %Chunk
; pointers casting requires -funsafe translator option
; (see Makefile)
    %6 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
    %7 = bitcast [100 x i8]* %6 to [0 x i8]*
    %8 = call [0 x i8]*([0 x i8]*, [0 x i8]*) @strcpy ([0 x i8]* %7, [0 x i8]* bitcast ([3 x i8]* @str5 to [0 x i8]*))
    %9 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
    %10 = bitcast [1024 x i8]* %9 to [0 x i8]*
    %11 = call [0 x i8]*([0 x i8]*, [0 x i8]*) @strcpy ([0 x i8]* %10, [0 x i8]* bitcast ([5 x i8]* @str6 to [0 x i8]*))
; write chunk to file
    %12 = bitcast %Chunk* %chunk to i8*
    %13 = call i64(i8*, i64, i64, %FILE*) @fwrite (i8* %12, i64 0, i64 1, %FILE* %2)
    %14 = call i32(%FILE*) @fclose (%FILE* %2)
    ret void
}

define void @read_example() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str7 to [0 x i8]*))
    %2 = call %FILE*(%ConstCharStr*, %ConstCharStr*) @fopen ([0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([3 x i8]* @str8 to [0 x i8]*))
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([29 x i8]* @str9 to [0 x i8]*), [0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*))
    ret void
    br label %endif_0
endif_0:
    %chunk = alloca %Chunk
    %6 = bitcast %Chunk* %chunk to i8*
    %7 = call i64(i8*, i64, i64, %FILE*) @fread (i8* %6, i64 0, i64 1, %FILE* %2)
    %8 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*), [0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*))
    %9 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
    %10 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str11 to [0 x i8]*), [100 x i8]* %9)
    %11 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
    %12 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([16 x i8]* @str12 to [0 x i8]*), [1024 x i8]* %11)
    %13 = call i32(%FILE*) @fclose (%FILE* %2)
    ret void
}

define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str13 to [0 x i8]*))
    call void() @write_example ()
    call void() @read_example ()
    ret i32 0
}


