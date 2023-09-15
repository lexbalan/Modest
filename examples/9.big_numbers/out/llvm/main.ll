
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

; -- MODULE: /Users/alexbalan/p/Modest/examples/9.big_numbers/src/main.cm

@str_1 = private constant [19 x i8] c"big0 = 0x%llX%llX\0A\00"
@str_2 = private constant [19 x i8] c"big1 = 0x%llX%llX\0A\00"
@str_3 = private constant [19 x i8] c"big2 = 0x%llX%llX\0A\00"
@str_4 = private constant [19 x i8] c"big3 = 0x%llX%llX\0A\00"
@str_5 = private constant [22 x i8] c"big_sum = 0x%llX%llX\0A\00"
@str_6 = private constant [13 x i8] c"sig1 = %lld\0A\00"



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
  %6 = bitcast [19 x i8]* @str_1 to %ConstCharStr
  %7 = load i128, i128* @big0
  %8 = call i64(i128) @high_128 (i128 %7)
  %9 = load i128, i128* @big0
  %10 = call i64(i128) @low_128 (i128 %9)
  %11 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %6, i64 %8, i64 %10)
  %12 = bitcast [19 x i8]* @str_2 to %ConstCharStr
  %13 = call i64(i128) @high_128 (i128 340282366920938463463374607431768211455)
  %14 = call i64(i128) @low_128 (i128 340282366920938463463374607431768211455)
  %15 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %12, i64 %13, i64 %14)
  %16 = bitcast [19 x i8]* @str_3 to %ConstCharStr
  %17 = load i128, i128* %big2
  %18 = call i64(i128) @high_128 (i128 %17)
  %19 = load i128, i128* %big2
  %20 = call i64(i128) @low_128 (i128 %19)
  %21 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %16, i64 %18, i64 %20)
  %22 = bitcast [19 x i8]* @str_4 to %ConstCharStr
  %23 = load i128, i128* %big3
  %24 = call i64(i128) @high_128 (i128 %23)
  %25 = load i128, i128* %big3
  %26 = call i64(i128) @low_128 (i128 %25)
  %27 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %22, i64 %24, i64 %26)
  %28 = bitcast [22 x i8]* @str_5 to %ConstCharStr
  %29 = load i128, i128* %big_sum
  %30 = call i64(i128) @high_128 (i128 %29)
  %31 = load i128, i128* %big_sum
  %32 = call i64(i128) @low_128 (i128 %31)
  %33 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %28, i64 %30, i64 %32)
; signed big int test
  %sig1 = alloca i128
  store i128 -1, i128* %sig1
  %34 = load i128, i128* %sig1
  %35 = add i128 %34, 1
  store i128 %35, i128* %sig1
  %36 = bitcast [13 x i8]* @str_6 to %ConstCharStr
  %37 = load i128, i128* %sig1
  %38 = trunc i128 %37 to i64
  %39 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %36, i64 %38)
  ret i32 0
}


