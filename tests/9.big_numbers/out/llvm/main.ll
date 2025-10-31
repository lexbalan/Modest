
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
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 48, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str2 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 49, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str3 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 51, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str4 = private constant [22 x i8] [i8 98, i8 105, i8 103, i8 95, i8 115, i8 117, i8 109, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 115, i8 105, i8 103, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
; -- endstrings --; tests/9.big_numbers/src/main.m
@big0 = internal global %Word128 1512366075204170947332355369683137040
define internal %Word64 @high_128(%Word128 %x) {
	%1 = zext i8 64 to %Word128
	%2 = lshr %Word128 %x, %1
	%3 = trunc %Word128 %2 to %Word64
	ret %Word64 %3
}

define internal %Word64 @low_128(%Word128 %x) {
	%1 = and %Word128 %x, 18446744073709551615
	%2 = trunc %Word128 %1 to %Word64
	ret %Word64 %2
}

define %Int @main() {
	%1 = alloca %Word128, align 16
	store %Word128 1, %Word128* %1
	%2 = alloca %Nat32, align 4
	store %Nat32 1, %Nat32* %2
	%3 = alloca %Nat128, align 16
	%4 = load %Nat32, %Nat32* %2
	%5 = zext %Nat32 %4 to %Nat128
	%6 = add %Nat128 115792089237316195423570985008687907853269984665640564039457584007913129639935, %5
	%7 = add %Nat128 340282366920938463463374607431768211455, %6
	store %Nat128 %7, %Nat128* %3
	%8 = load %Word128, %Word128* @big0
	%9 = call %Word64 @high_128(%Word128 %8)
	%10 = load %Word128, %Word128* @big0
	%11 = call %Word64 @low_128(%Word128 %10)
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*), %Word64 %9, %Word64 %11)
	%13 = call %Word64 @high_128(%Word128 340282366920938463463374607431768211455)
	%14 = call %Word64 @low_128(%Word128 340282366920938463463374607431768211455)
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*), %Word64 %13, %Word64 %14)
	;printf("big2 = 0x%llX%llX\n", high_128(big2), low_128(big2))
	%16 = load %Word128, %Word128* %1
	%17 = call %Word64 @high_128(%Word128 %16)
	%18 = load %Word128, %Word128* %1
	%19 = call %Word64 @low_128(%Word128 %18)
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str3 to [0 x i8]*), %Word64 %17, %Word64 %19)
	%21 = load %Nat128, %Nat128* %3
	%22 = bitcast %Nat128 %21 to %Word128
	%23 = call %Word64 @high_128(%Word128 %22)
	%24 = load %Nat128, %Nat128* %3
	%25 = bitcast %Nat128 %24 to %Word128
	%26 = call %Word64 @low_128(%Word128 %25)
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str4 to [0 x i8]*), %Word64 %23, %Word64 %26)


	; signed big int test
	%28 = sub i8 0, 1
	%29 = alloca %Int128, align 16
	store %Int128 -1, %Int128* %29
	%30 = load %Int128, %Int128* %29
	%31 = add %Int128 %30, 1
	store %Int128 %31, %Int128* %29
	%32 = load %Int128, %Int128* %29
	%33 = trunc %Int128 %32 to %Nat64
	%34 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), %Nat64 %33)
	ret %Int 0
}


