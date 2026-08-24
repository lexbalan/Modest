
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
@.str1 = private constant [14 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 10, i8 0]
@.str2 = private constant [15 x i8] [i8 102, i8 120, i8 51, i8 50, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@.str3 = private constant [18 x i8] [i8 102, i8 120, i8 54, i8 52, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 49, i8 54, i8 108, i8 108, i8 120, i8 10, i8 0]
@.str4 = private constant [15 x i8] [i8 102, i8 120, i8 51, i8 50, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@.str5 = private constant [18 x i8] [i8 102, i8 120, i8 54, i8 52, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 49, i8 54, i8 108, i8 108, i8 120, i8 10, i8 0]
@.str6 = private constant [13 x i8] [i8 99, i8 51, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@.str7 = private constant [10 x i8] [i8 99, i8 51, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str8 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
; -- endstrings --
@f32 = internal global %Float32 0.0000000000000000
@f64 = internal global %Float64 0.0000000000000000
@fx32 = internal global %Fixed32 0
@fx64 = internal global %Fixed64 0
@arr = internal global [10 x %Fixed64] [
	%Fixed64 6442450944,
	%Fixed64 10737418240,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0
]
define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str1 to [0 x i8]*))
	store %Float32 1.0000000000000000, %Float32* @f32
	store %Float64 1.0000000000000000, %Float64* @f64
	store %Fixed32 65536, %Fixed32* @fx32
	store %Fixed64 4294967296, %Fixed64* @fx64
	%2 = load %Fixed32, %Fixed32* @fx32
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str2 to [0 x i8]*), %Fixed32 %2)
	%4 = load %Fixed64, %Fixed64* @fx64
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str3 to [0 x i8]*), %Fixed64 %4)
	store %Fixed32 98304, %Fixed32* @fx32
	store %Fixed64 6442450944, %Fixed64* @fx64
	%6 = load %Fixed32, %Fixed32* @fx32
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str4 to [0 x i8]*), %Fixed32 %6)
	%8 = load %Fixed64, %Fixed64* @fx64
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str5 to [0 x i8]*), %Fixed64 %8)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str6 to [0 x i8]*), %Fixed32 49152)
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str7 to [0 x i8]*), %Float64 0.7500000000000000)
	%12 = alloca %Fixed32, align 4
	store %Fixed32 49152, %Fixed32* %12
	%13 = load %Fixed32, %Fixed32* %12
	%14 = add %Fixed32 %13, 65536
	%15 = sdiv %Fixed32 %14, 131072
	store %Fixed32 %15, %Fixed32* %12
	%16 = load %Fixed32, %Fixed32* %12
	%17 = sitofp %Fixed32 %16 to %Float64
	%18 = fdiv %Float64 %17, 65536.0000000000000000
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str8 to [0 x i8]*), %Float64 %18)
	ret %Int 0
}


