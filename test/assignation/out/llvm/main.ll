
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
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

@str1 = private constant [18 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 97, i8 116, i8 105, i8 111, i8 110, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 103, i8 108, i8 98, i8 95, i8 105, i8 48, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str3 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str4 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str5 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str6 = private constant [15 x i8] [i8 103, i8 108, i8 98, i8 95, i8 114, i8 48, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [15 x i8] [i8 103, i8 108, i8 98, i8 95, i8 114, i8 48, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str8 = private constant [13 x i8] [i8 108, i8 111, i8 99, i8 95, i8 105, i8 48, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str10 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str12 = private constant [15 x i8] [i8 108, i8 111, i8 99, i8 95, i8 114, i8 48, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [15 x i8] [i8 108, i8 111, i8 99, i8 95, i8 114, i8 48, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]




%Point = type {
	i32,
	i32
}


@glb_i0 = global i32 0
@glb_i1 = global i32 321
@glb_r0 = global %Point zeroinitializer
@glb_r1 = global %Point {
    i32 20,
    i32 10
}
@glb_a0 = global [10 x i32] [
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0
]
@glb_a1 = global [10 x i32] [
    i32 64,
    i32 53,
    i32 42,
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0,
    i32 0
]

define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str1 to [0 x i8]*))
    ; -----------------------------------
    ; Global
    ; copy integers by value
    %2 = load i32, i32* @glb_i1
    store i32 %2, i32* @glb_i0
    %3 = load i32, i32* @glb_i0
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), i32 %3)
    ; copy arrays by value
    %5 = load [10 x i32], [10 x i32]* @glb_a1
    store [10 x i32] %5, [10 x i32]* @glb_a0
    %6 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 0
    %7 = load i32, i32* %6
    %8 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([16 x i8]* @str3 to [0 x i8]*), i32 %7)
    %9 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 1
    %10 = load i32, i32* %9
    %11 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([16 x i8]* @str4 to [0 x i8]*), i32 %10)
    %12 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 2
    %13 = load i32, i32* %12
    %14 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), i32 %13)
    ; copy records by value
    %15 = load %Point, %Point* @glb_r1
    store %Point %15, %Point* @glb_r0
    %16 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 0
    %17 = load i32, i32* %16
    %18 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), i32 %17)
    %19 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 1
    %20 = load i32, i32* %19
    %21 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i32 %20)
    ; -----------------------------------
    ; Local
    ; copy integers by value
    %loc_i0 = alloca i32
    store i32 0, i32* %loc_i0
    %loc_i1 = alloca i32
    store i32 123, i32* %loc_i1
    %22 = load i32, i32* %loc_i1
    store i32 %22, i32* %loc_i0
    %23 = load i32, i32* %loc_i0
    %24 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*), i32 %23)
    ; copy arrays by value
    ; C backend will be use memcpy()
    %25 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
    %26 = insertvalue [10 x i32] %25, i32 0, 1
    %27 = insertvalue [10 x i32] %26, i32 0, 2
    %28 = insertvalue [10 x i32] %27, i32 0, 3
    %29 = insertvalue [10 x i32] %28, i32 0, 4
    %30 = insertvalue [10 x i32] %29, i32 0, 5
    %31 = insertvalue [10 x i32] %30, i32 0, 6
    %32 = insertvalue [10 x i32] %31, i32 0, 7
    %33 = insertvalue [10 x i32] %32, i32 0, 8
    %34 = insertvalue [10 x i32] %33, i32 0, 9
    %loc_a0 = alloca [10 x i32]
    store [10 x i32] %34, [10 x i32]* %loc_a0
    %35 = insertvalue [10 x i32] zeroinitializer, i32 42, 0
    %36 = insertvalue [10 x i32] %35, i32 53, 1
    %37 = insertvalue [10 x i32] %36, i32 64, 2
    %38 = insertvalue [10 x i32] %37, i32 0, 3
    %39 = insertvalue [10 x i32] %38, i32 0, 4
    %40 = insertvalue [10 x i32] %39, i32 0, 5
    %41 = insertvalue [10 x i32] %40, i32 0, 6
    %42 = insertvalue [10 x i32] %41, i32 0, 7
    %43 = insertvalue [10 x i32] %42, i32 0, 8
    %44 = insertvalue [10 x i32] %43, i32 0, 9
    %loc_a1 = alloca [10 x i32]
    store [10 x i32] %44, [10 x i32]* %loc_a1
    %45 = load [10 x i32], [10 x i32]* %loc_a1
    store [10 x i32] %45, [10 x i32]* %loc_a0
    %46 = getelementptr inbounds [10 x i32], [10 x i32]* %loc_a0, i32 0, i32 0
    %47 = load i32, i32* %46
    %48 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([16 x i8]* @str9 to [0 x i8]*), i32 %47)
    %49 = getelementptr inbounds [10 x i32], [10 x i32]* %loc_a0, i32 0, i32 1
    %50 = load i32, i32* %49
    %51 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([16 x i8]* @str10 to [0 x i8]*), i32 %50)
    %52 = getelementptr inbounds [10 x i32], [10 x i32]* %loc_a0, i32 0, i32 2
    %53 = load i32, i32* %52
    %54 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), i32 %53)
    ; copy records by value
    ; C backend will be use memcpy()
    %loc_r0 = alloca %Point
    store %Point zeroinitializer, %Point* %loc_r0
    %loc_r1 = alloca %Point
    store %Point {
        i32 10,
        i32 20
    }, %Point* %loc_r1
    %55 = load %Point, %Point* %loc_r1
    store %Point %55, %Point* %loc_r0
    %56 = getelementptr inbounds %Point, %Point* %loc_r0, i32 0, i32 0
    %57 = load i32, i32* %56
    %58 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([15 x i8]* @str12 to [0 x i8]*), i32 %57)
    %59 = getelementptr inbounds %Point, %Point* %loc_r0, i32 0, i32 1
    %60 = load i32, i32* %59
    %61 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %60)
    ret i32 0
}


