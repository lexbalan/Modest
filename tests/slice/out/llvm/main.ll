
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
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; from included limits
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [42 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 82, i8 101, i8 97, i8 100, i8 76, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 66, i8 111, i8 117, i8 110, i8 100, i8 115, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 10, i8 0]
@.str2 = private constant [44 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 82, i8 101, i8 97, i8 100, i8 76, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 66, i8 111, i8 117, i8 110, i8 100, i8 115, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 10, i8 0]
@.str3 = private constant [36 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 101, i8 97, i8 100, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 44, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 32, i8 98, i8 111, i8 117, i8 110, i8 100, i8 115, i8 10, i8 0]
@.str4 = private constant [42 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 82, i8 101, i8 97, i8 100, i8 82, i8 117, i8 110, i8 116, i8 105, i8 109, i8 101, i8 66, i8 111, i8 117, i8 110, i8 100, i8 115, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 10, i8 0]
@.str5 = private constant [44 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 82, i8 101, i8 97, i8 100, i8 82, i8 117, i8 110, i8 116, i8 105, i8 109, i8 101, i8 66, i8 111, i8 117, i8 110, i8 100, i8 115, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 10, i8 0]
@.str6 = private constant [36 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 101, i8 97, i8 100, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 44, i8 32, i8 114, i8 117, i8 110, i8 116, i8 105, i8 109, i8 101, i8 32, i8 98, i8 111, i8 117, i8 110, i8 100, i8 115, i8 10, i8 0]
@.str7 = private constant [39 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 82, i8 101, i8 97, i8 100, i8 86, i8 105, i8 97, i8 80, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 10, i8 0]
@.str8 = private constant [41 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 82, i8 101, i8 97, i8 100, i8 86, i8 105, i8 97, i8 80, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 10, i8 0]
@.str9 = private constant [41 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 114, i8 101, i8 97, i8 100, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 118, i8 105, i8 97, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 32, i8 116, i8 111, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 10, i8 0]
@.str10 = private constant [40 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 69, i8 109, i8 112, i8 116, i8 121, i8 83, i8 108, i8 105, i8 99, i8 101, i8 58, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 32, i8 48, i8 10, i8 0]
@.str11 = private constant [21 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 101, i8 109, i8 112, i8 116, i8 121, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 10, i8 0]
@.str12 = private constant [39 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 70, i8 117, i8 108, i8 108, i8 82, i8 97, i8 110, i8 103, i8 101, i8 83, i8 108, i8 105, i8 99, i8 101, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 10, i8 0]
@.str13 = private constant [41 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 70, i8 117, i8 108, i8 108, i8 82, i8 97, i8 110, i8 103, i8 101, i8 83, i8 108, i8 105, i8 99, i8 101, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 10, i8 0]
@.str14 = private constant [26 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 102, i8 117, i8 108, i8 108, i8 32, i8 114, i8 97, i8 110, i8 103, i8 101, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 10, i8 0]
@.str15 = private constant [42 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 85, i8 110, i8 115, i8 105, i8 122, i8 101, i8 100, i8 65, i8 114, i8 114, i8 97, i8 121, i8 83, i8 108, i8 105, i8 99, i8 101, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 10, i8 0]
@.str16 = private constant [44 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 85, i8 110, i8 115, i8 105, i8 122, i8 101, i8 100, i8 65, i8 114, i8 114, i8 97, i8 121, i8 83, i8 108, i8 105, i8 99, i8 101, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 10, i8 0]
@.str17 = private constant [32 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 111, i8 102, i8 32, i8 117, i8 110, i8 115, i8 105, i8 122, i8 101, i8 100, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 10, i8 0]
@.str18 = private constant [51 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 83, i8 108, i8 105, i8 99, i8 101, i8 65, i8 115, i8 70, i8 117, i8 110, i8 99, i8 65, i8 114, i8 103, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 115, i8 117, i8 109, i8 32, i8 102, i8 111, i8 114, i8 32, i8 102, i8 105, i8 114, i8 115, i8 116, i8 32, i8 104, i8 97, i8 108, i8 102, i8 10, i8 0]
@.str19 = private constant [52 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 83, i8 108, i8 105, i8 99, i8 101, i8 65, i8 115, i8 70, i8 117, i8 110, i8 99, i8 65, i8 114, i8 103, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 115, i8 117, i8 109, i8 32, i8 102, i8 111, i8 114, i8 32, i8 115, i8 101, i8 99, i8 111, i8 110, i8 100, i8 32, i8 104, i8 97, i8 108, i8 102, i8 10, i8 0]
@.str20 = private constant [36 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 97, i8 115, i8 32, i8 102, i8 117, i8 110, i8 99, i8 116, i8 105, i8 111, i8 110, i8 32, i8 97, i8 114, i8 103, i8 117, i8 109, i8 101, i8 110, i8 116, i8 10, i8 0]
@.str21 = private constant [46 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 83, i8 108, i8 105, i8 99, i8 101, i8 65, i8 115, i8 115, i8 105, i8 103, i8 110, i8 70, i8 114, i8 111, i8 109, i8 67, i8 97, i8 108, i8 108, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 10, i8 0]
@.str22 = private constant [47 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 109, i8 101, i8 110, i8 116, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 102, i8 117, i8 110, i8 99, i8 116, i8 105, i8 111, i8 110, i8 32, i8 114, i8 101, i8 116, i8 117, i8 114, i8 110, i8 10, i8 0]
@.str23 = private constant [71 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 83, i8 108, i8 105, i8 99, i8 101, i8 65, i8 115, i8 115, i8 105, i8 103, i8 110, i8 70, i8 114, i8 111, i8 109, i8 76, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 32, i8 40, i8 115, i8 101, i8 101, i8 32, i8 100, i8 111, i8 99, i8 115, i8 47, i8 66, i8 85, i8 71, i8 83, i8 46, i8 109, i8 100, i8 32, i8 35, i8 51, i8 41, i8 10, i8 0]
@.str24 = private constant [45 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 109, i8 101, i8 110, i8 116, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 10, i8 0]
@.str25 = private constant [84 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 83, i8 108, i8 105, i8 99, i8 101, i8 65, i8 115, i8 115, i8 105, i8 103, i8 110, i8 70, i8 114, i8 111, i8 109, i8 76, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 82, i8 117, i8 110, i8 116, i8 105, i8 109, i8 101, i8 66, i8 111, i8 117, i8 110, i8 100, i8 115, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 32, i8 40, i8 115, i8 101, i8 101, i8 32, i8 100, i8 111, i8 99, i8 115, i8 47, i8 66, i8 85, i8 71, i8 83, i8 46, i8 109, i8 100, i8 32, i8 35, i8 51, i8 41, i8 10, i8 0]
@.str26 = private constant [61 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 109, i8 101, i8 110, i8 116, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 108, i8 105, i8 116, i8 101, i8 114, i8 97, i8 108, i8 44, i8 32, i8 114, i8 117, i8 110, i8 116, i8 105, i8 109, i8 101, i8 32, i8 98, i8 111, i8 117, i8 110, i8 100, i8 115, i8 10, i8 0]
@.str27 = private constant [76 x i8] [i8 70, i8 65, i8 73, i8 76, i8 32, i8 116, i8 101, i8 115, i8 116, i8 83, i8 108, i8 105, i8 99, i8 101, i8 65, i8 115, i8 115, i8 105, i8 103, i8 110, i8 87, i8 105, i8 100, i8 101, i8 114, i8 69, i8 108, i8 101, i8 109, i8 101, i8 110, i8 116, i8 84, i8 121, i8 112, i8 101, i8 58, i8 32, i8 119, i8 114, i8 111, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 115, i8 32, i8 40, i8 115, i8 101, i8 101, i8 32, i8 100, i8 111, i8 99, i8 115, i8 47, i8 66, i8 85, i8 71, i8 83, i8 46, i8 109, i8 100, i8 32, i8 35, i8 51, i8 41, i8 10, i8 0]
@.str28 = private constant [46 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 109, i8 101, i8 110, i8 116, i8 44, i8 32, i8 119, i8 105, i8 100, i8 101, i8 114, i8 32, i8 101, i8 108, i8 101, i8 109, i8 101, i8 110, i8 116, i8 32, i8 116, i8 121, i8 112, i8 101, i8 10, i8 0]
@.str29 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 10, i8 0]
@.str30 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@.str31 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str32 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
define internal void @array4intInc([4 x %Int32]* %0, [4 x %Int32] %__a) {
	%a = alloca [4 x %Int32]
	%2 = zext i8 4 to %Nat32
	store [4 x %Int32] %__a, [4 x %Int32]* %a
	%3 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 0
	%4 = load %Int32, %Int32* %3
	%5 = add %Int32 %4, 1
	%6 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 1
	%7 = load %Int32, %Int32* %6
	%8 = add %Int32 %7, 1
	%9 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 2
	%10 = load %Int32, %Int32* %9
	%11 = add %Int32 %10, 1
	%12 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 3
	%13 = load %Int32, %Int32* %12
	%14 = add %Int32 %13, 1
	%15 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 0
	%16 = load %Int32, %Int32* %15
	%17 = add %Int32 %16, 1
	%18 = insertvalue [4 x %Int32] zeroinitializer, %Int32 %17, 0
	%19 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 1
	%20 = load %Int32, %Int32* %19
	%21 = add %Int32 %20, 1
	%22 = insertvalue [4 x %Int32] %18, %Int32 %21, 1
	%23 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 2
	%24 = load %Int32, %Int32* %23
	%25 = add %Int32 %24, 1
	%26 = insertvalue [4 x %Int32] %22, %Int32 %25, 2
	%27 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 3
	%28 = load %Int32, %Int32* %27
	%29 = add %Int32 %28, 1
	%30 = insertvalue [4 x %Int32] %26, %Int32 %29, 3
	%31 = zext i8 4 to %Nat32
	store [4 x %Int32] %30, [4 x %Int32]* %0
	ret void
}

