
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
@.str1 = private constant [21 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 73, i8 110, i8 116, i8 56, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str2 = private constant [22 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str3 = private constant [22 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 78, i8 97, i8 116, i8 54, i8 52, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str4 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 70, i8 108, i8 111, i8 97, i8 116, i8 54, i8 52, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 46, i8 48, i8 10, i8 0]
@.str5 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 87, i8 111, i8 114, i8 100, i8 49, i8 54, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str6 = private constant [33 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 32, i8 97, i8 100, i8 97, i8 112, i8 116, i8 97, i8 116, i8 105, i8 111, i8 110, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str7 = private constant [17 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 119, i8 111, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@.str8 = private constant [22 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 111, i8 109, i8 98, i8 105, i8 110, i8 101, i8 100, i8 32, i8 33, i8 61, i8 32, i8 53, i8 10, i8 0]
@.str9 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 98, i8 105, i8 103, i8 32, i8 33, i8 61, i8 32, i8 49, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 10, i8 0]
@.str10 = private constant [21 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 104, i8 101, i8 120, i8 86, i8 97, i8 108, i8 32, i8 33, i8 61, i8 32, i8 52, i8 50, i8 10, i8 0]
@.str11 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 101, i8 103, i8 97, i8 116, i8 101, i8 100, i8 32, i8 33, i8 61, i8 32, i8 45, i8 52, i8 50, i8 10, i8 0]
@.str12 = private constant [28 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 102, i8 111, i8 108, i8 100, i8 105, i8 110, i8 103, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str13 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 78, i8 97, i8 116, i8 32, i8 33, i8 61, i8 32, i8 49, i8 48, i8 48, i8 10, i8 0]
@.str14 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 73, i8 110, i8 116, i8 32, i8 33, i8 61, i8 32, i8 45, i8 49, i8 48, i8 48, i8 10, i8 0]
@.str15 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 70, i8 108, i8 111, i8 97, i8 116, i8 32, i8 33, i8 61, i8 32, i8 51, i8 46, i8 53, i8 10, i8 0]
@.str16 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 70, i8 114, i8 111, i8 109, i8 71, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@.str17 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 121, i8 112, i8 101, i8 100, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str18 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 111, i8 102, i8 40, i8 103, i8 114, i8 101, i8 101, i8 116, i8 105, i8 110, i8 103, i8 41, i8 32, i8 33, i8 61, i8 32, i8 51, i8 10, i8 0]
@.str19 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 103, i8 114, i8 101, i8 101, i8 116, i8 105, i8 110, i8 103, i8 32, i8 99, i8 104, i8 97, i8 114, i8 115, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str20 = private constant [4 x i8] [i8 72, i8 105, i8 10, i8 0]
@.str21 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 103, i8 114, i8 101, i8 101, i8 116, i8 105, i8 110, i8 103, i8 91, i8 48, i8 93, i8 32, i8 33, i8 61, i8 32, i8 39, i8 72, i8 39, i8 10, i8 0]
@.str22 = private constant [18 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 104, i8 32, i8 33, i8 61, i8 32, i8 39, i8 65, i8 39, i8 10, i8 0]
@.str23 = private constant [32 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 116, i8 114, i8 105, i8 110, i8 103, i8 47, i8 99, i8 104, i8 97, i8 114, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str24 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 97, i8 109, i8 101, i8 32, i8 33, i8 61, i8 32, i8 91, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@.str25 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 110, i8 103, i8 101, i8 114, i8 32, i8 104, i8 101, i8 97, i8 100, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str26 = private constant [36 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 110, i8 103, i8 101, i8 114, i8 32, i8 116, i8 97, i8 105, i8 108, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str27 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str28 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 46, i8 120, i8 47, i8 112, i8 46, i8 121, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str29 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 51, i8 46, i8 120, i8 47, i8 112, i8 51, i8 46, i8 121, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str30 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 51, i8 46, i8 122, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str31 = private constant [27 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str32 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 114, i8 101, i8 99, i8 116, i8 67, i8 111, i8 110, i8 115, i8 116, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str33 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 114, i8 101, i8 99, i8 116, i8 80, i8 97, i8 114, i8 116, i8 105, i8 97, i8 108, i8 46, i8 116, i8 111, i8 112, i8 76, i8 101, i8 102, i8 116, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str34 = private constant [48 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 114, i8 101, i8 99, i8 116, i8 80, i8 97, i8 114, i8 116, i8 105, i8 97, i8 108, i8 46, i8 98, i8 111, i8 116, i8 116, i8 111, i8 109, i8 82, i8 105, i8 103, i8 104, i8 116, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str35 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 114, i8 101, i8 99, i8 116, i8 90, i8 101, i8 114, i8 111, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str36 = private constant [34 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 110, i8 101, i8 115, i8 116, i8 101, i8 100, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str37 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 109, i8 97, i8 116, i8 114, i8 105, i8 120, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str38 = private constant [28 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 119, i8 105, i8 100, i8 101, i8 114, i8 32, i8 104, i8 101, i8 97, i8 100, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str39 = private constant [40 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 119, i8 105, i8 100, i8 101, i8 114, i8 32, i8 101, i8 120, i8 116, i8 114, i8 97, i8 32, i8 114, i8 111, i8 119, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str40 = private constant [43 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 119, i8 105, i8 100, i8 101, i8 114, i8 32, i8 33, i8 61, i8 32, i8 91, i8 91, i8 49, i8 44, i8 50, i8 44, i8 51, i8 93, i8 44, i8 91, i8 52, i8 44, i8 53, i8 44, i8 54, i8 93, i8 44, i8 91, i8 48, i8 44, i8 48, i8 44, i8 48, i8 93, i8 93, i8 10, i8 0]
@.str41 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 109, i8 122, i8 32, i8 114, i8 111, i8 119, i8 32, i8 48, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str42 = private constant [30 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 109, i8 122, i8 32, i8 114, i8 111, i8 119, i8 32, i8 49, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str43 = private constant [33 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 110, i8 101, i8 115, i8 116, i8 101, i8 100, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str44 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 115, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str45 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 110, i8 103, i8 101, i8 114, i8 32, i8 104, i8 101, i8 97, i8 100, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str46 = private constant [44 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 110, i8 103, i8 101, i8 114, i8 32, i8 116, i8 97, i8 105, i8 108, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str47 = private constant [37 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 111, i8 102, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str48 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 114, i8 105, i8 97, i8 110, i8 103, i8 108, i8 101, i8 46, i8 99, i8 111, i8 117, i8 110, i8 116, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str49 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 116, i8 114, i8 105, i8 97, i8 110, i8 103, i8 108, i8 101, i8 46, i8 118, i8 101, i8 114, i8 116, i8 115, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str50 = private constant [35 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 111, i8 108, i8 121, i8 80, i8 97, i8 114, i8 116, i8 105, i8 97, i8 108, i8 46, i8 99, i8 111, i8 117, i8 110, i8 116, i8 32, i8 109, i8 105, i8 115, i8 109, i8 97, i8 116, i8 99, i8 104, i8 10, i8 0]
@.str51 = private constant [42 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 111, i8 108, i8 121, i8 80, i8 97, i8 114, i8 116, i8 105, i8 97, i8 108, i8 46, i8 118, i8 101, i8 114, i8 116, i8 115, i8 32, i8 110, i8 111, i8 116, i8 32, i8 122, i8 101, i8 114, i8 111, i8 45, i8 102, i8 105, i8 108, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str52 = private constant [44 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 119, i8 105, i8 116, i8 104, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 102, i8 105, i8 101, i8 108, i8 100, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str53 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 65, i8 114, i8 114, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str54 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 80, i8 111, i8 105, i8 110, i8 116, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str55 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 77, i8 97, i8 116, i8 114, i8 105, i8 120, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str56 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 122, i8 101, i8 114, i8 111, i8 80, i8 111, i8 105, i8 110, i8 116, i8 115, i8 32, i8 110, i8 111, i8 116, i8 32, i8 97, i8 108, i8 108, i8 32, i8 122, i8 101, i8 114, i8 111, i8 10, i8 0]
@.str57 = private constant [34 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 101, i8 109, i8 112, i8 116, i8 121, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str58 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 82, i8 101, i8 100, i8 32, i8 61, i8 61, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 71, i8 114, i8 101, i8 101, i8 110, i8 10, i8 0]
@.str59 = private constant [32 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 71, i8 114, i8 101, i8 101, i8 110, i8 32, i8 61, i8 61, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 66, i8 108, i8 117, i8 101, i8 10, i8 0]
@.str60 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 82, i8 101, i8 100, i8 32, i8 33, i8 61, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 82, i8 101, i8 100, i8 10, i8 0]
@.str61 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 78, i8 97, i8 116, i8 56, i8 32, i8 99, i8 111, i8 108, i8 111, i8 114, i8 71, i8 114, i8 101, i8 101, i8 110, i8 32, i8 33, i8 61, i8 32, i8 49, i8 10, i8 0]
@.str62 = private constant [33 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 98, i8 114, i8 97, i8 110, i8 100, i8 101, i8 100, i8 32, i8 101, i8 110, i8 117, i8 109, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str63 = private constant [22 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 99, i8 97, i8 108, i8 84, i8 119, i8 111, i8 32, i8 33, i8 61, i8 32, i8 50, i8 10, i8 0]
@.str64 = private constant [23 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 70, i8 108, i8 111, i8 97, i8 116, i8 32, i8 33, i8 61, i8 32, i8 49, i8 46, i8 48, i8 10, i8 0]
@.str65 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 108, i8 111, i8 99, i8 97, i8 108, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str66 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 10, i8 0]
@.str67 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@.str68 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str69 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
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
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str1 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%11 = load %Int32, %Int32* %2
	%12 = icmp ne %Int32 %11, 42
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str2 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%15 = load %Nat64, %Nat64* %3
	%16 = icmp ne %Nat64 %15, 42
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str3 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%19 = load %Float64, %Float64* %4
	%20 = fcmp one %Float64 %19, 42.0000000000000000
	br %Bool %20 , label %then_3, label %endif_3
then_3:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str4 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	%23 = zext i8 42 to %Word16
	%24 = load %Word16, %Word16* %5
	%25 = icmp ne %Word16 %24, %23
	br %Bool %25 , label %then_4, label %endif_4
then_4:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str5 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @.str6 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testConstFolding() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str7 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str8 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str9 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str10 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	br %Bool 0 , label %then_4, label %endif_4
then_4:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str11 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @.str12 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testTypedConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str14 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str15 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str16 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str17 to [0 x i8]*))
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
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str18 to [0 x i8]*))
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
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str19 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%17 = alloca %Str8*, align 8
	store %Str8* bitcast ([4 x i8]* @.str20 to [0 x i8]*), %Str8** %17
; if_2
	%18 = load %Str8*, %Str8** %17
	%19 = getelementptr %Str8, %Str8* %18, %Int32 0, %Int32 0
	%20 = load %Char8, %Char8* %19
	%21 = icmp ne %Char8 %20, 72
	br %Bool %21 , label %then_2, label %endif_2
then_2:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str21 to [0 x i8]*))
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
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str22 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str23 to [0 x i8]*))
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
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str24 to [0 x i8]*))
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
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str25 to [0 x i8]*))
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
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([36 x i8]* @.str26 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str27 to [0 x i8]*))
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
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str28 to [0 x i8]*))
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
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str29 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%25 = getelementptr %Point3D, %Point3D* %13, %Int32 0, %Int32 2
	%26 = load %Int32, %Int32* %25
	%27 = icmp ne %Int32 %26, 0
	br %Bool %27 , label %then_2, label %endif_2
