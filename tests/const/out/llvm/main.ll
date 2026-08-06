
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
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [18 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 32, i8 33, i8 61, i8 32, i8 48, i8 10, i8 0]
@.str2 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 101, i8 109, i8 112, i8 116, i8 121, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str3 = private constant [36 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 117, i8 110, i8 116, i8 121, i8 112, i8 101, i8 100, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str4 = private constant [21 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 73, i8 110, i8 116, i8 56, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str5 = private constant [22 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str6 = private constant [22 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 78, i8 97, i8 116, i8 54, i8 52, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str7 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 70, i8 108, i8 111, i8 97, i8 116, i8 54, i8 52, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 46, i8 48, i8 10, i8 0]
@.str8 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 87, i8 111, i8 114, i8 100, i8 49, i8 54, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str9 = private constant [33 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 32, i8 97, i8 100, i8 97, i8 112, i8 116, i8 97, i8 116, i8 105, i8 111, i8 110, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str10 = private constant [17 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 119, i8 111, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@.str11 = private constant [22 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 111, i8 109, i8 98, i8 105, i8 110, i8 101, i8 100, i8 32, i8 33, i8 61, i8 32, i8 53, i8 10, i8 0]
@.str12 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 98, i8 105, i8 103, i8 32, i8 33, i8 61, i8 32, i8 49, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@.str13 = private constant [21 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 104, i8 101, i8 120, i8 86, i8 97, i8 108, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str14 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 101, i8 103, i8 97, i8 116, i8 101, i8 100, i8 32, i8 33, i8 61, i8 32, i8 45, i8 52, i8 50, i8 10, i8 0]
@.str15 = private constant [28 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 102, i8 111, i8 108, i8 100, i8 105, i8 110, i8 103, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str16 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 78, i8 97, i8 116, i8 32, i8 33, i8 61, i8 32, i8 49, i8 48, i8 48, i8 10, i8 0]
@.str17 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 73, i8 110, i8 116, i8 32, i8 33, i8 61, i8 32, i8 45, i8 49, i8 48, i8 48, i8 10, i8 0]
@.str18 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 70, i8 108, i8 111, i8 97, i8 116, i8 32, i8 33, i8 61, i8 32, i8 51, i8 46, i8 53, i8 10, i8 0]
@.str19 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 70, i8 114, i8 111, i8 109, i8 71, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@.str20 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str21 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 111, i8 102, i8 40, i8 103, i8 114, i8 101, i8 101, i8 116, i8 105, i8 110, i8 103, i8 41, i8 32, i8 33, i8 61, i8 32, i8 51, i8 10, i8 0]
@.str22 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 103, i8 114, i8 101, i8 101, i8 116, i8 105, i8 110, i8 103, i8 32, i8 99, i8 104, i8 97, i8 114, i8 115, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str23 = private constant [4 x i8] [i8 72, i8 105, i8 10, i8 0]
@.str24 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 103, i8 114, i8 101, i8 101, i8 116, i8 105, i8 110, i8 103, i8 91, i8 48, i8 93, i8 32, i8 33, i8 61, i8 32, i8 39, i8 72, i8 39, i8 10, i8 0]
@.str25 = private constant [18 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 104, i8 32, i8 33, i8 61, i8 32, i8 39, i8 65, i8 39, i8 10, i8 0]
@.str26 = private constant [32 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 116, i8 114, i8 105, i8 110, i8 103, i8 47, i8 99, i8 104, i8 97, i8 114, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str27 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 97, i8 109, i8 101, i8 32, i8 33, i8 61, i8 32, i8 91, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@.str28 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 110, i8 103, i8 101, i8 114, i8 32, i8 104, i8 101, i8 97, i8 100, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str29 = private constant [36 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 110, i8 103, i8 101, i8 114, i8 32, i8 116, i8 97, i8 105, i8 108, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str30 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str31 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 46, i8 120, i8 47, i8 112, i8 46, i8 121, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str32 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 51, i8 46, i8 120, i8 47, i8 112, i8 51, i8 46, i8 121, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str33 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 51, i8 46, i8 122, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str34 = private constant [27 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str35 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 114, i8 101, i8 99, i8 116, i8 67, i8 111, i8 110, i8 115, i8 116, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str36 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 114, i8 101, i8 99, i8 116, i8 80, i8 97, i8 114, i8 116, i8 105, i8 97, i8 108, i8 46, i8 116, i8 111, i8 112, i8 76, i8 101, i8 102, i8 116, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str37 = private constant [48 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 114, i8 101, i8 99, i8 116, i8 80, i8 97, i8 114, i8 116, i8 105, i8 97, i8 108, i8 46, i8 98, i8 111, i8 116, i8 116, i8 111, i8 109, i8 82, i8 105, i8 103, i8 104, i8 116, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str38 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 114, i8 101, i8 99, i8 116, i8 90, i8 101, i8 114, i8 111, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str39 = private constant [34 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 110, i8 101, i8 115, i8 116, i8 101, i8 100, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str40 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 109, i8 97, i8 116, i8 114, i8 105, i8 120, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str41 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 119, i8 105, i8 100, i8 101, i8 114, i8 32, i8 104, i8 101, i8 97, i8 100, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str42 = private constant [40 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 119, i8 105, i8 100, i8 101, i8 114, i8 32, i8 101, i8 120, i8 116, i8 114, i8 97, i8 32, i8 114, i8 111, i8 119, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str43 = private constant [43 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 119, i8 105, i8 100, i8 101, i8 114, i8 32, i8 33, i8 61, i8 32, i8 91, i8 91, i8 49, i8 44, i8 50, i8 44, i8 51, i8 93, i8 44, i8 91, i8 52, i8 44, i8 53, i8 44, i8 54, i8 93, i8 44, i8 91, i8 48, i8 44, i8 48, i8 44, i8 48, i8 93, i8 93, i8 10, i8 0]
@.str44 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 109, i8 122, i8 32, i8 114, i8 111, i8 119, i8 32, i8 48, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str45 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 109, i8 122, i8 32, i8 114, i8 111, i8 119, i8 32, i8 49, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str46 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 109, i8 122, i8 32, i8 33, i8 61, i8 32, i8 91, i8 91, i8 48, i8 44, i8 48, i8 44, i8 48, i8 93, i8 44, i8 91, i8 48, i8 44, i8 48, i8 44, i8 48, i8 93, i8 93, i8 10, i8 0]
@.str47 = private constant [20 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 109, i8 122, i8 32, i8 33, i8 61, i8 32, i8 101, i8 109, i8 112, i8 116, i8 121, i8 10, i8 0]
@.str48 = private constant [33 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 110, i8 101, i8 115, i8 116, i8 101, i8 100, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str49 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 115, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str50 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 110, i8 103, i8 101, i8 114, i8 32, i8 104, i8 101, i8 97, i8 100, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str51 = private constant [44 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 110, i8 103, i8 101, i8 114, i8 32, i8 116, i8 97, i8 105, i8 108, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str52 = private constant [37 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 111, i8 102, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str53 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 114, i8 105, i8 97, i8 110, i8 103, i8 108, i8 101, i8 46, i8 99, i8 111, i8 117, i8 110, i8 116, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str54 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 114, i8 105, i8 97, i8 110, i8 103, i8 108, i8 101, i8 46, i8 118, i8 101, i8 114, i8 116, i8 115, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str55 = private constant [35 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 111, i8 108, i8 121, i8 80, i8 97, i8 114, i8 116, i8 105, i8 97, i8 108, i8 46, i8 99, i8 111, i8 117, i8 110, i8 116, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str56 = private constant [42 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 111, i8 108, i8 121, i8 80, i8 97, i8 114, i8 116, i8 105, i8 97, i8 108, i8 46, i8 118, i8 101, i8 114, i8 116, i8 115, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str57 = private constant [44 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 119, i8 105, i8 116, i8 104, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 102, i8 105, i8 101, i8 108, i8 100, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str58 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 65, i8 114, i8 114, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str59 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 80, i8 111, i8 105, i8 110, i8 116, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str60 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 77, i8 97, i8 116, i8 114, i8 105, i8 120, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str61 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 80, i8 111, i8 105, i8 110, i8 116, i8 115, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str62 = private constant [34 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 101, i8 109, i8 112, i8 116, i8 121, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str63 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 82, i8 101, i8 100, i8 32, i8 61, i8 61, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 71, i8 114, i8 101, i8 101, i8 110, i8 10, i8 0]
@.str64 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 71, i8 114, i8 101, i8 101, i8 110, i8 32, i8 61, i8 61, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 66, i8 108, i8 117, i8 101, i8 10, i8 0]
@.str65 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 82, i8 101, i8 100, i8 32, i8 33, i8 61, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 82, i8 101, i8 100, i8 10, i8 0]
@.str66 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 78, i8 97, i8 116, i8 56, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 71, i8 114, i8 101, i8 101, i8 110, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@.str67 = private constant [33 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 98, i8 114, i8 97, i8 110, i8 100, i8 101, i8 100, i8 32, i8 101, i8 110, i8 117, i8 109, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str68 = private constant [22 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 99, i8 97, i8 108, i8 84, i8 119, i8 111, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@.str69 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 70, i8 108, i8 111, i8 97, i8 116, i8 32, i8 33, i8 61, i8 32, i8 49, i8 46, i8 48, i8 10, i8 0]
@.str70 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 108, i8 111, i8 99, i8 97, i8 108, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str71 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 10, i8 0]
@.str72 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@.str73 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str74 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
@emptyArray = constant [0 x {}] zeroinitializer
%Point = type {
	%Int32,
	%Int32
};

%Point3D = type {
	%Int32,
	%Int32,
	%Int32
};

%Rect = type {
	%Point,
	%Point
};

%Poly3 = type {
	[3 x %Point],
	%Int32
};

%Color = type %Nat8;
define %Bool @main_testUntypedLiteralConst() {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
; if_0
	%2 = load %Int32, %Int32* %1
	%3 = icmp ne %Int32 %2, 0
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str1 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%6 = alloca [3 x %Int32], align 4
	%7 = zext i8 3 to %Nat32
	%8 = mul %Nat32 %7, 4
	%9 = bitcast [3 x %Int32]* %6 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %9, i8 0, %Nat32 %8, i1 0)
; if_1
	%10 = getelementptr [3 x %Int32], [3 x %Int32]* %6, %Int32 0, %Int32 0
	%11 = load %Int32, %Int32* %10
	%12 = icmp ne %Int32 %11, 0
	%13 = getelementptr [3 x %Int32], [3 x %Int32]* %6, %Int32 0, %Int32 1
	%14 = load %Int32, %Int32* %13
	%15 = icmp ne %Int32 %14, 0
	%16 = getelementptr [3 x %Int32], [3 x %Int32]* %6, %Int32 0, %Int32 2
	%17 = load %Int32, %Int32* %16
	%18 = icmp ne %Int32 %17, 0
	%19 = or %Bool %15, %18
	%20 = or %Bool %12, %19
	br %Bool %20 , label %then_1, label %endif_1
then_1:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str2 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%23 = alloca %Point, align 4
	store %Point zeroinitializer, %Point* %23
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([36 x i8]* @.str3 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testGenericAdaptation() {
	%1 = alloca %Int8, align 1
	store %Int8 42, %Int8* %1
	%2 = alloca %Int32, align 4
	store %Int32 42, %Int32* %2
	%3 = alloca %Nat64, align 8
	store %Nat64 42, %Nat64* %3
	%4 = alloca %Float64, align 8
	store %Float64 42.0000000000000000, %Float64* %4
	%5 = alloca %Word16, align 2
	%6 = zext i8 42 to %Word16
	store %Word16 %6, %Word16* %5
; if_0
	%7 = load %Int8, %Int8* %1
	%8 = icmp ne %Int8 %7, 42
	br %Bool %8 , label %then_0, label %endif_0
then_0:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str4 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%11 = load %Int32, %Int32* %2
	%12 = icmp ne %Int32 %11, 42
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str5 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%15 = load %Nat64, %Nat64* %3
	%16 = icmp ne %Nat64 %15, 42
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str6 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%19 = load %Float64, %Float64* %4
	%20 = fcmp one %Float64 %19, 42.0000000000000000
	br %Bool %20 , label %then_3, label %endif_3
then_3:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str7 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	%23 = zext i8 42 to %Word16
	%24 = load %Word16, %Word16* %5
	%25 = icmp ne %Word16 %24, %23
	br %Bool %25 , label %then_4, label %endif_4
then_4:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str8 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @.str9 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testConstFolding() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str10 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str11 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str12 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	br %Bool 0 , label %then_4, label %endif_4
then_4:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str14 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @.str15 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testTypedConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str16 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str17 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str18 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str19 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str20 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testStringAndCharConst() {
	%1 = alloca [3 x %Char8], align 1
	%2 = insertvalue [3 x %Char8] zeroinitializer, %Char8 72, 0
	%3 = insertvalue [3 x %Char8] %2, %Char8 105, 1
	%4 = insertvalue [3 x %Char8] %3, %Char8 10, 2
	%5 = zext i8 3 to %Nat32
	store [3 x %Char8] %4, [3 x %Char8]* %1
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str21 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%8 = getelementptr [3 x %Char8], [3 x %Char8]* %1, %Int32 0, %Int32 0
	%9 = load %Char8, %Char8* %8
	%10 = icmp ne %Char8 %9, 72
	%11 = getelementptr [3 x %Char8], [3 x %Char8]* %1, %Int32 0, %Int32 1
	%12 = load %Char8, %Char8* %11
	%13 = icmp ne %Char8 %12, 105
	%14 = or %Bool %10, %13
	br %Bool %14 , label %then_1, label %endif_1
then_1:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str22 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%17 = alloca %Str8*, align 8
	store %Str8* bitcast ([4 x i8]* @.str23 to [0 x i8]*), %Str8** %17
; if_2
	%18 = load %Str8*, %Str8** %17
	%19 = getelementptr %Str8, %Str8* %18, %Int32 0, %Int32 0
	%20 = load %Char8, %Char8* %19
	%21 = icmp ne %Char8 %20, 72
	br %Bool %21 , label %then_2, label %endif_2
then_2:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str24 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%24 = alloca %Char8, align 1
	store %Char8 65, %Char8* %24
; if_3
	%25 = load %Char8, %Char8* %24
	%26 = icmp ne %Char8 %25, 65
	br %Bool %26 , label %then_3, label %endif_3
then_3:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str25 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str26 to [0 x i8]*))
	ret %Bool 1
}

@nums = constant [3 x i8] [
	i8 1,
	i8 2,
	i8 3
]
define %Bool @main_testArrayConst() {
	%1 = alloca [3 x %Int32], align 4
	%2 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%3 = insertvalue [3 x %Int32] %2, %Int32 2, 1
	%4 = insertvalue [3 x %Int32] %3, %Int32 3, 2
	%5 = zext i8 3 to %Nat32
	store [3 x %Int32] %4, [3 x %Int32]* %1
; if_0
	%6 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%7 = insertvalue [3 x %Int32] %6, %Int32 2, 1
	%8 = insertvalue [3 x %Int32] %7, %Int32 3, 2
	%9 = alloca [3 x %Int32]
	%10 = zext i8 3 to %Nat32
	store [3 x %Int32] %8, [3 x %Int32]* %9
	%11 = bitcast [3 x %Int32]* %1 to i8*
	%12 = bitcast [3 x %Int32]* %9 to i8*
	%13 = call i1 (i8*, i8*, i64) @memeq(i8* %11, i8* %12, %Int64 12)
	%14 = icmp eq %Bool %13, 0
	br %Bool %14 , label %then_0, label %endif_0
then_0:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str27 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%17 = alloca [5 x %Int32], align 4
	%18 = insertvalue [5 x %Int32] zeroinitializer, %Int32 1, 0
	%19 = insertvalue [5 x %Int32] %18, %Int32 2, 1
	%20 = insertvalue [5 x %Int32] %19, %Int32 3, 2
	%21 = zext i8 5 to %Nat32
	store [5 x %Int32] %20, [5 x %Int32]* %17
; if_1
	%22 = getelementptr [5 x %Int32], [5 x %Int32]* %17, %Int32 0, %Int32 0
	%23 = load %Int32, %Int32* %22
	%24 = icmp ne %Int32 %23, 1
	%25 = getelementptr [5 x %Int32], [5 x %Int32]* %17, %Int32 0, %Int32 1
	%26 = load %Int32, %Int32* %25
	%27 = icmp ne %Int32 %26, 2
	%28 = getelementptr [5 x %Int32], [5 x %Int32]* %17, %Int32 0, %Int32 2
	%29 = load %Int32, %Int32* %28
	%30 = icmp ne %Int32 %29, 3
	%31 = or %Bool %27, %30
	%32 = or %Bool %24, %31
	br %Bool %32 , label %then_1, label %endif_1
then_1:
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str28 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%35 = getelementptr [5 x %Int32], [5 x %Int32]* %17, %Int32 0, %Int32 3
	%36 = load %Int32, %Int32* %35
	%37 = icmp ne %Int32 %36, 0
	%38 = getelementptr [5 x %Int32], [5 x %Int32]* %17, %Int32 0, %Int32 4
	%39 = load %Int32, %Int32* %38
	%40 = icmp ne %Int32 %39, 0
	%41 = or %Bool %37, %40
	br %Bool %41 , label %then_2, label %endif_2
then_2:
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([36 x i8]* @.str29 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str30 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testRecordConst() {
	%1 = alloca %Point, align 4
	%2 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%3 = insertvalue %Point %2, %Int32 2, 1
	store %Point %3, %Point* %1
; if_0
	%4 = getelementptr %Point, %Point* %1, %Int32 0, %Int32 0
	%5 = load %Int32, %Int32* %4
	%6 = icmp ne %Int32 %5, 1
	%7 = getelementptr %Point, %Point* %1, %Int32 0, %Int32 1
	%8 = load %Int32, %Int32* %7
	%9 = icmp ne %Int32 %8, 2
	%10 = or %Bool %6, %9
	br %Bool %10 , label %then_0, label %endif_0
then_0:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str31 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%13 = alloca %Point3D, align 4
	%14 = insertvalue %Point3D zeroinitializer, %Int32 1, 0
	%15 = insertvalue %Point3D %14, %Int32 2, 1
	store %Point3D %15, %Point3D* %13
; if_1
	%16 = getelementptr %Point3D, %Point3D* %13, %Int32 0, %Int32 0
	%17 = load %Int32, %Int32* %16
	%18 = icmp ne %Int32 %17, 1
	%19 = getelementptr %Point3D, %Point3D* %13, %Int32 0, %Int32 1
	%20 = load %Int32, %Int32* %19
	%21 = icmp ne %Int32 %20, 2
	%22 = or %Bool %18, %21
	br %Bool %22 , label %then_1, label %endif_1
then_1:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str32 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%25 = getelementptr %Point3D, %Point3D* %13, %Int32 0, %Int32 2
	%26 = load %Int32, %Int32* %25
	%27 = icmp ne %Int32 %26, 0
	br %Bool %27 , label %then_2, label %endif_2
then_2:
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str33 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str34 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testNestedRecordConst() {
	%1 = alloca %Rect, align 4
	%2 = insertvalue %Point zeroinitializer, %Int32 10, 0
	%3 = insertvalue %Point %2, %Int32 20, 1
	%4 = insertvalue %Rect zeroinitializer, %Point %3, 1
	store %Rect %4, %Rect* %1
; if_0
	%5 = getelementptr %Rect, %Rect* %1, %Int32 0, %Int32 0, %Int32 0
	%6 = load %Int32, %Int32* %5
	%7 = icmp ne %Int32 %6, 0
	%8 = getelementptr %Rect, %Rect* %1, %Int32 0, %Int32 0, %Int32 1
	%9 = load %Int32, %Int32* %8
	%10 = icmp ne %Int32 %9, 0
	%11 = getelementptr %Rect, %Rect* %1, %Int32 0, %Int32 1, %Int32 0
	%12 = load %Int32, %Int32* %11
	%13 = icmp ne %Int32 %12, 10
	%14 = getelementptr %Rect, %Rect* %1, %Int32 0, %Int32 1, %Int32 1
	%15 = load %Int32, %Int32* %14
	%16 = icmp ne %Int32 %15, 20
	%17 = or %Bool %13, %16
	%18 = or %Bool %10, %17
	%19 = or %Bool %7, %18
	br %Bool %19 , label %then_0, label %endif_0
then_0:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str35 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%22 = alloca %Rect, align 4
	%23 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%24 = insertvalue %Point %23, %Int32 1, 1
	%25 = insertvalue %Rect zeroinitializer, %Point %24, 0
	store %Rect %25, %Rect* %22
; if_1
	%26 = getelementptr %Rect, %Rect* %22, %Int32 0, %Int32 0, %Int32 0
	%27 = load %Int32, %Int32* %26
	%28 = icmp ne %Int32 %27, 1
	%29 = getelementptr %Rect, %Rect* %22, %Int32 0, %Int32 0, %Int32 1
	%30 = load %Int32, %Int32* %29
	%31 = icmp ne %Int32 %30, 1
	%32 = or %Bool %28, %31
	br %Bool %32 , label %then_1, label %endif_1
then_1:
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @.str36 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%35 = getelementptr %Rect, %Rect* %22, %Int32 0, %Int32 1, %Int32 0
	%36 = load %Int32, %Int32* %35
	%37 = icmp ne %Int32 %36, 0
	%38 = getelementptr %Rect, %Rect* %22, %Int32 0, %Int32 1, %Int32 1
	%39 = load %Int32, %Int32* %38
	%40 = icmp ne %Int32 %39, 0
	%41 = or %Bool %37, %40
	br %Bool %41 , label %then_2, label %endif_2
then_2:
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([48 x i8]* @.str37 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str38 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @.str39 to [0 x i8]*))
	ret %Bool 1
}

@matrix = constant [2 x [3 x i8]] [
	[3 x i8] [
		i8 1,
		i8 2,
		i8 3
	],
	[3 x i8] [
		i8 4,
		i8 5,
		i8 6
	]
]
define %Bool @main_testNestedArrayConst() {
	%1 = alloca [2 x [3 x %Int32]], align 4
	%2 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%3 = insertvalue [3 x %Int32] %2, %Int32 2, 1
	%4 = insertvalue [3 x %Int32] %3, %Int32 3, 2
	%5 = insertvalue [2 x [3 x %Int32]] zeroinitializer, [3 x %Int32] %4, 0
	%6 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%7 = insertvalue [3 x %Int32] %6, %Int32 5, 1
	%8 = insertvalue [3 x %Int32] %7, %Int32 6, 2
	%9 = insertvalue [2 x [3 x %Int32]] %5, [3 x %Int32] %8, 1
	%10 = zext i8 2 to %Nat32
	store [2 x [3 x %Int32]] %9, [2 x [3 x %Int32]]* %1
; if_0
	%11 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %1, %Int32 0, %Int32 0, %Int32 0
	%12 = load %Int32, %Int32* %11
	%13 = icmp ne %Int32 %12, 1
	%14 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %1, %Int32 0, %Int32 0, %Int32 2
	%15 = load %Int32, %Int32* %14
	%16 = icmp ne %Int32 %15, 3
	%17 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %1, %Int32 0, %Int32 1, %Int32 0
	%18 = load %Int32, %Int32* %17
	%19 = icmp ne %Int32 %18, 4
	%20 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %1, %Int32 0, %Int32 1, %Int32 2
	%21 = load %Int32, %Int32* %20
	%22 = icmp ne %Int32 %21, 6
	%23 = or %Bool %19, %22
	%24 = or %Bool %16, %23
	%25 = or %Bool %13, %24
	br %Bool %25 , label %then_0, label %endif_0
then_0:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str40 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%28 = alloca [3 x [3 x %Int32]], align 4
	%29 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%30 = insertvalue [3 x %Int32] %29, %Int32 2, 1
	%31 = insertvalue [3 x %Int32] %30, %Int32 3, 2
	%32 = insertvalue [3 x [3 x %Int32]] zeroinitializer, [3 x %Int32] %31, 0
	%33 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%34 = insertvalue [3 x %Int32] %33, %Int32 5, 1
	%35 = insertvalue [3 x %Int32] %34, %Int32 6, 2
	%36 = insertvalue [3 x [3 x %Int32]] %32, [3 x %Int32] %35, 1
	%37 = zext i8 3 to %Nat32
	store [3 x [3 x %Int32]] %36, [3 x [3 x %Int32]]* %28
; if_1
	%38 = getelementptr [3 x [3 x %Int32]], [3 x [3 x %Int32]]* %28, %Int32 0, %Int32 0
	%39 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%40 = insertvalue [3 x %Int32] %39, %Int32 2, 1
	%41 = insertvalue [3 x %Int32] %40, %Int32 3, 2
	%42 = alloca [3 x %Int32]
	%43 = zext i8 3 to %Nat32
	store [3 x %Int32] %41, [3 x %Int32]* %42
	%44 = bitcast [3 x %Int32]* %38 to i8*
	%45 = bitcast [3 x %Int32]* %42 to i8*
	%46 = call i1 (i8*, i8*, i64) @memeq(i8* %44, i8* %45, %Int64 12)
	%47 = icmp eq %Bool %46, 0
	%48 = getelementptr [3 x [3 x %Int32]], [3 x [3 x %Int32]]* %28, %Int32 0, %Int32 1
	%49 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%50 = insertvalue [3 x %Int32] %49, %Int32 5, 1
	%51 = insertvalue [3 x %Int32] %50, %Int32 6, 2
	%52 = alloca [3 x %Int32]
	%53 = zext i8 3 to %Nat32
	store [3 x %Int32] %51, [3 x %Int32]* %52
	%54 = bitcast [3 x %Int32]* %48 to i8*
	%55 = bitcast [3 x %Int32]* %52 to i8*
	%56 = call i1 (i8*, i8*, i64) @memeq(i8* %54, i8* %55, %Int64 12)
	%57 = icmp eq %Bool %56, 0
	%58 = or %Bool %47, %57
	br %Bool %58 , label %then_1, label %endif_1
then_1:
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @.str41 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%61 = getelementptr [3 x [3 x %Int32]], [3 x [3 x %Int32]]* %28, %Int32 0, %Int32 2
	%62 = alloca [3 x %Int32]
	%63 = zext i8 3 to %Nat32
	%64 = mul %Nat32 %63, 4
	%65 = bitcast [3 x %Int32]* %62 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %65, i8 0, %Nat32 %64, i1 0)
	%66 = bitcast [3 x %Int32]* %61 to i8*
	%67 = bitcast [3 x %Int32]* %62 to i8*
	%68 = call i1 (i8*, i8*, i64) @memeq(i8* %66, i8* %67, %Int64 12)
	%69 = icmp eq %Bool %68, 0
	br %Bool %69 , label %then_2, label %endif_2
then_2:
	%70 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([40 x i8]* @.str42 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%72 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%73 = insertvalue [3 x %Int32] %72, %Int32 2, 1
	%74 = insertvalue [3 x %Int32] %73, %Int32 3, 2
	%75 = insertvalue [3 x [3 x %Int32]] zeroinitializer, [3 x %Int32] %74, 0
	%76 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%77 = insertvalue [3 x %Int32] %76, %Int32 5, 1
	%78 = insertvalue [3 x %Int32] %77, %Int32 6, 2
	%79 = insertvalue [3 x [3 x %Int32]] %75, [3 x %Int32] %78, 1
	%80 = alloca [3 x [3 x %Int32]]
	%81 = zext i8 3 to %Nat32
	store [3 x [3 x %Int32]] %79, [3 x [3 x %Int32]]* %80
	%82 = bitcast [3 x [3 x %Int32]]* %28 to i8*
	%83 = bitcast [3 x [3 x %Int32]]* %80 to i8*
	%84 = call i1 (i8*, i8*, i64) @memeq(i8* %82, i8* %83, %Int64 36)
	%85 = icmp eq %Bool %84, 0
	br %Bool %85 , label %then_3, label %endif_3
then_3:
	%86 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @.str43 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%88 = alloca [0 x {}]
	%89 = zext i8 0 to %Nat32
	%90 = mul %Nat32 %89, 0
	%91 = bitcast [0 x {}]* %88 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %91, i8 0, %Nat32 %90, i1 0)
	%92 = alloca [2 x [3 x %Int32]], align 4
	%93 = zext i8 2 to %Nat32
	%94 = mul %Nat32 %93, 12
	%95 = bitcast [2 x [3 x %Int32]]* %92 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %95, i8 0, %Nat32 %94, i1 0)
; if_4
	%96 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %92, %Int32 0, %Int32 0, %Int32 0
	%97 = load %Int32, %Int32* %96
	%98 = icmp ne %Int32 %97, 0
	%99 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %92, %Int32 0, %Int32 0, %Int32 1
	%100 = load %Int32, %Int32* %99
	%101 = icmp ne %Int32 %100, 0
	%102 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %92, %Int32 0, %Int32 0, %Int32 2
	%103 = load %Int32, %Int32* %102
	%104 = icmp ne %Int32 %103, 0
	%105 = or %Bool %101, %104
	%106 = or %Bool %98, %105
	br %Bool %106 , label %then_4, label %endif_4
then_4:
	%107 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str44 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
; if_5
	%109 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %92, %Int32 0, %Int32 1, %Int32 0
	%110 = load %Int32, %Int32* %109
	%111 = icmp ne %Int32 %110, 0
	%112 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %92, %Int32 0, %Int32 1, %Int32 1
	%113 = load %Int32, %Int32* %112
	%114 = icmp ne %Int32 %113, 0
	%115 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %92, %Int32 0, %Int32 1, %Int32 2
	%116 = load %Int32, %Int32* %115
	%117 = icmp ne %Int32 %116, 0
	%118 = or %Bool %114, %117
	%119 = or %Bool %111, %118
	br %Bool %119 , label %then_5, label %endif_5
then_5:
	%120 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str45 to [0 x i8]*))
	ret %Bool 0
	br label %endif_5
endif_5:
; if_6
	%122 = alloca [2 x [3 x %Int32]]
	%123 = zext i8 2 to %Nat32
	%124 = mul %Nat32 %123, 12
	%125 = bitcast [2 x [3 x %Int32]]* %122 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %125, i8 0, %Nat32 %124, i1 0)
	%126 = bitcast [2 x [3 x %Int32]]* %92 to i8*
	%127 = bitcast [2 x [3 x %Int32]]* %122 to i8*
	%128 = call i1 (i8*, i8*, i64) @memeq(i8* %126, i8* %127, %Int64 24)
	%129 = icmp eq %Bool %128, 0
	br %Bool %129 , label %then_6, label %endif_6
then_6:
	%130 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str46 to [0 x i8]*))
	ret %Bool 0
	br label %endif_6
endif_6:
; if_7
	%132 = alloca [2 x [3 x %Int32]]
	%133 = zext i8 2 to %Nat32
	%134 = mul %Nat32 %133, 12
	%135 = bitcast [2 x [3 x %Int32]]* %132 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %135, i8 0, %Nat32 %134, i1 0)
	%136 = bitcast [2 x [3 x %Int32]]* %92 to i8*
	%137 = bitcast [2 x [3 x %Int32]]* %132 to i8*
	%138 = call i1 (i8*, i8*, i64) @memeq(i8* %136, i8* %137, %Int64 24)
	%139 = icmp eq %Bool %138, 0
	br %Bool %139 , label %then_7, label %endif_7
then_7:
	%140 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str47 to [0 x i8]*))
	ret %Bool 0
	br label %endif_7
endif_7:
	%142 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @.str48 to [0 x i8]*))
	ret %Bool 1
}

