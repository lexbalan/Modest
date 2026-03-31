
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
; -- print imports 'main' --
; -- 1

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 85, i8 110, i8 105, i8 116, i8 41, i8 32, i8 33, i8 61, i8 32, i8 48, i8 10, i8 0]
@str2 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 85, i8 110, i8 105, i8 116, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str3 = private constant [18 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 85, i8 110, i8 105, i8 116, i8 10, i8 0]
@str4 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 66, i8 111, i8 111, i8 108, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str5 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 66, i8 111, i8 111, i8 108, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str6 = private constant [18 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 66, i8 111, i8 111, i8 108, i8 10, i8 0]
@str7 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 87, i8 111, i8 114, i8 100, i8 56, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str8 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 87, i8 111, i8 114, i8 100, i8 49, i8 54, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@str9 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str10 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 87, i8 111, i8 114, i8 100, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str11 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 87, i8 111, i8 114, i8 100, i8 56, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str12 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 87, i8 111, i8 114, i8 100, i8 49, i8 54, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@str13 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str14 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 87, i8 111, i8 114, i8 100, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str15 = private constant [18 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 87, i8 111, i8 114, i8 100, i8 10, i8 0]
@str16 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 56, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str17 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 54, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@str18 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str19 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str20 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 56, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str21 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 54, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@str22 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str23 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str24 = private constant [17 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 73, i8 110, i8 116, i8 10, i8 0]
@str25 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 56, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str26 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 54, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@str27 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str28 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str29 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 56, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str30 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 54, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@str31 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str32 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str33 = private constant [17 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 78, i8 97, i8 116, i8 10, i8 0]
@str34 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 56, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str35 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 49, i8 54, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@str36 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str37 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 56, i8 41, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@str38 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 49, i8 54, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@str39 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str40 = private constant [18 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 67, i8 104, i8 97, i8 114, i8 10, i8 0]
@str41 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str42 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 70, i8 108, i8 111, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str43 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str44 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 70, i8 108, i8 111, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str45 = private constant [19 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 70, i8 108, i8 111, i8 97, i8 116, i8 10, i8 0]
@str46 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 70, i8 105, i8 120, i8 101, i8 100, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str47 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 70, i8 105, i8 120, i8 101, i8 100, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str48 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 70, i8 105, i8 120, i8 101, i8 100, i8 51, i8 50, i8 41, i8 32, i8 33, i8 61, i8 32, i8 52, i8 10, i8 0]
@str49 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 70, i8 105, i8 120, i8 101, i8 100, i8 54, i8 52, i8 41, i8 32, i8 33, i8 61, i8 32, i8 56, i8 10, i8 0]
@str50 = private constant [19 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 70, i8 105, i8 120, i8 101, i8 100, i8 10, i8 0]
@str51 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 111, i8 102, i8 40, i8 97, i8 114, i8 114, i8 97, i8 121, i8 41, i8 32, i8 33, i8 61, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 83, i8 105, i8 122, i8 101, i8 10, i8 0]
@str52 = private constant [59 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 97, i8 114, i8 114, i8 97, i8 121, i8 41, i8 32, i8 33, i8 61, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 83, i8 105, i8 122, i8 101, i8 32, i8 42, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 65, i8 114, i8 114, i8 97, i8 121, i8 73, i8 116, i8 101, i8 109, i8 84, i8 121, i8 112, i8 101, i8 41, i8 10, i8 0]
@str53 = private constant [49 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 97, i8 114, i8 114, i8 97, i8 121, i8 41, i8 32, i8 33, i8 61, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 65, i8 114, i8 114, i8 97, i8 121, i8 73, i8 116, i8 101, i8 109, i8 84, i8 121, i8 112, i8 101, i8 41, i8 10, i8 0]
@str54 = private constant [19 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 65, i8 114, i8 114, i8 97, i8 121, i8 10, i8 0]
@str55 = private constant [44 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 41, i8 32, i8 33, i8 61, i8 32, i8 50, i8 32, i8 42, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 10, i8 0]
@str56 = private constant [44 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 95, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 41, i8 32, i8 33, i8 61, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 82, i8 101, i8 99, i8 111, i8 114, i8 100, i8 41, i8 10, i8 0]
@str57 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 82, i8 101, i8 99, i8 111, i8 114, i8 100, i8 10, i8 0]
@str58 = private constant [53 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 41, i8 32, i8 33, i8 61, i8 32, i8 95, i8 95, i8 116, i8 97, i8 114, i8 103, i8 101, i8 116, i8 46, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 87, i8 105, i8 100, i8 116, i8 104, i8 32, i8 47, i8 32, i8 56, i8 10, i8 0]
@str59 = private constant [44 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 41, i8 32, i8 33, i8 61, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 41, i8 10, i8 0]
@str60 = private constant [21 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 101, i8 115, i8 116, i8 80, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 10, i8 0]
@str61 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 10, i8 0]
@str62 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@str63 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str64 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
define internal %Bool @testUnit() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str1 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str2 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str3 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testBool() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str4 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str5 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str6 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testWord() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str7 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str8 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str9 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str10 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	br %Bool 0 , label %then_4, label %endif_4
then_4:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str11 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
; if_5
	br %Bool 0 , label %then_5, label %endif_5