then_2:
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str30 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str31 to [0 x i8]*))
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
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str32 to [0 x i8]*))
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
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @.str33 to [0 x i8]*))
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
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([48 x i8]* @.str34 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str35 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @.str36 to [0 x i8]*))
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
	%5 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%6 = insertvalue [3 x %Int32] %5, %Int32 5, 1
	%7 = insertvalue [3 x %Int32] %6, %Int32 6, 2
	%8 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%9 = insertvalue [3 x %Int32] %8, %Int32 2, 1
	%10 = insertvalue [3 x %Int32] %9, %Int32 3, 2
	%11 = insertvalue [2 x [3 x %Int32]] zeroinitializer, [3 x %Int32] %10, 0
	%12 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%13 = insertvalue [3 x %Int32] %12, %Int32 5, 1
	%14 = insertvalue [3 x %Int32] %13, %Int32 6, 2
	%15 = insertvalue [2 x [3 x %Int32]] %11, [3 x %Int32] %14, 1
	%16 = zext i8 2 to %Nat32
	store [2 x [3 x %Int32]] %15, [2 x [3 x %Int32]]* %1
; if_0
	%17 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %1, %Int32 0, %Int32 0, %Int32 0
	%18 = load %Int32, %Int32* %17
	%19 = icmp ne %Int32 %18, 1
	%20 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %1, %Int32 0, %Int32 0, %Int32 2
	%21 = load %Int32, %Int32* %20
	%22 = icmp ne %Int32 %21, 3
	%23 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %1, %Int32 0, %Int32 1, %Int32 0
	%24 = load %Int32, %Int32* %23
	%25 = icmp ne %Int32 %24, 4
	%26 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %1, %Int32 0, %Int32 1, %Int32 2
	%27 = load %Int32, %Int32* %26
	%28 = icmp ne %Int32 %27, 6
	%29 = or %Bool %25, %28
	%30 = or %Bool %22, %29
	%31 = or %Bool %19, %30
	br %Bool %31 , label %then_0, label %endif_0
