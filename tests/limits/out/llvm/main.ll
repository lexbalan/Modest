
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
; from included limits
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 56, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 110, i8 97, i8 116, i8 56, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str2 = private constant [44 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 56, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 110, i8 97, i8 116, i8 56, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str3 = private constant [45 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 56, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 110, i8 97, i8 116, i8 56, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str4 = private constant [19 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 78, i8 97, i8 116, i8 56, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str5 = private constant [39 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str6 = private constant [46 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str7 = private constant [47 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str8 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 78, i8 97, i8 116, i8 49, i8 54, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str9 = private constant [39 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str10 = private constant [46 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str11 = private constant [47 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str12 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str13 = private constant [39 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str14 = private constant [46 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str15 = private constant [47 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str16 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 78, i8 97, i8 116, i8 54, i8 52, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str17 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 56, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 62, i8 61, i8 32, i8 48, i8 10, i8 0]
@str18 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 56, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 48, i8 10, i8 0]
@str19 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 56, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 105, i8 110, i8 116, i8 56, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str20 = private constant [44 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 56, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 105, i8 110, i8 116, i8 56, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str21 = private constant [45 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 56, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 105, i8 110, i8 116, i8 56, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str22 = private constant [19 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 73, i8 110, i8 116, i8 56, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str23 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 62, i8 61, i8 32, i8 48, i8 10, i8 0]
@str24 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 48, i8 10, i8 0]
@str25 = private constant [39 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 105, i8 110, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str26 = private constant [46 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 105, i8 110, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str27 = private constant [47 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 105, i8 110, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str28 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 73, i8 110, i8 116, i8 49, i8 54, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str29 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 62, i8 61, i8 32, i8 48, i8 10, i8 0]
@str30 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 48, i8 10, i8 0]
@str31 = private constant [39 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 105, i8 110, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str32 = private constant [46 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 105, i8 110, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str33 = private constant [47 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 105, i8 110, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str34 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str35 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 62, i8 61, i8 32, i8 48, i8 10, i8 0]
@str36 = private constant [27 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 48, i8 10, i8 0]
@str37 = private constant [39 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 32, i8 60, i8 61, i8 32, i8 105, i8 110, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str38 = private constant [46 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 105, i8 110, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str39 = private constant [47 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 105, i8 110, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 86, i8 97, i8 108, i8 117, i8 101, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 105, i8 110, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 86, i8 97, i8 108, i8 117, i8 101, i8 10, i8 0]
@str40 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 73, i8 110, i8 116, i8 54, i8 52, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str41 = private constant [24 x i8] [i8 51, i8 46, i8 48, i8 32, i8 43, i8 32, i8 50, i8 46, i8 48, i8 32, i8 33, i8 61, i8 32, i8 53, i8 46, i8 48, i8 32, i8 40, i8 61, i8 37, i8 102, i8 41, i8 10, i8 0]
@str42 = private constant [24 x i8] [i8 51, i8 46, i8 48, i8 32, i8 45, i8 32, i8 50, i8 46, i8 48, i8 32, i8 33, i8 61, i8 32, i8 49, i8 46, i8 48, i8 32, i8 40, i8 61, i8 37, i8 102, i8 41, i8 10, i8 0]
@str43 = private constant [24 x i8] [i8 51, i8 46, i8 48, i8 32, i8 42, i8 32, i8 50, i8 46, i8 48, i8 32, i8 33, i8 61, i8 32, i8 54, i8 46, i8 48, i8 32, i8 40, i8 61, i8 37, i8 102, i8 41, i8 10, i8 0]
@str44 = private constant [24 x i8] [i8 51, i8 46, i8 48, i8 32, i8 47, i8 32, i8 50, i8 46, i8 48, i8 32, i8 33, i8 61, i8 32, i8 49, i8 46, i8 53, i8 32, i8 40, i8 61, i8 37, i8 102, i8 41, i8 10, i8 0]
@str45 = private constant [22 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 73, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str46 = private constant [19 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 105, i8 32, i8 33, i8 61, i8 32, i8 51, i8 46, i8 49, i8 52, i8 10, i8 0]
@str47 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str48 = private constant [17 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 112, i8 105, i8 32, i8 33, i8 61, i8 32, i8 51, i8 10, i8 0]
@str49 = private constant [23 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 82, i8 97, i8 116, i8 105, i8 111, i8 110, i8 97, i8 108, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str50 = private constant [24 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 110, i8 117, i8 109, i8 101, i8 114, i8 105, i8 99, i8 32, i8 98, i8 111, i8 117, i8 110, i8 100, i8 97, i8 114, i8 121, i8 58, i8 10, i8 0]
@str51 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@str52 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str53 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --

; constants check (error)
;const nat8MaxValuePlusOne = Nat8 nat8MaxValue + 1
;const nat8MinValueMinusOne = Nat8 nat8MinValue - 1
;const nat16MaxValuePlusOne = Nat16 nat16MaxValue + 1
;const nat16MinValueMinusOne = Nat16 nat16MinValue - 1
;const nat32MaxValuePlusOne = Nat32 nat32MaxValue + 1
;const nat32MinValueMinusOne = Nat32 nat32MinValue - 1
;const nat64MaxValuePlusOne = Nat64 nat64MaxValue + 1
;const nat64MinValueMinusOne = Nat64 nat64MinValue - 1
;
;const int8MaxValuePlusOne = Int8 int8MaxValue + 1
;const int8MinValueMinusOne = Int8 int8MinValue - 1
;const int16MaxValuePlusOne = Int16 int16MaxValue + 1
;const int16MinValueMinusOne = Int16 int16MinValue - 1
;const int32MaxValuePlusOne = Int32 int32MaxValue + 1
;const int32MinValueMinusOne = Int32 int32MinValue - 1
;const int64MaxValuePlusOne = Int64 int64MaxValue + 1
;const int64MinValueMinusOne = Int64 int64MinValue - 1


;const float32MaxValue       = Float32 3.4028234663852886e+38
;const float32MinValueNormal = Float32 1.1754943508222875e-38
;const float32MinValueSub    = Float32 1.401298464324817e-45
;const float32Epsilon   = Float32 1.1920928955078125e-7
;
;const float32PosInf    = Float32 1.0 / 0.0
;const float32NaN       = Float32 0.0 / 0.0
;const float32NegInf    = Float32 -1.0 / 0.0
;
;const float64PosInf    = Float64 1.0 / 0.0
;const float64NaN       = Float64 0.0 / 0.0
;const float64NegInf    = Float64 -1.0 / 0.0
define internal %Bool @testNat8Static() {
	%1 = alloca %Nat8, align 1
	store %Nat8 255, %Nat8* %1	; ok
	store %Nat8 0, %Nat8* %1	; ok
	;nat8 = nat8MaxValue + 1  // error: unsigned integer overflow
	;nat8 = nat8MinValue - 1  // error: unsigned integer overflow
	%2 = alloca %Nat8, align 1
	store %Nat8 255, %Nat8* %2
	%3 = alloca %Nat8, align 1
	store %Nat8 0, %Nat8* %3
; if_0
	%4 = load %Nat8, %Nat8* %2
	%5 = load %Nat8, %Nat8* %3
	%6 = icmp ule %Nat8 %4, %5
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str1 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%9 = load %Nat8, %Nat8* %2
	%10 = add %Nat8 %9, 1
	%11 = load %Nat8, %Nat8* %3
	%12 = icmp ne %Nat8 %10, %11
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @str2 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%15 = load %Nat8, %Nat8* %3
	%16 = sub %Nat8 %15, 1
	%17 = load %Nat8, %Nat8* %2
	%18 = icmp ne %Nat8 %16, %17
	br %Bool %18 , label %then_2, label %endif_2
then_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([45 x i8]* @str3 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str4 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testNat16Static() {
	%1 = alloca %Nat16, align 2
	store %Nat16 65535, %Nat16* %1	; ok
	store %Nat16 0, %Nat16* %1	; ok
	;nat16 = nat16MaxValue + 1  // error: unsigned integer overflow
	;nat16 = nat16MinValue - 1  // error: unsigned integer overflow
	%2 = alloca %Nat16, align 2
	store %Nat16 0, %Nat16* %2
	%3 = alloca %Nat16, align 2
	store %Nat16 65535, %Nat16* %3
; if_0
	%4 = load %Nat16, %Nat16* %3
	%5 = load %Nat16, %Nat16* %2
	%6 = icmp ule %Nat16 %4, %5
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([39 x i8]* @str5 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%9 = load %Nat16, %Nat16* %3
	%10 = add %Nat16 %9, 1
	%11 = load %Nat16, %Nat16* %2
	%12 = icmp ne %Nat16 %10, %11
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str6 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%15 = load %Nat16, %Nat16* %2
	%16 = sub %Nat16 %15, 1
	%17 = load %Nat16, %Nat16* %3
	%18 = icmp ne %Nat16 %16, %17
	br %Bool %18 , label %then_2, label %endif_2
then_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([47 x i8]* @str7 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str8 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testNat32Static() {
	%1 = alloca %Nat32, align 4
	store %Nat32 4294967295, %Nat32* %1	; ok
	store %Nat32 0, %Nat32* %1	; ok
	;nat32 = nat32MaxValue + 1  // error: unsigned integer overflow
	;nat32 = nat32MinValue - 1  // error: unsigned integer overflow
	%2 = alloca %Nat32, align 4
	store %Nat32 4294967295, %Nat32* %2
	%3 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %3
; if_0
	%4 = load %Nat32, %Nat32* %2
	%5 = load %Nat32, %Nat32* %3
	%6 = icmp ule %Nat32 %4, %5
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([39 x i8]* @str9 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%9 = load %Nat32, %Nat32* %2
	%10 = add %Nat32 %9, 1
	%11 = load %Nat32, %Nat32* %3
	%12 = icmp ne %Nat32 %10, %11
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str10 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%15 = load %Nat32, %Nat32* %3
	%16 = sub %Nat32 %15, 1
	%17 = load %Nat32, %Nat32* %2
	%18 = icmp ne %Nat32 %16, %17
	br %Bool %18 , label %then_2, label %endif_2
then_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([47 x i8]* @str11 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str12 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testNat64Static() {
	%1 = alloca %Nat64, align 8
	store %Nat64 18446744073709551615, %Nat64* %1	; ok
	store %Nat64 0, %Nat64* %1	; ok
	;nat64 = nat64MaxValue + 1  // error: unsigned integer overflow
	;nat64 = nat64MinValue - 1  // error: unsigned integer overflow
	%2 = alloca %Nat64, align 8
	store %Nat64 18446744073709551615, %Nat64* %2
	%3 = alloca %Nat64, align 8
	store %Nat64 0, %Nat64* %3
; if_0
	%4 = load %Nat64, %Nat64* %2
	%5 = load %Nat64, %Nat64* %3
	%6 = icmp ule %Nat64 %4, %5
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([39 x i8]* @str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%9 = load %Nat64, %Nat64* %2
	%10 = add %Nat64 %9, 1
	%11 = load %Nat64, %Nat64* %3
	%12 = icmp ne %Nat64 %10, %11
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str14 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%15 = load %Nat64, %Nat64* %3
	%16 = sub %Nat64 %15, 1
	%17 = load %Nat64, %Nat64* %2
	%18 = icmp ne %Nat64 %16, %17
	br %Bool %18 , label %then_2, label %endif_2
then_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([47 x i8]* @str15 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str16 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testInt8Static() {
	%1 = alloca %Int8, align 1
	store %Int8 127, %Int8* %1	; ok
	%2 = sub i8 0, 128
	store %Int8 %2, %Int8* %1	; ok
	;int8 = int8MaxValue + 1  // error: integer overflow
	;int8 = int8MinValue - 1  // error: integer overflow
	%3 = alloca %Int8, align 1
	%4 = sub i8 0, 128
	store %Int8 %4, %Int8* %3
	%5 = alloca %Int8, align 1
	store %Int8 127, %Int8* %5
; if_0
	%6 = load %Int8, %Int8* %3
	%7 = icmp sge %Int8 %6, 0
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str17 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%10 = load %Int8, %Int8* %5
	%11 = icmp sle %Int8 %10, 0
	br %Bool %11 , label %then_1, label %endif_1
then_1:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str18 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%14 = load %Int8, %Int8* %5
	%15 = load %Int8, %Int8* %3
	%16 = icmp sle %Int8 %14, %15
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str19 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%19 = load %Int8, %Int8* %5
	%20 = add %Int8 %19, 1
	%21 = load %Int8, %Int8* %3
	%22 = icmp ne %Int8 %20, %21
	br %Bool %22 , label %then_3, label %endif_3
then_3:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @str20 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	%25 = load %Int8, %Int8* %3
	%26 = sub %Int8 %25, 1
	%27 = load %Int8, %Int8* %5
	%28 = icmp ne %Int8 %26, %27
	br %Bool %28 , label %then_4, label %endif_4
then_4:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([45 x i8]* @str21 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str22 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testInt16Static() {
	%1 = alloca %Int16, align 2
	store %Int16 32767, %Int16* %1	; ok
	%2 = sub i16 0, 32768
	store %Int16 %2, %Int16* %1	; ok
	;int16 = int16MaxValue + 1  // error: integer overflow
	;int16 = int16MinValue - 1  // error: integer overflow
	%3 = alloca %Int16, align 2
	%4 = sub i16 0, 32768
	store %Int16 %4, %Int16* %3
	%5 = alloca %Int16, align 2
	store %Int16 32767, %Int16* %5
; if_0
	%6 = load %Int16, %Int16* %3
	%7 = icmp sge %Int16 %6, 0
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str23 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%10 = load %Int16, %Int16* %5
	%11 = icmp sle %Int16 %10, 0
	br %Bool %11 , label %then_1, label %endif_1
then_1:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str24 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%14 = load %Int16, %Int16* %5
	%15 = load %Int16, %Int16* %3
	%16 = icmp sle %Int16 %14, %15
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([39 x i8]* @str25 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%19 = load %Int16, %Int16* %5
	%20 = add %Int16 %19, 1
	%21 = load %Int16, %Int16* %3
	%22 = icmp ne %Int16 %20, %21
	br %Bool %22 , label %then_3, label %endif_3
then_3:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str26 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	%25 = load %Int16, %Int16* %3
	%26 = sub %Int16 %25, 1
	%27 = load %Int16, %Int16* %5
	%28 = icmp ne %Int16 %26, %27
	br %Bool %28 , label %then_4, label %endif_4
then_4:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([47 x i8]* @str27 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str28 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testInt32Static() {
	%1 = alloca %Int32, align 4
	store %Int32 2147483647, %Int32* %1	; ok
	%2 = sub i32 0, 2147483648
	store %Int32 %2, %Int32* %1	; ok
	;int32 = int32MaxValue + 1  // error: integer overflow
	;int32 = int32MinValue - 1  // error: integer overflow
	%3 = alloca %Int32, align 4
	%4 = sub i32 0, 2147483648
	store %Int32 %4, %Int32* %3
	%5 = alloca %Int32, align 4
	store %Int32 2147483647, %Int32* %5
; if_0
	%6 = load %Int32, %Int32* %3
	%7 = icmp sge %Int32 %6, 0
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str29 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%10 = load %Int32, %Int32* %5
	%11 = icmp sle %Int32 %10, 0
	br %Bool %11 , label %then_1, label %endif_1
then_1:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str30 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%14 = load %Int32, %Int32* %5
	%15 = load %Int32, %Int32* %3
	%16 = icmp sle %Int32 %14, %15
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([39 x i8]* @str31 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%19 = load %Int32, %Int32* %5
	%20 = add %Int32 %19, 1
	%21 = load %Int32, %Int32* %3
	%22 = icmp ne %Int32 %20, %21
	br %Bool %22 , label %then_3, label %endif_3
then_3:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str32 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	%25 = load %Int32, %Int32* %3
	%26 = sub %Int32 %25, 1
	%27 = load %Int32, %Int32* %5
	%28 = icmp ne %Int32 %26, %27
	br %Bool %28 , label %then_4, label %endif_4
then_4:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([47 x i8]* @str33 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str34 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testInt64Static() {
	%1 = alloca %Int64, align 8
	%2 = sub i64 0, 9223372036854775808
	store %Int64 %2, %Int64* %1
	%3 = alloca %Int64, align 8
	store %Int64 9223372036854775807, %Int64* %3
	%4 = alloca %Int64, align 8
	store %Int64 9223372036854775807, %Int64* %4	; ok
	%5 = sub i64 0, 9223372036854775808
	store %Int64 %5, %Int64* %4	; ok
	;int64 = int64MaxValue + 1  // error: integer overflow
	;int64 = int64MinValue - 1  // error: integer overflow
; if_0
	%6 = load %Int64, %Int64* %1
	%7 = icmp sge %Int64 %6, 0
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str35 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%10 = load %Int64, %Int64* %3
	%11 = icmp sle %Int64 %10, 0
	br %Bool %11 , label %then_1, label %endif_1
then_1:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str36 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%14 = load %Int64, %Int64* %3
	%15 = load %Int64, %Int64* %1
	%16 = icmp sle %Int64 %14, %15
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([39 x i8]* @str37 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%19 = load %Int64, %Int64* %3
	%20 = add %Int64 %19, 1
	%21 = load %Int64, %Int64* %1
	%22 = icmp ne %Int64 %20, %21
	br %Bool %22 , label %then_3, label %endif_3
then_3:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str38 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	%25 = load %Int64, %Int64* %1
	%26 = sub %Int64 %25, 1
	%27 = load %Int64, %Int64* %3
	%28 = icmp ne %Int64 %26, %27
	br %Bool %28 , label %then_4, label %endif_4
then_4:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([47 x i8]* @str39 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str40 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testFloat32Static() {
	%1 = alloca %Float32, align 4
	store %Float32 3.0000000000000000, %Float32* %1
	%2 = alloca %Float32, align 4
	store %Float32 2.0000000000000000, %Float32* %2
; if_0
	%3 = load %Float32, %Float32* %1
	%4 = load %Float32, %Float32* %2
	%5 = fadd %Float32 %3, %4
	%6 = fcmp one %Float32 %5, 5.0000000000000000
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = load %Float32, %Float32* %1
	%8 = load %Float32, %Float32* %2
	%9 = fadd %Float32 %7, %8
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str41 to [0 x i8]*), %Float32 %9)
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%12 = load %Float32, %Float32* %1
	%13 = load %Float32, %Float32* %2
	%14 = fsub %Float32 %12, %13
	%15 = fcmp one %Float32 %14, 1.0000000000000000
	br %Bool %15 , label %then_1, label %endif_1
then_1:
	%16 = load %Float32, %Float32* %1
	%17 = load %Float32, %Float32* %2
	%18 = fsub %Float32 %16, %17
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str42 to [0 x i8]*), %Float32 %18)
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%21 = load %Float32, %Float32* %1
	%22 = load %Float32, %Float32* %2
	%23 = fmul %Float32 %21, %22
	%24 = fcmp one %Float32 %23, 6.0000000000000000
	br %Bool %24 , label %then_2, label %endif_2
then_2:
	%25 = load %Float32, %Float32* %1
	%26 = load %Float32, %Float32* %2
	%27 = fmul %Float32 %25, %26
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str43 to [0 x i8]*), %Float32 %27)
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%30 = load %Float32, %Float32* %1
	%31 = load %Float32, %Float32* %2
	%32 = fdiv %Float32 %30, %31
	%33 = fcmp one %Float32 %32, 1.5000000000000000
	br %Bool %33 , label %then_3, label %endif_3
then_3:
	%34 = load %Float32, %Float32* %1
	%35 = load %Float32, %Float32* %2
	%36 = fdiv %Float32 %34, %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str44 to [0 x i8]*), %Float32 %36)
	ret %Bool 0
	br label %endif_3
endif_3:
	ret %Bool 1
}

define internal %Bool @testInteger() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str45 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testRational() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str46 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str47 to [0 x i8]*), %Int32 3)
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str48 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str49 to [0 x i8]*))
	ret %Bool 1
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str50 to [0 x i8]*))
	%2 = alloca %Bool, align 1
	%3 = alloca %Bool, align 1
	store %Bool 1, %Bool* %3

	; test built-in generic types
	%4 = call %Bool @testInteger()
	store %Bool %4, %Bool* %2
	%5 = load %Bool, %Bool* %3
	%6 = load %Bool, %Bool* %2
	%7 = and %Bool %5, %6
	store %Bool %7, %Bool* %3
	%8 = call %Bool @testRational()
	store %Bool %8, %Bool* %2
	%9 = load %Bool, %Bool* %3
	%10 = load %Bool, %Bool* %2
	%11 = and %Bool %9, %10
	store %Bool %11, %Bool* %3

	; test built-in unsigned integer types
	%12 = call %Bool @testNat8Static()
	store %Bool %12, %Bool* %2
	%13 = load %Bool, %Bool* %3
	%14 = load %Bool, %Bool* %2
	%15 = and %Bool %13, %14
	store %Bool %15, %Bool* %3
	%16 = call %Bool @testNat16Static()
	store %Bool %16, %Bool* %2
	%17 = load %Bool, %Bool* %3
	%18 = load %Bool, %Bool* %2
	%19 = and %Bool %17, %18
	store %Bool %19, %Bool* %3
	%20 = call %Bool @testNat32Static()
	store %Bool %20, %Bool* %2
	%21 = load %Bool, %Bool* %3
	%22 = load %Bool, %Bool* %2
	%23 = and %Bool %21, %22
	store %Bool %23, %Bool* %3
	%24 = call %Bool @testNat64Static()
	store %Bool %24, %Bool* %2
	%25 = load %Bool, %Bool* %3
	%26 = load %Bool, %Bool* %2
	%27 = and %Bool %25, %26
	store %Bool %27, %Bool* %3

	; test built-in signed integer types
	%28 = call %Bool @testInt8Static()
	store %Bool %28, %Bool* %2
	%29 = load %Bool, %Bool* %3
	%30 = load %Bool, %Bool* %2
	%31 = and %Bool %29, %30
	store %Bool %31, %Bool* %3
	%32 = call %Bool @testInt16Static()
	store %Bool %32, %Bool* %2
	%33 = load %Bool, %Bool* %3
	%34 = load %Bool, %Bool* %2
	%35 = and %Bool %33, %34
	store %Bool %35, %Bool* %3
	%36 = call %Bool @testInt32Static()
	store %Bool %36, %Bool* %2
	%37 = load %Bool, %Bool* %3
	%38 = load %Bool, %Bool* %2
	%39 = and %Bool %37, %38
	store %Bool %39, %Bool* %3
	%40 = call %Bool @testInt64Static()
	store %Bool %40, %Bool* %2
	%41 = load %Bool, %Bool* %3
	%42 = load %Bool, %Bool* %2
	%43 = and %Bool %41, %42
	store %Bool %43, %Bool* %3

	;
	%44 = call %Bool @testFloat32Static()
	store %Bool %44, %Bool* %2
	%45 = load %Bool, %Bool* %3
	%46 = load %Bool, %Bool* %2
	%47 = and %Bool %45, %46
	store %Bool %47, %Bool* %3
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str51 to [0 x i8]*))
; if_0
	%49 = load %Bool, %Bool* %3
	%50 = xor %Bool %49, 1
	br %Bool %50 , label %then_0, label %endif_0
then_0:
	%51 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str52 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%53 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str53 to [0 x i8]*))
	ret %Int 0
}


