
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
    %2 = bitcast i32* @glb_i0 to i8*
    %3 = bitcast i32* @glb_i1 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %2, i8* %3, i32 4, i1 0)
    %4 = load i32, i32* @glb_i0
    %5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), i32 %4)
    ; copy arrays by value
    %6 = bitcast [10 x i32]* @glb_a0 to i8*
    %7 = bitcast [10 x i32]* @glb_a1 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %6, i8* %7, i32 40, i1 0)
    %8 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 0
    %9 = load i32, i32* %8
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str3 to [0 x i8]*), i32 %9)
    %11 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 1
    %12 = load i32, i32* %11
    %13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str4 to [0 x i8]*), i32 %12)
    %14 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 2
    %15 = load i32, i32* %14
    %16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), i32 %15)
    ; copy records by value
    %17 = bitcast %Point* @glb_r0 to i8*
    %18 = bitcast %Point* @glb_r1 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %17, i8* %18, i32 8, i1 0)
    %19 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 0
    %20 = load i32, i32* %19
    %21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), i32 %20)
    %22 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 1
    %23 = load i32, i32* %22
    %24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i32 %23)
    ; -----------------------------------
    ; Local
    ; copy integers by value
    %25 = alloca i32
    store i32 0, i32* %25
    %26 = alloca i32
    store i32 123, i32* %26
    %27 = bitcast i32* %25 to i8*
    %28 = bitcast i32* %26 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %27, i8* %28, i32 4, i1 0)
    %29 = load i32, i32* %25
    %30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*), i32 %29)
    ; copy arrays by value
    ; C backend will be use memcpy()
    %31 = alloca [10 x i32]
    %32 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
    %33 = insertvalue [10 x i32] %32, i32 0, 1
    %34 = insertvalue [10 x i32] %33, i32 0, 2
    %35 = insertvalue [10 x i32] %34, i32 0, 3
    %36 = insertvalue [10 x i32] %35, i32 0, 4
    %37 = insertvalue [10 x i32] %36, i32 0, 5
    %38 = insertvalue [10 x i32] %37, i32 0, 6
    %39 = insertvalue [10 x i32] %38, i32 0, 7
    %40 = insertvalue [10 x i32] %39, i32 0, 8
    %41 = insertvalue [10 x i32] %40, i32 0, 9
    store [10 x i32] %41, [10 x i32]* %31
    %42 = alloca [10 x i32]
    %43 = insertvalue [10 x i32] zeroinitializer, i32 42, 0
    %44 = insertvalue [10 x i32] %43, i32 53, 1
    %45 = insertvalue [10 x i32] %44, i32 64, 2
    %46 = insertvalue [10 x i32] %45, i32 0, 3
    %47 = insertvalue [10 x i32] %46, i32 0, 4
    %48 = insertvalue [10 x i32] %47, i32 0, 5
    %49 = insertvalue [10 x i32] %48, i32 0, 6
    %50 = insertvalue [10 x i32] %49, i32 0, 7
    %51 = insertvalue [10 x i32] %50, i32 0, 8
    %52 = insertvalue [10 x i32] %51, i32 0, 9
    store [10 x i32] %52, [10 x i32]* %42
    %53 = bitcast [10 x i32]* %31 to i8*
    %54 = bitcast [10 x i32]* %42 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %53, i8* %54, i32 40, i1 0)
    %55 = getelementptr inbounds [10 x i32], [10 x i32]* %31, i32 0, i32 0
    %56 = load i32, i32* %55
    %57 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str9 to [0 x i8]*), i32 %56)
    %58 = getelementptr inbounds [10 x i32], [10 x i32]* %31, i32 0, i32 1
    %59 = load i32, i32* %58
    %60 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str10 to [0 x i8]*), i32 %59)
    %61 = getelementptr inbounds [10 x i32], [10 x i32]* %31, i32 0, i32 2
    %62 = load i32, i32* %61
    %63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), i32 %62)
    ; copy records by value
    ; C backend will be use memcpy()
    %64 = alloca %Point
    store %Point zeroinitializer, %Point* %64
    %65 = alloca %Point
    %66 = insertvalue %Point zeroinitializer, i32 10, 0
    %67 = insertvalue %Point %66, i32 20, 1
    store %Point %67, %Point* %65
    %68 = bitcast %Point* %64 to i8*
    %69 = bitcast %Point* %65 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %68, i8* %69, i32 8, i1 0)
    %70 = getelementptr inbounds %Point, %Point* %64, i32 0, i32 0
    %71 = load i32, i32* %70
    %72 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str12 to [0 x i8]*), i32 %71)
    %73 = getelementptr inbounds %Point, %Point* %64, i32 0, i32 1
    %74 = load i32, i32* %73
    %75 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %74)
    %76 = alloca [15 x [16 x i32]]
    %77 = alloca i32
    store i32 0, i32* %77
    br label %again_1