then_0:
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str37 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%34 = alloca [3 x [3 x %Int32]], align 4
	%35 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%36 = insertvalue [3 x %Int32] %35, %Int32 2, 1
	%37 = insertvalue [3 x %Int32] %36, %Int32 3, 2
	%38 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%39 = insertvalue [3 x %Int32] %38, %Int32 5, 1
	%40 = insertvalue [3 x %Int32] %39, %Int32 6, 2
	%41 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%42 = insertvalue [3 x %Int32] %41, %Int32 2, 1
	%43 = insertvalue [3 x %Int32] %42, %Int32 3, 2
	%44 = insertvalue [3 x [3 x %Int32]] zeroinitializer, [3 x %Int32] %43, 0
	%45 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%46 = insertvalue [3 x %Int32] %45, %Int32 5, 1
	%47 = insertvalue [3 x %Int32] %46, %Int32 6, 2
	%48 = insertvalue [3 x [3 x %Int32]] %44, [3 x %Int32] %47, 1
	%49 = zext i8 3 to %Nat32
	store [3 x [3 x %Int32]] %48, [3 x [3 x %Int32]]* %34
; if_1
	%50 = getelementptr [3 x [3 x %Int32]], [3 x [3 x %Int32]]* %34, %Int32 0, %Int32 0
	%51 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%52 = insertvalue [3 x %Int32] %51, %Int32 2, 1
	%53 = insertvalue [3 x %Int32] %52, %Int32 3, 2
	%54 = alloca [3 x %Int32]
	%55 = zext i8 3 to %Nat32
	store [3 x %Int32] %53, [3 x %Int32]* %54
	%56 = bitcast [3 x %Int32]* %50 to i8*
	%57 = bitcast [3 x %Int32]* %54 to i8*
	%58 = call i1 (i8*, i8*, i64) @memeq(i8* %56, i8* %57, %Int64 12)
	%59 = icmp eq %Bool %58, 0
	%60 = getelementptr [3 x [3 x %Int32]], [3 x [3 x %Int32]]* %34, %Int32 0, %Int32 1
	%61 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%62 = insertvalue [3 x %Int32] %61, %Int32 5, 1
	%63 = insertvalue [3 x %Int32] %62, %Int32 6, 2
	%64 = alloca [3 x %Int32]
	%65 = zext i8 3 to %Nat32
	store [3 x %Int32] %63, [3 x %Int32]* %64
	%66 = bitcast [3 x %Int32]* %60 to i8*
	%67 = bitcast [3 x %Int32]* %64 to i8*
	%68 = call i1 (i8*, i8*, i64) @memeq(i8* %66, i8* %67, %Int64 12)
	%69 = icmp eq %Bool %68, 0
	%70 = or %Bool %59, %69
	br %Bool %70 , label %then_1, label %endif_1
