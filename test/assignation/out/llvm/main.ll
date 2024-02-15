
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
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %2, i8 0, i32 4, i1 0)
    %3 = bitcast i32* @glb_i0 to i8*
    %4 = bitcast i32* @glb_i1 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %3, i8* %4, i32 4, i1 0)
    %5 = load i32, i32* @glb_i0
    %6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), i32 %5)
    ; copy arrays by value
    %7 = bitcast [10 x i32]* @glb_a0 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %7, i8 0, i32 40, i1 0)
    %8 = bitcast [10 x i32]* @glb_a0 to i8*
    %9 = bitcast [10 x i32]* @glb_a1 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %8, i8* %9, i32 40, i1 0)
    %10 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 0
    %11 = load i32, i32* %10
    %12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str3 to [0 x i8]*), i32 %11)
    %13 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 1
    %14 = load i32, i32* %13
    %15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str4 to [0 x i8]*), i32 %14)
    %16 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 2
    %17 = load i32, i32* %16
    %18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), i32 %17)
    ; copy records by value
    %19 = bitcast %Point* @glb_r0 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %19, i8 0, i32 8, i1 0)
    %20 = bitcast %Point* @glb_r0 to i8*
    %21 = bitcast %Point* @glb_r1 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %20, i8* %21, i32 8, i1 0)
    %22 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 0
    %23 = load i32, i32* %22
    %24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), i32 %23)
    %25 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 1
    %26 = load i32, i32* %25
    %27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i32 %26)
    ; -----------------------------------
    ; Local
    ; copy integers by value
    %28 = alloca i32
    store i32 0, i32* %28
    %29 = alloca i32
    store i32 123, i32* %29
    %30 = bitcast i32* %28 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %30, i8 0, i32 4, i1 0)
    %31 = bitcast i32* %28 to i8*
    %32 = bitcast i32* %29 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %31, i8* %32, i32 4, i1 0)
    %33 = load i32, i32* %28
    %34 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*), i32 %33)
    ; copy arrays by value
    ; C backend will be use memcpy()
    %35 = alloca [10 x i32]
    %36 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
    %37 = insertvalue [10 x i32] %36, i32 0, 1
    %38 = insertvalue [10 x i32] %37, i32 0, 2
    %39 = insertvalue [10 x i32] %38, i32 0, 3
    %40 = insertvalue [10 x i32] %39, i32 0, 4
    %41 = insertvalue [10 x i32] %40, i32 0, 5
    %42 = insertvalue [10 x i32] %41, i32 0, 6
    %43 = insertvalue [10 x i32] %42, i32 0, 7
    %44 = insertvalue [10 x i32] %43, i32 0, 8
    %45 = insertvalue [10 x i32] %44, i32 0, 9
    store [10 x i32] %45, [10 x i32]* %35
    %46 = alloca [10 x i32]
    %47 = insertvalue [10 x i32] zeroinitializer, i32 42, 0
    %48 = insertvalue [10 x i32] %47, i32 53, 1
    %49 = insertvalue [10 x i32] %48, i32 64, 2
    %50 = insertvalue [10 x i32] %49, i32 0, 3
    %51 = insertvalue [10 x i32] %50, i32 0, 4
    %52 = insertvalue [10 x i32] %51, i32 0, 5
    %53 = insertvalue [10 x i32] %52, i32 0, 6
    %54 = insertvalue [10 x i32] %53, i32 0, 7
    %55 = insertvalue [10 x i32] %54, i32 0, 8
    %56 = insertvalue [10 x i32] %55, i32 0, 9
    store [10 x i32] %56, [10 x i32]* %46
    %57 = bitcast [10 x i32]* %35 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %57, i8 0, i32 40, i1 0)
    %58 = bitcast [10 x i32]* %35 to i8*
    %59 = bitcast [10 x i32]* %46 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %58, i8* %59, i32 40, i1 0)
    %60 = getelementptr inbounds [10 x i32], [10 x i32]* %35, i32 0, i32 0
    %61 = load i32, i32* %60
    %62 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str9 to [0 x i8]*), i32 %61)
    %63 = getelementptr inbounds [10 x i32], [10 x i32]* %35, i32 0, i32 1
    %64 = load i32, i32* %63
    %65 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str10 to [0 x i8]*), i32 %64)
    %66 = getelementptr inbounds [10 x i32], [10 x i32]* %35, i32 0, i32 2
    %67 = load i32, i32* %66
    %68 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), i32 %67)
    ; copy records by value
    ; C backend will be use memcpy()
    %69 = alloca %Point
    store %Point zeroinitializer, %Point* %69
    %70 = alloca %Point
    %71 = insertvalue %Point zeroinitializer, i32 10, 0
    %72 = insertvalue %Point %71, i32 20, 1
    store %Point %72, %Point* %70
    %73 = bitcast %Point* %69 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %73, i8 0, i32 8, i1 0)
    %74 = bitcast %Point* %69 to i8*
    %75 = bitcast %Point* %70 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %74, i8* %75, i32 8, i1 0)
    %76 = getelementptr inbounds %Point, %Point* %69, i32 0, i32 0
    %77 = load i32, i32* %76
    %78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str12 to [0 x i8]*), i32 %77)
    %79 = getelementptr inbounds %Point, %Point* %69, i32 0, i32 1
    %80 = load i32, i32* %79
    %81 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %80)
    %82 = alloca [15 x [16 x i32]]
    %83 = alloca i32
    store i32 0, i32* %83
    br label %again_1