define internal %Int32 @sum4([4 x %Int32] %__a) {
	%a = alloca [4 x %Int32]
	%1 = zext i8 4 to %Nat32
	store [4 x %Int32] %__a, [4 x %Int32]* %a
	%2 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 0
	%3 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 1
	%4 = load %Int32, %Int32* %2
	%5 = load %Int32, %Int32* %3
	%6 = add %Int32 %4, %5
	%7 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 2
	%8 = load %Int32, %Int32* %7
	%9 = add %Int32 %6, %8
	%10 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 3
	%11 = load %Int32, %Int32* %10
	%12 = add %Int32 %9, %11
	ret %Int32 %12
}



;
; 1. read a slice, literal bounds
;
define internal %Bool @testReadLiteralBounds() {
	%1 = alloca [5 x %Int32], align 4
	%2 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%3 = insertvalue [5 x %Int32] %2, %Int32 20, 1
	%4 = insertvalue [5 x %Int32] %3, %Int32 30, 2
	%5 = insertvalue [5 x %Int32] %4, %Int32 40, 3
	%6 = insertvalue [5 x %Int32] %5, %Int32 50, 4
	%7 = zext i8 5 to %Nat32
	store [5 x %Int32] %6, [5 x %Int32]* %1
	%8 = zext i8 1 to %Nat32
	%9 = getelementptr [5 x %Int32], [5 x %Int32]* %1, %Int32 0, %Nat32 %8
	%10 = bitcast %Int32* %9 to [3 x %Int32]*
	%11 = load [3 x %Int32], [3 x %Int32]* %10
	%12 = alloca [3 x %Int32]
	%13 = zext i8 3 to %Nat32
	store [3 x %Int32] %11, [3 x %Int32]* %12
	%14 = insertvalue [3 x %Int32] zeroinitializer, %Int32 20, 0
	%15 = insertvalue [3 x %Int32] %14, %Int32 30, 1
	%16 = insertvalue [3 x %Int32] %15, %Int32 40, 2
	%17 = alloca [3 x %Int32]
	%18 = zext i8 3 to %Nat32
	store [3 x %Int32] %16, [3 x %Int32]* %17
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([42 x i8]* @.str1 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%21 = bitcast [3 x %Int32]* %12 to i8*
	%22 = bitcast [3 x %Int32]* %17 to i8*
	%23 = call i1 (i8*, i8*, i64) @memeq(i8* %21, i8* %22, %Int64 12)
	%24 = icmp eq %Bool %23, 0
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @.str2 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([36 x i8]* @.str3 to [0 x i8]*))
	ret %Bool 1
}