then_1:
	%71 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @.str38 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%73 = getelementptr [3 x [3 x %Int32]], [3 x [3 x %Int32]]* %34, %Int32 0, %Int32 2
	%74 = alloca [3 x %Int32]
	%75 = zext i8 3 to %Nat32
	%76 = mul %Nat32 %75, 4
	%77 = bitcast [3 x %Int32]* %74 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %77, i8 0, %Nat32 %76, i1 0)
	%78 = bitcast [3 x %Int32]* %73 to i8*
	%79 = bitcast [3 x %Int32]* %74 to i8*
	%80 = call i1 (i8*, i8*, i64) @memeq(i8* %78, i8* %79, %Int64 12)
	%81 = icmp eq %Bool %80, 0
	br %Bool %81 , label %then_2, label %endif_2
then_2:
	%82 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([40 x i8]* @.str39 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%84 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%85 = insertvalue [3 x %Int32] %84, %Int32 2, 1
	%86 = insertvalue [3 x %Int32] %85, %Int32 3, 2
	%87 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%88 = insertvalue [3 x %Int32] %87, %Int32 5, 1
	%89 = insertvalue [3 x %Int32] %88, %Int32 6, 2
	%90 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%91 = insertvalue [3 x %Int32] %90, %Int32 2, 1
	%92 = insertvalue [3 x %Int32] %91, %Int32 3, 2
	%93 = insertvalue [3 x [3 x %Int32]] zeroinitializer, [3 x %Int32] %92, 0
	%94 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%95 = insertvalue [3 x %Int32] %94, %Int32 5, 1
	%96 = insertvalue [3 x %Int32] %95, %Int32 6, 2
	%97 = insertvalue [3 x [3 x %Int32]] %93, [3 x %Int32] %96, 1
	%98 = alloca [3 x [3 x %Int32]]
	%99 = zext i8 3 to %Nat32
	store [3 x [3 x %Int32]] %97, [3 x [3 x %Int32]]* %98
	%100 = bitcast [3 x [3 x %Int32]]* %34 to i8*
	%101 = bitcast [3 x [3 x %Int32]]* %98 to i8*
	%102 = call i1 (i8*, i8*, i64) @memeq(i8* %100, i8* %101, %Int64 36)
	%103 = icmp eq %Bool %102, 0
	br %Bool %103 , label %then_3, label %endif_3
then_3:
	%104 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @.str40 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%106 = alloca [2 x [3 x %Int32]], align 4
	%107 = zext i8 2 to %Nat32
	%108 = mul %Nat32 %107, 12
	%109 = bitcast [2 x [3 x %Int32]]* %106 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %109, i8 0, %Nat32 %108, i1 0)
