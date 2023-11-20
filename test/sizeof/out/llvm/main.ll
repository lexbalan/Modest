
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

@str1 = private constant [21 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 99, i8 97, i8 115, i8 116, i8 32, i8 111, i8 112, i8 101, i8 114, i8 97, i8 116, i8 105, i8 111, i8 110, i8 10, i8 0]
@str2 = private constant [20 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 85, i8 110, i8 105, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str3 = private constant [21 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 85, i8 110, i8 105, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str4 = private constant [20 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 66, i8 111, i8 111, i8 108, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str5 = private constant [21 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 66, i8 111, i8 111, i8 108, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str6 = private constant [20 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str7 = private constant [21 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str8 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str9 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str10 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str11 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str12 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str13 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str14 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str15 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str16 = private constant [20 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str17 = private constant [21 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str18 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str19 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str20 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str21 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str22 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str23 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str24 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str25 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str26 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str27 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str28 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str29 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str30 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str31 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str32 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 42, i8 83, i8 116, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str33 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 42, i8 83, i8 116, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str34 = private constant [25 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 91, i8 49, i8 48, i8 93, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str35 = private constant [26 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 91, i8 49, i8 48, i8 93, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str36 = private constant [27 x i8] [i8 62, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 91, i8 51, i8 93, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str37 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str38 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str39 = private constant [25 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 46, i8 120, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str40 = private constant [25 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 46, i8 121, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str41 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 49, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str42 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 49, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str43 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str44 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str45 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 51, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str46 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 51, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str47 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str48 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str49 = private constant [26 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 115, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str50 = private constant [26 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 99, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str51 = private constant [26 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str52 = private constant [26 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 102, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str53 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 99, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str54 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 105, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str55 = private constant [26 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 112, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str56 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 115, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]



%Point = type {
	i32,
	i32
}

%Mixed1 = type {
	i8,
	i32,
	double
}

%Mixed2 = type {
	i8,
	i32,
	double,
	i8
}

%Mixed3 = type {
	i8,
	i32,
	double,
	[9 x i8]
}

%Mixed4 = type {
	%Mixed2,
	i8,
	i32,
	double,
	[9 x i8],
	i16,
	[3 x %Point],
	%Mixed3
}


define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
; sizeof(void) in C  == 1
; sizeof(Unit) in CM == 0
; TODO: here is a broblem
    %2 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([20 x i8]* @str2 to [0 x i8]*), i64 0)
    %3 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*), i64 0)
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([20 x i8]* @str4 to [0 x i8]*), i64 1)
    %5 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*), i64 1)
    %6 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([20 x i8]* @str6 to [0 x i8]*), i64 1)
    %7 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str7 to [0 x i8]*), i64 1)
    %8 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str8 to [0 x i8]*), i64 2)
    %9 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str9 to [0 x i8]*), i64 2)
    %10 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*), i64 4)
    %11 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str11 to [0 x i8]*), i64 4)
    %12 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str12 to [0 x i8]*), i64 8)
    %13 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str13 to [0 x i8]*), i64 8)
    %14 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str14 to [0 x i8]*), i64 16)
    %15 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([23 x i8]* @str15 to [0 x i8]*), i64 16)
; type Nat256 not implemented
;printf("sizeof(Nat256) = %lu\n", sizeof(Nat256) to Nat64)
    %16 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([20 x i8]* @str16 to [0 x i8]*), i64 1)
    %17 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str17 to [0 x i8]*), i64 1)
    %18 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str18 to [0 x i8]*), i64 2)
    %19 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str19 to [0 x i8]*), i64 2)
    %20 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str20 to [0 x i8]*), i64 4)
    %21 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str21 to [0 x i8]*), i64 4)
    %22 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str22 to [0 x i8]*), i64 8)
    %23 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str23 to [0 x i8]*), i64 8)
    %24 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str24 to [0 x i8]*), i64 16)
    %25 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([23 x i8]* @str25 to [0 x i8]*), i64 16)
; type Int256 not implemented
;printf("sizeof(Int256) = %lu\n", sizeof(Int256) to Nat64)
    %26 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str26 to [0 x i8]*), i64 1)
    %27 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str27 to [0 x i8]*), i64 1)
    %28 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str28 to [0 x i8]*), i64 2)
    %29 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([23 x i8]* @str29 to [0 x i8]*), i64 2)
    %30 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str30 to [0 x i8]*), i64 4)
    %31 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([23 x i8]* @str31 to [0 x i8]*), i64 4)
; pointer size (for example pointer to []Char8)
    %32 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str32 to [0 x i8]*), i64 8)
    %33 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str33 to [0 x i8]*), i64 8)
; array size
    %34 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([25 x i8]* @str34 to [0 x i8]*), i64 40)
    %35 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([26 x i8]* @str35 to [0 x i8]*), i64 4)
    %36 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([27 x i8]* @str36 to [0 x i8]*), i64 4)
; record size
    %37 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str37 to [0 x i8]*), i64 8)
    %38 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str38 to [0 x i8]*), i64 4)
    %39 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([25 x i8]* @str39 to [0 x i8]*), i64 0)
    %40 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([25 x i8]* @str40 to [0 x i8]*), i64 4)
    %41 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str41 to [0 x i8]*), i64 16)
    %42 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([23 x i8]* @str42 to [0 x i8]*), i64 8)
    %43 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str43 to [0 x i8]*), i64 24)
    %44 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([23 x i8]* @str44 to [0 x i8]*), i64 8)
    %45 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str45 to [0 x i8]*), i64 32)
    %46 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([23 x i8]* @str46 to [0 x i8]*), i64 8)
    %47 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str47 to [0 x i8]*), i64 112)
    %48 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([23 x i8]* @str48 to [0 x i8]*), i64 8)
    %49 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([26 x i8]* @str49 to [0 x i8]*), i64 0)
    %50 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([26 x i8]* @str50 to [0 x i8]*), i64 24)
    %51 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([26 x i8]* @str51 to [0 x i8]*), i64 28)
    %52 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([26 x i8]* @str52 to [0 x i8]*), i64 32)
    %53 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([27 x i8]* @str53 to [0 x i8]*), i64 40)
    %54 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([27 x i8]* @str54 to [0 x i8]*), i64 50)
    %55 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([26 x i8]* @str55 to [0 x i8]*), i64 52)
    %56 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([27 x i8]* @str56 to [0 x i8]*), i64 80)
    ret i32 0
}