again_1:
    %84 = load i32, i32* %83
    %85 = icmp slt i32 %84, 16
    br i1 %85 , label %body_1, label %break_1
body_1:
    %86 = alloca i32
    store i32 0, i32* %86
    br label %again_2
again_2:
    %87 = load i32, i32* %86
    %88 = icmp slt i32 %87, 16
    br i1 %88 , label %body_2, label %break_2
body_2:
    %89 = load i32, i32* %83
    %90 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %82, i32 0, i32 %89
    %91 = load i32, i32* %86
    %92 = getelementptr inbounds [16 x i32], [16 x i32]* %90, i32 0, i32 %91
    %93 = load i32, i32* %83
    %94 = load i32, i32* %86
    %95 = mul i32 %93, %94
    store i32 %95, i32* %92
    %96 = load i32, i32* %86
    %97 = add i32 %96, 1
    store i32 %97, i32* %86
    br label %again_2
break_2:
    %98 = load i32, i32* %83
    %99 = add i32 %98, 1
    store i32 %99, i32* %83
    br label %again_1
break_1:
    store i32 0, i32* %83
    br label %again_3
again_3:
    %100 = load i32, i32* %83
    %101 = icmp slt i32 %100, 16
    br i1 %101 , label %body_3, label %break_3
body_3:
    %102 = alloca i32
    store i32 0, i32* %102
    br label %again_4
again_4:
    %103 = load i32, i32* %102
    %104 = icmp slt i32 %103, 16
    br i1 %104 , label %body_4, label %break_4
body_4:
    %105 = load i32, i32* %83
    %106 = load i32, i32* %102
    %107 = load i32, i32* %83
    %108 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %82, i32 0, i32 %107
    %109 = load i32, i32* %102
    %110 = getelementptr inbounds [16 x i32], [16 x i32]* %108, i32 0, i32 %109
    %111 = load i32, i32* %110
    %112 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str14 to [0 x i8]*), i32 %105, i32 %106, i32 %111)
    %113 = load i32, i32* %102
    %114 = add i32 %113, 1
    store i32 %114, i32* %102
    br label %again_4
break_4:
    %115 = load i32, i32* %83
    %116 = add i32 %115, 1
    store i32 %116, i32* %83
    br label %again_3
break_3:
    %117 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %82, i32 0, i32 3
    %118 = load [16 x i32], [16 x i32]* %117
    %119 = alloca [16 x i32]
    store [16 x i32] %118, [16 x i32]* %119
    store i32 0, i32* %83
    br label %again_5
again_5:
    %120 = load i32, i32* %83
    %121 = icmp slt i32 %120, 16
    br i1 %121 , label %body_5, label %break_5
body_5:
    %122 = load i32, i32* %83
    %123 = load i32, i32* %83
    %124 = getelementptr inbounds [16 x i32], [16 x i32]* %119, i32 0, i32 %123
    %125 = load i32, i32* %124
    %126 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str15 to [0 x i8]*), i32 %122, i32 %125)
    %127 = load i32, i32* %83
    %128 = add i32 %127, 1
    store i32 %128, i32* %83
    br label %again_5
break_5:
    ret %Int 0
}