; if_4
	%110 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %106, %Int32 0, %Int32 0, %Int32 0
	%111 = load %Int32, %Int32* %110
	%112 = icmp ne %Int32 %111, 0
	%113 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %106, %Int32 0, %Int32 0, %Int32 1
	%114 = load %Int32, %Int32* %113
	%115 = icmp ne %Int32 %114, 0
	%116 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %106, %Int32 0, %Int32 0, %Int32 2
	%117 = load %Int32, %Int32* %116
	%118 = icmp ne %Int32 %117, 0
	%119 = or %Bool %115, %118
	%120 = or %Bool %112, %119
	br %Bool %120 , label %then_4, label %endif_4
then_4:
	%121 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str41 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
; if_5
	%123 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %106, %Int32 0, %Int32 1, %Int32 0
	%124 = load %Int32, %Int32* %123
	%125 = icmp ne %Int32 %124, 0
	%126 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %106, %Int32 0, %Int32 1, %Int32 1
	%127 = load %Int32, %Int32* %126
	%128 = icmp ne %Int32 %127, 0
	%129 = getelementptr [2 x [3 x %Int32]], [2 x [3 x %Int32]]* %106, %Int32 0, %Int32 1, %Int32 2
	%130 = load %Int32, %Int32* %129
	%131 = icmp ne %Int32 %130, 0
	%132 = or %Bool %128, %131
	%133 = or %Bool %125, %132
	br %Bool %133 , label %then_5, label %endif_5
then_5:
	%134 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str42 to [0 x i8]*))
	ret %Bool 0
	br label %endif_5
endif_5:
	%136 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @.str43 to [0 x i8]*))
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
	%4 = insertvalue %Point zeroinitializer, %Int32 2, 0
	%5 = insertvalue %Point %4, %Int32 2, 1
	%6 = insertvalue %Point zeroinitializer, %Int32 3, 0
	%7 = insertvalue %Point %6, %Int32 3, 1
	%8 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%9 = insertvalue %Point %8, %Int32 1, 1
	%10 = insertvalue [3 x %Point] zeroinitializer, %Point %9, 0
	%11 = insertvalue %Point zeroinitializer, %Int32 2, 0
	%12 = insertvalue %Point %11, %Int32 2, 1
	%13 = insertvalue [3 x %Point] %10, %Point %12, 1
	%14 = insertvalue %Point zeroinitializer, %Int32 3, 0
	%15 = insertvalue %Point %14, %Int32 3, 1
	%16 = insertvalue [3 x %Point] %13, %Point %15, 2
	%17 = zext i8 3 to %Nat32
	store [3 x %Point] %16, [3 x %Point]* %1
