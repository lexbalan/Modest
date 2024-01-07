
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


declare i32 @fclose(%FILE* %f)
declare i32 @feof(%FILE* %f)
declare i32 @ferror(%FILE* %f)
declare i32 @fflush(%FILE* %f)
declare i32 @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare i32 @fseek(%FILE* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%FILE* %f, %FposT* %pos)
declare i64 @ftell(%FILE* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare i32 @setvbuf(%FILE* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%FILE* %stream, %Str* %format, ...)
declare i32 @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare i32 @fgetc(%FILE* %f)
declare i32 @fputc(i32 %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %FILE* %f)
declare i32 @fputs(%ConstCharStr* %str, %FILE* %f)
declare i32 @getc(%FILE* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %FILE* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)

; -- SOURCE: src/main.cm

@str1 = private constant [7 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 33, i8 0]
@str2 = private constant [7 x i16] [i16 72, i16 101, i16 108, i16 108, i16 111, i16 33, i16 0]
@str3 = private constant [7 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 33, i32 0]
@str4 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 10, i8 0]
@str5 = private constant [22 x i8] [i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 73, i8 110, i8 116, i8 67, i8 111, i8 110, i8 115, i8 116, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [17 x i8] [i8 105, i8 110, i8 116, i8 51, i8 50, i8 67, i8 111, i8 110, i8 115, i8 116, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [19 x i8] [i8 115, i8 116, i8 114, i8 105, i8 110, i8 103, i8 56, i8 67, i8 111, i8 110, i8 115, i8 116, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]




%Point = type {
	i32,
	i32
}




@points2 = global [3 x %Point] [
    %Point {
        i32 0,
        i32 0
    },
    %Point {
        i32 1,
        i32 1
    },
    %Point {
        i32 2,
        i32 2
    }
]


define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([12 x i8]* @str4 to [0 x i8]*))
    %2 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([22 x i8]* @str5 to [0 x i8]*), i32 42)
    %3 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([17 x i8]* @str6 to [0 x i8]*), i32 42)
    ;	printf("genericStringConst = %s\n", genericStringConst)
    %4 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([19 x i8]* @str7 to [0 x i8]*), [0 x i8]* bitcast ([7 x i8]* @str1 to [0 x i8]*))
    ret i32 0
}


