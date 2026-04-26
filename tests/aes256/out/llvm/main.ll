
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



%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
}

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
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
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
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports private 'main' --

; from import "builtin"

; end from import "builtin"

; from import "aes"
%aes256_Result = type %Word8;
%aes256_Key = type [32 x %Byte];
%aes256_Block = type [16 x %Byte];
%aes256_Context = type {
	%aes256_Key,
	%aes256_Key,
	%aes256_Key
};

declare %aes256_Result @aes256_init(%aes256_Context* %ctx, %aes256_Key* %key)
declare %aes256_Result @aes256_encrypt_ecb(%aes256_Context* %ctx, %aes256_Block* %block)
declare %aes256_Result @aes256_decrypt_ecb(%aes256_Context* %ctx, %aes256_Block* %block)
declare %aes256_Result @aes256_deinit(%aes256_Context* %ctx)

; end from import "aes"
; -- end print imports private 'main' --
; -- print imports public 'main' --
; -- end print imports public 'main' --
; -- strings --
@.str1 = private constant [17 x i8] [i8 70, i8 65, i8 73, i8 76, i8 69, i8 68, i8 32, i8 40, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 41, i8 0]
@.str2 = private constant [17 x i8] [i8 70, i8 65, i8 73, i8 76, i8 69, i8 68, i8 32, i8 40, i8 100, i8 101, i8 99, i8 114, i8 121, i8 112, i8 116, i8 41, i8 0]
@.str3 = private constant [7 x i8] [i8 80, i8 65, i8 83, i8 83, i8 69, i8 68, i8 0]
@.str4 = private constant [18 x i8] [i8 114, i8 117, i8 110, i8 32, i8 65, i8 69, i8 83, i8 45, i8 50, i8 53, i8 54, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str5 = private constant [14 x i8] [i8 114, i8 117, i8 110, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 100, i8 32, i8 0]
@.str6 = private constant [2 x i8] [i8 10, i8 0]
@.str7 = private constant [14 x i8] [i8 65, i8 69, i8 83, i8 45, i8 50, i8 53, i8 54, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@.str8 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str9 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
%main_TestCase = type {
	%aes256_Key,
	%aes256_Block,
	%aes256_Block
};

@main_tests = internal global [8 x %main_TestCase] [
	%main_TestCase {
		%aes256_Key [
			%Byte 0,
			%Byte 1,
			%Byte 2,
			%Byte 3,
			%Byte 4,
			%Byte 5,
			%Byte 6,
			%Byte 7,
			%Byte 8,
			%Byte 9,
			%Byte 10,
			%Byte 11,
			%Byte 12,
			%Byte 13,
			%Byte 14,
			%Byte 15,
			%Byte 16,
			%Byte 17,
			%Byte 18,
			%Byte 19,
			%Byte 20,
			%Byte 21,
			%Byte 22,
			%Byte 23,
			%Byte 24,
			%Byte 25,
			%Byte 26,
			%Byte 27,
			%Byte 28,
			%Byte 29,
			%Byte 30,
			%Byte 31
		],
		%aes256_Block [
			%Byte 0,
			%Byte 17,
			%Byte 34,
			%Byte 51,
			%Byte 68,
			%Byte 85,
			%Byte 102,
			%Byte 119,
			%Byte 136,
			%Byte 153,
			%Byte 170,
			%Byte 187,
			%Byte 204,
			%Byte 221,
			%Byte 238,
			%Byte 255
		],
		%aes256_Block [
			%Byte 142,
			%Byte 162,
			%Byte 183,
			%Byte 202,
			%Byte 81,
			%Byte 103,
			%Byte 69,
			%Byte 191,
			%Byte 234,
			%Byte 252,
			%Byte 73,
			%Byte 144,
			%Byte 75,
			%Byte 73,
			%Byte 96,
			%Byte 137
		]
	},
	%main_TestCase {
		%aes256_Key [
			%Byte 96,
			%Byte 61,
			%Byte 235,
			%Byte 16,
			%Byte 21,
			%Byte 202,
			%Byte 113,
			%Byte 190,
			%Byte 43,
			%Byte 115,
			%Byte 174,
			%Byte 240,
			%Byte 133,
			%Byte 125,
			%Byte 119,
			%Byte 129,
			%Byte 31,
			%Byte 53,
			%Byte 44,
			%Byte 7,
			%Byte 59,
			%Byte 97,
			%Byte 8,
			%Byte 215,
			%Byte 45,
			%Byte 152,
			%Byte 16,
			%Byte 163,
			%Byte 9,
			%Byte 20,
			%Byte 223,
			%Byte 244
		],
		%aes256_Block [
			%Byte 107,
			%Byte 193,
			%Byte 190,
			%Byte 226,
			%Byte 46,
			%Byte 64,
			%Byte 159,
			%Byte 150,
			%Byte 233,
			%Byte 61,
			%Byte 126,
			%Byte 17,
			%Byte 115,
			%Byte 147,
			%Byte 23,
			%Byte 42
		],
		%aes256_Block [
			%Byte 243,
			%Byte 238,
			%Byte 209,
			%Byte 189,
			%Byte 181,
			%Byte 210,
			%Byte 160,
			%Byte 60,
			%Byte 6,
			%Byte 75,
			%Byte 90,
			%Byte 126,
			%Byte 61,
			%Byte 177,
			%Byte 129,
			%Byte 248
		]
	},
	%main_TestCase {
		%aes256_Key [
			%Byte 96,
			%Byte 61,
			%Byte 235,
			%Byte 16,
			%Byte 21,
			%Byte 202,
			%Byte 113,
			%Byte 190,
			%Byte 43,
			%Byte 115,
			%Byte 174,
			%Byte 240,
			%Byte 133,
			%Byte 125,
			%Byte 119,
			%Byte 129,
			%Byte 31,
			%Byte 53,
			%Byte 44,
			%Byte 7,
			%Byte 59,
			%Byte 97,
			%Byte 8,
			%Byte 215,
			%Byte 45,
			%Byte 152,
			%Byte 16,
			%Byte 163,
			%Byte 9,
			%Byte 20,
			%Byte 223,
			%Byte 244
		],
		%aes256_Block [
			%Byte 174,
			%Byte 45,
			%Byte 138,
			%Byte 87,
			%Byte 30,
			%Byte 3,
			%Byte 172,
			%Byte 156,
			%Byte 158,
			%Byte 183,
			%Byte 111,
			%Byte 172,
			%Byte 69,
			%Byte 175,
			%Byte 142,
			%Byte 81
		],
		%aes256_Block [
			%Byte 89,
			%Byte 28,
			%Byte 203,
			%Byte 16,
			%Byte 212,
			%Byte 16,
			%Byte 237,
			%Byte 38,
			%Byte 220,
			%Byte 91,
			%Byte 167,
			%Byte 74,
			%Byte 49,
			%Byte 54,
			%Byte 40,
			%Byte 112
		]
	},
	%main_TestCase {
		%aes256_Key [
			%Byte 96,
			%Byte 61,
			%Byte 235,
			%Byte 16,
			%Byte 21,
			%Byte 202,
			%Byte 113,
			%Byte 190,
			%Byte 43,
			%Byte 115,
			%Byte 174,
			%Byte 240,
			%Byte 133,
			%Byte 125,
			%Byte 119,
			%Byte 129,
			%Byte 31,
			%Byte 53,
			%Byte 44,
			%Byte 7,
			%Byte 59,
			%Byte 97,
			%Byte 8,
			%Byte 215,
			%Byte 45,
			%Byte 152,
			%Byte 16,
			%Byte 163,
			%Byte 9,
			%Byte 20,
			%Byte 223,
			%Byte 244
		],
		%aes256_Block [
			%Byte 48,
			%Byte 200,
			%Byte 28,
			%Byte 70,
			%Byte 163,
			%Byte 92,
			%Byte 228,
			%Byte 17,
			%Byte 229,
			%Byte 251,
			%Byte 193,
			%Byte 25,
			%Byte 26,
			%Byte 10,
			%Byte 82,
			%Byte 239
		],
		%aes256_Block [
			%Byte 182,
			%Byte 237,
			%Byte 33,
			%Byte 185,
			%Byte 156,
			%Byte 166,
			%Byte 244,
			%Byte 249,
			%Byte 241,
			%Byte 83,
			%Byte 231,
			%Byte 177,
			%Byte 190,
			%Byte 175,
			%Byte 237,
			%Byte 29
		]
	},
	%main_TestCase {
		%aes256_Key [
			%Byte 96,
			%Byte 61,
			%Byte 235,
			%Byte 16,
			%Byte 21,
			%Byte 202,
			%Byte 113,
			%Byte 190,
			%Byte 43,
			%Byte 115,
			%Byte 174,
			%Byte 240,
			%Byte 133,
			%Byte 125,
			%Byte 119,
			%Byte 129,
			%Byte 31,
			%Byte 53,
			%Byte 44,
			%Byte 7,
			%Byte 59,
			%Byte 97,
			%Byte 8,
			%Byte 215,
			%Byte 45,
			%Byte 152,
			%Byte 16,
			%Byte 163,
			%Byte 9,
			%Byte 20,
			%Byte 223,
			%Byte 244
		],
		%aes256_Block [
			%Byte 246,
			%Byte 159,
			%Byte 36,
			%Byte 69,
			%Byte 223,
			%Byte 79,
			%Byte 155,
			%Byte 23,
			%Byte 173,
			%Byte 43,
			%Byte 65,
			%Byte 123,
			%Byte 230,
			%Byte 108,
			%Byte 55,
			%Byte 16
		],
		%aes256_Block [
			%Byte 35,
			%Byte 48,
			%Byte 75,
			%Byte 122,
			%Byte 57,
			%Byte 249,
			%Byte 243,
			%Byte 255,
			%Byte 6,
			%Byte 125,
			%Byte 141,
			%Byte 143,
			%Byte 158,
			%Byte 36,
			%Byte 236,
			%Byte 199
		]
	},
	%main_TestCase {
		%aes256_Key [
			%Byte 196,
			%Byte 123,
			%Byte 2,
			%Byte 148,
			%Byte 219,
			%Byte 187,
			%Byte 238,
			%Byte 15,
			%Byte 236,
			%Byte 71,
			%Byte 87,
			%Byte 242,
			%Byte 47,
			%Byte 254,
			%Byte 238,
			%Byte 53,
			%Byte 135,
			%Byte 202,
			%Byte 71,
			%Byte 48,
			%Byte 195,
			%Byte 211,
			%Byte 59,
			%Byte 105,
			%Byte 29,
			%Byte 243,
			%Byte 139,
			%Byte 171,
			%Byte 7,
			%Byte 107,
			%Byte 197,
			%Byte 88
		],
		%aes256_Block [
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
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
		%aes256_Block [
			%Byte 70,
			%Byte 242,
			%Byte 251,
			%Byte 52,
			%Byte 45,
			%Byte 111,
			%Byte 10,
			%Byte 180,
			%Byte 119,
			%Byte 71,
			%Byte 111,
			%Byte 197,
			%Byte 1,
			%Byte 36,
			%Byte 44,
			%Byte 95
		]
	},
	%main_TestCase {
		%aes256_Key [
			%Byte 252,
			%Byte 160,
			%Byte 47,
			%Byte 61,
			%Byte 80,
			%Byte 17,
			%Byte 207,
			%Byte 197,
			%Byte 193,
			%Byte 226,
			%Byte 49,
			%Byte 101,
			%Byte 212,
			%Byte 19,
			%Byte 160,
			%Byte 73,
			%Byte 212,
			%Byte 82,
			%Byte 106,
			%Byte 153,
			%Byte 24,
			%Byte 39,
			%Byte 66,
			%Byte 77,
			%Byte 137,
			%Byte 111,
			%Byte 227,
			%Byte 67,
			%Byte 94,
			%Byte 11,
			%Byte 246,
			%Byte 142
		],
		%aes256_Block [
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
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
		%aes256_Block [
			%Byte 23,
			%Byte 154,
			%Byte 73,
			%Byte 199,
			%Byte 18,
			%Byte 21,
			%Byte 75,
			%Byte 191,
			%Byte 251,
			%Byte 230,
			%Byte 231,
			%Byte 168,
			%Byte 74,
			%Byte 24,
			%Byte 226,
			%Byte 32
		]
	},
	%main_TestCase {
		%aes256_Key [
			%Byte 248,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
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
		%aes256_Block [
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
			%Byte 0,
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
		%aes256_Block [
			%Byte 156,
			%Byte 244,
			%Byte 137,
			%Byte 62,
			%Byte 202,
			%Byte 250,
			%Byte 10,
			%Byte 2,
			%Byte 71,
			%Byte 168,
			%Byte 152,
			%Byte 224,
			%Byte 64,
			%Byte 105,
			%Byte 21,
			%Byte 89
		]
	}
]
define internal %Bool @main_runTest(%main_TestCase* %test) {
	%1 = alloca %aes256_Context, align 1
	%2 = getelementptr %main_TestCase, %main_TestCase* %test, %Int32 0, %Int32 0
	%3 = call %aes256_Result @aes256_init(%aes256_Context* %1, %aes256_Key* %2)
	%4 = alloca %aes256_Block, align 1
	%5 = getelementptr %main_TestCase, %main_TestCase* %test, %Int32 0, %Int32 1
	%6 = load %aes256_Block, %aes256_Block* %5
	%7 = zext i8 16 to %Nat32
	store %aes256_Block %6, %aes256_Block* %4
	%8 = getelementptr %main_TestCase, %main_TestCase* %test, %Int32 0, %Int32 1
	%9 = call %aes256_Result @aes256_encrypt_ecb(%aes256_Context* %1, %aes256_Block* %8)
; if_0
	%10 = getelementptr %main_TestCase, %main_TestCase* %test, %Int32 0, %Int32 1
	%11 = getelementptr %main_TestCase, %main_TestCase* %test, %Int32 0, %Int32 2
	%12 = bitcast %aes256_Block* %10 to i8*
	%13 = bitcast %aes256_Block* %11 to i8*
	%14 = call i1 (i8*, i8*, i64) @memeq(i8* %12, i8* %13, %Int64 16)
	%15 = icmp eq %Bool %14, 0
	br %Bool %15 , label %then_0, label %endif_0
then_0:
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str1 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%18 = getelementptr %main_TestCase, %main_TestCase* %test, %Int32 0, %Int32 1
	%19 = call %aes256_Result @aes256_decrypt_ecb(%aes256_Context* %1, %aes256_Block* %18)
; if_1
	%20 = getelementptr %main_TestCase, %main_TestCase* %test, %Int32 0, %Int32 1
	%21 = bitcast %aes256_Block* %20 to i8*
	%22 = bitcast %aes256_Block* %4 to i8*
	%23 = call i1 (i8*, i8*, i64) @memeq(i8* %21, i8* %22, %Int64 16)
	%24 = icmp eq %Bool %23, 0
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str2 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%27 = call %aes256_Result @aes256_deinit(%aes256_Context* %1)
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @.str3 to [0 x i8]*))
	ret %Bool 1
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str4 to [0 x i8]*))
	%2 = alloca %Bool, align 1
	store %Bool 1, %Bool* %2
	%3 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %3
; while_1
	br label %again_1
again_1:
	%4 = load %Nat8, %Nat8* %3
	%5 = icmp ult %Nat8 %4, 8
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %Nat8, %Nat8* %3
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str5 to [0 x i8]*), %Nat8 %6)
	%8 = load %Nat8, %Nat8* %3
	%9 = zext %Nat8 %8 to %Nat32
	%10 = getelementptr [8 x %main_TestCase], [8 x %main_TestCase]* @main_tests, %Int32 0, %Nat32 %9
	%11 = call %Bool @main_runTest(%main_TestCase* %10)
	%12 = load %Bool, %Bool* %2
	%13 = and %Bool %12, %11
	store %Bool %13, %Bool* %2
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str6 to [0 x i8]*))
	%15 = load %Nat8, %Nat8* %3
	%16 = add %Nat8 %15, 1
	store %Nat8 %16, %Nat8* %3
	br label %again_1
break_1:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str7 to [0 x i8]*))
; if_0
	%18 = load %Bool, %Bool* %2
	%19 = xor %Bool %18, 1
	br %Bool %19 , label %then_0, label %endif_0
then_0:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str8 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str9 to [0 x i8]*))
	ret %Int 0
}