; if_0
	%18 = getelementptr [3 x %Point], [3 x %Point]* %1, %Int32 0, %Int32 0
	%19 = getelementptr %Point, %Point* %18, %Int32 0, %Int32 0
	%20 = load %Int32, %Int32* %19
	%21 = icmp ne %Int32 %20, 1
	%22 = getelementptr [3 x %Point], [3 x %Point]* %1, %Int32 0, %Int32 0
	%23 = getelementptr %Point, %Point* %22, %Int32 0, %Int32 1
	%24 = load %Int32, %Int32* %23
	%25 = icmp ne %Int32 %24, 1
	%26 = getelementptr [3 x %Point], [3 x %Point]* %1, %Int32 0, %Int32 2
	%27 = getelementptr %Point, %Point* %26, %Int32 0, %Int32 0
	%28 = load %Int32, %Int32* %27
	%29 = icmp ne %Int32 %28, 3
	%30 = getelementptr [3 x %Point], [3 x %Point]* %1, %Int32 0, %Int32 2
	%31 = getelementptr %Point, %Point* %30, %Int32 0, %Int32 1
	%32 = load %Int32, %Int32* %31
	%33 = icmp ne %Int32 %32, 3
	%34 = or %Bool %29, %33
	%35 = or %Bool %25, %34
	%36 = or %Bool %21, %35
	br %Bool %36 , label %then_0, label %endif_0
then_0:
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str44 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%39 = alloca [5 x %Point], align 4
	%40 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%41 = insertvalue %Point %40, %Int32 1, 1
	%42 = insertvalue %Point zeroinitializer, %Int32 2, 0
	%43 = insertvalue %Point %42, %Int32 2, 1
	%44 = insertvalue %Point zeroinitializer, %Int32 3, 0
	%45 = insertvalue %Point %44, %Int32 3, 1
	%46 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%47 = insertvalue %Point %46, %Int32 1, 1
	%48 = insertvalue [5 x %Point] zeroinitializer, %Point %47, 0
	%49 = insertvalue %Point zeroinitializer, %Int32 2, 0
	%50 = insertvalue %Point %49, %Int32 2, 1
	%51 = insertvalue [5 x %Point] %48, %Point %50, 1
	%52 = insertvalue %Point zeroinitializer, %Int32 3, 0
	%53 = insertvalue %Point %52, %Int32 3, 1
	%54 = insertvalue [5 x %Point] %51, %Point %53, 2
	%55 = zext i8 5 to %Nat32
	store [5 x %Point] %54, [5 x %Point]* %39
; if_1
	%56 = getelementptr [5 x %Point], [5 x %Point]* %39, %Int32 0, %Int32 2
	%57 = getelementptr %Point, %Point* %56, %Int32 0, %Int32 0
	%58 = load %Int32, %Int32* %57
	%59 = icmp ne %Int32 %58, 3
	%60 = getelementptr [5 x %Point], [5 x %Point]* %39, %Int32 0, %Int32 2
	%61 = getelementptr %Point, %Point* %60, %Int32 0, %Int32 1
	%62 = load %Int32, %Int32* %61
	%63 = icmp ne %Int32 %62, 3
	%64 = or %Bool %59, %63
	br %Bool %64 , label %then_1, label %endif_1
then_1:
	%65 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str45 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%67 = getelementptr [5 x %Point], [5 x %Point]* %39, %Int32 0, %Int32 3
	%68 = getelementptr %Point, %Point* %67, %Int32 0, %Int32 0
	%69 = load %Int32, %Int32* %68
	%70 = icmp ne %Int32 %69, 0
	%71 = getelementptr [5 x %Point], [5 x %Point]* %39, %Int32 0, %Int32 3
	%72 = getelementptr %Point, %Point* %71, %Int32 0, %Int32 1
	%73 = load %Int32, %Int32* %72
	%74 = icmp ne %Int32 %73, 0
	%75 = getelementptr [5 x %Point], [5 x %Point]* %39, %Int32 0, %Int32 4
	%76 = getelementptr %Point, %Point* %75, %Int32 0, %Int32 0
	%77 = load %Int32, %Int32* %76
	%78 = icmp ne %Int32 %77, 0
	%79 = getelementptr [5 x %Point], [5 x %Point]* %39, %Int32 0, %Int32 4
	%80 = getelementptr %Point, %Point* %79, %Int32 0, %Int32 1
	%81 = load %Int32, %Int32* %80
	%82 = icmp ne %Int32 %81, 0
	%83 = or %Bool %78, %82
	%84 = or %Bool %74, %83
	%85 = or %Bool %70, %84
	br %Bool %85 , label %then_2, label %endif_2
