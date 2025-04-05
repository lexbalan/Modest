
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
%File = type %Nat8;
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
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
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
@str12 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str14 = private constant [19 x i8] [i8 98, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str15 = private constant [19 x i8] [i8 99, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str16 = private constant [37 x i8] [i8 100, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 93, i8 10, i8 0]
; -- endstrings --; tests/1.hello_world/src/main.m
define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str1 to [0 x i8]*))
	%2 = call %Bool @test_generic_integer()
; if_0
	br %Bool %2 , label %then_0, label %else_0
then_0:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str2 to [0 x i8]*))
	br label %endif_0
else_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
endif_0:
	%5 = call %Bool @test_generic_float()
; if_1
	br %Bool %5 , label %then_1, label %else_1
then_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
	br label %endif_1
else_1:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str5 to [0 x i8]*))
	br label %endif_1
endif_1:
	%8 = call %Bool @test_generic_char()
; if_2
	br %Bool %8 , label %then_2, label %else_2
then_2:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	br label %endif_2
else_2:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str7 to [0 x i8]*))
	br label %endif_2
endif_2:
	%11 = call %Bool @test_generic_array()
; if_3
	br %Bool %11 , label %then_3, label %else_3
then_3:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str8 to [0 x i8]*))
	br label %endif_3
else_3:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str9 to [0 x i8]*))
	br label %endif_3
endif_3:
	%14 = call %Bool @test_generic_record()
; if_4
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
	%2 = alloca %Nat64, align 8
	store %Nat64 1, %Nat64* %2

	; to Float
	%3 = alloca %Float32, align 4
	store %Float32 1.0000000000000000, %Float32* %3
	%4 = alloca %Float64, align 8
	store %Float64 1.0000000000000000, %Float64* %4

	; and to Word8
	%5 = alloca %Word8, align 1
	%6 = bitcast i8 1 to %Word8
	store %Word8 %6, %Word8* %5


	; explicit cast GenericInteger value
	%7 = alloca %Char8, align 1
	store %Char8 1, %Char8* %7
	%8 = alloca %Char16, align 2
	store %Char16 1, %Char16* %8
	%9 = alloca %Char32, align 4
	store %Char32 1, %Char32* %9
	%10 = alloca %Bool, align 1
	store %Bool 1, %Bool* %10
	ret %Bool 1
}

define internal %Bool @test_generic_float() {
	; Any float literal have GenericFloat type

	; value with GenericFloat type
	; can be implicit casted to any Float type
	; (in this case value may lose precision)
	%1 = alloca %Float32, align 4
	store %Float32 3.1415927410125732, %Float32* %1
	%2 = alloca %Float64, align 8
	store %Float64 3.1415926535897931, %Float64* %2

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
	%5 = zext i8 4 to %Nat32
	store [4 x i8] %3, [4 x i8]* %4
	%6 = alloca %Int32, align 4
	store %Int32 0, %Int32* %6
; while_1
	br label %again_1
again_1:
	%7 = load %Int32, %Int32* %6
	%8 = icmp slt %Int32 %7, 4
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = load %Int32, %Int32* %6
	%10 = load %Int32, %Int32* %6
	%11 = getelementptr [4 x i8], [4 x i8]* %4, %Int32 0, %Int32 %10
	%12 = load i8, i8* %11
	%13 = sext i8 %12 to %Int32
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str12 to [0 x i8]*), %Int32 %9, %Int32 %13)
	%15 = load %Int32, %Int32* %6
	%16 = add %Int32 %15, 1
	store %Int32 %16, %Int32* %6
	br label %again_1
break_1:
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:

	; value with GenericArray type
	; can be implicit casted to Array with compatible type and same size

	; implicit cast Generic([4]GenericInteger) value to [4]Int32
	%19 = alloca [4 x %Int32], align 1
	%20 = insertvalue [4 x %Int32] zeroinitializer, %Int32 1, 1
	%21 = insertvalue [4 x %Int32] %20, %Int32 2, 2
	%22 = insertvalue [4 x %Int32] %21, %Int32 3, 3
	%23 = zext i8 4 to %Nat32
	store [4 x %Int32] %22, [4 x %Int32]* %19
; if_1
	%24 = insertvalue [4 x %Int32] zeroinitializer, %Int32 1, 1
	%25 = insertvalue [4 x %Int32] %24, %Int32 2, 2
	%26 = insertvalue [4 x %Int32] %25, %Int32 3, 3
	%27 = alloca [4 x %Int32]
	%28 = zext i8 4 to %Nat32
	store [4 x %Int32] %26, [4 x %Int32]* %27
	%29 = bitcast [4 x %Int32]* %19 to i8*
	%30 = bitcast [4 x %Int32]* %27 to i8*
	%31 = call i1 (i8*, i8*, i64) @memeq(i8* %29, i8* %30, %Int64 16)
	%32 = icmp eq %Bool %31, 0
	br %Bool %32 , label %then_1, label %endif_1
then_1:
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str14 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:

	; implicit cast Generic([4]GenericInteger) value to [4]Nat64
	%35 = alloca [4 x %Int64], align 1
	%36 = insertvalue [4 x %Int64] zeroinitializer, %Int64 1, 1
	%37 = insertvalue [4 x %Int64] %36, %Int64 2, 2
	%38 = insertvalue [4 x %Int64] %37, %Int64 3, 3
	%39 = zext i8 4 to %Nat32
	store [4 x %Int64] %38, [4 x %Int64]* %35
; if_2
	%40 = insertvalue [4 x %Int64] zeroinitializer, %Int64 1, 1
	%41 = insertvalue [4 x %Int64] %40, %Int64 2, 2
	%42 = insertvalue [4 x %Int64] %41, %Int64 3, 3
	%43 = alloca [4 x %Int64]
	%44 = zext i8 4 to %Nat32
	store [4 x %Int64] %42, [4 x %Int64]* %43
	%45 = bitcast [4 x %Int64]* %35 to i8*
	%46 = bitcast [4 x %Int64]* %43 to i8*
	%47 = call i1 (i8*, i8*, i64) @memeq(i8* %45, i8* %46, %Int64 32)
	%48 = icmp eq %Bool %47, 0
	br %Bool %48 , label %then_2, label %endif_2
then_2:
	%49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str15 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:

	; explicit cast Generic([4]GenericInteger) value to [10]Int32
	%51 = alloca [10 x %Int32], align 1
	%52 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%53 = insertvalue [10 x %Int32] %52, %Int32 2, 2
	%54 = insertvalue [10 x %Int32] %53, %Int32 3, 3
	%55 = zext i8 10 to %Nat32
	store [10 x %Int32] %54, [10 x %Int32]* %51
; if_3
	%56 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%57 = insertvalue [10 x %Int32] %56, %Int32 2, 2
	%58 = insertvalue [10 x %Int32] %57, %Int32 3, 3
	%59 = alloca [10 x %Int32]
	%60 = zext i8 10 to %Nat32
	store [10 x %Int32] %58, [10 x %Int32]* %59
	%61 = bitcast [10 x %Int32]* %51 to i8*
	%62 = bitcast [10 x %Int32]* %59 to i8*
	%63 = call i1 (i8*, i8*, i64) @memeq(i8* %61, i8* %62, %Int64 40)
	%64 = icmp eq %Bool %63, 0
	br %Bool %64 , label %then_3, label %endif_3
then_3:
	%65 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str16 to [0 x i8]*))
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