;
; 2. read a slice, bounds come from `let` (not compile-time literals)
;
define internal %Bool @testReadRuntimeBounds() {
	%1 = alloca [5 x %Int32], align 4
	%2 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%3 = insertvalue [5 x %Int32] %2, %Int32 20, 1
	%4 = insertvalue [5 x %Int32] %3, %Int32 30, 2
	%5 = insertvalue [5 x %Int32] %4, %Int32 40, 3
	%6 = insertvalue [5 x %Int32] %5, %Int32 50, 4
	%7 = zext i8 5 to %Nat32
	store [5 x %Int32] %6, [5 x %Int32]* %1
	%8 = zext i8 1 to %Nat32
	%9 = getelementptr [5 x %Int32], [5 x %Int32]* %1, %Int32 0, %Nat32 %8
	%10 = bitcast %Int32* %9 to [3 x %Int32]*
	%11 = load [3 x %Int32], [3 x %Int32]* %10
	%12 = alloca [3 x %Int32]
	%13 = zext i8 3 to %Nat32
	store [3 x %Int32] %11, [3 x %Int32]* %12
	%14 = insertvalue [3 x %Int32] zeroinitializer, %Int32 20, 0
	%15 = insertvalue [3 x %Int32] %14, %Int32 30, 1
	%16 = insertvalue [3 x %Int32] %15, %Int32 40, 2
	%17 = alloca [3 x %Int32]
	%18 = zext i8 3 to %Nat32
	store [3 x %Int32] %16, [3 x %Int32]* %17
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([42 x i8]* @.str4 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%21 = bitcast [3 x %Int32]* %12 to i8*
	%22 = bitcast [3 x %Int32]* %17 to i8*
	%23 = call i1 (i8*, i8*, i64) @memeq(i8* %21, i8* %22, %Int64 12)
	%24 = icmp eq %Bool %23, 0
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @.str5 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([36 x i8]* @.str6 to [0 x i8]*))
	ret %Bool 1
}