@points = constant [3 x {
	i8,
	i8
}] [
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
	},
	{
	i8,
	i8
} {
		i8 3,
		i8 3
	}
]
define %Bool @main_testArrayOfRecordsConst() {
	%1 = alloca [3 x %Point], align 4
	%2 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%3 = insertvalue %Point %2, %Int32 1, 1
	%4 = insertvalue [3 x %Point] zeroinitializer, %Point %3, 0
	%5 = insertvalue %Point zeroinitializer, %Int32 2, 0
	%6 = insertvalue %Point %5, %Int32 2, 1
	%7 = insertvalue [3 x %Point] %4, %Point %6, 1
	%8 = insertvalue %Point zeroinitializer, %Int32 3, 0
	%9 = insertvalue %Point %8, %Int32 3, 1
	%10 = insertvalue [3 x %Point] %7, %Point %9, 2
	%11 = zext i8 3 to %Nat32
	store [3 x %Point] %10, [3 x %Point]* %1
; if_0
	%12 = getelementptr [3 x %Point], [3 x %Point]* %1, %Int32 0, %Int32 0
	%13 = getelementptr %Point, %Point* %12, %Int32 0, %Int32 0
	%14 = load %Int32, %Int32* %13
	%15 = icmp ne %Int32 %14, 1
	%16 = getelementptr [3 x %Point], [3 x %Point]* %1, %Int32 0, %Int32 0
	%17 = getelementptr %Point, %Point* %16, %Int32 0, %Int32 1
	%18 = load %Int32, %Int32* %17
	%19 = icmp ne %Int32 %18, 1
	%20 = getelementptr [3 x %Point], [3 x %Point]* %1, %Int32 0, %Int32 2
	%21 = getelementptr %Point, %Point* %20, %Int32 0, %Int32 0
	%22 = load %Int32, %Int32* %21
	%23 = icmp ne %Int32 %22, 3
	%24 = getelementptr [3 x %Point], [3 x %Point]* %1, %Int32 0, %Int32 2
	%25 = getelementptr %Point, %Point* %24, %Int32 0, %Int32 1
	%26 = load %Int32, %Int32* %25
	%27 = icmp ne %Int32 %26, 3
	%28 = or %Bool %23, %27
	%29 = or %Bool %19, %28
	%30 = or %Bool %15, %29
	br %Bool %30 , label %then_0, label %endif_0
then_0:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str49 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%33 = alloca [5 x %Point], align 4
	%34 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%35 = insertvalue %Point %34, %Int32 1, 1
	%36 = insertvalue [5 x %Point] zeroinitializer, %Point %35, 0
	%37 = insertvalue %Point zeroinitializer, %Int32 2, 0
	%38 = insertvalue %Point %37, %Int32 2, 1
	%39 = insertvalue [5 x %Point] %36, %Point %38, 1
	%40 = insertvalue %Point zeroinitializer, %Int32 3, 0
	%41 = insertvalue %Point %40, %Int32 3, 1
	%42 = insertvalue [5 x %Point] %39, %Point %41, 2
	%43 = zext i8 5 to %Nat32
	store [5 x %Point] %42, [5 x %Point]* %33
; if_1
	%44 = getelementptr [5 x %Point], [5 x %Point]* %33, %Int32 0, %Int32 2
	%45 = getelementptr %Point, %Point* %44, %Int32 0, %Int32 0
	%46 = load %Int32, %Int32* %45
	%47 = icmp ne %Int32 %46, 3
	%48 = getelementptr [5 x %Point], [5 x %Point]* %33, %Int32 0, %Int32 2
	%49 = getelementptr %Point, %Point* %48, %Int32 0, %Int32 1
	%50 = load %Int32, %Int32* %49
	%51 = icmp ne %Int32 %50, 3
	%52 = or %Bool %47, %51
	br %Bool %52 , label %then_1, label %endif_1
then_1:
	%53 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str50 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%55 = getelementptr [5 x %Point], [5 x %Point]* %33, %Int32 0, %Int32 3
	%56 = getelementptr %Point, %Point* %55, %Int32 0, %Int32 0
	%57 = load %Int32, %Int32* %56
	%58 = icmp ne %Int32 %57, 0
	%59 = getelementptr [5 x %Point], [5 x %Point]* %33, %Int32 0, %Int32 3
	%60 = getelementptr %Point, %Point* %59, %Int32 0, %Int32 1
	%61 = load %Int32, %Int32* %60
	%62 = icmp ne %Int32 %61, 0
	%63 = getelementptr [5 x %Point], [5 x %Point]* %33, %Int32 0, %Int32 4
	%64 = getelementptr %Point, %Point* %63, %Int32 0, %Int32 0
	%65 = load %Int32, %Int32* %64
	%66 = icmp ne %Int32 %65, 0
	%67 = getelementptr [5 x %Point], [5 x %Point]* %33, %Int32 0, %Int32 4
	%68 = getelementptr %Point, %Point* %67, %Int32 0, %Int32 1
	%69 = load %Int32, %Int32* %68
	%70 = icmp ne %Int32 %69, 0
	%71 = or %Bool %66, %70
	%72 = or %Bool %62, %71
	%73 = or %Bool %58, %72
	br %Bool %73 , label %then_2, label %endif_2
then_2:
	%74 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @.str51 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%76 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @.str52 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testRecordWithArrayFieldConst() {
	%1 = alloca %Poly3, align 4
	%2 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%3 = insertvalue [3 x %Point] zeroinitializer, %Point %2, 1
	%4 = insertvalue %Point zeroinitializer, %Int32 1, 1
	%5 = insertvalue [3 x %Point] %3, %Point %4, 2
	%6 = insertvalue %Poly3 zeroinitializer, [3 x %Point] %5, 0
	%7 = insertvalue %Poly3 %6, %Int32 3, 1
	store %Poly3 %7, %Poly3* %1
; if_0
	%8 = getelementptr %Poly3, %Poly3* %1, %Int32 0, %Int32 1
	%9 = load %Int32, %Int32* %8
	%10 = icmp ne %Int32 %9, 3
	br %Bool %10 , label %then_0, label %endif_0
then_0:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str53 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%13 = getelementptr %Poly3, %Poly3* %1, %Int32 0, %Int32 0
	%14 = getelementptr [3 x %Point], [3 x %Point]* %13, %Int32 0, %Int32 0
	%15 = getelementptr %Point, %Point* %14, %Int32 0, %Int32 0
	%16 = load %Int32, %Int32* %15
	%17 = icmp ne %Int32 %16, 0
	%18 = getelementptr %Poly3, %Poly3* %1, %Int32 0, %Int32 0
	%19 = getelementptr [3 x %Point], [3 x %Point]* %18, %Int32 0, %Int32 1
	%20 = getelementptr %Point, %Point* %19, %Int32 0, %Int32 0
	%21 = load %Int32, %Int32* %20
	%22 = icmp ne %Int32 %21, 1
	%23 = getelementptr %Poly3, %Poly3* %1, %Int32 0, %Int32 0
	%24 = getelementptr [3 x %Point], [3 x %Point]* %23, %Int32 0, %Int32 2
	%25 = getelementptr %Point, %Point* %24, %Int32 0, %Int32 1
	%26 = load %Int32, %Int32* %25
	%27 = icmp ne %Int32 %26, 1
	%28 = or %Bool %22, %27
	%29 = or %Bool %17, %28
	br %Bool %29 , label %then_1, label %endif_1
then_1:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str54 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%32 = alloca %Poly3, align 4
	%33 = insertvalue %Poly3 zeroinitializer, %Int32 1, 1
	store %Poly3 %33, %Poly3* %32
; if_2
	%34 = getelementptr %Poly3, %Poly3* %32, %Int32 0, %Int32 1
	%35 = load %Int32, %Int32* %34
	%36 = icmp ne %Int32 %35, 1
	br %Bool %36 , label %then_2, label %endif_2
then_2:
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @.str55 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%39 = getelementptr %Poly3, %Poly3* %32, %Int32 0, %Int32 0
	%40 = getelementptr [3 x %Point], [3 x %Point]* %39, %Int32 0, %Int32 0
	%41 = getelementptr %Point, %Point* %40, %Int32 0, %Int32 0
	%42 = load %Int32, %Int32* %41
	%43 = icmp ne %Int32 %42, 0
	%44 = getelementptr %Poly3, %Poly3* %32, %Int32 0, %Int32 0
	%45 = getelementptr [3 x %Point], [3 x %Point]* %44, %Int32 0, %Int32 1
	%46 = getelementptr %Point, %Point* %45, %Int32 0, %Int32 1
	%47 = load %Int32, %Int32* %46
	%48 = icmp ne %Int32 %47, 0
	%49 = getelementptr %Poly3, %Poly3* %32, %Int32 0, %Int32 0
	%50 = getelementptr [3 x %Point], [3 x %Point]* %49, %Int32 0, %Int32 2
	%51 = getelementptr %Point, %Point* %50, %Int32 0, %Int32 0
	%52 = load %Int32, %Int32* %51
	%53 = icmp ne %Int32 %52, 0
	%54 = or %Bool %48, %53
	%55 = or %Bool %43, %54
	br %Bool %55 , label %then_3, label %endif_3
then_3:
	%56 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([42 x i8]* @.str56 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @.str57 to [0 x i8]*))
	ret %Bool 1
}

