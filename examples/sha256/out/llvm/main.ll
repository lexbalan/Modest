
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
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
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --
; -- 1
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare [0 x %Char]* @strncpy([0 x %Char]* %dst, [0 x %ConstChar]* %src, %SizeT %n)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)

; from import "sha256"
%sha256_Hash = type [32 x %Word8];
declare void @sha256_hash([0 x %Word8]* %msg, %Nat32 %msgLen, %sha256_Hash* %outHash)

; end from import "sha256"
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [5 x i8] [i8 39, i8 37, i8 115, i8 39, i8 0]
@str2 = private constant [5 x i8] [i8 32, i8 45, i8 62, i8 32, i8 0]
@str3 = private constant [5 x i8] [i8 37, i8 48, i8 50, i8 88, i8 0]
@str4 = private constant [2 x i8] [i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 83, i8 72, i8 65, i8 50, i8 53, i8 54, i8 10, i8 0]
@str6 = private constant [7 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 0]
@str7 = private constant [7 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 0]
@str8 = private constant [14 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 105, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
; -- endstrings --
%SHA256_TestCase = type {
	[32 x %Char8],
	%Nat32,
	%sha256_Hash
};

@test0 = internal global %SHA256_TestCase {
	[32 x %Char8] [
		%Char8 97,
		%Char8 98,
		%Char8 99,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0
	],
	%Nat32 3,
	%sha256_Hash [
		%Word8 186,
		%Word8 120,
		%Word8 22,
		%Word8 191,
		%Word8 143,
		%Word8 1,
		%Word8 207,
		%Word8 234,
		%Word8 65,
		%Word8 65,
		%Word8 64,
		%Word8 222,
		%Word8 93,
		%Word8 174,
		%Word8 34,
		%Word8 35,
		%Word8 176,
		%Word8 3,
		%Word8 97,
		%Word8 163,
		%Word8 150,
		%Word8 23,
		%Word8 122,
		%Word8 156,
		%Word8 180,
		%Word8 16,
		%Word8 255,
		%Word8 97,
		%Word8 242,
		%Word8 0,
		%Word8 21,
		%Word8 173
	]
}
@test1 = internal global %SHA256_TestCase {
	[32 x %Char8] [
		%Char8 72,
		%Char8 101,
		%Char8 108,
		%Char8 108,
		%Char8 111,
		%Char8 32,
		%Char8 87,
		%Char8 111,
		%Char8 114,
		%Char8 108,
		%Char8 100,
		%Char8 33,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0,
		%Char8 0
	],
	%Nat32 12,
	%sha256_Hash [
		%Word8 127,
		%Word8 131,
		%Word8 177,
		%Word8 101,
		%Word8 127,
		%Word8 241,
		%Word8 252,
		%Word8 83,
		%Word8 185,
		%Word8 45,
		%Word8 193,
		%Word8 129,
		%Word8 72,
		%Word8 161,
		%Word8 214,
		%Word8 93,
		%Word8 252,
		%Word8 45,
		%Word8 75,
		%Word8 31,
		%Word8 163,
		%Word8 214,
		%Word8 119,
		%Word8 40,
		%Word8 74,
		%Word8 221,
		%Word8 210,
		%Word8 0,
		%Word8 18,
		%Word8 109,
		%Word8 144,
		%Word8 105
	]
}
@tests = constant [2 x %SHA256_TestCase*] [
	%SHA256_TestCase* @test0,
	%SHA256_TestCase* @test1
]
define internal %Bool @doTest(%SHA256_TestCase* %test) {
	%1 = alloca %sha256_Hash, align 1
	%2 = getelementptr %SHA256_TestCase, %SHA256_TestCase* %test, %Int32 0, %Int32 0
	%3 = bitcast [32 x %Char8]* %2 to [0 x %Word8]*
	%4 = getelementptr %SHA256_TestCase, %SHA256_TestCase* %test, %Int32 0, %Int32 1
	%5 = load %Nat32, %Nat32* %4
	call void @sha256_hash([0 x %Word8]* %3, %Nat32 %5, %sha256_Hash* %1)
	%6 = getelementptr %SHA256_TestCase, %SHA256_TestCase* %test, %Int32 0, %Int32 0
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str1 to [0 x i8]*), [32 x %Char8]* %6)
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str2 to [0 x i8]*))
	%9 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %9
; while_1
	br label %again_1
again_1:
	%10 = load %Nat32, %Nat32* %9
	%11 = icmp ult %Nat32 %10, 32
	br %Bool %11 , label %body_1, label %break_1
body_1:
	%12 = load %Nat32, %Nat32* %9
	%13 = bitcast %Nat32 %12 to %Nat32
	%14 = getelementptr %sha256_Hash, %sha256_Hash* %1, %Int32 0, %Nat32 %13
	%15 = load %Word8, %Word8* %14
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str3 to [0 x i8]*), %Word8 %15)
	%17 = load %Nat32, %Nat32* %9
	%18 = add %Nat32 %17, 1
	store %Nat32 %18, %Nat32* %9
	br label %again_1
break_1:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
	%20 = getelementptr %SHA256_TestCase, %SHA256_TestCase* %test, %Int32 0, %Int32 2
	%21 = bitcast %sha256_Hash* %1 to i8*
	%22 = bitcast %sha256_Hash* %20 to i8*
	%23 = call i1 (i8*, i8*, i64) @memeq(i8* %21, i8* %22, %Int64 32)
	%24 = icmp ne %Bool %23, 0
	ret %Bool %24
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*))
	%2 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %2
; while_1
	br label %again_1
again_1:
	%3 = load %Nat32, %Nat32* %2
	%4 = icmp ult %Nat32 %3, 2
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = load %Nat32, %Nat32* %2
	%6 = bitcast %Nat32 %5 to %Nat32
	%7 = getelementptr [2 x %SHA256_TestCase*], [2 x %SHA256_TestCase*]* @tests, %Int32 0, %Nat32 %6
	%8 = load %SHA256_TestCase*, %SHA256_TestCase** %7
	%9 = bitcast %SHA256_TestCase* %8 to %SHA256_TestCase*
	%10 = call %Bool @doTest(%SHA256_TestCase* %9)
	%11 = alloca %Str8*, align 8
	store %Str8* bitcast ([7 x i8]* @str6 to [0 x i8]*), %Str8** %11
; if_0
	br %Bool %10 , label %then_0, label %endif_0
then_0:
	store %Str8* bitcast ([7 x i8]* @str7 to [0 x i8]*), %Str8** %11
	br label %endif_0
endif_0:
	%12 = load %Nat32, %Nat32* %2
	%13 = load %Str8*, %Str8** %11
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*), %Nat32 %12, %Str8* %13)
	%15 = load %Nat32, %Nat32* %2
	%16 = add %Nat32 %15, 1
	store %Nat32 %16, %Nat32* %2
	br label %again_1
break_1:
	ret %Int 0
}


