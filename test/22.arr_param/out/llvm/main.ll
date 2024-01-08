
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

@str1 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str2 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str3 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str4 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str5 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str6 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str7 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str8 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str9 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str10 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str11 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str12 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str13 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str14 = private constant [2 x i8] [i8 10, i8 0]
@str15 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str16 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str17 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str18 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str19 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str20 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str21 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str22 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str23 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str24 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str25 = private constant [2 x i8] [i8 10, i8 0]



define [2 x i32] @swap([2 x i32] %x) {
    %out = alloca [2 x i32]
    %1 = extractvalue [2 x i32] %x, 1
    %2 = getelementptr inbounds [2 x i32], [2 x i32]* %out, i32 0, i32 0
    store i32 %1, i32* %2
    %3 = extractvalue [2 x i32] %x, 0
    %4 = getelementptr inbounds [2 x i32], [2 x i32]* %out, i32 0, i32 1
    store i32 %3, i32* %4
    %5 = load [2 x i32], [2 x i32]* %out
    ret [2 x i32] %5
}

define [8 x i8] @ret_str() {
    %1 = insertvalue [8 x i8] zeroinitializer, i8 104, 0
    %2 = insertvalue [8 x i8] %1, i8 101, 1
    %3 = insertvalue [8 x i8] %2, i8 108, 2
    %4 = insertvalue [8 x i8] %3, i8 108, 3
    %5 = insertvalue [8 x i8] %4, i8 111, 4
    %6 = insertvalue [8 x i8] %5, i8 109, 5
    %7 = insertvalue [8 x i8] %6, i8 97, 6
    %8 = insertvalue [8 x i8] %7, i8 33, 7
    ret [8 x i8] %8
}



define void @ret_str2([2 x [10 x i8]]* noalias sret([2 x [10 x i8]]) %0) {
    %2 = insertvalue [10 x i8] zeroinitializer, i8 97, 0
    %3 = insertvalue [10 x i8] %2, i8 98, 1
    %4 = insertvalue [10 x i8] %3, i8 0, 2
    %5 = insertvalue [10 x i8] %4, i8 0, 3
    %6 = insertvalue [10 x i8] %5, i8 0, 4
    %7 = insertvalue [10 x i8] %6, i8 0, 5
    %8 = insertvalue [10 x i8] %7, i8 0, 6
    %9 = insertvalue [10 x i8] %8, i8 0, 7
    %10 = insertvalue [10 x i8] %9, i8 0, 8
    %11 = insertvalue [10 x i8] %10, i8 0, 9
    %12 = insertvalue [10 x i8] zeroinitializer, i8 99, 0
    %13 = insertvalue [10 x i8] %12, i8 100, 1
    %14 = insertvalue [10 x i8] %13, i8 0, 2
    %15 = insertvalue [10 x i8] %14, i8 0, 3
    %16 = insertvalue [10 x i8] %15, i8 0, 4
    %17 = insertvalue [10 x i8] %16, i8 0, 5
    %18 = insertvalue [10 x i8] %17, i8 0, 6
    %19 = insertvalue [10 x i8] %18, i8 0, 7
    %20 = insertvalue [10 x i8] %19, i8 0, 8
    %21 = insertvalue [10 x i8] %20, i8 0, 9
    %22 = insertvalue [2 x [10 x i8]] zeroinitializer, [10 x i8] %11, 0
    %23 = insertvalue [2 x [10 x i8]] %22, [10 x i8] %21, 1
    store [2 x [10 x i8]] %23, [2 x [10 x i8]]* %0
    ret void
}

define void @ee([2 x [10 x i8]] %x) {
    ;var y = x
    ;y[0][6] = 0 to Char8
    ;y[1][7] = 0 to Char8
    %1 = extractvalue [2 x [10 x i8]] %x, 1
    %2 = extractvalue [10 x i8] %1, 0
    %3 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str1 to [0 x i8]*), i8 %2)
    %4 = extractvalue [2 x [10 x i8]] %x, 1
    %5 = extractvalue [10 x i8] %4, 1
    %6 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str2 to [0 x i8]*), i8 %5)
    %7 = extractvalue [2 x [10 x i8]] %x, 1
    %8 = extractvalue [10 x i8] %7, 2
    %9 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str3 to [0 x i8]*), i8 %8)
    ret void
}

