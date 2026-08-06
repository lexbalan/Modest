
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float32 = type float
%Float64 = type double
%Fixed32 = type i32
%Fixed64 = type i64
%Size = type i64
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)


; MODULE: main

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type %Int64;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [18 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 97, i8 116, i8 105, i8 111, i8 110, i8 10, i8 0]
@.str2 = private constant [13 x i8] [i8 103, i8 108, i8 98, i8 95, i8 105, i8 48, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str3 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str4 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str5 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str6 = private constant [15 x i8] [i8 103, i8 108, i8 98, i8 95, i8 114, i8 48, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str7 = private constant [15 x i8] [i8 103, i8 108, i8 98, i8 95, i8 114, i8 48, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str8 = private constant [13 x i8] [i8 108, i8 111, i8 99, i8 95, i8 105, i8 48, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str9 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str10 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str11 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str12 = private constant [15 x i8] [i8 108, i8 111, i8 99, i8 95, i8 114, i8 48, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str13 = private constant [15 x i8] [i8 108, i8 111, i8 99, i8 95, i8 114, i8 48, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
; -- endstrings --
%Point = type {
	%Int32,
	%Int32
};

@glb_i0 = internal global %Int32 0
@glb_i1 = internal global %Int32 321
@glb_r0 = internal global %Point {
	%Int32 0,
	%Int32 0
}
@glb_r1 = internal global %Point {
	%Int32 20,
	%Int32 10
}
@glb_a0 = internal global [10 x %Int32] zeroinitializer
@glb_a1 = internal global [10 x %Int32] [
	%Int32 64,
	%Int32 53,
	%Int32 42,
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0
]
define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str1 to [0 x i8]*))
	%2 = load %Int32, %Int32* @glb_i1
	store %Int32 %2, %Int32* @glb_i0
	%3 = load %Int32, %Int32* @glb_i0
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str2 to [0 x i8]*), %Int32 %3)
	%5 = load [10 x %Int32], [10 x %Int32]* @glb_a1
	%6 = zext i8 10 to %Nat32
	store [10 x %Int32] %5, [10 x %Int32]* @glb_a0
	%7 = getelementptr [10 x %Int32], [10 x %Int32]* @glb_a0, %Int32 0, %Int32 0
	%8 = load %Int32, %Int32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str3 to [0 x i8]*), %Int32 %8)
	%10 = getelementptr [10 x %Int32], [10 x %Int32]* @glb_a0, %Int32 0, %Int32 1
	%11 = load %Int32, %Int32* %10
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str4 to [0 x i8]*), %Int32 %11)
	%13 = getelementptr [10 x %Int32], [10 x %Int32]* @glb_a0, %Int32 0, %Int32 2
	%14 = load %Int32, %Int32* %13
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str5 to [0 x i8]*), %Int32 %14)
	%16 = load %Point, %Point* @glb_r1
	store %Point %16, %Point* @glb_r0
	%17 = getelementptr %Point, %Point* @glb_r0, %Int32 0, %Int32 0
	%18 = load %Int32, %Int32* %17
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str6 to [0 x i8]*), %Int32 %18)
	%20 = getelementptr %Point, %Point* @glb_r0, %Int32 0, %Int32 1
	%21 = load %Int32, %Int32* %20
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str7 to [0 x i8]*), %Int32 %21)
	%23 = alloca %Int32, align 4
	store %Int32 0, %Int32* %23
	%24 = alloca %Int32, align 4
	store %Int32 123, %Int32* %24
	%25 = load %Int32, %Int32* %24
	store %Int32 %25, %Int32* %23
	%26 = load %Int32, %Int32* %23
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str8 to [0 x i8]*), %Int32 %26)
	%28 = alloca [10 x %Int32], align 4
	%29 = zext i8 10 to %Nat32
	%30 = mul %Nat32 %29, 4
	%31 = bitcast [10 x %Int32]* %28 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %31, i8 0, %Nat32 %30, i1 0)
	%32 = alloca [10 x %Int32], align 4
	%33 = insertvalue [10 x %Int32] zeroinitializer, %Int32 42, 0
	%34 = insertvalue [10 x %Int32] %33, %Int32 53, 1
	%35 = insertvalue [10 x %Int32] %34, %Int32 64, 2
	%36 = zext i8 10 to %Nat32
	store [10 x %Int32] %35, [10 x %Int32]* %32
	%37 = load [10 x %Int32], [10 x %Int32]* %32
	%38 = zext i8 10 to %Nat32
	store [10 x %Int32] %37, [10 x %Int32]* %28
	%39 = getelementptr [10 x %Int32], [10 x %Int32]* %28, %Int32 0, %Int32 0
	%40 = load %Int32, %Int32* %39
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str9 to [0 x i8]*), %Int32 %40)
	%42 = getelementptr [10 x %Int32], [10 x %Int32]* %28, %Int32 0, %Int32 1
	%43 = load %Int32, %Int32* %42
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str10 to [0 x i8]*), %Int32 %43)
	%45 = getelementptr [10 x %Int32], [10 x %Int32]* %28, %Int32 0, %Int32 2
	%46 = load %Int32, %Int32* %45
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str11 to [0 x i8]*), %Int32 %46)
	%48 = alloca %Point, align 4
	store %Point zeroinitializer, %Point* %48
	%49 = alloca %Point, align 4
	%50 = insertvalue %Point zeroinitializer, %Int32 10, 0
	%51 = insertvalue %Point %50, %Int32 20, 1
	store %Point %51, %Point* %49
	%52 = load %Point, %Point* %49
	store %Point %52, %Point* %48
	%53 = getelementptr %Point, %Point* %48, %Int32 0, %Int32 0
	%54 = load %Int32, %Int32* %53
	%55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str12 to [0 x i8]*), %Int32 %54)
	%56 = getelementptr %Point, %Point* %48, %Int32 0, %Int32 1
	%57 = load %Int32, %Int32* %56
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str13 to [0 x i8]*), %Int32 %57)
	ret %Int 0
}


