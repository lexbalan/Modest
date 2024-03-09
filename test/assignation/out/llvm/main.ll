
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


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
    %2 = load i32, i32* @glb_i1
    store i32 %2, i32* @glb_i0
    %3 = load i32, i32* @glb_i0
    %4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), i32 %3)
    ; copy arrays by value
    %5 = bitcast [10 x i32]* @glb_a0 to i8*
    %6 = bitcast [10 x i32]* @glb_a1 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %5, i8* %6, i32 40, i1 0)
    %7 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 0
    %8 = load i32, i32* %7
    %9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str3 to [0 x i8]*), i32 %8)
    %10 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 1
    %11 = load i32, i32* %10
    %12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str4 to [0 x i8]*), i32 %11)
    %13 = getelementptr inbounds [10 x i32], [10 x i32]* @glb_a0, i32 0, i32 2
    %14 = load i32, i32* %13
    %15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), i32 %14)
    ; copy records by value
    %16 = bitcast %Point* @glb_r0 to i8*
    %17 = bitcast %Point* @glb_r1 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %16, i8* %17, i32 8, i1 0)
    %18 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 0
    %19 = load i32, i32* %18
    %20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), i32 %19)
    %21 = getelementptr inbounds %Point, %Point* @glb_r0, i32 0, i32 1
    %22 = load i32, i32* %21
    %23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i32 %22)
    ; -----------------------------------
    ; Local
    ; copy integers by value
    %24 = alloca i32
    store i32 0, i32* %24
    %25 = alloca i32
    store i32 123, i32* %25
    %26 = load i32, i32* %25
    store i32 %26, i32* %24
    %27 = load i32, i32* %24
    %28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*), i32 %27)
    ; copy arrays by value
    ; C backend will be use memcpy()
    %29 = alloca [10 x i32]
    %30 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
    %31 = insertvalue [10 x i32] %30, i32 0, 1
    %32 = insertvalue [10 x i32] %31, i32 0, 2
    %33 = insertvalue [10 x i32] %32, i32 0, 3
    %34 = insertvalue [10 x i32] %33, i32 0, 4
    %35 = insertvalue [10 x i32] %34, i32 0, 5
    %36 = insertvalue [10 x i32] %35, i32 0, 6
    %37 = insertvalue [10 x i32] %36, i32 0, 7
    %38 = insertvalue [10 x i32] %37, i32 0, 8
    %39 = insertvalue [10 x i32] %38, i32 0, 9
    store [10 x i32] %39, [10 x i32]* %29
    %40 = alloca [10 x i32]
    %41 = insertvalue [10 x i32] zeroinitializer, i32 42, 0
    %42 = insertvalue [10 x i32] %41, i32 53, 1
    %43 = insertvalue [10 x i32] %42, i32 64, 2
    %44 = insertvalue [10 x i32] %43, i32 0, 3
    %45 = insertvalue [10 x i32] %44, i32 0, 4
    %46 = insertvalue [10 x i32] %45, i32 0, 5
    %47 = insertvalue [10 x i32] %46, i32 0, 6
    %48 = insertvalue [10 x i32] %47, i32 0, 7
    %49 = insertvalue [10 x i32] %48, i32 0, 8
    %50 = insertvalue [10 x i32] %49, i32 0, 9
    store [10 x i32] %50, [10 x i32]* %40
    %51 = bitcast [10 x i32]* %29 to i8*
    %52 = bitcast [10 x i32]* %40 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %51, i8* %52, i32 40, i1 0)
    %53 = getelementptr inbounds [10 x i32], [10 x i32]* %29, i32 0, i32 0
    %54 = load i32, i32* %53
    %55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str9 to [0 x i8]*), i32 %54)
    %56 = getelementptr inbounds [10 x i32], [10 x i32]* %29, i32 0, i32 1
    %57 = load i32, i32* %56
    %58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str10 to [0 x i8]*), i32 %57)
    %59 = getelementptr inbounds [10 x i32], [10 x i32]* %29, i32 0, i32 2
    %60 = load i32, i32* %59
    %61 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), i32 %60)
    ; copy records by value
    ; C backend will be use memcpy()
    %62 = alloca %Point
    store %Point zeroinitializer, %Point* %62
    %63 = alloca %Point
    %64 = insertvalue %Point zeroinitializer, i32 10, 0
    %65 = insertvalue %Point %64, i32 20, 1
    store %Point %65, %Point* %63
    %66 = bitcast %Point* %62 to i8*
    %67 = bitcast %Point* %63 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %66, i8* %67, i32 8, i1 0)
    %68 = getelementptr inbounds %Point, %Point* %62, i32 0, i32 0
    %69 = load i32, i32* %68
    %70 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str12 to [0 x i8]*), i32 %69)
    %71 = getelementptr inbounds %Point, %Point* %62, i32 0, i32 1
    %72 = load i32, i32* %71
    %73 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %72)
    %74 = alloca [15 x [16 x i32]]
    %75 = alloca i32
    store i32 0, i32* %75
    br label %again_1