;
; 3. read a slice through a pointer to array (auto-deref)
;
define internal %Bool @testReadViaPointer() {
	%1 = alloca [5 x %Int32], align 4
	%2 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%3 = insertvalue [5 x %Int32] %2, %Int32 20, 1
	%4 = insertvalue [5 x %Int32] %3, %Int32 30, 2
	%5 = insertvalue [5 x %Int32] %4, %Int32 40, 3
	%6 = insertvalue [5 x %Int32] %5, %Int32 50, 4
	%7 = zext i8 5 to %Nat32
	store [5 x %Int32] %6, [5 x %Int32]* %1
	%8 = zext i8 1 to %Nat32
	%9 = getelementptr [5 x %Int32], [5 x %Int32]* %1, %Int32 0, %Nat32 %8
;
	%10 = bitcast %Int32* %9 to [3 x %Int32]*
	%11 = load [3 x %Int32], [3 x %Int32]* %10
	%12 = alloca [3 x %Int32]
	%13 = zext i8 3 to %Nat32
	store [3 x %Int32] %11, [3 x %Int32]* %12
	%14 = insertvalue [3 x %Int32] zeroinitializer, %Int32 20, 0
	%15 = insertvalue [3 x %Int32] %14, %Int32 30, 1
	%16 = insertvalue [3 x %Int32] %15, %Int32 40, 2
	%17 = alloca [3 x %Int32]
	%18 = zext i8 3 to %Nat32
	store [3 x %Int32] %16, [3 x %Int32]* %17
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([39 x i8]* @.str7 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%21 = bitcast [3 x %Int32]* %12 to i8*
	%22 = bitcast [3 x %Int32]* %17 to i8*
	%23 = call i1 (i8*, i8*, i64) @memeq(i8* %21, i8* %22, %Int64 12)
	%24 = icmp eq %Bool %23, 0
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([41 x i8]* @.str8 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([41 x i8]* @.str9 to [0 x i8]*))
	ret %Bool 1
}



;
; 4. empty slice: from == to
;
define internal %Bool @testEmptySlice() {
	%1 = alloca [5 x %Int32], align 4
	%2 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%3 = insertvalue [5 x %Int32] %2, %Int32 20, 1
	%4 = insertvalue [5 x %Int32] %3, %Int32 30, 2
	%5 = insertvalue [5 x %Int32] %4, %Int32 40, 3
	%6 = insertvalue [5 x %Int32] %5, %Int32 50, 4
	%7 = zext i8 5 to %Nat32
	store [5 x %Int32] %6, [5 x %Int32]* %1
	%8 = zext i8 2 to %Nat32
	%9 = getelementptr [5 x %Int32], [5 x %Int32]* %1, %Int32 0, %Nat32 %8
	%10 = bitcast %Int32* %9 to [0 x %Int32]*
	%11 = load [0 x %Int32], [0 x %Int32]* %10
	%12 = alloca [0 x %Int32]
	%13 = zext i8 0 to %Nat32
	store [0 x %Int32] %11, [0 x %Int32]* %12
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([40 x i8]* @.str10 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str11 to [0 x i8]*))
	ret %Bool 1
}