then_2:
	%86 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @.str46 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%88 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @.str47 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testRecordWithArrayFieldConst() {
	%1 = alloca %Poly3, align 4
	%2 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%3 = insertvalue %Point zeroinitializer, %Int32 1, 1
	%4 = insertvalue %Point zeroinitializer, %Int32 1, 0
	%5 = insertvalue [3 x %Point] zeroinitializer, %Point %4, 1
	%6 = insertvalue %Point zeroinitializer, %Int32 1, 1
	%7 = insertvalue [3 x %Point] %5, %Point %6, 2
	%8 = insertvalue %Poly3 zeroinitializer, [3 x %Point] %7, 0
	%9 = insertvalue %Poly3 %8, %Int32 3, 1
	store %Poly3 %9, %Poly3* %1
; if_0
	%10 = getelementptr %Poly3, %Poly3* %1, %Int32 0, %Int32 1
	%11 = load %Int32, %Int32* %10
	%12 = icmp ne %Int32 %11, 3
	br %Bool %12 , label %then_0, label %endif_0
then_0:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str48 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%15 = getelementptr %Poly3, %Poly3* %1, %Int32 0, %Int32 0
	%16 = getelementptr [3 x %Point], [3 x %Point]* %15, %Int32 0, %Int32 0
	%17 = getelementptr %Point, %Point* %16, %Int32 0, %Int32 0
	%18 = load %Int32, %Int32* %17
	%19 = icmp ne %Int32 %18, 0
	%20 = getelementptr %Poly3, %Poly3* %1, %Int32 0, %Int32 0
	%21 = getelementptr [3 x %Point], [3 x %Point]* %20, %Int32 0, %Int32 1
	%22 = getelementptr %Point, %Point* %21, %Int32 0, %Int32 0
	%23 = load %Int32, %Int32* %22
	%24 = icmp ne %Int32 %23, 1
	%25 = getelementptr %Poly3, %Poly3* %1, %Int32 0, %Int32 0
	%26 = getelementptr [3 x %Point], [3 x %Point]* %25, %Int32 0, %Int32 2
	%27 = getelementptr %Point, %Point* %26, %Int32 0, %Int32 1
	%28 = load %Int32, %Int32* %27
	%29 = icmp ne %Int32 %28, 1
	%30 = or %Bool %24, %29
	%31 = or %Bool %19, %30
	br %Bool %31 , label %then_1, label %endif_1
then_1:
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str49 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%34 = alloca %Poly3, align 4
	%35 = insertvalue %Poly3 zeroinitializer, %Int32 1, 1
	store %Poly3 %35, %Poly3* %34
; if_2
	%36 = getelementptr %Poly3, %Poly3* %34, %Int32 0, %Int32 1
	%37 = load %Int32, %Int32* %36
	%38 = icmp ne %Int32 %37, 1
	br %Bool %38 , label %then_2, label %endif_2
then_2:
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @.str50 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%41 = getelementptr %Poly3, %Poly3* %34, %Int32 0, %Int32 0
	%42 = getelementptr [3 x %Point], [3 x %Point]* %41, %Int32 0, %Int32 0
	%43 = getelementptr %Point, %Point* %42, %Int32 0, %Int32 0
	%44 = load %Int32, %Int32* %43
	%45 = icmp ne %Int32 %44, 0
	%46 = getelementptr %Poly3, %Poly3* %34, %Int32 0, %Int32 0
	%47 = getelementptr [3 x %Point], [3 x %Point]* %46, %Int32 0, %Int32 1
	%48 = getelementptr %Point, %Point* %47, %Int32 0, %Int32 1
	%49 = load %Int32, %Int32* %48
	%50 = icmp ne %Int32 %49, 0
	%51 = getelementptr %Poly3, %Poly3* %34, %Int32 0, %Int32 0
	%52 = getelementptr [3 x %Point], [3 x %Point]* %51, %Int32 0, %Int32 2
	%53 = getelementptr %Point, %Point* %52, %Int32 0, %Int32 0
	%54 = load %Int32, %Int32* %53
	%55 = icmp ne %Int32 %54, 0
	%56 = or %Bool %50, %55
	%57 = or %Bool %45, %56
	br %Bool %57 , label %then_3, label %endif_3
then_3:
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([42 x i8]* @.str51 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%60 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @.str52 to [0 x i8]*))
	ret %Bool 1
}

