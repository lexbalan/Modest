
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
; -- print imports private 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports private 'main' --
; -- print imports public 'main' --
; -- end print imports public 'main' --
; -- strings --
@str1 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 56, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 55, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 10, i8 0]
@str2 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 56, i8 32, i8 48, i8 120, i8 56, i8 48, i8 32, i8 62, i8 62, i8 32, i8 55, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str3 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 55, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 10, i8 0]
@str4 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 48, i8 120, i8 56, i8 48, i8 32, i8 62, i8 62, i8 32, i8 55, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str5 = private constant [21 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 83, i8 104, i8 105, i8 102, i8 116, i8 56, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str6 = private constant [33 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 49, i8 54, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 49, i8 53, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 10, i8 0]
@str7 = private constant [33 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 49, i8 54, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 32, i8 62, i8 62, i8 32, i8 49, i8 53, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str8 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 49, i8 53, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 10, i8 0]
@str9 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 32, i8 62, i8 62, i8 32, i8 49, i8 53, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str10 = private constant [22 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 83, i8 104, i8 105, i8 102, i8 116, i8 49, i8 54, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str11 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 51, i8 49, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@str12 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 32, i8 62, i8 62, i8 32, i8 51, i8 49, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str13 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 51, i8 49, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@str14 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 32, i8 62, i8 62, i8 32, i8 51, i8 49, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str15 = private constant [22 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 83, i8 104, i8 105, i8 102, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str16 = private constant [45 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 54, i8 52, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 54, i8 51, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@str17 = private constant [45 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 54, i8 52, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 32, i8 62, i8 62, i8 32, i8 54, i8 51, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str18 = private constant [38 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 54, i8 51, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@str19 = private constant [38 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 32, i8 62, i8 62, i8 32, i8 54, i8 51, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str20 = private constant [22 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 83, i8 104, i8 105, i8 102, i8 116, i8 54, i8 52, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str21 = private constant [63 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 49, i8 50, i8 56, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 49, i8 50, i8 55, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@str22 = private constant [63 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 87, i8 111, i8 114, i8 100, i8 49, i8 50, i8 56, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 32, i8 62, i8 62, i8 32, i8 49, i8 50, i8 55, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str23 = private constant [55 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 49, i8 32, i8 60, i8 60, i8 32, i8 49, i8 50, i8 55, i8 32, i8 33, i8 61, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@str24 = private constant [55 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 48, i8 120, i8 56, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 32, i8 62, i8 62, i8 32, i8 49, i8 50, i8 55, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str25 = private constant [23 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 83, i8 104, i8 105, i8 102, i8 116, i8 49, i8 50, i8 56, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str26 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 115, i8 104, i8 105, i8 102, i8 116, i8 10, i8 0]
@str27 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@str28 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str29 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
define internal %Bool @testShift8() {
	%1 = alloca %Word8, align 1
	store %Word8 128, %Word8* %1
; if_0
	%2 = bitcast i8 128 to %Word8
	%3 = load %Word8, %Word8* %1
	%4 = icmp ne %Word8 %3, %2
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str1 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	store %Word8 1, %Word8* %1
; if_1
	%7 = bitcast i8 1 to %Word8
	%8 = load %Word8, %Word8* %1
	%9 = icmp ne %Word8 %8, %7
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str2 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	store %Word8 128, %Word8* %1
; if_2
	%12 = bitcast i8 128 to %Word8
	%13 = load %Word8, %Word8* %1
	%14 = icmp ne %Word8 %13, %12
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str3 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	store %Word8 1, %Word8* %1
; if_3
	%17 = bitcast i8 1 to %Word8
	%18 = load %Word8, %Word8* %1
	%19 = icmp ne %Word8 %18, %17
	br %Bool %19 , label %then_3, label %endif_3
then_3:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str4 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testShift16() {
	%1 = alloca %Word16, align 2
	store %Word16 32768, %Word16* %1
; if_0
	%2 = bitcast i16 32768 to %Word16
	%3 = load %Word16, %Word16* %1
	%4 = icmp ne %Word16 %3, %2
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @str6 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	store %Word16 1, %Word16* %1
; if_1
	%7 = zext i8 1 to %Word16
	%8 = load %Word16, %Word16* %1
	%9 = icmp ne %Word16 %8, %7
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @str7 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	store %Word16 32768, %Word16* %1
; if_2
	%12 = bitcast i16 32768 to %Word16
	%13 = load %Word16, %Word16* %1
	%14 = icmp ne %Word16 %13, %12
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str8 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	store %Word16 1, %Word16* %1
; if_3
	%17 = zext i8 1 to %Word16
	%18 = load %Word16, %Word16* %1
	%19 = icmp ne %Word16 %18, %17
	br %Bool %19 , label %then_3, label %endif_3
then_3:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str9 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str10 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testShift32() {
	%1 = alloca %Word32, align 4
	store %Word32 2147483648, %Word32* %1
; if_0
	%2 = bitcast i32 2147483648 to %Word32
	%3 = load %Word32, %Word32* %1
	%4 = icmp ne %Word32 %3, %2
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str11 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	store %Word32 1, %Word32* %1
; if_1
	%7 = zext i8 1 to %Word32
	%8 = load %Word32, %Word32* %1
	%9 = icmp ne %Word32 %8, %7
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str12 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	store %Word32 2147483648, %Word32* %1
; if_2
	%12 = bitcast i32 2147483648 to %Word32
	%13 = load %Word32, %Word32* %1
	%14 = icmp ne %Word32 %13, %12
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	store %Word32 1, %Word32* %1
; if_3
	%17 = zext i8 1 to %Word32
	%18 = load %Word32, %Word32* %1
	%19 = icmp ne %Word32 %18, %17
	br %Bool %19 , label %then_3, label %endif_3
then_3:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str14 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str15 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testShift64() {
	%1 = alloca %Word64, align 8
	store %Word64 9223372036854775808, %Word64* %1
; if_0
	%2 = bitcast i64 9223372036854775808 to %Word64
	%3 = load %Word64, %Word64* %1
	%4 = icmp ne %Word64 %3, %2
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([45 x i8]* @str16 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	store %Word64 1, %Word64* %1
; if_1
	%7 = zext i8 1 to %Word64
	%8 = load %Word64, %Word64* %1
	%9 = icmp ne %Word64 %8, %7
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([45 x i8]* @str17 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	store %Word64 9223372036854775808, %Word64* %1
; if_2
	%12 = bitcast i64 9223372036854775808 to %Word64
	%13 = load %Word64, %Word64* %1
	%14 = icmp ne %Word64 %13, %12
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str18 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	store %Word64 1, %Word64* %1
; if_3
	%17 = zext i8 1 to %Word64
	%18 = load %Word64, %Word64* %1
	%19 = icmp ne %Word64 %18, %17
	br %Bool %19 , label %then_3, label %endif_3
then_3:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str19 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str20 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testShift128() {
	%1 = alloca %Word128, align 16
	store %Word128 170141183460469231731687303715884105728, %Word128* %1
; if_0
	%2 = bitcast i128 170141183460469231731687303715884105728 to %Word128
	%3 = load %Word128, %Word128* %1
	%4 = icmp ne %Word128 %3, %2
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([63 x i8]* @str21 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	store %Word128 1, %Word128* %1
; if_1
	%7 = zext i8 1 to %Word128
	%8 = load %Word128, %Word128* %1
	%9 = icmp ne %Word128 %8, %7
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([63 x i8]* @str22 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	store %Word128 170141183460469231731687303715884105728, %Word128* %1
; if_2
	%12 = bitcast i128 170141183460469231731687303715884105728 to %Word128
	%13 = load %Word128, %Word128* %1
	%14 = icmp ne %Word128 %13, %12
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([55 x i8]* @str23 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	store %Word128 1, %Word128* %1
; if_3
	%17 = zext i8 1 to %Word128
	%18 = load %Word128, %Word128* %1
	%19 = icmp ne %Word128 %18, %17
	br %Bool %19 , label %then_3, label %endif_3
then_3:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([55 x i8]* @str24 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str25 to [0 x i8]*))
	ret %Bool 1
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str26 to [0 x i8]*))
	%2 = alloca %Bool, align 1
	store %Bool 1, %Bool* %2
	%3 = call %Bool @testShift8()
	%4 = load %Bool, %Bool* %2
	%5 = and %Bool %3, %4
	store %Bool %5, %Bool* %2
	%6 = call %Bool @testShift16()
	%7 = load %Bool, %Bool* %2
	%8 = and %Bool %6, %7
	store %Bool %8, %Bool* %2
	%9 = call %Bool @testShift32()
	%10 = load %Bool, %Bool* %2
	%11 = and %Bool %9, %10
	store %Bool %11, %Bool* %2
	%12 = call %Bool @testShift64()
	%13 = load %Bool, %Bool* %2
	%14 = and %Bool %12, %13
	store %Bool %14, %Bool* %2
	%15 = call %Bool @testShift128()
	%16 = load %Bool, %Bool* %2
	%17 = and %Bool %15, %16
	store %Bool %17, %Bool* %2
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str27 to [0 x i8]*))
; if_0
	%19 = load %Bool, %Bool* %2
	%20 = xor %Bool %19, 1
	br %Bool %20 , label %then_0, label %endif_0
then_0:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str28 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str29 to [0 x i8]*))
	ret %Int 0
}


