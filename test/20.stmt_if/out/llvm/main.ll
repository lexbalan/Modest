
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*); -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

@str1 = private constant [17 x i8] [i8 115, i8 116, i8 109, i8 116, i8 95, i8 105, i8 102, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 97, i8 58, i8 32, i8 0]
@str3 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str4 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 98, i8 58, i8 32, i8 0]
@str5 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str6 = private constant [7 x i8] [i8 97, i8 32, i8 62, i8 32, i8 98, i8 10, i8 0]
@str7 = private constant [7 x i8] [i8 97, i8 32, i8 60, i8 32, i8 98, i8 10, i8 0]
@str8 = private constant [8 x i8] [i8 97, i8 32, i8 61, i8 61, i8 32, i8 98, i8 10, i8 0]



define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str1 to [0 x i8]*))
    %a = alloca i32
    %b = alloca i32
    %2 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*))
    %3 = call i32(%ConstCharStr*, ...) @scanf (%ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*), i32* %a)
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([10 x i8]* @str4 to [0 x i8]*))
    %5 = call i32(%ConstCharStr*, ...) @scanf (%ConstCharStr* bitcast ([3 x i8]* @str5 to [0 x i8]*), i32* %b)
    %6 = load i32, i32* %a
    %7 = load i32, i32* %b
    %8 = icmp sgt i32 %6, %7
    br i1 %8 , label %then_0, label %else_0
then_0:
    %9 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([7 x i8]* @str6 to [0 x i8]*))
    br label %endif_0
else_0:
    %10 = load i32, i32* %a
    %11 = load i32, i32* %b
    %12 = icmp slt i32 %10, %11
    br i1 %12 , label %then_1, label %else_1
then_1:
    %13 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([7 x i8]* @str7 to [0 x i8]*))
    br label %endif_1
else_1:
    %14 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([8 x i8]* @str8 to [0 x i8]*))
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret i32 0
}