@zeroArr = constant [4 x %Int32] zeroinitializer
@zeroPoints = constant [3 x %Point] zeroinitializer
@zeroMatrix = constant [2 x [3 x %Int32]] zeroinitializer
define %Bool @main_testEmptyLiteralConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str58 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str59 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str60 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str61 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @.str62 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testBrandedEnumConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str63 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str64 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str65 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str66 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @.str67 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testLocalConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str68 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%3 = alloca %Float64, align 8
	store %Float64 1.0000000000000000, %Float64* %3
; if_1
	%4 = load %Float64, %Float64* %3
	%5 = fcmp one %Float64 %4, 1.0000000000000000
	br %Bool %5 , label %then_1, label %endif_1
then_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str69 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str70 to [0 x i8]*))
	ret %Bool 1
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str71 to [0 x i8]*))
	%2 = alloca %Bool, align 1
	store %Bool 1, %Bool* %2
	%3 = call %Bool @main_testUntypedLiteralConst()
	%4 = load %Bool, %Bool* %2
	%5 = and %Bool %3, %4
	store %Bool %5, %Bool* %2
	%6 = call %Bool @main_testGenericAdaptation()
	%7 = load %Bool, %Bool* %2
	%8 = and %Bool %6, %7
	store %Bool %8, %Bool* %2
	%9 = call %Bool @main_testConstFolding()
	%10 = load %Bool, %Bool* %2
	%11 = and %Bool %9, %10
	store %Bool %11, %Bool* %2
	%12 = call %Bool @main_testTypedConst()
	%13 = load %Bool, %Bool* %2
	%14 = and %Bool %12, %13
	store %Bool %14, %Bool* %2
	%15 = call %Bool @main_testStringAndCharConst()
	%16 = load %Bool, %Bool* %2
	%17 = and %Bool %15, %16
	store %Bool %17, %Bool* %2
	%18 = call %Bool @main_testArrayConst()
	%19 = load %Bool, %Bool* %2
	%20 = and %Bool %18, %19
	store %Bool %20, %Bool* %2
	%21 = call %Bool @main_testRecordConst()
	%22 = load %Bool, %Bool* %2
	%23 = and %Bool %21, %22
	store %Bool %23, %Bool* %2
	%24 = call %Bool @main_testNestedRecordConst()
	%25 = load %Bool, %Bool* %2
	%26 = and %Bool %24, %25
	store %Bool %26, %Bool* %2
	%27 = call %Bool @main_testNestedArrayConst()
	%28 = load %Bool, %Bool* %2
	%29 = and %Bool %27, %28
	store %Bool %29, %Bool* %2
	%30 = call %Bool @main_testArrayOfRecordsConst()
	%31 = load %Bool, %Bool* %2
	%32 = and %Bool %30, %31
	store %Bool %32, %Bool* %2
	%33 = call %Bool @main_testRecordWithArrayFieldConst()
	%34 = load %Bool, %Bool* %2
	%35 = and %Bool %33, %34
	store %Bool %35, %Bool* %2
	%36 = call %Bool @main_testEmptyLiteralConst()
	%37 = load %Bool, %Bool* %2
	%38 = and %Bool %36, %37
	store %Bool %38, %Bool* %2
	%39 = call %Bool @main_testBrandedEnumConst()
	%40 = load %Bool, %Bool* %2
	%41 = and %Bool %39, %40
	store %Bool %41, %Bool* %2
	%42 = call %Bool @main_testLocalConst()
	%43 = load %Bool, %Bool* %2
	%44 = and %Bool %42, %43
	store %Bool %44, %Bool* %2
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @.str72 to [0 x i8]*))
; if_0
	%46 = load %Bool, %Bool* %2
	%47 = xor %Bool %46, 1
	br %Bool %47 , label %then_0, label %endif_0
then_0:
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str73 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%50 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str74 to [0 x i8]*))
	ret %Int 0
}


