
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

@str1 = private constant [15 x i8] [i8 121, i8 91, i8 48, i8 93, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str2 = private constant [15 x i8] [i8 121, i8 91, i8 49, i8 93, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]



%RecordWith2DArray = type {
	[2 x [20 x i32]]
}


define void @yy(%RecordWith2DArray* noalias sret(%RecordWith2DArray) %0) {
    %2 = insertvalue [20 x i32] zeroinitializer, i32 0, 0
    %3 = insertvalue [20 x i32] %2, i32 1, 1
    %4 = insertvalue [20 x i32] %3, i32 2, 2
    %5 = insertvalue [20 x i32] %4, i32 3, 3
    %6 = insertvalue [20 x i32] %5, i32 4, 4
    %7 = insertvalue [20 x i32] %6, i32 5, 5
    %8 = insertvalue [20 x i32] %7, i32 6, 6
    %9 = insertvalue [20 x i32] %8, i32 7, 7
    %10 = insertvalue [20 x i32] %9, i32 8, 8
    %11 = insertvalue [20 x i32] %10, i32 9, 9
    %12 = insertvalue [20 x i32] %11, i32 0, 10
    %13 = insertvalue [20 x i32] %12, i32 0, 11
    %14 = insertvalue [20 x i32] %13, i32 0, 12
    %15 = insertvalue [20 x i32] %14, i32 0, 13
    %16 = insertvalue [20 x i32] %15, i32 0, 14
    %17 = insertvalue [20 x i32] %16, i32 0, 15
    %18 = insertvalue [20 x i32] %17, i32 0, 16
    %19 = insertvalue [20 x i32] %18, i32 0, 17
    %20 = insertvalue [20 x i32] %19, i32 0, 18
    %21 = insertvalue [20 x i32] %20, i32 0, 19
    %22 = insertvalue [20 x i32] zeroinitializer, i32 20, 0
    %23 = insertvalue [20 x i32] %22, i32 21, 1
    %24 = insertvalue [20 x i32] %23, i32 22, 2
    %25 = insertvalue [20 x i32] %24, i32 23, 3
    %26 = insertvalue [20 x i32] %25, i32 24, 4
    %27 = insertvalue [20 x i32] %26, i32 25, 5
    %28 = insertvalue [20 x i32] %27, i32 26, 6
    %29 = insertvalue [20 x i32] %28, i32 27, 7
    %30 = insertvalue [20 x i32] %29, i32 28, 8
    %31 = insertvalue [20 x i32] %30, i32 29, 9
    %32 = insertvalue [20 x i32] %31, i32 0, 10
    %33 = insertvalue [20 x i32] %32, i32 0, 11
    %34 = insertvalue [20 x i32] %33, i32 0, 12
    %35 = insertvalue [20 x i32] %34, i32 0, 13
    %36 = insertvalue [20 x i32] %35, i32 0, 14
    %37 = insertvalue [20 x i32] %36, i32 0, 15
    %38 = insertvalue [20 x i32] %37, i32 0, 16
    %39 = insertvalue [20 x i32] %38, i32 0, 17
    %40 = insertvalue [20 x i32] %39, i32 0, 18
    %41 = insertvalue [20 x i32] %40, i32 0, 19
    %42 = insertvalue [2 x [20 x i32]] zeroinitializer, [20 x i32] %21, 0
    %43 = insertvalue [2 x [20 x i32]] %42, [20 x i32] %41, 1
    %44 = insertvalue %RecordWith2DArray zeroinitializer, [2 x [20 x i32]] %43, 0
    %s = alloca %RecordWith2DArray
    store %RecordWith2DArray %44, %RecordWith2DArray* %s
    %45 = bitcast %RecordWith2DArray* %0 to i8*
    %46 = bitcast %RecordWith2DArray* %s to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %45, i8* %46, i32 160, i1 0)
    ret void
}

define void @inc_items([2 x [20 x i32]]* noalias sret([2 x [20 x i32]]) %0, [2 x [20 x i32]] %x) {
    %x0 = alloca [2 x [20 x i32]]
    store [2 x [20 x i32]] %x, [2 x [20 x i32]]* %x0
    %retval = alloca [2 x [20 x i32]]
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %2 = load i32, i32* %i
    %3 = icmp slt i32 %2, 20
    br i1 %3 , label %body_1, label %break_1
body_1:
    %4 = getelementptr inbounds [2 x [20 x i32]], [2 x [20 x i32]]* %x0, i32 0, i32 0
    %5 = load i32, i32* %i
    %6 = getelementptr inbounds [20 x i32], [20 x i32]* %4, i32 0, i32 %5
    %7 = load i32, i32* %6
    %8 = add i32 %7, 1
    %9 = getelementptr inbounds [2 x [20 x i32]], [2 x [20 x i32]]* %retval, i32 0, i32 0
    %10 = load i32, i32* %i
    %11 = getelementptr inbounds [20 x i32], [20 x i32]* %9, i32 0, i32 %10
    store i32 %8, i32* %11
    %12 = load i32, i32* %i
    %13 = add i32 %12, 1
    store i32 %13, i32* %i
    br label %again_1
break_1:
    store i32 0, i32* %i
    br label %again_2
again_2:
    %14 = load i32, i32* %i
    %15 = icmp slt i32 %14, 20
    br i1 %15 , label %body_2, label %break_2
body_2:
    %16 = getelementptr inbounds [2 x [20 x i32]], [2 x [20 x i32]]* %x0, i32 0, i32 1
    %17 = load i32, i32* %i
    %18 = getelementptr inbounds [20 x i32], [20 x i32]* %16, i32 0, i32 %17
    %19 = load i32, i32* %18
    %20 = add i32 %19, 1
    %21 = getelementptr inbounds [2 x [20 x i32]], [2 x [20 x i32]]* %retval, i32 0, i32 1
    %22 = load i32, i32* %i
    %23 = getelementptr inbounds [20 x i32], [20 x i32]* %21, i32 0, i32 %22
    store i32 %20, i32* %23
    %24 = load i32, i32* %i
    %25 = add i32 %24, 1
    store i32 %25, i32* %i
    br label %again_2
break_2:
    %26 = bitcast [2 x [20 x i32]]* %0 to i8*
    %27 = bitcast [2 x [20 x i32]]* %retval to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %26, i8* %27, i32 160, i1 0)
    ret void
}

