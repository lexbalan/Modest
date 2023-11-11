
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

@str1 = private constant [11 x i8] [i8 99, i8 104, i8 56, i8 32, i8 61, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@str2 = private constant [12 x i8] [i8 99, i8 104, i8 49, i8 54, i8 32, i8 61, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@str3 = private constant [12 x i8] [i8 99, i8 104, i8 51, i8 50, i8 32, i8 61, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@str4 = private constant [14 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 10, i8 0]




define i32 @main() {
    %ch8 = alloca i8
    %ch16 = alloca i16
    %ch32 = alloca i32
;ch8 := "🐀"[0]  // error
;ch16 := "🐀"[0] // erro
    store i32 128000, i32* %ch32
    %1 = load i8, i8* %ch8
    %2 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([11 x i8]* @str1 to [0 x i8]*), i8 %1)
    %3 = load i16, i16* %ch16
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([12 x i8]* @str2 to [0 x i8]*), i16 %3)
    %5 = load i32, i32* %ch32
    %6 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([12 x i8]* @str3 to [0 x i8]*), i32 %5)
    %7 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str4 to [0 x i8]*))
    ret i32 0
}