then_5:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str12 to [0 x i8]*))
	ret %Bool 0
	br label %endif_5
endif_5:
; if_6
	br %Bool 0 , label %then_6, label %endif_6
then_6:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_6
endif_6:
; if_7
	br %Bool 0 , label %then_7, label %endif_7
then_7:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str14 to [0 x i8]*))
	ret %Bool 0
	br label %endif_7
endif_7:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str15 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testInt() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str16 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str17 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str18 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str19 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	br %Bool 0 , label %then_4, label %endif_4
then_4:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str20 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
; if_5
	br %Bool 0 , label %then_5, label %endif_5
then_5:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str21 to [0 x i8]*))
	ret %Bool 0
	br label %endif_5
endif_5:
; if_6
	br %Bool 0 , label %then_6, label %endif_6
then_6:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str22 to [0 x i8]*))
	ret %Bool 0
	br label %endif_6
endif_6:
; if_7
	br %Bool 0 , label %then_7, label %endif_7
then_7:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str23 to [0 x i8]*))
	ret %Bool 0
	br label %endif_7
endif_7:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str24 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testNat() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str25 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str26 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str27 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str28 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	br %Bool 0 , label %then_4, label %endif_4
then_4:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str29 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
; if_5
	br %Bool 0 , label %then_5, label %endif_5
then_5:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str30 to [0 x i8]*))
	ret %Bool 0
	br label %endif_5
endif_5:
; if_6
	br %Bool 0 , label %then_6, label %endif_6
then_6:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str31 to [0 x i8]*))
	ret %Bool 0
	br label %endif_6
endif_6:
; if_7
	br %Bool 0 , label %then_7, label %endif_7
then_7:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str32 to [0 x i8]*))
	ret %Bool 0
	br label %endif_7
endif_7:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str33 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testChar() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str34 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str35 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str36 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str37 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	br %Bool 0 , label %then_4, label %endif_4
then_4:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str38 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
; if_5
	br %Bool 0 , label %then_5, label %endif_5
then_5:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str39 to [0 x i8]*))
	ret %Bool 0
	br label %endif_5
endif_5:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str40 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testFloat() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str41 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str42 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str43 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str44 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str45 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testFixed() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str46 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str47 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str48 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str49 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str50 to [0 x i8]*))
	ret %Bool 1
}

%testArray.ArrayItemType = type %Int32;
define internal %Bool @testArray() {
	%1 = alloca [10 x %testArray.ArrayItemType], align 4
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str51 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([59 x i8]* @str52 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([49 x i8]* @str53 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str54 to [0 x i8]*))
	ret %Bool 1
}

%testRecord.Record = type {
	%Int32,
	%Int32
};

define internal %Bool @testRecord() {
	%1 = alloca %testRecord.Record, align 4
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @str55 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @str56 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str57 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testPointer() {
	%1 = alloca i8*, align 8
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([53 x i8]* @str58 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @str59 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str60 to [0 x i8]*))
	ret %Bool 1
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str61 to [0 x i8]*))
	%2 = alloca %Bool, align 1
	store %Bool 1, %Bool* %2
	%3 = call %Bool @testUnit()
	%4 = load %Bool, %Bool* %2
	%5 = and %Bool %3, %4
	store %Bool %5, %Bool* %2
	%6 = call %Bool @testBool()
	%7 = load %Bool, %Bool* %2
	%8 = and %Bool %6, %7
	store %Bool %8, %Bool* %2
	%9 = call %Bool @testWord()
	%10 = load %Bool, %Bool* %2
	%11 = and %Bool %9, %10
	store %Bool %11, %Bool* %2
	%12 = call %Bool @testInt()
	%13 = load %Bool, %Bool* %2
	%14 = and %Bool %12, %13
	store %Bool %14, %Bool* %2
	%15 = call %Bool @testNat()
	%16 = load %Bool, %Bool* %2
	%17 = and %Bool %15, %16
	store %Bool %17, %Bool* %2
	%18 = call %Bool @testChar()
	%19 = load %Bool, %Bool* %2
	%20 = and %Bool %18, %19
	store %Bool %20, %Bool* %2
	%21 = call %Bool @testFloat()
	%22 = load %Bool, %Bool* %2
	%23 = and %Bool %21, %22
	store %Bool %23, %Bool* %2
	%24 = call %Bool @testFixed()
	%25 = load %Bool, %Bool* %2
	%26 = and %Bool %24, %25
	store %Bool %26, %Bool* %2
	%27 = call %Bool @testArray()
	%28 = load %Bool, %Bool* %2
	%29 = and %Bool %27, %28
	store %Bool %29, %Bool* %2
	%30 = call %Bool @testRecord()
	%31 = load %Bool, %Bool* %2
	%32 = and %Bool %30, %31
	store %Bool %32, %Bool* %2
	%33 = call %Bool @testPointer()
	%34 = load %Bool, %Bool* %2
	%35 = and %Bool %33, %34
	store %Bool %35, %Bool* %2
	%36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str62 to [0 x i8]*))
; if_0
	%37 = load %Bool, %Bool* %2
	%38 = xor %Bool %37, 1
	br %Bool %38 , label %then_0, label %endif_0
then_0:
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str63 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str64 to [0 x i8]*))
	ret %Int 0
}


