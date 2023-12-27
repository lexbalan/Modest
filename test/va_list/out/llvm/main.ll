
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/fastfood/print.hm



declare void @ff_printf([0 x i8]*, ...)

; -- SOURCE: src/main.cm

@str1 = private constant [14 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 10, i8 0]
@str2 = private constant [4 x i8] [i8 72, i8 105, i8 33, i8 0]
@str3 = private constant [11 x i8] [i8 37, i8 37, i8 32, i8 61, i8 32, i8 39, i8 37, i8 37, i8 39, i8 10, i8 0]
@str4 = private constant [10 x i8] [i8 99, i8 32, i8 61, i8 32, i8 39, i8 37, i8 99, i8 39, i8 10, i8 0]
@str5 = private constant [10 x i8] [i8 115, i8 32, i8 61, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@str6 = private constant [9 x i8] [i8 105, i8 32, i8 58, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [8 x i8] [i8 110, i8 32, i8 61, i8 32, i8 37, i8 110, i8 10, i8 0]
@str8 = private constant [10 x i8] [i8 120, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]



define i32 @main() {
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([14 x i8]* @str1 to [0 x i8]*))
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([11 x i8]* @str3 to [0 x i8]*))
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([10 x i8]* @str4 to [0 x i8]*), i8 36)
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([10 x i8]* @str5 to [0 x i8]*), [0 x i8]* bitcast ([4 x i8]* @str2 to [0 x i8]*))
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([9 x i8]* @str6 to [0 x i8]*), i32 -1)
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([8 x i8]* @str7 to [0 x i8]*), i32 123)
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([10 x i8]* @str8 to [0 x i8]*), i32 305419903)
    ret i32 0
}


