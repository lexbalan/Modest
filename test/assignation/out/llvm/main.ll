
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




%FposT = type opaque
%FILE = type opaque

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

define %Int @main() {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str1 to [0 x i8]*))
    ; -----------------------------------
    ; Global
    ; copy integers by value
    %2 = load i32, i32* @glb_i1
    store i32 %2, i32* @glb_i0
    %3 = load i32, i32* @glb_i0
    %4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), i32 %3)
    ; copy arrays by value
    %5 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 0
    %6 = load i32, i32* %5
    %7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str3 to [0 x i8]*), i32 %6)
    %8 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 1
    %9 = load i32, i32* %8
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str4 to [0 x i8]*), i32 %9)
    %11 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 2
    %12 = load i32, i32* %11
    %13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), i32 %12)
    ; copy records by value
    %14 = load %Point, %Point* @glb_r1
    store %Point %14, %Point* @glb_r0
    %15 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 0
    %16 = load i32, i32* %15
    %17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), i32 %16)
    %18 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 1
    %19 = load i32, i32* %18
    %20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i32 %19)
    ; -----------------------------------
    ; Local
    ; copy integers by value
    %21 = alloca i32
    store i32 0, i32* %21
    %22 = alloca i32
    store i32 123, i32* %22
    %23 = load i32, i32* %22
    store i32 %23, i32* %21
    %24 = load i32, i32* %21
    %25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*), i32 %24)
    ; copy arrays by value
    ; C backend will be use memcpy()
    %26 = alloca [10 x i32]
    %27 = bitcast [10 x i32]* %26 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %27, i8 0, i32 40, i1 0)
    %28 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
    %29 = insertvalue [10 x i32] %28, i32 0, 1
    %30 = insertvalue [10 x i32] %29, i32 0, 2
    %31 = insertvalue [10 x i32] %30, i32 0, 3
    %32 = insertvalue [10 x i32] %31, i32 0, 4
    %33 = insertvalue [10 x i32] %32, i32 0, 5
    %34 = insertvalue [10 x i32] %33, i32 0, 6
    %35 = insertvalue [10 x i32] %34, i32 0, 7
    %36 = insertvalue [10 x i32] %35, i32 0, 8
    %37 = insertvalue [10 x i32] %36, i32 0, 9
    store [10 x i32] %37, [10 x i32]* %26
    %38 = alloca [10 x i32]
    %39 = bitcast [10 x i32]* %38 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %39, i8 0, i32 40, i1 0)
    %40 = insertvalue [10 x i32] zeroinitializer, i32 42, 0
    %41 = insertvalue [10 x i32] %40, i32 53, 1
    %42 = insertvalue [10 x i32] %41, i32 64, 2
    %43 = insertvalue [10 x i32] %42, i32 0, 3
    %44 = insertvalue [10 x i32] %43, i32 0, 4
    %45 = insertvalue [10 x i32] %44, i32 0, 5
    %46 = insertvalue [10 x i32] %45, i32 0, 6
    %47 = insertvalue [10 x i32] %46, i32 0, 7
    %48 = insertvalue [10 x i32] %47, i32 0, 8
    %49 = insertvalue [10 x i32] %48, i32 0, 9
    store [10 x i32] %49, [10 x i32]* %38
    %50 = getelementptr inbounds [10 x i32], [10 x i32]* %26, i32 0, i32 0
    %51 = load i32, i32* %50
    %52 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str9 to [0 x i8]*), i32 %51)
    %53 = getelementptr inbounds [10 x i32], [10 x i32]* %26, i32 0, i32 1
    %54 = load i32, i32* %53
    %55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str10 to [0 x i8]*), i32 %54)
    %56 = getelementptr inbounds [10 x i32], [10 x i32]* %26, i32 0, i32 2
    %57 = load i32, i32* %56
    %58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), i32 %57)
    ; copy records by value
    ; C backend will be use memcpy()
    %59 = alloca %Point
    store %Point zeroinitializer, %Point* %59
    %60 = insertvalue %Point zeroinitializer, i32 10, 0
    %61 = insertvalue %Point %60, i32 20, 1
    %62 = alloca %Point
    store %Point %61, %Point* %62
    %63 = load %Point, %Point* %62
    store %Point %63, %Point* %59
    %64 = getelementptr inbounds %Point, %Point* %59, i32 0, i32 0
    %65 = load i32, i32* %64
    %66 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str12 to [0 x i8]*), i32 %65)
    %67 = getelementptr inbounds %Point, %Point* %59, i32 0, i32 1
    %68 = load i32, i32* %67
    %69 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %68)
    %70 = alloca [15 x [16 x i32]]
    %71 = alloca i32
    store i32 0, i32* %71
    br label %again_1