again_1:
    %78 = load i32, i32* %77
    %79 = icmp slt i32 %78, 16
    br i1 %79 , label %body_1, label %break_1
body_1:
    %80 = alloca i32
    store i32 0, i32* %80
    br label %again_2
again_2:
    %81 = load i32, i32* %80
    %82 = icmp slt i32 %81, 16
    br i1 %82 , label %body_2, label %break_2
body_2:
    %83 = load i32, i32* %77
    %84 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %76, i32 0, i32 %83
    %85 = load i32, i32* %80
    %86 = getelementptr inbounds [16 x i32], [16 x i32]* %84, i32 0, i32 %85
    %87 = load i32, i32* %77
    %88 = load i32, i32* %80
    %89 = mul i32 %87, %88
    store i32 %89, i32* %86
    %90 = load i32, i32* %80
    %91 = add i32 %90, 1
    store i32 %91, i32* %80
    br label %again_2
break_2:
    %92 = load i32, i32* %77
    %93 = add i32 %92, 1
    store i32 %93, i32* %77
    br label %again_1
break_1:
    store i32 0, i32* %77
    br label %again_3
again_3:
    %94 = load i32, i32* %77
    %95 = icmp slt i32 %94, 16
    br i1 %95 , label %body_3, label %break_3
body_3:
    %96 = alloca i32
    store i32 0, i32* %96
    br label %again_4
again_4:
    %97 = load i32, i32* %96
    %98 = icmp slt i32 %97, 16
    br i1 %98 , label %body_4, label %break_4
body_4:
    %99 = load i32, i32* %77
    %100 = load i32, i32* %96
    %101 = load i32, i32* %77
    %102 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %76, i32 0, i32 %101
    %103 = load i32, i32* %96
    %104 = getelementptr inbounds [16 x i32], [16 x i32]* %102, i32 0, i32 %103
    %105 = load i32, i32* %104
    %106 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str14 to [0 x i8]*), i32 %99, i32 %100, i32 %105)
    %107 = load i32, i32* %96
    %108 = add i32 %107, 1
    store i32 %108, i32* %96
    br label %again_4
break_4:
    %109 = load i32, i32* %77
    %110 = add i32 %109, 1
    store i32 %110, i32* %77
    br label %again_3
break_3:
    %111 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %76, i32 0, i32 3
    %112 = load [16 x i32], [16 x i32]* %111
    %113 = alloca [16 x i32]
    store [16 x i32] %112, [16 x i32]* %113
    store i32 0, i32* %77
    br label %again_5
again_5:
    %114 = load i32, i32* %77
    %115 = icmp slt i32 %114, 16
    br i1 %115 , label %body_5, label %break_5
body_5:
    %116 = load i32, i32* %77
    %117 = load i32, i32* %77
    %118 = getelementptr inbounds [16 x i32], [16 x i32]* %113, i32 0, i32 %117
    %119 = load i32, i32* %118
    %120 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str15 to [0 x i8]*), i32 %116, i32 %119)
    %121 = load i32, i32* %77
    %122 = add i32 %121, 1
    store i32 %122, i32* %77
    br label %again_5
break_5:
    ret %Int 0
}