;
; 5. full-range slice
;
define internal %Bool @testFullRangeSlice() {
	%1 = alloca [5 x %Int32], align 4
	%2 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%3 = insertvalue [5 x %Int32] %2, %Int32 20, 1
	%4 = insertvalue [5 x %Int32] %3, %Int32 30, 2
	%5 = insertvalue [5 x %Int32] %4, %Int32 40, 3
	%6 = insertvalue [5 x %Int32] %5, %Int32 50, 4
	%7 = zext i8 5 to %Nat32
	store [5 x %Int32] %6, [5 x %Int32]* %1
	%8 = zext i8 0 to %Nat32
	%9 = getelementptr [5 x %Int32], [5 x %Int32]* %1, %Int32 0, %Nat32 %8
	%10 = bitcast %Int32* %9 to [5 x %Int32]*
	%11 = load [5 x %Int32], [5 x %Int32]* %10
	%12 = alloca [5 x %Int32]
	%13 = zext i8 5 to %Nat32
	store [5 x %Int32] %11, [5 x %Int32]* %12
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([39 x i8]* @.str12 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%16 = bitcast [5 x %Int32]* %12 to i8*
	%17 = bitcast [5 x %Int32]* %1 to i8*
	%18 = call i1 (i8*, i8*, i64) @memeq(i8* %16, i8* %17, %Int64 20)
	%19 = icmp eq %Bool %18, 0
	br %Bool %19 , label %then_1, label %endif_1
then_1:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([41 x i8]* @.str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str14 to [0 x i8]*))
	ret %Bool 1
}



;
; 6. slice of an unsized array
;
define internal %Bool @testUnsizedArraySlice() {
	%1 = alloca [5 x %Int32], align 1
	%2 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%3 = insertvalue [5 x %Int32] %2, %Int32 20, 1
	%4 = insertvalue [5 x %Int32] %3, %Int32 30, 2
	%5 = insertvalue [5 x %Int32] %4, %Int32 40, 3
	%6 = insertvalue [5 x %Int32] %5, %Int32 50, 4
	%7 = zext i8 5 to %Nat32
	store [5 x %Int32] %6, [5 x %Int32]* %1
	%8 = zext i8 1 to %Nat32
	%9 = getelementptr [5 x %Int32], [5 x %Int32]* %1, %Int32 0, %Nat32 %8
	%10 = bitcast %Int32* %9 to [3 x %Int32]*
	%11 = load [3 x %Int32], [3 x %Int32]* %10
	%12 = alloca [3 x %Int32]
	%13 = zext i8 3 to %Nat32
	store [3 x %Int32] %11, [3 x %Int32]* %12
	%14 = insertvalue [3 x %Int32] zeroinitializer, %Int32 20, 0
	%15 = insertvalue [3 x %Int32] %14, %Int32 30, 1
	%16 = insertvalue [3 x %Int32] %15, %Int32 40, 2
	%17 = alloca [3 x %Int32]
	%18 = zext i8 3 to %Nat32
	store [3 x %Int32] %16, [3 x %Int32]* %17
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([42 x i8]* @.str15 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%21 = bitcast [3 x %Int32]* %12 to i8*
	%22 = bitcast [3 x %Int32]* %17 to i8*
	%23 = call i1 (i8*, i8*, i64) @memeq(i8* %21, i8* %22, %Int64 12)
	%24 = icmp eq %Bool %23, 0
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([44 x i8]* @.str16 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @.str17 to [0 x i8]*))
	ret %Bool 1
}



