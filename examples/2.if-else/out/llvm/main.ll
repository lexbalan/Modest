
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

@str1 = private constant [17 x i8] [i8 105, i8 102, i8 45, i8 101, i8 108, i8 115, i8 101, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 97, i8 58, i8 32, i8 0]
@str3 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str4 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 98, i8 58, i8 32, i8 0]
@str5 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str6 = private constant [7 x i8] [i8 97, i8 32, i8 62, i8 32, i8 98, i8 10, i8 0]
@str7 = private constant [7 x i8] [i8 97, i8 32, i8 60, i8 32, i8 98, i8 10, i8 0]
@str8 = private constant [8 x i8] [i8 97, i8 32, i8 61, i8 61, i8 32, i8 98, i8 10, i8 0]



define i32 @main() {
    %1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str1 to [0 x i8]*))
    %2 = alloca i32
    %3 = alloca i32
    %4 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*))
    %5 = call i32 (%ConstCharStr*, ...) @scanf(%ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*), i32* %2)
    %6 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str4 to [0 x i8]*))
    %7 = call i32 (%ConstCharStr*, ...) @scanf(%ConstCharStr* bitcast ([3 x i8]* @str5 to [0 x i8]*), i32* %3)
    %8 = load i32, i32* %2
    %9 = load i32, i32* %3
    %10 = icmp sgt i32 %8, %9
    br i1 %10 , label %then_0, label %else_0
then_0:
    %11 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str6 to [0 x i8]*))
    br label %endif_0
else_0:
    %12 = load i32, i32* %2
    %13 = load i32, i32* %3
    %14 = icmp slt i32 %12, %13
    br i1 %14 , label %then_1, label %else_1
then_1:
    %15 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str7 to [0 x i8]*))
    br label %endif_1
else_1:
    %16 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str8 to [0 x i8]*))
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret i32 0
}