again_1:
    %72 = load i32, i32* %71
    %73 = icmp slt i32 %72, 16
    br i1 %73 , label %body_1, label %break_1
body_1:
    %74 = alloca i32
    store i32 0, i32* %74
    br label %again_2
again_2:
    %75 = load i32, i32* %74
    %76 = icmp slt i32 %75, 16
    br i1 %76 , label %body_2, label %break_2
body_2:
    %77 = load i32, i32* %71
    %78 = load i32, i32* %74
    %79 = mul i32 %77, %78
    %80 = load i32, i32* %71
    %81 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %70, i32 0, i32 %80
    %82 = load i32, i32* %74
    %83 = getelementptr inbounds [16 x i32], [16 x i32]* %81, i32 0, i32 %82
    store i32 %79, i32* %83
    %84 = load i32, i32* %74
    %85 = add i32 %84, 1
    store i32 %85, i32* %74
    br label %again_2
break_2:
    %86 = load i32, i32* %71
    %87 = add i32 %86, 1
    store i32 %87, i32* %71
    br label %again_1
break_1:
    store i32 0, i32* %71
    br label %again_3
again_3:
    %88 = load i32, i32* %71
    %89 = icmp slt i32 %88, 16
    br i1 %89 , label %body_3, label %break_3
body_3:
    %90 = alloca i32
    store i32 0, i32* %90
    br label %again_4
again_4:
    %91 = load i32, i32* %90
    %92 = icmp slt i32 %91, 16
    br i1 %92 , label %body_4, label %break_4
body_4:
    %93 = load i32, i32* %71
    %94 = load i32, i32* %90
    %95 = load i32, i32* %71
    %96 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %70, i32 0, i32 %95
    %97 = load i32, i32* %90
    %98 = getelementptr inbounds [16 x i32], [16 x i32]* %96, i32 0, i32 %97
    %99 = load i32, i32* %98
    %100 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str14 to [0 x i8]*), i32 %93, i32 %94, i32 %99)
    %101 = load i32, i32* %90
    %102 = add i32 %101, 1
    store i32 %102, i32* %90
    br label %again_4
break_4:
    %103 = load i32, i32* %71
    %104 = add i32 %103, 1
    store i32 %104, i32* %71
    br label %again_3
break_3:
    %105 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %70, i32 0, i32 3
    %106 = load [16 x i32], [16 x i32]* %105
    %107 = alloca [16 x i32]
    store [16 x i32] %106, [16 x i32]* %107
    store i32 0, i32* %71
    br label %again_5
again_5:
    %108 = load i32, i32* %71
    %109 = icmp slt i32 %108, 16
    br i1 %109 , label %body_5, label %break_5
body_5:
    %110 = load i32, i32* %71
    %111 = load i32, i32* %71
    %112 = getelementptr inbounds [16 x i32], [16 x i32]* %107, i32 0, i32 %111
    %113 = load i32, i32* %112
    %114 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str15 to [0 x i8]*), i32 %110, i32 %113)
    %115 = load i32, i32* %71
    %116 = add i32 %115, 1
    store i32 %116, i32* %71
    br label %again_5
break_5:
    ret %Int 0
}


