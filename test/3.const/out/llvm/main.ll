
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

; -- MODULE: /Users/alexbalan/p/Modest/test/3.const/src/main.cm

@str1.c8 = private constant [7 x i8] c"Hello!\00"
@str2.c8 = private constant [12 x i8] c"test const\0A\00"
@str3.c8 = private constant [22 x i8] c"genericIntConst = %d\0A\00"
@str4.c8 = private constant [17 x i8] c"int32Const = %d\0A\00"
@str5.c8 = private constant [25 x i8] c"genericStringConst = %s\0A\00"
@str6.c8 = private constant [26 x i8] c"genericString8Const = %s\0A\00"





define i32 @main() {
    %1 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str2.c8)
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str3.c8, i32 42)
    %3 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str4.c8, i32 42)
    %4 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str5.c8, [0 x i8]* @str1.c8)
    %5 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str6.c8, [0 x i8]* @str1.c8)
    ret i32 0
}

