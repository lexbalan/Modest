
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
@str1 = private constant [20 x i8] [i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 32, i8 116, i8 121, i8 112, i8 101, i8 115, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [29 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 105, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str3 = private constant [29 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 105, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str4 = private constant [27 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 102, i8 108, i8 111, i8 97, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str5 = private constant [27 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 102, i8 108, i8 111, i8 97, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 99, i8 104, i8 97, i8 114, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str7 = private constant [26 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 99, i8 104, i8 97, i8 114, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str8 = private constant [27 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str9 = private constant [27 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str10 = private constant [28 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str11 = private constant [29 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 105, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str12 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str13 = private constant [19 x i8] [i8 98, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str14 = private constant [19 x i8] [i8 99, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str15 = private constant [37 x i8] [i8 100, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 93, i8 10, i8 0]
; -- endstrings --
define %ctypes64_Int @main() {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([20 x i8]* @str1 to [0 x i8]*))
	%2 = call %Bool @test_generic_integer()
	br %Bool %2 , label %then_0, label %else_0
then_0:
	%3 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([29 x i8]* @str2 to [0 x i8]*))
	br label %endif_0
else_0:
	%4 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([29 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
endif_0:
	%5 = call %Bool @test_generic_float()
	br %Bool %5 , label %then_1, label %else_1
then_1:
	%6 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
	br label %endif_1
else_1:
	%7 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([27 x i8]* @str5 to [0 x i8]*))
	br label %endif_1
endif_1:
	%8 = call %Bool @test_generic_char()
	br %Bool %8 , label %then_2, label %else_2
then_2:
	%9 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	br label %endif_2
else_2:
	%10 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([26 x i8]* @str7 to [0 x i8]*))
	br label %endif_2
endif_2:
	%11 = call %Bool @test_generic_array()
	br %Bool %11 , label %then_3, label %else_3
then_3:
	%12 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([27 x i8]* @str8 to [0 x i8]*))
	br label %endif_3
else_3:
	%13 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([27 x i8]* @str9 to [0 x i8]*))
	br label %endif_3
endif_3:
	%14 = call %Bool @test_generic_record()
	br %Bool %14 , label %then_4, label %else_4
then_4:
	%15 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([28 x i8]* @str10 to [0 x i8]*))
	br label %endif_4
else_4:
	%16 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([29 x i8]* @str11 to [0 x i8]*))
	br label %endif_4
endif_4:
	ret %ctypes64_Int 0
}

define internal %Bool @test_generic_integer() {
	; Any integer literal have GenericInteger type

	; result of such expressions also have generic type

	; GenericInteger value can be implicitly casted to any Integer type
	%1 = alloca %Int32, align 4
	store %Int32 1, %Int32* %1
	%2 = alloca %Int64, align 8
	store %Int64 1, %Int64* %2

	; to Float
	%3 = alloca float, align 4
	store float 1.0000000000000000, float* %3
	%4 = alloca double, align 8
	store double 1.0000000000000000, double* %4

	; and to Word8
	%5 = alloca %Word8, align 1
	store %Word8 1, %Word8* %5


	; explicit cast GenericInteger value
	%6 = alloca %Char8, align 1
	store %Char8 1, %Char8* %6
	%7 = alloca %Char16, align 2
	store %Char16 1, %Char16* %7
	%8 = alloca %Char32, align 4
	store %Char32 1, %Char32* %8
	%9 = alloca %Bool, align 1
	store %Bool 1, %Bool* %9
	ret %Bool 1
}

define internal %Bool @test_generic_float() {
	; Any float literal have GenericFloat type

	; value with GenericFloat type
	; can be implicit casted to any Float type
	; (in this case value may lose precision)
	%1 = alloca float, align 4
	store float 3.1415927410125732, float* %1
	%2 = alloca double, align 8
	store double 3.1415926535897931, double* %2

	; explicit cast GenericFloat value to Int32
	%3 = alloca %Int32, align 4
	store %Int32 3, %Int32* %3
	ret %Bool 1
}

define internal %Bool @test_generic_char() {
	; Any char value expression have GenericChar type
	; (you can pick GenericChar value by index of GenericString value)

	; value with GenericChar type
	; can be implicit casted to any Char type
	%1 = alloca %Char8, align 1
	store %Char8 65, %Char8* %1
	%2 = alloca %Char16, align 2
	store %Char16 65, %Char16* %2
	%3 = alloca %Char32, align 4
	store %Char32 65, %Char32* %3

	; explicit cast GenericChar value to Int32
	%4 = alloca %Int32, align 4
	store %Int32 65, %Int32* %4
	ret %Bool 1
}

define internal %Bool @test_generic_array() {
	; Any array expression have GenericArray type
	; this array expression (GenericArray of four GenericInteger items)
	%1 = insertvalue [4 x i8] zeroinitializer, i8 1, 1
	%2 = insertvalue [4 x i8] %1, i8 2, 2
	%3 = insertvalue [4 x i8] %2, i8 3, 3
	%4 = alloca [4 x i8]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%5 = zext i8 4 to %Int32
	; -- end vol eval --
	store [4 x i8] %3, [4 x i8]* %4
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%6 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([26 x i8]* @str12 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:

	; value with GenericArray type
	; can be implicit casted to Array with compatible type and same size

	; implicit cast Generic([4]GenericInteger) value to [4]Int32
	%8 = alloca [4 x %Int32], align 1
	%9 = insertvalue [4 x %Int32] zeroinitializer, %Int32 1, 1
	%10 = insertvalue [4 x %Int32] %9, %Int32 2, 2
	%11 = insertvalue [4 x %Int32] %10, %Int32 3, 3
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%12 = zext i8 4 to %Int32
	; -- end vol eval --
	store [4 x %Int32] %11, [4 x %Int32]* %8
	%13 = insertvalue [4 x %Int32] zeroinitializer, %Int32 1, 1
	%14 = insertvalue [4 x %Int32] %13, %Int32 2, 2
	%15 = insertvalue [4 x %Int32] %14, %Int32 3, 3
	%16 = alloca [4 x %Int32]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%17 = zext i8 4 to %Int32
	; -- end vol eval --
	store [4 x %Int32] %15, [4 x %Int32]* %16
	%18 = bitcast [4 x %Int32]* %8 to i8*
	%19 = bitcast [4 x %Int32]* %16 to i8*
	%20 = call i1 (i8*, i8*, i64) @memeq(i8* %18, i8* %19, %Int64 16)
	%21 = icmp eq %Bool %20, 0
	br %Bool %21 , label %then_1, label %endif_1
then_1:
	%22 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([19 x i8]* @str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:

	; implicit cast Generic([4]GenericInteger) value to [4]Nat64
	%24 = alloca [4 x %Int64], align 1
	%25 = insertvalue [4 x %Int64] zeroinitializer, %Int64 1, 1
	%26 = insertvalue [4 x %Int64] %25, %Int64 2, 2
	%27 = insertvalue [4 x %Int64] %26, %Int64 3, 3
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%28 = zext i8 4 to %Int32
	; -- end vol eval --
	store [4 x %Int64] %27, [4 x %Int64]* %24
	%29 = insertvalue [4 x %Int64] zeroinitializer, %Int64 1, 1
	%30 = insertvalue [4 x %Int64] %29, %Int64 2, 2
	%31 = insertvalue [4 x %Int64] %30, %Int64 3, 3
	%32 = alloca [4 x %Int64]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%33 = zext i8 4 to %Int32
	; -- end vol eval --
	store [4 x %Int64] %31, [4 x %Int64]* %32
	%34 = bitcast [4 x %Int64]* %24 to i8*
	%35 = bitcast [4 x %Int64]* %32 to i8*
	%36 = call i1 (i8*, i8*, i64) @memeq(i8* %34, i8* %35, %Int64 32)
	%37 = icmp eq %Bool %36, 0
	br %Bool %37 , label %then_2, label %endif_2
then_2:
	%38 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([19 x i8]* @str14 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:

	; explicit cast Generic([4]GenericInteger) value to [10]Int32
	%40 = alloca [10 x %Int32], align 1
	%41 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%42 = insertvalue [10 x %Int32] %41, %Int32 2, 2
	%43 = insertvalue [10 x %Int32] %42, %Int32 3, 3
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%44 = zext i8 10 to %Int32
	; -- end vol eval --
	store [10 x %Int32] %43, [10 x %Int32]* %40
	%45 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%46 = insertvalue [10 x %Int32] %45, %Int32 2, 2
	%47 = insertvalue [10 x %Int32] %46, %Int32 3, 3
	%48 = alloca [10 x %Int32]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%49 = zext i8 10 to %Int32
	; -- end vol eval --
	store [10 x %Int32] %47, [10 x %Int32]* %48
	%50 = bitcast [10 x %Int32]* %40 to i8*
	%51 = bitcast [10 x %Int32]* %48 to i8*
	%52 = call i1 (i8*, i8*, i64) @memeq(i8* %50, i8* %51, %Int64 40)
	%53 = icmp eq %Bool %52, 0
	br %Bool %53 , label %then_3, label %endif_3
then_3:
	%54 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([37 x i8]* @str15 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
	ret %Bool 1
}

%Point2D = type {
	%Int32,
	%Int32
};

%Point3D = type {
	%Int32,
	%Int32,
	%Int32
};

define internal %Bool @test_generic_record() {
	; Any record expression have GenericRecord type
	; this record expression have type:
	; Generic(record {x: GenericInteger, y: GenericInteger})
	%1 = insertvalue {i8,i8} zeroinitializer, i8 10, 0
	%2 = insertvalue {i8,i8} %1, i8 20, 1
	%3 = alloca {i8,i8}
	store {i8,i8} %2, {i8,i8}* %3

	; value with GenericRecord type
	; can be implicit casted to Record with same fields.

	; implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	; to record {x: Int32, y: Int32}
	%4 = alloca %Point2D, align 8
	%5 = insertvalue %Point2D zeroinitializer, %Int32 10, 0
	%6 = insertvalue %Point2D %5, %Int32 20, 1
	store %Point2D %6, %Point2D* %4


	; explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	; to record {x: Int32, y: Int32, z: Int32}
	%7 = alloca %Point3D, align 16
	%8 = insertvalue %Point3D zeroinitializer, %Int32 10, 0
	%9 = insertvalue %Point3D %8, %Int32 20, 1
	store %Point3D %9, %Point3D* %7
	ret %Bool 1
}


