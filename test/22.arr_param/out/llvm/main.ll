
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Float32 = type float
%Float64 = type double
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%VA_List = type i8*

declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8
%Char = type i8
%ConstChar = type %Char
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




%FILE = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare %Int @setvbuf(%FILE* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%FILE* %stream, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
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
@str11 = private constant [2 x i8] [i8 10, i8 0]
@str12 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str13 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str14 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str15 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str16 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str17 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str18 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str19 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str20 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str21 = private constant [4 x i8] [i8 37, i8 99, i8 10, i8 0]
@str22 = private constant [2 x i8] [i8 10, i8 0]
@str23 = private constant [21 x i8] [i8 114, i8 101, i8 116, i8 117, i8 114, i8 110, i8 101, i8 100, i8 95, i8 115, i8 116, i8 114, i8 105, i8 110, i8 103, i8 32, i8 61, i8 32, i8 37, i8 115, i8 0]
@str24 = private constant [14 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 32, i8 115, i8 119, i8 97, i8 112, i8 58, i8 10, i8 0]
@str25 = private constant [11 x i8] [i8 97, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str26 = private constant [11 x i8] [i8 97, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str27 = private constant [13 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 115, i8 119, i8 97, i8 112, i8 58, i8 10, i8 0]
@str28 = private constant [11 x i8] [i8 98, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str29 = private constant [11 x i8] [i8 98, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]



define [2 x i32] @swap([2 x i32] %x) {
    %1 = alloca [2 x i32]
    %2 = getelementptr inbounds [2 x i32], [2 x i32]* %1, i32 0, i32 0
    %3 = extractvalue [2 x i32] %x, 1
    store i32 %3, i32* %2
    %4 = getelementptr inbounds [2 x i32], [2 x i32]* %1, i32 0, i32 1
    %5 = extractvalue [2 x i32] %x, 0
    store i32 %5, i32* %4
    %6 = load [2 x i32], [2 x i32]* %1
    ret [2 x i32] %6
}

define [7 x i8] @ret_str() {
    %1 = insertvalue [7 x i8] zeroinitializer, i8 104, 0
    %2 = insertvalue [7 x i8] %1, i8 101, 1
    %3 = insertvalue [7 x i8] %2, i8 108, 2
    %4 = insertvalue [7 x i8] %3, i8 108, 3
    %5 = insertvalue [7 x i8] %4, i8 111, 4
    %6 = insertvalue [7 x i8] %5, i8 33, 5
    %7 = insertvalue [7 x i8] %6, i8 10, 6
    ret [7 x i8] %7
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
    store [2 x [10 x i8]] %23, [2 x [10 x i8]]* %0ret void
}

define void @kk([2 x [10 x i8]] %x) {
    %1 = extractvalue [2 x [10 x i8]] %x, 0
    %2 = extractvalue [10 x i8] %1, 0
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str1 to [0 x i8]*), i8 %2)
    %4 = extractvalue [2 x [10 x i8]] %x, 0
    %5 = extractvalue [10 x i8] %4, 1
    %6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str2 to [0 x i8]*), i8 %5)
    %7 = extractvalue [2 x [10 x i8]] %x, 0
    %8 = extractvalue [10 x i8] %7, 2
    %9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str3 to [0 x i8]*), i8 %8)
    %10 = extractvalue [2 x [10 x i8]] %x, 0
    %11 = extractvalue [10 x i8] %10, 3
    %12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str4 to [0 x i8]*), i8 %11)
    %13 = extractvalue [2 x [10 x i8]] %x, 0
    %14 = extractvalue [10 x i8] %13, 4
    %15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str5 to [0 x i8]*), i8 %14)
    %16 = extractvalue [2 x [10 x i8]] %x, 0
    %17 = extractvalue [10 x i8] %16, 5
    %18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str6 to [0 x i8]*), i8 %17)
    %19 = extractvalue [2 x [10 x i8]] %x, 0
    %20 = extractvalue [10 x i8] %19, 6
    %21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str7 to [0 x i8]*), i8 %20)
    %22 = extractvalue [2 x [10 x i8]] %x, 0
    %23 = extractvalue [10 x i8] %22, 7
    %24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str8 to [0 x i8]*), i8 %23)
    %25 = extractvalue [2 x [10 x i8]] %x, 0
    %26 = extractvalue [10 x i8] %25, 8
    %27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str9 to [0 x i8]*), i8 %26)
    %28 = extractvalue [2 x [10 x i8]] %x, 0
    %29 = extractvalue [10 x i8] %28, 9
    %30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str10 to [0 x i8]*), i8 %29)
    %31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str11 to [0 x i8]*))
    %32 = extractvalue [2 x [10 x i8]] %x, 1
    %33 = extractvalue [10 x i8] %32, 0
    %34 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str12 to [0 x i8]*), i8 %33)
    %35 = extractvalue [2 x [10 x i8]] %x, 1
    %36 = extractvalue [10 x i8] %35, 1
    %37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str13 to [0 x i8]*), i8 %36)
    %38 = extractvalue [2 x [10 x i8]] %x, 1
    %39 = extractvalue [10 x i8] %38, 2
    %40 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str14 to [0 x i8]*), i8 %39)
    %41 = extractvalue [2 x [10 x i8]] %x, 1
    %42 = extractvalue [10 x i8] %41, 3
    %43 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str15 to [0 x i8]*), i8 %42)
    %44 = extractvalue [2 x [10 x i8]] %x, 1
    %45 = extractvalue [10 x i8] %44, 4
    %46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str16 to [0 x i8]*), i8 %45)
    %47 = extractvalue [2 x [10 x i8]] %x, 1
    %48 = extractvalue [10 x i8] %47, 5
    %49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str17 to [0 x i8]*), i8 %48)
    %50 = extractvalue [2 x [10 x i8]] %x, 1
    %51 = extractvalue [10 x i8] %50, 6
    %52 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str18 to [0 x i8]*), i8 %51)
    %53 = extractvalue [2 x [10 x i8]] %x, 1
    %54 = extractvalue [10 x i8] %53, 7
    %55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str19 to [0 x i8]*), i8 %54)
    %56 = extractvalue [2 x [10 x i8]] %x, 1
    %57 = extractvalue [10 x i8] %56, 8
    %58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str20 to [0 x i8]*), i8 %57)
    %59 = extractvalue [2 x [10 x i8]] %x, 1
    %60 = extractvalue [10 x i8] %59, 9
    %61 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str21 to [0 x i8]*), i8 %60)
    %62 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str22 to [0 x i8]*))
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


