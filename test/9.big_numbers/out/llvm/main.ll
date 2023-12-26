
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

@str1 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 48, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str2 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 49, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str3 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 50, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str4 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 51, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str5 = private constant [22 x i8] [i8 98, i8 105, i8 103, i8 95, i8 115, i8 117, i8 109, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str6 = private constant [13 x i8] [i8 115, i8 105, i8 103, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]



@big0 = global i128 1512366075204170947332355369683137040

define i64 @high_128(i128 %x) {
    %1 = lshr i128 %x, 64
    %2 = trunc i128 %1 to i64
    ret i64 %2
}

define i64 @low_128(i128 %x) {
    %1 = and i128 %x, 18446744073709551615
    %2 = trunc i128 %1 to i64
    ret i64 %2
}

define i32 @main() {
    %big2 = alloca i128
    store i128 340282366920938463463374607431768211455, i128* %big2
    %big3 = alloca i128
    store i128 1, i128* %big3
    %a = alloca i32
    store i32 1, i32* %a
    %1 = load i128, i128* %big2
    %2 = add i128 340282366920938463463374607431768211455, %1
    %3 = load i32, i32* %a
    %4 = zext i32 %3 to i128
    %5 = add i128 %2, %4
    %big_sum = alloca i128
    store i128 %5, i128* %big_sum
    %6 = load i128, i128* @big0
    %7 = call i64(i128) @high_128 (i128 %6)
    %8 = load i128, i128* @big0
    %9 = call i64(i128) @low_128 (i128 %8)
    %10 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*), i64 %7, i64 %9)
    %11 = call i64(i128) @high_128 (i128 340282366920938463463374607431768211455)
    %12 = call i64(i128) @low_128 (i128 340282366920938463463374607431768211455)
    %13 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*), i64 %11, i64 %12)
    %14 = load i128, i128* %big2
    %15 = call i64(i128) @high_128 (i128 %14)
    %16 = load i128, i128* %big2
    %17 = call i64(i128) @low_128 (i128 %16)
    %18 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str3 to [0 x i8]*), i64 %15, i64 %17)
    %19 = load i128, i128* %big3
    %20 = call i64(i128) @high_128 (i128 %19)
    %21 = load i128, i128* %big3
    %22 = call i64(i128) @low_128 (i128 %21)
    %23 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str4 to [0 x i8]*), i64 %20, i64 %22)
    %24 = load i128, i128* %big_sum
    %25 = call i64(i128) @high_128 (i128 %24)
    %26 = load i128, i128* %big_sum
    %27 = call i64(i128) @low_128 (i128 %26)
    %28 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str5 to [0 x i8]*), i64 %25, i64 %27)
    ; signed big int test
    %sig1 = alloca i128
    store i128 -1, i128* %sig1
    %29 = load i128, i128* %sig1
    %30 = add i128 %29, 1
    store i128 %30, i128* %sig1
    %31 = load i128, i128* %sig1
    %32 = trunc i128 %31 to i64
    %33 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str6 to [0 x i8]*), i64 %32)
    ret i32 0
}


