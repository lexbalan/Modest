
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
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
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
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
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
; -- print imports --
; -- end print imports --
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
define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str1 to [0 x i8]*))
	%2 = call %Bool @test_generic_integer()
	br %Bool %2 , label %then_0, label %else_0
then_0:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str2 to [0 x i8]*))
	br label %endif_0
else_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
endif_0:
	%5 = call %Bool @test_generic_float()
	br %Bool %5 , label %then_1, label %else_1
then_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
	br label %endif_1
else_1:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str5 to [0 x i8]*))
	br label %endif_1
endif_1:
	%8 = call %Bool @test_generic_char()
	br %Bool %8 , label %then_2, label %else_2
then_2:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	br label %endif_2
else_2:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str7 to [0 x i8]*))
	br label %endif_2
endif_2:
	%11 = call %Bool @test_generic_array()
	br %Bool %11 , label %then_3, label %else_3
then_3:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str8 to [0 x i8]*))
	br label %endif_3
else_3:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str9 to [0 x i8]*))
	br label %endif_3
endif_3:
	%14 = call %Bool @test_generic_record()
	br %Bool %14 , label %then_4, label %else_4
then_4:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str10 to [0 x i8]*))
	br label %endif_4
else_4:
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str11 to [0 x i8]*))
	br label %endif_4
endif_4:
	ret %Int 0
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
	%1 = insertvalue [4 x %Int8] zeroinitializer, %Int8 1, 1
	%2 = insertvalue [4 x %Int8] %1, %Int8 2, 2
	%3 = insertvalue [4 x %Int8] %2, %Int8 3, 3
	%4 = alloca [4 x %Int8]
	store [4 x %Int8] %3, [4 x %Int8]* %4
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str12 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:

	; value with GenericArray type
	; can be implicit casted to Array with compatible type and same size

	; implicit cast Generic([4]GenericInteger) value to [4]Int32
	%7 = alloca [4 x %Int32], align 4
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%8 = zext %Int8 4 to %Int32
	; -- end vol eval --
	%9 = insertvalue [4 x %Int32] zeroinitializer, %Int32 1, 1
	%10 = insertvalue [4 x %Int32] %9, %Int32 2, 2
	%11 = insertvalue [4 x %Int32] %10, %Int32 3, 3
	store [4 x %Int32] %11, [4 x %Int32]* %7
	%12 = insertvalue [4 x %Int32] zeroinitializer, %Int32 1, 1
	%13 = insertvalue [4 x %Int32] %12, %Int32 2, 2
	%14 = insertvalue [4 x %Int32] %13, %Int32 3, 3
	%15 = alloca [4 x %Int32]
	store [4 x %Int32] %14, [4 x %Int32]* %15
	%16 = bitcast [4 x %Int32]* %7 to i8*
	%17 = bitcast [4 x %Int32]* %15 to i8*
	%18 = call i1 (i8*, i8*, i64) @memeq(i8* %16, i8* %17, %Int64 16)
	%19 = icmp eq %Bool %18, 0
	br %Bool %19 , label %then_1, label %endif_1
then_1:
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:

	; implicit cast Generic([4]GenericInteger) value to [4]Nat64
	%22 = alloca [4 x %Int64], align 8
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%23 = zext %Int8 4 to %Int32
	; -- end vol eval --
	%24 = insertvalue [4 x %Int64] zeroinitializer, %Int64 1, 1
	%25 = insertvalue [4 x %Int64] %24, %Int64 2, 2
	%26 = insertvalue [4 x %Int64] %25, %Int64 3, 3
	store [4 x %Int64] %26, [4 x %Int64]* %22
	%27 = insertvalue [4 x %Int64] zeroinitializer, %Int64 1, 1
	%28 = insertvalue [4 x %Int64] %27, %Int64 2, 2
	%29 = insertvalue [4 x %Int64] %28, %Int64 3, 3
	%30 = alloca [4 x %Int64]
	store [4 x %Int64] %29, [4 x %Int64]* %30
	%31 = bitcast [4 x %Int64]* %22 to i8*
	%32 = bitcast [4 x %Int64]* %30 to i8*
	%33 = call i1 (i8*, i8*, i64) @memeq(i8* %31, i8* %32, %Int64 32)
	%34 = icmp eq %Bool %33, 0
	br %Bool %34 , label %then_2, label %endif_2
then_2:
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str14 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:

	; explicit cast Generic([4]GenericInteger) value to [10]Int32
	%37 = alloca [10 x %Int32], align 4
	%38 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%39 = insertvalue [10 x %Int32] %38, %Int32 2, 2
	%40 = insertvalue [10 x %Int32] %39, %Int32 3, 3
	store [10 x %Int32] %40, [10 x %Int32]* %37
	%41 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%42 = insertvalue [10 x %Int32] %41, %Int32 2, 2
	%43 = insertvalue [10 x %Int32] %42, %Int32 3, 3
	%44 = alloca [10 x %Int32]
	store [10 x %Int32] %43, [10 x %Int32]* %44
	%45 = bitcast [10 x %Int32]* %37 to i8*
	%46 = bitcast [10 x %Int32]* %44 to i8*
	%47 = call i1 (i8*, i8*, i64) @memeq(i8* %45, i8* %46, %Int64 40)
	%48 = icmp eq %Bool %47, 0
	br %Bool %48 , label %then_3, label %endif_3
then_3:
	%49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str15 to [0 x i8]*))
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
	%1 = insertvalue {%Int8,%Int8} zeroinitializer, %Int8 10, 0
	%2 = insertvalue {%Int8,%Int8} %1, %Int8 20, 1
	%3 = alloca {%Int8,%Int8}
	store {%Int8,%Int8} %2, {%Int8,%Int8}* %3

	; value with GenericRecord type
	; can be implicit casted to Record with same fields.

	; implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	; to record {x: Int32, y: Int32}
	%4 = alloca %Point2D, align 4
	%5 = insertvalue %Point2D zeroinitializer, %Int32 10, 0
	%6 = insertvalue %Point2D %5, %Int32 20, 1
	store %Point2D %6, %Point2D* %4


	; explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	; to record {x: Int32, y: Int32, z: Int32}
	%7 = alloca %Point3D, align 4
	%8 = insertvalue %Point3D zeroinitializer, %Int32 10, 0
	%9 = insertvalue %Point3D %8, %Int32 20, 1
	%10 = insertvalue %Point3D %9, %Int32 0, 2
	store %Point3D %10, %Point3D* %7
	ret %Bool 1
}