;
; 7. slice as a function argument (pass-by-value)
;
define internal %Bool @testSliceAsFuncArg() {
	%1 = alloca [8 x %Int32], align 4
	%2 = insertvalue [8 x %Int32] zeroinitializer, %Int32 1, 0
	%3 = insertvalue [8 x %Int32] %2, %Int32 2, 1
	%4 = insertvalue [8 x %Int32] %3, %Int32 3, 2
	%5 = insertvalue [8 x %Int32] %4, %Int32 4, 3
	%6 = insertvalue [8 x %Int32] %5, %Int32 5, 4
	%7 = insertvalue [8 x %Int32] %6, %Int32 6, 5
	%8 = insertvalue [8 x %Int32] %7, %Int32 7, 6
	%9 = insertvalue [8 x %Int32] %8, %Int32 8, 7
	%10 = zext i8 8 to %Nat32
	store [8 x %Int32] %9, [8 x %Int32]* %1
; if_0
	%11 = zext i8 0 to %Nat32
	%12 = getelementptr [8 x %Int32], [8 x %Int32]* %1, %Int32 0, %Nat32 %11
	%13 = bitcast %Int32* %12 to [4 x %Int32]*
	%14 = load [4 x %Int32], [4 x %Int32]* %13
	%15 = call %Int32 @sum4([4 x %Int32] %14)
	%16 = icmp ne %Int32 %15, 10
	br %Bool %16 , label %then_0, label %endif_0
then_0:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([51 x i8]* @.str18 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%19 = zext i8 4 to %Nat32
	%20 = getelementptr [8 x %Int32], [8 x %Int32]* %1, %Int32 0, %Nat32 %19
	%21 = bitcast %Int32* %20 to [4 x %Int32]*
	%22 = load [4 x %Int32], [4 x %Int32]* %21
	%23 = call %Int32 @sum4([4 x %Int32] %22)
	%24 = icmp ne %Int32 %23, 26
	br %Bool %24 , label %then_1, label %endif_1
then_1:
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([52 x i8]* @.str19 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([36 x i8]* @.str20 to [0 x i8]*))
	ret %Bool 1
}



;
; 8. slice assignment from a function's return value
;
define internal %Bool @testSliceAssignFromCall() {
	%1 = alloca [8 x %Int32], align 4
	%2 = insertvalue [8 x %Int32] zeroinitializer, %Int32 1, 1
	%3 = insertvalue [8 x %Int32] %2, %Int32 2, 2
	%4 = insertvalue [8 x %Int32] %3, %Int32 3, 3
	%5 = insertvalue [8 x %Int32] %4, %Int32 4, 4
	%6 = insertvalue [8 x %Int32] %5, %Int32 5, 5
	%7 = insertvalue [8 x %Int32] %6, %Int32 6, 6
	%8 = insertvalue [8 x %Int32] %7, %Int32 7, 7
	%9 = zext i8 8 to %Nat32
	store [8 x %Int32] %8, [8 x %Int32]* %1
	%10 = zext i8 0 to %Nat32
	%11 = getelementptr [8 x %Int32], [8 x %Int32]* %1, %Int32 0, %Nat32 %10
	%12 = bitcast %Int32* %11 to [4 x %Int32]*
	%13 = zext i8 0 to %Nat32
	%14 = getelementptr [8 x %Int32], [8 x %Int32]* %1, %Int32 0, %Nat32 %13
	%15 = bitcast %Int32* %14 to [4 x %Int32]*
	%16 = load [4 x %Int32], [4 x %Int32]* %15; alloca memory for return value
	%17 = alloca [4 x %Int32]
	call void @array4intInc([4 x %Int32]* %17, [4 x %Int32] %16)
	%18 = load [4 x %Int32], [4 x %Int32]* %17
	%19 = zext i8 4 to %Nat32
	store [4 x %Int32] %18, [4 x %Int32]* %12
	%20 = zext i8 4 to %Nat32
	%21 = getelementptr [8 x %Int32], [8 x %Int32]* %1, %Int32 0, %Nat32 %20
	%22 = bitcast %Int32* %21 to [4 x %Int32]*
	%23 = zext i8 4 to %Nat32
	%24 = getelementptr [8 x %Int32], [8 x %Int32]* %1, %Int32 0, %Nat32 %23
	%25 = bitcast %Int32* %24 to [4 x %Int32]*
	%26 = load [4 x %Int32], [4 x %Int32]* %25; alloca memory for return value
	%27 = alloca [4 x %Int32]
	call void @array4intInc([4 x %Int32]* %27, [4 x %Int32] %26)
	%28 = load [4 x %Int32], [4 x %Int32]* %27
	%29 = zext i8 4 to %Nat32
	store [4 x %Int32] %28, [4 x %Int32]* %22
	%30 = insertvalue [8 x %Int32] zeroinitializer, %Int32 1, 0
	%31 = insertvalue [8 x %Int32] %30, %Int32 2, 1
	%32 = insertvalue [8 x %Int32] %31, %Int32 3, 2
	%33 = insertvalue [8 x %Int32] %32, %Int32 4, 3
	%34 = insertvalue [8 x %Int32] %33, %Int32 5, 4
	%35 = insertvalue [8 x %Int32] %34, %Int32 6, 5
	%36 = insertvalue [8 x %Int32] %35, %Int32 7, 6
	%37 = insertvalue [8 x %Int32] %36, %Int32 8, 7
	%38 = alloca [8 x %Int32]
	%39 = zext i8 8 to %Nat32
	store [8 x %Int32] %37, [8 x %Int32]* %38
; if_0
	%40 = bitcast [8 x %Int32]* %1 to i8*
	%41 = bitcast [8 x %Int32]* %38 to i8*
	%42 = call i1 (i8*, i8*, i64) @memeq(i8* %40, i8* %41, %Int64 32)
	%43 = icmp eq %Bool %42, 0
	br %Bool %43 , label %then_0, label %endif_0
then_0:
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str21 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([47 x i8]* @.str22 to [0 x i8]*))
	ret %Bool 1
}