define i32 @main() {
    %rec_with_2d_array = alloca %RecordWith2DArray
    call void(%RecordWith2DArray*)@yy(%RecordWith2DArray* %rec_with_2d_array)
    %1 = getelementptr inbounds %RecordWith2DArray, %RecordWith2DArray* %rec_with_2d_array, i32 0, i32 0
    %2 = load [2 x [20 x i32]], [2 x [20 x i32]]* %1
    %array_2d = alloca [2 x [20 x i32]]
    store [2 x [20 x i32]] %2, [2 x [20 x i32]]* %array_2d
    %w = alloca [2 x [20 x i32]]
    %3 = load [2 x [20 x i32]], [2 x [20 x i32]]* %array_2d
    call void([2 x [20 x i32]]*, [2 x [20 x i32]])@inc_items([2 x [20 x i32]]* %w, [2 x [20 x i32]] %3)
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %4 = load i32, i32* %i
    %5 = icmp slt i32 %4, 10
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load i32, i32* %i
    %7 = getelementptr inbounds [2 x [20 x i32]], [2 x [20 x i32]]* %w, i32 0, i32 0
    %8 = load i32, i32* %i
    %9 = getelementptr inbounds [20 x i32], [20 x i32]* %7, i32 0, i32 %8
    %10 = load i32, i32* %9
    %11 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([15 x i8]* @str1 to [0 x i8]*), i32 %6, i32 %10)
    %12 = load i32, i32* %i
    %13 = getelementptr inbounds [2 x [20 x i32]], [2 x [20 x i32]]* %w, i32 0, i32 1
    %14 = load i32, i32* %i
    %15 = getelementptr inbounds [20 x i32], [20 x i32]* %13, i32 0, i32 %14
    %16 = load i32, i32* %15
    %17 = call i32(%ConstCharStr*, ...)@printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), i32 %12, i32 %16)
    %18 = load i32, i32* %i
    %19 = add i32 %18, 1
    store i32 %19, i32* %i
    br label %again_1
break_1:
    %x = alloca [2 x [10 x i8]]
    %20 = insertvalue [10 x i8] zeroinitializer, i8 104, 0
    %21 = insertvalue [10 x i8] %20, i8 101, 1
    %22 = insertvalue [10 x i8] %21, i8 108, 2
    %23 = insertvalue [10 x i8] %22, i8 108, 3
    %24 = insertvalue [10 x i8] %23, i8 111, 4
    %25 = insertvalue [10 x i8] %24, i8 zeroinitializer, 5
    %26 = insertvalue [10 x i8] %25, i8 zeroinitializer, 6
    %27 = insertvalue [10 x i8] %26, i8 zeroinitializer, 7
    %28 = insertvalue [10 x i8] %27, i8 zeroinitializer, 8
    %29 = insertvalue [10 x i8] %28, i8 zeroinitializer, 9
    %30 = getelementptr inbounds [2 x [10 x i8]], [2 x [10 x i8]]* %x, i32 0, i32 0
    store [10 x i8] %29, [10 x i8]* %30
    %31 = insertvalue [10 x i8] zeroinitializer, i8 119, 0
    %32 = insertvalue [10 x i8] %31, i8 111, 1
    %33 = insertvalue [10 x i8] %32, i8 114, 2
    %34 = insertvalue [10 x i8] %33, i8 108, 3
    %35 = insertvalue [10 x i8] %34, i8 100, 4
    %36 = insertvalue [10 x i8] %35, i8 zeroinitializer, 5
    %37 = insertvalue [10 x i8] %36, i8 zeroinitializer, 6
    %38 = insertvalue [10 x i8] %37, i8 zeroinitializer, 7
    %39 = insertvalue [10 x i8] %38, i8 zeroinitializer, 8
    %40 = insertvalue [10 x i8] %39, i8 zeroinitializer, 9
    %41 = getelementptr inbounds [2 x [10 x i8]], [2 x [10 x i8]]* %x, i32 0, i32 1
    store [10 x i8] %40, [10 x i8]* %41
    ;let z = x
    ;ee(z)
    ret i32 0
}