@zeroArr = constant [4 x %Int32] [
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0
]
@zeroPoints = constant [3 x %Point] [
	%Point zeroinitializer,
	%Point zeroinitializer,
	%Point zeroinitializer
]
@zeroMatrix = constant [2 x [3 x %Int32]] [
	[3 x %Int32] zeroinitializer,
	[3 x %Int32] zeroinitializer
]
define %Bool @main_testEmptyLiteralConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str53 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str54 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str55 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str56 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @.str57 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testBrandedEnumConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str58 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str59 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str60 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str61 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @.str62 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testLocalConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str63 to [0 x i8]*))
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
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str64 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str65 to [0 x i8]*))
	ret %Bool 1
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str66 to [0 x i8]*))
	%2 = alloca %Bool, align 1
	store %Bool 1, %Bool* %2
	%3 = call %Bool @main_testGenericAdaptation()
	%4 = load %Bool, %Bool* %2
	%5 = and %Bool %3, %4
	store %Bool %5, %Bool* %2
	%6 = call %Bool @main_testConstFolding()
	%7 = load %Bool, %Bool* %2
	%8 = and %Bool %6, %7
	store %Bool %8, %Bool* %2
	%9 = call %Bool @main_testTypedConst()
	%10 = load %Bool, %Bool* %2
	%11 = and %Bool %9, %10
	store %Bool %11, %Bool* %2
	%12 = call %Bool @main_testStringAndCharConst()
	%13 = load %Bool, %Bool* %2
	%14 = and %Bool %12, %13
	store %Bool %14, %Bool* %2
	%15 = call %Bool @main_testArrayConst()
	%16 = load %Bool, %Bool* %2
	%17 = and %Bool %15, %16
	store %Bool %17, %Bool* %2
	%18 = call %Bool @main_testRecordConst()
	%19 = load %Bool, %Bool* %2
	%20 = and %Bool %18, %19
	store %Bool %20, %Bool* %2
	%21 = call %Bool @main_testNestedRecordConst()
	%22 = load %Bool, %Bool* %2
	%23 = and %Bool %21, %22
	store %Bool %23, %Bool* %2
	%24 = call %Bool @main_testNestedArrayConst()
	%25 = load %Bool, %Bool* %2
	%26 = and %Bool %24, %25
	store %Bool %26, %Bool* %2
	%27 = call %Bool @main_testArrayOfRecordsConst()
	%28 = load %Bool, %Bool* %2
	%29 = and %Bool %27, %28
	store %Bool %29, %Bool* %2
	%30 = call %Bool @main_testRecordWithArrayFieldConst()
	%31 = load %Bool, %Bool* %2
	%32 = and %Bool %30, %31
	store %Bool %32, %Bool* %2
	%33 = call %Bool @main_testEmptyLiteralConst()
	%34 = load %Bool, %Bool* %2
	%35 = and %Bool %33, %34
	store %Bool %35, %Bool* %2
	%36 = call %Bool @main_testBrandedEnumConst()
	%37 = load %Bool, %Bool* %2
	%38 = and %Bool %36, %37
	store %Bool %38, %Bool* %2
	%39 = call %Bool @main_testLocalConst()
	%40 = load %Bool, %Bool* %2
	%41 = and %Bool %39, %40
	store %Bool %41, %Bool* %2
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @.str67 to [0 x i8]*))
; if_0
	%43 = load %Bool, %Bool* %2
	%44 = xor %Bool %43, 1
	br %Bool %44 , label %then_0, label %endif_0
then_0:
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str68 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str69 to [0 x i8]*))
	ret %Int 0
}


