
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
@.str1 = private constant [7 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 33, i8 0]
@.str2 = private constant [7 x i16] [i16 72, i16 101, i16 108, i16 108, i16 111, i16 33, i16 0]
@.str3 = private constant [7 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 33, i32 0]
@.str4 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 10, i8 0]
@.str5 = private constant [22 x i8] [i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 73, i8 110, i8 116, i8 67, i8 111, i8 110, i8 115, i8 116, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str6 = private constant [17 x i8] [i8 105, i8 110, i8 116, i8 51, i8 50, i8 67, i8 111, i8 110, i8 115, i8 116, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str7 = private constant [19 x i8] [i8 115, i8 116, i8 114, i8 105, i8 110, i8 103, i8 56, i8 67, i8 111, i8 110, i8 115, i8 116, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
; -- endstrings --
%Point = type {
	%Nat32,
	%Nat32
};

%X = type {
	%Point,
	[2 x %Point]
};

@ps = constant [3 x {
	i8,
	i8
}] [
	{
	i8,
	i8
} {
		i8 0,
		i8 0
	},
	{
	i8,
	i8
} {
		i8 1,
		i8 1
	},
	{
	i8,
	i8
} {
		i8 2,
		i8 2
	}
]
@points = constant [3 x %Point] [
	%Point {
		%Nat32 0,
		%Nat32 0
	},
	%Point {
		%Nat32 1,
		%Nat32 1
	},
	%Point {
		%Nat32 2,
		%Nat32 2
	}
]
@zeroPoints = constant [3 x %Point] [
	%Point {
		%Nat32 1,
		%Nat32 1
	},
	%Point {
		%Nat32 1,
		%Nat32 1
	},
	%Point {
		%Nat32 1,
		%Nat32 1
	}
]
@x = internal global %X {
	%Point {
		%Nat32 10,
		%Nat32 20
	},
	[2 x %Point] [
		%Point {
			%Nat32 20,
			%Nat32 30
		},
		%Point {
			%Nat32 20,
			%Nat32 30
		}
	]
}
@points2 = internal global [3 x %Point] [
	%Point {
		%Nat32 0,
		%Nat32 0
	},
	%Point {
		%Nat32 1,
		%Nat32 1
	},
	%Point {
		%Nat32 2,
		%Nat32 2
	}
]
define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str4 to [0 x i8]*))
	%2 = alloca %X, align 4
	%3 = insertvalue %Point zeroinitializer, %Nat32 10, 0
	%4 = insertvalue %Point %3, %Nat32 20, 1
	%5 = insertvalue %X zeroinitializer, %Point %4, 0
	%6 = insertvalue %Point zeroinitializer, %Nat32 20, 0
	%7 = insertvalue %Point %6, %Nat32 30, 1
	%8 = insertvalue [2 x %Point] zeroinitializer, %Point %7, 0
	%9 = insertvalue %X %5, [2 x %Point] %8, 1
	store %X %9, %X* %2
	%10 = alloca [3 x %Point], align 4
	%11 = load [3 x %Point], [3 x %Point]* @points
	%12 = zext i8 3 to %Nat32
	store [3 x %Point] %11, [3 x %Point]* %10
	%13 = alloca %Point
	store %Point zeroinitializer, %Point* %13
	%14 = insertvalue %Point zeroinitializer, %Nat32 1, 0
	%15 = insertvalue %Point %14, %Nat32 1, 1
	%16 = alloca %Point
	store %Point %15, %Point* %16
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str5 to [0 x i8]*), %Int32 42)
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str6 to [0 x i8]*), %Int32 42)
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @.str7 to [0 x i8]*), %Str8* bitcast ([7 x i8]* @.str1 to [0 x i8]*))
	ret %Int 0
}


