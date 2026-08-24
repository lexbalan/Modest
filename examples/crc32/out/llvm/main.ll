
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
%Float = type %Float32;
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
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"

; from import "crc32"
declare void @crc32_init()
declare %Word32 @crc32_run([0 x %Word8]* %buf, %Nat32 %len)

; end from import "crc32"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 67, i8 82, i8 67, i8 51, i8 50, i8 10, i8 0]
@.str2 = private constant [17 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 100, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str3 = private constant [17 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 100, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@.str4 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@.str5 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str6 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
%Test = type {
	[128 x %Byte],
	%Nat32,
	%Word32
};

@tests = internal global [3 x %Test] [
	%Test {
		[128 x %Byte] [
			%Byte 49,
			%Byte 50,
			%Byte 51,
			%Byte 52,
			%Byte 53,
			%Byte 54,
			%Byte 55,
			%Byte 56,
			%Byte 57,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0
		],
		%Nat32 9,
		%Word32 3421780262
	},
	%Test {
		[128 x %Byte] [
			%Byte 84,
			%Byte 104,
			%Byte 101,
			%Byte 32,
			%Byte 113,
			%Byte 117,
			%Byte 105,
			%Byte 99,
			%Byte 107,
			%Byte 32,
			%Byte 98,
			%Byte 114,
			%Byte 111,
			%Byte 119,
			%Byte 110,
			%Byte 32,
			%Byte 102,
			%Byte 111,
			%Byte 120,
			%Byte 32,
			%Byte 106,
			%Byte 117,
			%Byte 109,
			%Byte 112,
			%Byte 115,
			%Byte 32,
			%Byte 111,
			%Byte 118,
			%Byte 101,
			%Byte 114,
			%Byte 32,
			%Byte 116,
			%Byte 104,
			%Byte 101,
			%Byte 32,
			%Byte 108,
			%Byte 97,
			%Byte 122,
			%Byte 121,
			%Byte 32,
			%Byte 100,
			%Byte 111,
			%Byte 103,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0
		],
		%Nat32 43,
		%Word32 1095738169
	},
	%Test {
		[128 x %Byte] [
			%Byte 84,
			%Byte 101,
			%Byte 115,
			%Byte 116,
			%Byte 32,
			%Byte 118,
			%Byte 101,
			%Byte 99,
			%Byte 116,
			%Byte 111,
			%Byte 114,
			%Byte 32,
			%Byte 102,
			%Byte 114,
			%Byte 111,
			%Byte 109,
			%Byte 32,
			%Byte 102,
			%Byte 101,
			%Byte 98,
			%Byte 111,
			%Byte 111,
			%Byte 116,
			%Byte 105,
			%Byte 46,
			%Byte 99,
			%Byte 111,
			%Byte 109,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0
		],
		%Nat32 28,
		%Word32 210206561
	}
]
define internal %Bool @runTest(%Test* %test) {
	%1 = getelementptr %Test, %Test* %test, %Int32 0, %Int32 0
	%2 = bitcast [128 x %Byte]* %1 to [0 x %Byte]*
	%3 = getelementptr %Test, %Test* %test, %Int32 0, %Int32 1
	%4 = load %Nat32, %Nat32* %3
	%5 = call %Word32 @crc32_run([0 x %Byte]* %2, %Nat32 %4)
	%6 = getelementptr %Test, %Test* %test, %Int32 0, %Int32 2
	%7 = load %Word32, %Word32* %6
	%8 = icmp eq %Word32 %5, %7
	ret %Bool %8
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str1 to [0 x i8]*))
	call void @crc32_init()
	%2 = alloca %Bool, align 1
	store %Bool 1, %Bool* %2
	%3 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %3
; while_1
	br label %again_1
again_1:
	%4 = load %Nat32, %Nat32* %3
	%5 = icmp ult %Nat32 %4, 3
	br %Bool %5 , label %body_1, label %break_1
body_1:
; if_0
	%6 = load %Nat32, %Nat32* %3
	%7 = bitcast %Nat32 %6 to %Nat32
	%8 = getelementptr [3 x %Test], [3 x %Test]* @tests, %Int32 0, %Nat32 %7
	%9 = call %Bool @runTest(%Test* %8)
	%10 = xor %Bool %9, 1
	br %Bool %10 , label %then_0, label %else_0
then_0:
	%11 = load %Nat32, %Nat32* %3
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str2 to [0 x i8]*), %Nat32 %11)
	store %Bool 0, %Bool* %2
	br label %endif_0
else_0:
	%13 = load %Nat32, %Nat32* %3
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str3 to [0 x i8]*), %Nat32 %13)
	br label %endif_0
endif_0:
	%15 = load %Nat32, %Nat32* %3
	%16 = add %Nat32 %15, 1
	store %Nat32 %16, %Nat32* %3
	br label %again_1
break_1:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @.str4 to [0 x i8]*))
; if_1
	%18 = load %Bool, %Bool* %2
	%19 = xor %Bool %18, 1
	br %Bool %19 , label %then_1, label %endif_1
then_1:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str5 to [0 x i8]*))
	ret %Int 1
	br label %endif_1
endif_1:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str6 to [0 x i8]*))
	ret %Int 0
}