;
; 9. slice assignment from an array literal, literal bounds
;    docs/lang/value/slice.md: `a[0:2] = [2]Int32 [9, 9]`
;    known bug: docs/BUGS.md #3
;
define internal %Bool @testSliceAssignFromLiteral() {
	%1 = alloca [5 x %Int32], align 4
	%2 = zext i8 5 to %Nat32
	%3 = mul %Nat32 %2, 4
	%4 = bitcast [5 x %Int32]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %4, i8 0, %Nat32 %3, i1 0)
	%5 = zext i8 1 to %Nat32
	%6 = getelementptr [5 x %Int32], [5 x %Int32]* %1, %Int32 0, %Nat32 %5
	%7 = bitcast %Int32* %6 to [3 x %Int32]*
	%8 = insertvalue [3 x %Int32] zeroinitializer, %Int32 7, 0
	%9 = insertvalue [3 x %Int32] %8, %Int32 8, 1
	%10 = insertvalue [3 x %Int32] %9, %Int32 9, 2
	%11 = zext i8 3 to %Nat32
	store [3 x %Int32] %10, [3 x %Int32]* %7
	%12 = insertvalue [5 x %Int32] zeroinitializer, %Int32 7, 1
	%13 = insertvalue [5 x %Int32] %12, %Int32 8, 2
	%14 = insertvalue [5 x %Int32] %13, %Int32 9, 3
	%15 = alloca [5 x %Int32]
	%16 = zext i8 5 to %Nat32
	store [5 x %Int32] %14, [5 x %Int32]* %15
; if_0
	%17 = bitcast [5 x %Int32]* %1 to i8*
	%18 = bitcast [5 x %Int32]* %15 to i8*
	%19 = call i1 (i8*, i8*, i64) @memeq(i8* %17, i8* %18, %Int64 20)
	%20 = icmp eq %Bool %19, 0
	br %Bool %20 , label %then_0, label %endif_0
then_0:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([71 x i8]* @.str23 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([45 x i8]* @.str24 to [0 x i8]*))
	ret %Bool 1
}



;
; 10. same as above, but bounds come from `let` variables, not literals
;
define internal %Bool @testSliceAssignFromLiteralRuntimeBounds() {
	%1 = alloca [5 x %Int32], align 4
	%2 = zext i8 5 to %Nat32
	%3 = mul %Nat32 %2, 4
	%4 = bitcast [5 x %Int32]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %4, i8 0, %Nat32 %3, i1 0)
	%5 = zext i8 1 to %Nat32
	%6 = getelementptr [5 x %Int32], [5 x %Int32]* %1, %Int32 0, %Nat32 %5
	%7 = bitcast %Int32* %6 to [3 x %Int32]*
	%8 = insertvalue [3 x %Int32] zeroinitializer, %Int32 7, 0
	%9 = insertvalue [3 x %Int32] %8, %Int32 8, 1
	%10 = insertvalue [3 x %Int32] %9, %Int32 9, 2
	%11 = zext i8 3 to %Nat32
	store [3 x %Int32] %10, [3 x %Int32]* %7
	%12 = insertvalue [5 x %Int32] zeroinitializer, %Int32 7, 1
	%13 = insertvalue [5 x %Int32] %12, %Int32 8, 2
	%14 = insertvalue [5 x %Int32] %13, %Int32 9, 3
	%15 = alloca [5 x %Int32]
	%16 = zext i8 5 to %Nat32
	store [5 x %Int32] %14, [5 x %Int32]* %15
; if_0
	%17 = bitcast [5 x %Int32]* %1 to i8*
	%18 = bitcast [5 x %Int32]* %15 to i8*
	%19 = call i1 (i8*, i8*, i64) @memeq(i8* %17, i8* %18, %Int64 20)
	%20 = icmp eq %Bool %19, 0
	br %Bool %20 , label %then_0, label %endif_0