again_1:
    %76 = load i32, i32* %75
    %77 = icmp slt i32 %76, 16
    br i1 %77 , label %body_1, label %break_1
body_1:
    %78 = alloca i32
    store i32 0, i32* %78
    br label %again_2
again_2:
    %79 = load i32, i32* %78
    %80 = icmp slt i32 %79, 16
    br i1 %80 , label %body_2, label %break_2
body_2:
    %81 = load i32, i32* %75
    %82 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %74, i32 0, i32 %81
    %83 = load i32, i32* %78
    %84 = getelementptr inbounds [16 x i32], [16 x i32]* %82, i32 0, i32 %83
    %85 = load i32, i32* %75
    %86 = load i32, i32* %78
    %87 = mul i32 %85, %86
    store i32 %87, i32* %84
    %88 = load i32, i32* %78
    %89 = add i32 %88, 1
    store i32 %89, i32* %78
    br label %again_2
break_2:
    %90 = load i32, i32* %75
    %91 = add i32 %90, 1
    store i32 %91, i32* %75
    br label %again_1
break_1:
    store i32 0, i32* %75
    br label %again_3
again_3:
    %92 = load i32, i32* %75
    %93 = icmp slt i32 %92, 16
    br i1 %93 , label %body_3, label %break_3
body_3:
    %94 = alloca i32
    store i32 0, i32* %94
    br label %again_4
again_4:
    %95 = load i32, i32* %94
    %96 = icmp slt i32 %95, 16
    br i1 %96 , label %body_4, label %break_4
body_4:
    %97 = load i32, i32* %75
    %98 = load i32, i32* %94
    %99 = load i32, i32* %75
    %100 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %74, i32 0, i32 %99
    %101 = load i32, i32* %94
    %102 = getelementptr inbounds [16 x i32], [16 x i32]* %100, i32 0, i32 %101
    %103 = load i32, i32* %102
    %104 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str14 to [0 x i8]*), i32 %97, i32 %98, i32 %103)
    %105 = load i32, i32* %94
    %106 = add i32 %105, 1
    store i32 %106, i32* %94
    br label %again_4
break_4:
    %107 = load i32, i32* %75
    %108 = add i32 %107, 1
    store i32 %108, i32* %75
    br label %again_3
break_3:
    %109 = getelementptr inbounds [15 x [16 x i32]], [15 x [16 x i32]]* %74, i32 0, i32 3
    %110 = load [16 x i32], [16 x i32]* %109
    %111 = alloca [16 x i32]
    store [16 x i32] %110, [16 x i32]* %111
    store i32 0, i32* %75
    br label %again_5
again_5:
    %112 = load i32, i32* %75
    %113 = icmp slt i32 %112, 16
    br i1 %113 , label %body_5, label %break_5
body_5:
    %114 = load i32, i32* %75
    %115 = load i32, i32* %75
    %116 = getelementptr inbounds [16 x i32], [16 x i32]* %111, i32 0, i32 %115
    %117 = load i32, i32* %116
    %118 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str15 to [0 x i8]*), i32 %114, i32 %117)
    %119 = load i32, i32* %75
    %120 = add i32 %119, 1
    store i32 %120, i32* %75
    br label %again_5
break_5:
    ret %Int 0
}


