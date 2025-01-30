
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Float32 = type float
%Float64 = type double
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
%ctypes64_Str = type %Str8;
%ctypes64_Char = type %Char8;
%ctypes64_ConstChar = type %ctypes64_Char;
%ctypes64_SignedChar = type %Int8;
%ctypes64_UnsignedChar = type %Int8;
%ctypes64_Short = type %Int16;
%ctypes64_UnsignedShort = type %Int16;
%ctypes64_Int = type %Int32;
%ctypes64_UnsignedInt = type %Int32;
%ctypes64_LongInt = type %Int64;
%ctypes64_UnsignedLongInt = type %Int64;
%ctypes64_Long = type %Int64;
%ctypes64_UnsignedLong = type %Int64;
%ctypes64_LongLong = type %Int64;
%ctypes64_UnsignedLongLong = type %Int64;
%ctypes64_LongLongInt = type %Int64;
%ctypes64_UnsignedLongLongInt = type %Int64;
%ctypes64_Float = type double;
%ctypes64_Double = type double;
%ctypes64_LongDouble = type double;
%ctypes64_SizeT = type %ctypes64_UnsignedLongInt;
%ctypes64_SSizeT = type %ctypes64_LongInt;
%ctypes64_IntPtrT = type %Int64;
%ctypes64_PtrDiffT = type i8*;
%ctypes64_OffT = type %Int64;
%ctypes64_USecondsT = type %Int32;
%ctypes64_PIDT = type %Int32;
%ctypes64_UIDT = type %Int32;
%ctypes64_GIDT = type %Int32;
; from included stdio
%stdio_File = type %Int8;
%stdio_FposT = type %Int8;
%stdio_CharStr = type %ctypes64_Str;
%stdio_ConstCharStr = type %stdio_CharStr;
declare %ctypes64_Int @fclose(%stdio_File* %f)
declare %ctypes64_Int @feof(%stdio_File* %f)
declare %ctypes64_Int @ferror(%stdio_File* %f)
declare %ctypes64_Int @fflush(%stdio_File* %f)
declare %ctypes64_Int @fgetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %stdio_File* @fopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode)
declare %ctypes64_SizeT @fread(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %ctypes64_SizeT @fwrite(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %stdio_File* @freopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode, %stdio_File* %f)
declare %ctypes64_Int @fseek(%stdio_File* %f, %ctypes64_LongInt %offset, %ctypes64_Int %whence)
declare %ctypes64_Int @fsetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %ctypes64_LongInt @ftell(%stdio_File* %f)
declare %ctypes64_Int @remove(%stdio_ConstCharStr* %fname)
declare %ctypes64_Int @rename(%stdio_ConstCharStr* %old_filename, %stdio_ConstCharStr* %new_filename)
declare void @rewind(%stdio_File* %f)
declare void @setbuf(%stdio_File* %f, %stdio_CharStr* %buf)
declare %ctypes64_Int @setvbuf(%stdio_File* %f, %stdio_CharStr* %buf, %ctypes64_Int %mode, %ctypes64_SizeT %size)
declare %stdio_File* @tmpfile()
declare %stdio_CharStr* @tmpnam(%stdio_CharStr* %str)
declare %ctypes64_Int @printf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @scanf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @fprintf(%stdio_File* %f, %ctypes64_Str* %format, ...)
declare %ctypes64_Int @fscanf(%stdio_File* %f, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sscanf(%stdio_ConstCharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sprintf(%stdio_CharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @vfprintf(%stdio_File* %f, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vprintf(%stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsprintf(%stdio_CharStr* %str, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsnprintf(%stdio_CharStr* %str, %ctypes64_SizeT %n, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @__vsnprintf_chk(%stdio_CharStr* %dest, %ctypes64_SizeT %len, %ctypes64_Int %flags, %ctypes64_SizeT %dstlen, %stdio_ConstCharStr* %format, i8* %arg)
declare %ctypes64_Int @fgetc(%stdio_File* %f)
declare %ctypes64_Int @fputc(%ctypes64_Int %char, %stdio_File* %f)
declare %stdio_CharStr* @fgets(%stdio_CharStr* %str, %ctypes64_Int %n, %stdio_File* %f)
declare %ctypes64_Int @fputs(%stdio_ConstCharStr* %str, %stdio_File* %f)
declare %ctypes64_Int @getc(%stdio_File* %f)
declare %ctypes64_Int @getchar()
declare %stdio_CharStr* @gets(%stdio_CharStr* %str)
declare %ctypes64_Int @putc(%ctypes64_Int %char, %stdio_File* %f)
declare %ctypes64_Int @putchar(%ctypes64_Int %char)
declare %ctypes64_Int @puts(%stdio_ConstCharStr* %str)
declare %ctypes64_Int @ungetc(%ctypes64_Int %char, %stdio_File* %f)
declare void @perror(%stdio_ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [21 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 99, i8 97, i8 115, i8 116, i8 32, i8 111, i8 112, i8 101, i8 114, i8 97, i8 116, i8 105, i8 111, i8 110, i8 10, i8 0]
@str2 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 99, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str3 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str4 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 102, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str5 = private constant [16 x i8] [i8 111, i8 102, i8 102, i8 40, i8 105, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str6 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 112, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str7 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 103, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str8 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 85, i8 110, i8 105, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str9 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 85, i8 110, i8 105, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str10 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 66, i8 111, i8 111, i8 108, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str11 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 66, i8 111, i8 111, i8 108, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str12 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str13 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str14 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str15 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str16 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str17 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str18 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str19 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str20 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str21 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str22 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str23 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str24 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str25 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str26 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str27 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str28 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str29 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str30 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str31 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str32 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str33 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str34 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str35 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str36 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str37 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str38 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 42, i8 83, i8 116, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str39 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 42, i8 83, i8 116, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str40 = private constant [26 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 91, i8 49, i8 48, i8 93, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str41 = private constant [27 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 91, i8 49, i8 48, i8 93, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str42 = private constant [28 x i8] [i8 62, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 91, i8 51, i8 93, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str43 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str44 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str45 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 49, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str46 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 49, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str47 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str48 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str49 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 51, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str50 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 51, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str51 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str52 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
; -- endstrings --
%Point = type {
	%Int32,
	%Int32
};

%Mixed1 = type {
	%Char8,
	%Int32,
	double
};

%Mixed2 = type {
	%Int32,
	%Char8,
	double,
	[3 x %Char8],
	%Mixed1
};

%Mixed3 = type {
	%Char8,
	%Int32,
	double,
	[9 x %Char8]
};

%Mixed4 = type {
	%Mixed2,
	%Char8,
	%Int32,
	double,
	[9 x %Char8],
	%Int16,
	[3 x %Point],
	%Mixed3
};



;var s: Mixed2
@c = internal global %Char8 zeroinitializer
@i = internal global %Int32 zeroinitializer
@f = internal global double zeroinitializer
@i2 = internal global %Int16 zeroinitializer
@p = internal global [3 x %Point] zeroinitializer
@g = internal global %Bool zeroinitializer
%X = type {
	%Char8,
	%Int32,
	double,
	%Int16,
	[3 x %Point],
	%Bool
};

@x = internal global %X zeroinitializer
define %ctypes64_Int @main() {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
	%2 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), %Int64 0)
	%3 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str3 to [0 x i8]*), %Int64 0)
	%4 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str4 to [0 x i8]*), %Int64 0)
	%5 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), %Int64 0)
	%6 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), %Int64 0)
	%7 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), %Int64 0)

	; дженерики в с явно не приводятся, но нектороые нужно!
	;	printf("offsetof(x.c) = %llu\n", Nat64 offsetof(X.c))
	;	printf("offsetof(x.i) = %llu\n", Nat64 offsetof(X.i))
	;	printf("offsetof(x.f) = %llu\n", Nat64 offsetof(X.f))
	;	printf("offsetof(x.i2) = %llu\n", Nat64 offsetof(X.i2))
	;	printf("offsetof(x.p) = %llu\n", Nat64 offsetof(X.p))
	;	printf("offsetof(x.g) = %llu\n", Nat64 offsetof(X.g))


	; sizeof(void) in C  == 1
	; sizeof(Unit) in CM == 0
	; TODO: here is a broblem
	%8 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([21 x i8]* @str8 to [0 x i8]*), %Int64 1)
	%9 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str9 to [0 x i8]*), %Int64 1)
	%10 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*), %Int64 1)
	%11 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str11 to [0 x i8]*), %Int64 1)
	%12 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([21 x i8]* @str12 to [0 x i8]*), %Int64 1)
	%13 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str13 to [0 x i8]*), %Int64 1)
	%14 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str14 to [0 x i8]*), %Int64 2)
	%15 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str15 to [0 x i8]*), %Int64 2)
	%16 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str16 to [0 x i8]*), %Int64 4)
	%17 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str17 to [0 x i8]*), %Int64 4)
	%18 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str18 to [0 x i8]*), %Int64 8)
	%19 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str19 to [0 x i8]*), %Int64 8)
	%20 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str20 to [0 x i8]*), %Int64 16)
	%21 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([24 x i8]* @str21 to [0 x i8]*), %Int64 16)
	; type Nat256 not implemented
	;printf("sizeof(Nat256) = %llu\n", Nat64 sizeof(Nat256))
	%22 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([21 x i8]* @str22 to [0 x i8]*), %Int64 1)
	%23 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str23 to [0 x i8]*), %Int64 1)
	%24 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str24 to [0 x i8]*), %Int64 2)
	%25 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str25 to [0 x i8]*), %Int64 2)
	%26 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str26 to [0 x i8]*), %Int64 4)
	%27 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str27 to [0 x i8]*), %Int64 4)
	%28 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str28 to [0 x i8]*), %Int64 8)
	%29 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str29 to [0 x i8]*), %Int64 8)
	%30 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str30 to [0 x i8]*), %Int64 16)
	%31 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([24 x i8]* @str31 to [0 x i8]*), %Int64 16)
	; type Int256 not implemented
	;printf("sizeof(Int256) = %llu\n", Nat64 sizeof(Int256))
	%32 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str32 to [0 x i8]*), %Int64 1)
	%33 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str33 to [0 x i8]*), %Int64 1)
	%34 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str34 to [0 x i8]*), %Int64 2)
	%35 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([24 x i8]* @str35 to [0 x i8]*), %Int64 2)
	%36 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str36 to [0 x i8]*), %Int64 4)
	%37 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([24 x i8]* @str37 to [0 x i8]*), %Int64 4)

	; pointer size (for example pointer to []Char8)
	%38 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str38 to [0 x i8]*), %Int64 8)
	%39 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str39 to [0 x i8]*), %Int64 8)

	; array size
	%40 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([26 x i8]* @str40 to [0 x i8]*), %Int64 40)
	%41 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([27 x i8]* @str41 to [0 x i8]*), %Int64 1)
	%42 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([28 x i8]* @str42 to [0 x i8]*), %Int64 1)


	; record size
	%43 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str43 to [0 x i8]*), %Int64 8)
	%44 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str44 to [0 x i8]*), %Int64 8)

	;	printf("offsetof(Point.x) = %llu\n", Nat64 offsetof(Point.x))
	;	printf("offsetof(Point.y) = %llu\n", Nat64 offsetof(Point.y))
	%45 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str45 to [0 x i8]*), %Int64 16)
	%46 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([24 x i8]* @str46 to [0 x i8]*), %Int64 16)
	%47 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str47 to [0 x i8]*), %Int64 64)
	%48 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([24 x i8]* @str48 to [0 x i8]*), %Int64 64)


	;	printf("offsetof(Mixed2.i) = %llu\n", Nat64 offsetof(Mixed2.i))
	;	printf("offsetof(Mixed2.c) = %llu\n", Nat64 offsetof(Mixed2.c))
	;	printf("offsetof(Mixed2.f) = %llu\n", Nat64 offsetof(Mixed2.f))
	;	printf("offsetof(Mixed2.c2) = %llu\n", Nat64 offsetof(Mixed2.c2))
	;	printf("offsetof(Mixed2.m) = %llu\n", Nat64 offsetof(Mixed2.m))
	%49 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str49 to [0 x i8]*), %Int64 32)
	%50 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([24 x i8]* @str50 to [0 x i8]*), %Int64 32)
	%51 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str51 to [0 x i8]*), %Int64 256)
	%52 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([24 x i8]* @str52 to [0 x i8]*), %Int64 256)

	;	printf("offsetof(Mixed4.s) = %llu\n", Nat64 offsetof(Mixed4.s))
	;	printf("offsetof(Mixed4.c) = %llu\n", Nat64 offsetof(Mixed4.c))
	;	printf("offsetof(Mixed4.i) = %llu\n", Nat64 offsetof(Mixed4.i))
	;	printf("offsetof(Mixed4.f) = %llu\n", Nat64 offsetof(Mixed4.f))
	;	printf("offsetof(Mixed4.c2) = %llu\n", Nat64 offsetof(Mixed4.c2))
	;	printf("offsetof(Mixed4.i2) = %llu\n", Nat64 offsetof(Mixed4.i2))
	;	printf("offsetof(Mixed4.p) = %llu\n", Nat64 offsetof(Mixed4.p))
	;	printf("offsetof(Mixed4.s2) = %llu\n", Nat64 offsetof(Mixed4.s2))
	ret %ctypes64_Int 0
}