define %Int @main() {
    ; function returns array
    %1 = alloca [7 x i8]
    %2 = call [7 x i8] () @ret_str()
    store [7 x i8] %2, [7 x i8]* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str23 to [0 x i8]*), [7 x i8]* %1)
    ; function receive array & return array
    %4 = alloca [2 x i32]
    %5 = getelementptr inbounds [2 x i32], [2 x i32]* %4, i32 0, i32 0
    store i32 10, i32* %5
    %6 = getelementptr inbounds [2 x i32], [2 x i32]* %4, i32 0, i32 1
    store i32 20, i32* %6
    %7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str24 to [0 x i8]*))
    %8 = getelementptr inbounds [2 x i32], [2 x i32]* %4, i32 0, i32 0
    %9 = load i32, i32* %8
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str25 to [0 x i8]*), i32 %9)
    %11 = getelementptr inbounds [2 x i32], [2 x i32]* %4, i32 0, i32 1
    %12 = load i32, i32* %11
    %13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str26 to [0 x i8]*), i32 %12)
    %14 = load [2 x i32], [2 x i32]* %4
    %15 = call [2 x i32] ([2 x i32]) @swap([2 x i32] %14)
    %16 = alloca [2 x i32]
    store [2 x i32] %15, [2 x i32]* %16
    %17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str27 to [0 x i8]*))
    %18 = getelementptr inbounds [2 x i32], [2 x i32]* %16, i32 0, i32 0
    %19 = load i32, i32* %18
    %20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str28 to [0 x i8]*), i32 %19)
    %21 = getelementptr inbounds [2 x i32], [2 x i32]* %16, i32 0, i32 1
    %22 = load i32, i32* %21
    %23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str29 to [0 x i8]*), i32 %22)
    %24 = alloca [2 x [10 x i8]]
    %25 = getelementptr inbounds [2 x [10 x i8]], [2 x [10 x i8]]* %24, i32 0, i32 0
    %26 = insertvalue [10 x i8] zeroinitializer, i8 104, 0
    %27 = insertvalue [10 x i8] %26, i8 101, 1
    %28 = insertvalue [10 x i8] %27, i8 108, 2
    %29 = insertvalue [10 x i8] %28, i8 108, 3
    %30 = insertvalue [10 x i8] %29, i8 111, 4
    %31 = insertvalue [10 x i8] %30, i8 0, 5
    %32 = insertvalue [10 x i8] %31, i8 0, 6
    %33 = insertvalue [10 x i8] %32, i8 0, 7
    %34 = insertvalue [10 x i8] %33, i8 0, 8
    %35 = insertvalue [10 x i8] %34, i8 0, 9
    store [10 x i8] %35, [10 x i8]* %25
    %36 = getelementptr inbounds [2 x [10 x i8]], [2 x [10 x i8]]* %24, i32 0, i32 1
    %37 = insertvalue [10 x i8] zeroinitializer, i8 119, 0
    %38 = insertvalue [10 x i8] %37, i8 111, 1
    %39 = insertvalue [10 x i8] %38, i8 114, 2
    %40 = insertvalue [10 x i8] %39, i8 108, 3
    %41 = insertvalue [10 x i8] %40, i8 100, 4
    %42 = insertvalue [10 x i8] %41, i8 0, 5
    %43 = insertvalue [10 x i8] %42, i8 0, 6
    %44 = insertvalue [10 x i8] %43, i8 0, 7
    %45 = insertvalue [10 x i8] %44, i8 0, 8
    %46 = insertvalue [10 x i8] %45, i8 0, 9
    store [10 x i8] %46, [10 x i8]* %36
    %47 = load [2 x [10 x i8]], [2 x [10 x i8]]* %24
    %48 = alloca [2 x [10 x i8]]
    store [2 x [10 x i8]] %47, [2 x [10 x i8]]* %48
    %49 = load [2 x [10 x i8]], [2 x [10 x i8]]* %48
    call void ([2 x [10 x i8]]) @kk([2 x [10 x i8]] %49)
    ret %Int 0
}


