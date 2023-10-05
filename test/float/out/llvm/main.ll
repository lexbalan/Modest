
target triple = "arm64-apple-darwin21.6.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

; -- SOURCE: src/main.cm

@str1.c8 = private constant [8 x i8] c"n = %d\0A\00"
@str2.c8 = private constant [8 x i8] c"p = %d\0A\00"
@str3.c8 = private constant [9 x i8] c"t2 = %f\0A\00"
@str4.c8 = private constant [14 x i8] c"Hello World!\0A\00"
@str5.c8 = private constant [8 x i8] c"f = %f\0A\00"
@str6.c8 = private constant [9 x i8] c"d = %lf\0A\00"
@str7.c8 = private constant [10 x i8] c"pi = %lf\0A\00"




define float @float32(i1 %s, i8 %p, i32 %n) {
    %bits = alloca i32
    br i1 %s , label %then_0, label %endif_0
then_0:
    store i32 2147483648, i32* %bits
    br label %endif_0
endif_0:
    %1 = load i32, i32* %bits
    %2 = zext i8 %p to i32
    %3 = shl i32 %2, 23
    %4 = or i32 %1, %3
    store i32 %4, i32* %bits
    %5 = load i32, i32* %bits
    %6 = and i32 %n, 8388607
    %7 = or i32 %5, %6
    store i32 %7, i32* %bits
; bitcast Nat32 to Float32
    %pfloat32 = alloca float*
    %8 = bitcast i32* %bits to i8*
    %9 = bitcast i8* %8 to float*
    store float* %9, float** %pfloat32
    %10 = load float*, float** %pfloat32
    %11 = load float, float* %10
    ret float %11
}

define void @test2() {
    %1 = sext i1 1 to i32
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str1.c8, i32 %1)
    %3 = sext i8 -128 to i32
    %4 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str2.c8, i32 %3)
    %5 = call float(i1, i8, i32) @float32 (i1 0, i8 -128, i32 1)
    %6 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str3.c8, float %5)
    ret void
}



define i32 @main() {
    %1 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str4.c8)
;test2()
    %f = alloca float
    store float 3.1415927410125732, float* %f
    %d = alloca double
    store double 3.141592653589793, double* %d
    %2 = load float, float* %f
    %3 = fpext float %2 to double
    %4 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str5.c8, double %3)
    %5 = load double, double* %d
    %6 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str6.c8, double %5)
    %7 = bitcast %Float 3.141592653589793 to double
    %8 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str7.c8, double %7)
    ret i32 0

    ret i32 0
}