then_0:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([84 x i8]* @.str25 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([61 x i8]* @.str26 to [0 x i8]*))
	ret %Bool 1
}



;
; 11. slice assignment with a wider element type
;     (checks whether the byte-count bug in #9/#10 scales with element size)
;
define internal %Bool @testSliceAssignWiderElementType() {
	%1 = alloca [4 x %Nat64], align 8
	%2 = zext i8 4 to %Nat32
	%3 = mul %Nat32 %2, 8
	%4 = bitcast [4 x %Nat64]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %4, i8 0, %Nat32 %3, i1 0)
	%5 = zext i8 1 to %Nat32
	%6 = getelementptr [4 x %Nat64], [4 x %Nat64]* %1, %Int32 0, %Nat32 %5
	%7 = bitcast %Nat64* %6 to [2 x %Nat64]*
	%8 = insertvalue [2 x %Nat64] zeroinitializer, %Nat64 111, 0
	%9 = insertvalue [2 x %Nat64] %8, %Nat64 222, 1
	%10 = zext i8 2 to %Nat32
	store [2 x %Nat64] %9, [2 x %Nat64]* %7
	%11 = insertvalue [4 x %Nat64] zeroinitializer, %Nat64 111, 1
	%12 = insertvalue [4 x %Nat64] %11, %Nat64 222, 2
	%13 = alloca [4 x %Nat64]
	%14 = zext i8 4 to %Nat32
	store [4 x %Nat64] %12, [4 x %Nat64]* %13
; if_0
	%15 = bitcast [4 x %Nat64]* %1 to i8*
	%16 = bitcast [4 x %Nat64]* %13 to i8*
	%17 = call i1 (i8*, i8*, i64) @memeq(i8* %15, i8* %16, %Int64 32)
	%18 = icmp eq %Bool %17, 0
	br %Bool %18 , label %then_0, label %endif_0
then_0:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([76 x i8]* @.str27 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str28 to [0 x i8]*))
	ret %Bool 1
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str29 to [0 x i8]*))
	%2 = alloca %Bool, align 1
	store %Bool 1, %Bool* %2
	%3 = call %Bool @testReadLiteralBounds()
	%4 = load %Bool, %Bool* %2
	%5 = and %Bool %3, %4
	store %Bool %5, %Bool* %2
	%6 = call %Bool @testReadRuntimeBounds()
	%7 = load %Bool, %Bool* %2
	%8 = and %Bool %6, %7
	store %Bool %8, %Bool* %2
	%9 = call %Bool @testReadViaPointer()
	%10 = load %Bool, %Bool* %2
	%11 = and %Bool %9, %10
	store %Bool %11, %Bool* %2
	%12 = call %Bool @testEmptySlice()
	%13 = load %Bool, %Bool* %2
	%14 = and %Bool %12, %13
	store %Bool %14, %Bool* %2
	%15 = call %Bool @testFullRangeSlice()
	%16 = load %Bool, %Bool* %2
	%17 = and %Bool %15, %16
	store %Bool %17, %Bool* %2
	%18 = call %Bool @testUnsizedArraySlice()
	%19 = load %Bool, %Bool* %2
	%20 = and %Bool %18, %19
	store %Bool %20, %Bool* %2
	%21 = call %Bool @testSliceAsFuncArg()
	%22 = load %Bool, %Bool* %2
	%23 = and %Bool %21, %22
	store %Bool %23, %Bool* %2
	%24 = call %Bool @testSliceAssignFromCall()
	%25 = load %Bool, %Bool* %2
	%26 = and %Bool %24, %25
	store %Bool %26, %Bool* %2
	%27 = call %Bool @testSliceAssignFromLiteral()
	%28 = load %Bool, %Bool* %2
	%29 = and %Bool %27, %28
	store %Bool %29, %Bool* %2
	%30 = call %Bool @testSliceAssignFromLiteralRuntimeBounds()
	%31 = load %Bool, %Bool* %2
	%32 = and %Bool %30, %31
	store %Bool %32, %Bool* %2
	%33 = call %Bool @testSliceAssignWiderElementType()
	%34 = load %Bool, %Bool* %2
	%35 = and %Bool %33, %34
	store %Bool %35, %Bool* %2
	%36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @.str30 to [0 x i8]*))
; if_0
	%37 = load %Bool, %Bool* %2
	%38 = xor %Bool %37, 1
	br %Bool %38 , label %then_0, label %endif_0
then_0:
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str31 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str32 to [0 x i8]*))
	ret %Int 0
}