define void @kk([2 x [10 x i8]] %x) {
    %1 = extractvalue [2 x [10 x i8]] %x, 0
    %2 = extractvalue [10 x i8] %1, 0
    %3 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str4 to [0 x i8]*), i8 %2)
    %4 = extractvalue [2 x [10 x i8]] %x, 0
    %5 = extractvalue [10 x i8] %4, 1
    %6 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str5 to [0 x i8]*), i8 %5)
    %7 = extractvalue [2 x [10 x i8]] %x, 0
    %8 = extractvalue [10 x i8] %7, 2
    %9 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str6 to [0 x i8]*), i8 %8)
    %10 = extractvalue [2 x [10 x i8]] %x, 0
    %11 = extractvalue [10 x i8] %10, 3
    %12 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str7 to [0 x i8]*), i8 %11)
    %13 = extractvalue [2 x [10 x i8]] %x, 0
    %14 = extractvalue [10 x i8] %13, 4
    %15 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str8 to [0 x i8]*), i8 %14)
    %16 = extractvalue [2 x [10 x i8]] %x, 0
    %17 = extractvalue [10 x i8] %16, 5
    %18 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str9 to [0 x i8]*), i8 %17)
    %19 = extractvalue [2 x [10 x i8]] %x, 0
    %20 = extractvalue [10 x i8] %19, 6
    %21 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str10 to [0 x i8]*), i8 %20)
    %22 = extractvalue [2 x [10 x i8]] %x, 0
    %23 = extractvalue [10 x i8] %22, 7
    %24 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str11 to [0 x i8]*), i8 %23)
    %25 = extractvalue [2 x [10 x i8]] %x, 0
    %26 = extractvalue [10 x i8] %25, 8
    %27 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str12 to [0 x i8]*), i8 %26)
    %28 = extractvalue [2 x [10 x i8]] %x, 0
    %29 = extractvalue [10 x i8] %28, 9
    %30 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str13 to [0 x i8]*), i8 %29)
    %31 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([2 x i8]* @str14 to [0 x i8]*))
    %32 = extractvalue [2 x [10 x i8]] %x, 1
    %33 = extractvalue [10 x i8] %32, 0
    %34 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str15 to [0 x i8]*), i8 %33)
    %35 = extractvalue [2 x [10 x i8]] %x, 1
    %36 = extractvalue [10 x i8] %35, 1
    %37 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str16 to [0 x i8]*), i8 %36)
    %38 = extractvalue [2 x [10 x i8]] %x, 1
    %39 = extractvalue [10 x i8] %38, 2
    %40 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str17 to [0 x i8]*), i8 %39)
    %41 = extractvalue [2 x [10 x i8]] %x, 1
    %42 = extractvalue [10 x i8] %41, 3
    %43 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str18 to [0 x i8]*), i8 %42)
    %44 = extractvalue [2 x [10 x i8]] %x, 1
    %45 = extractvalue [10 x i8] %44, 4
    %46 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str19 to [0 x i8]*), i8 %45)
    %47 = extractvalue [2 x [10 x i8]] %x, 1
    %48 = extractvalue [10 x i8] %47, 5
    %49 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str20 to [0 x i8]*), i8 %48)
    %50 = extractvalue [2 x [10 x i8]] %x, 1
    %51 = extractvalue [10 x i8] %50, 6
    %52 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str21 to [0 x i8]*), i8 %51)
    %53 = extractvalue [2 x [10 x i8]] %x, 1
    %54 = extractvalue [10 x i8] %53, 7
    %55 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str22 to [0 x i8]*), i8 %54)
    %56 = extractvalue [2 x [10 x i8]] %x, 1
    %57 = extractvalue [10 x i8] %56, 8
    %58 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str23 to [0 x i8]*), i8 %57)
    %59 = extractvalue [2 x [10 x i8]] %x, 1
    %60 = extractvalue [10 x i8] %59, 9
    %61 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([4 x i8]* @str24 to [0 x i8]*), i8 %60)
    %62 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([2 x i8]* @str25 to [0 x i8]*))
    ret void
}


@global_array = global [2 x i32] [
    i32 1,
    i32 2
]

%Point = type {
	i32,
	i32
}

%Pod = type {
	[10 x i8]
}


define i32 @main() {
    %1 = call [8 x i8]()@ret_str()
    %g = alloca [8 x i8]
    store [8 x i8] %1, [8 x i8]* %g
    ;let d = c[0]
    ;let s0 = c
    ;var s1 = c
    ; прикольно что имя массива чаров имеет тип char *
    ; а ziseof = char [n] ))
    %w = alloca [2 x [10 x i8]]
    %2 = insertvalue [10 x i8] zeroinitializer, i8 104, 0
    %3 = insertvalue [10 x i8] %2, i8 101, 1
    %4 = insertvalue [10 x i8] %3, i8 108, 2
    %5 = insertvalue [10 x i8] %4, i8 108, 3
    %6 = insertvalue [10 x i8] %5, i8 111, 4
    %7 = insertvalue [10 x i8] %6, i8 0, 5
    %8 = insertvalue [10 x i8] %7, i8 0, 6
    %9 = insertvalue [10 x i8] %8, i8 0, 7
    %10 = insertvalue [10 x i8] %9, i8 0, 8
    %11 = insertvalue [10 x i8] %10, i8 0, 9
    %12 = getelementptr inbounds [2 x [10 x i8]], [2 x [10 x i8]]* %w, i32 0, i32 0
    store [10 x i8] %11, [10 x i8]* %12
    %13 = insertvalue [10 x i8] zeroinitializer, i8 119, 0
    %14 = insertvalue [10 x i8] %13, i8 111, 1
    %15 = insertvalue [10 x i8] %14, i8 114, 2
    %16 = insertvalue [10 x i8] %15, i8 108, 3
    %17 = insertvalue [10 x i8] %16, i8 100, 4
    %18 = insertvalue [10 x i8] %17, i8 0, 5
    %19 = insertvalue [10 x i8] %18, i8 0, 6
    %20 = insertvalue [10 x i8] %19, i8 0, 7
    %21 = insertvalue [10 x i8] %20, i8 0, 8
    %22 = insertvalue [10 x i8] %21, i8 0, 9
    %23 = getelementptr inbounds [2 x [10 x i8]], [2 x [10 x i8]]* %w, i32 0, i32 1
    store [10 x i8] %22, [10 x i8]* %23
    %24 = load [2 x [10 x i8]], [2 x [10 x i8]]* %w
    %u = alloca [2 x [10 x i8]]
    store [2 x [10 x i8]] %24, [2 x [10 x i8]]* %u
    %25 = load [2 x [10 x i8]], [2 x [10 x i8]]* %u
    call void([2 x [10 x i8]])@kk([2 x [10 x i8]] %25)
    ret i32 0
}


