
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
@str14 = private constant [17 x i8] [i8 97, i8 97, i8 91, i8 37, i8 105, i8 93, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str15 = private constant [13 x i8] [i8 120, i8 97, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]




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
    %1 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([18 x i8]* @str1 to [0 x i8]*))
    ; -----------------------------------
    ; Global
    ; copy integers by value
    %2 = load i32, i32* @glb_i1
    store i32 %2, i32* @glb_i0
    %3 = load i32, i32* @glb_i0
    %4 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), i32 %3)
    ; copy arrays by value
    %5 = load [10 x i32], [10 x i32]* @glb_a1
    store [10 x i32] %5, [10 x i32]* @glb_a0
    %6 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 0
    %7 = load i32, i32* %6
    %8 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([16 x i8]* @str3 to [0 x i8]*), i32 %7)
    %9 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 1
    %10 = load i32, i32* %9
    %11 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([16 x i8]* @str4 to [0 x i8]*), i32 %10)
    %12 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 2
    %13 = load i32, i32* %12
    %14 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), i32 %13)
    ; copy records by value
    %15 = load %Point, %Point* @glb_r1
    store %Point %15, %Point* @glb_r0
    %16 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 0
    %17 = load i32, i32* %16
    %18 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), i32 %17)
    %19 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 1
    %20 = load i32, i32* %19
    %21 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i32 %20)
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
    %24 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*), i32 %23)
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
    %48 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([16 x i8]* @str9 to [0 x i8]*), i32 %47)
    %49 = getelementptr inbounds [10 x i32], [10 x i32]* %loc_a0, i32 0, i32 1
    %50 = load i32, i32* %49
    %51 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([16 x i8]* @str10 to [0 x i8]*), i32 %50)
    %52 = getelementptr inbounds [10 x i32], [10 x i32]* %loc_a0, i32 0, i32 2
    %53 = load i32, i32* %52
    %54 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), i32 %53)
    ; copy records by value
    ; C backend will be use memcpy()
    %loc_r0 = alloca %Point
    store %Point zeroinitializer, %Point* %loc_r0
    %55 = insertvalue %Point zeroinitializer, i32 10, 0
    %56 = insertvalue %Point %55, i32 20, 1
    %loc_r1 = alloca %Point
    store %Point %56, %Point* %loc_r1
    %57 = load %Point, %Point* %loc_r1
    store %Point %57, %Point* %loc_r0
    %58 = getelementptr inbounds %Point, %Point* %loc_r0, i32 0, i32 0
    %59 = load i32, i32* %58
    %60 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([15 x i8]* @str12 to [0 x i8]*), i32 %59)
    %61 = getelementptr inbounds %Point, %Point* %loc_r0, i32 0, i32 1
    %62 = load i32, i32* %61
    %63 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %62)
    %aa = alloca [15 x [16 x i32]]
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %64 = load i32, i32* %i
    %65 = icmp slt i32 %64, 16
    br i1 %65 , label %body_1, label %break_1
body_1:
    %j = alloca i32
    store i32 0, i32* %j
    br label %again_2
again_2:
    %66 = load i32, i32* %j
    %67 = icmp slt i32 %66, 16
    br i1 %67 , label %body_2, label %break_2
body_2:
    %68 = load i32, i32* %i
    %69 = load i32, i32* %j
    %70 = mul i32 %68, %69
    %71 = load i32, i32* %i
    %72 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %aa, i32 0, i32 %71
    %73 = load i32, i32* %j
    %74 = getelementptr inbounds [16 x i32], [16 x i32]* %72, i32 0, i32 %73
    store i32 %70, i32* %74
    %75 = load i32, i32* %j
    %76 = add i32 %75, 1
    store i32 %76, i32* %j
    br label %again_2
break_2:
    %77 = load i32, i32* %i
    %78 = add i32 %77, 1
    store i32 %78, i32* %i
    br label %again_1
break_1:
    store i32 0, i32* %i
    br label %again_3
again_3:
    %79 = load i32, i32* %i
    %80 = icmp slt i32 %79, 16
    br i1 %80 , label %body_3, label %break_3
body_3:
    %k = alloca i32
    store i32 0, i32* %k
    br label %again_4
again_4:
    %81 = load i32, i32* %k
    %82 = icmp slt i32 %81, 16
    br i1 %82 , label %body_4, label %break_4
body_4:
    %83 = load i32, i32* %i
    %84 = load i32, i32* %k
    %85 = load i32, i32* %i
    %86 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %aa, i32 0, i32 %85
    %87 = load i32, i32* %k
    %88 = getelementptr inbounds [16 x i32], [16 x i32]* %86, i32 0, i32 %87
    %89 = load i32, i32* %88
    %90 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([17 x i8]* @str14 to [0 x i8]*), i32 %83, i32 %84, i32 %89)
    %91 = load i32, i32* %k
    %92 = add i32 %91, 1
    store i32 %92, i32* %k
    br label %again_4
break_4:
    %93 = load i32, i32* %i
    %94 = add i32 %93, 1
    store i32 %94, i32* %i
    br label %again_3
break_3:
    %95 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %aa, i32 0, i32 3
    %96 = load [16 x i32], [16 x i32]* %95
    %xa = alloca [16 x i32]
    store [16 x i32] %96, [16 x i32]* %xa
    store i32 0, i32* %i
    br label %again_5
again_5:
    %97 = load i32, i32* %i
    %98 = icmp slt i32 %97, 16
    br i1 %98 , label %body_5, label %break_5
body_5:
    %99 = load i32, i32* %i
    %100 = load i32, i32* %i
    %101 = getelementptr inbounds [16 x i32], [16 x i32]* %xa, i32 0, i32 %100
    %102 = load i32, i32* %101
    %103 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([13 x i8]* @str15 to [0 x i8]*), i32 %99, i32 %102)
    %104 = load i32, i32* %i
    %105 = add i32 %104, 1
    store i32 %105, i32* %i
    br label %again_5
break_5:
    ret i32 0
}


