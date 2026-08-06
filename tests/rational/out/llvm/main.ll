
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
@.str1 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 33, i8 61, i8 32, i8 48, i8 46, i8 53, i8 10, i8 0]
@.str2 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 70, i8 108, i8 111, i8 97, i8 116, i8 54, i8 52, i8 32, i8 33, i8 61, i8 32, i8 48, i8 46, i8 53, i8 10, i8 0]
@.str3 = private constant [33 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 32, i8 97, i8 100, i8 97, i8 112, i8 116, i8 97, i8 116, i8 105, i8 111, i8 110, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str4 = private constant [20 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 115, i8 117, i8 109, i8 32, i8 33, i8 61, i8 32, i8 51, i8 46, i8 55, i8 53, i8 10, i8 0]
@.str5 = private constant [21 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 100, i8 105, i8 102, i8 102, i8 32, i8 33, i8 61, i8 32, i8 52, i8 46, i8 50, i8 53, i8 10, i8 0]
@.str6 = private constant [20 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 112, i8 114, i8 111, i8 100, i8 32, i8 33, i8 61, i8 32, i8 51, i8 46, i8 48, i8 10, i8 0]
@.str7 = private constant [21 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 113, i8 117, i8 111, i8 116, i8 32, i8 33, i8 61, i8 32, i8 49, i8 46, i8 55, i8 53, i8 10, i8 0]
@.str8 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 101, i8 103, i8 97, i8 116, i8 101, i8 100, i8 32, i8 33, i8 61, i8 32, i8 45, i8 51, i8 46, i8 55, i8 53, i8 10, i8 0]
@.str9 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 104, i8 97, i8 105, i8 110, i8 101, i8 100, i8 32, i8 33, i8 61, i8 32, i8 48, i8 46, i8 56, i8 55, i8 53, i8 10, i8 0]
@.str10 = private constant [28 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 102, i8 111, i8 108, i8 100, i8 105, i8 110, i8 103, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str11 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 112, i8 105, i8 32, i8 33, i8 61, i8 32, i8 51, i8 32, i8 40, i8 103, i8 111, i8 116, i8 32, i8 37, i8 100, i8 41, i8 10, i8 0]
@.str12 = private constant [35 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 110, i8 101, i8 103, i8 80, i8 105, i8 32, i8 33, i8 61, i8 32, i8 45, i8 51, i8 32, i8 40, i8 103, i8 111, i8 116, i8 32, i8 37, i8 100, i8 41, i8 10, i8 0]
@.str13 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 73, i8 110, i8 116, i8 56, i8 32, i8 110, i8 101, i8 103, i8 80, i8 105, i8 32, i8 33, i8 61, i8 32, i8 45, i8 51, i8 10, i8 0]
@.str14 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 112, i8 105, i8 32, i8 33, i8 61, i8 32, i8 51, i8 32, i8 40, i8 103, i8 111, i8 116, i8 32, i8 37, i8 100, i8 41, i8 10, i8 0]
@.str15 = private constant [38 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 116, i8 114, i8 117, i8 110, i8 99, i8 97, i8 116, i8 105, i8 110, i8 103, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 114, i8 117, i8 99, i8 116, i8 105, i8 111, i8 110, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str16 = private constant [19 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 102, i8 54, i8 52, i8 32, i8 60, i8 61, i8 32, i8 51, i8 46, i8 48, i8 10, i8 0]
@.str17 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 111, i8 116, i8 32, i8 40, i8 102, i8 54, i8 52, i8 32, i8 60, i8 32, i8 51, i8 46, i8 50, i8 41, i8 10, i8 0]
@.str18 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 111, i8 116, i8 32, i8 40, i8 102, i8 54, i8 52, i8 32, i8 62, i8 61, i8 32, i8 112, i8 105, i8 41, i8 10, i8 0]
@.str19 = private constant [18 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 102, i8 54, i8 52, i8 32, i8 33, i8 61, i8 32, i8 112, i8 105, i8 10, i8 0]
@.str20 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 102, i8 51, i8 50, i8 32, i8 33, i8 61, i8 32, i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 112, i8 105, i8 10, i8 0]
@.str21 = private constant [31 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 102, i8 108, i8 111, i8 97, i8 116, i8 32, i8 99, i8 111, i8 109, i8 112, i8 97, i8 114, i8 105, i8 115, i8 111, i8 110, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str22 = private constant [25 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 108, i8 111, i8 99, i8 97, i8 108, i8 83, i8 117, i8 109, i8 32, i8 33, i8 61, i8 32, i8 48, i8 46, i8 55, i8 53, i8 10, i8 0]
@.str23 = private constant [24 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 115, i8 70, i8 108, i8 111, i8 97, i8 116, i8 32, i8 33, i8 61, i8 32, i8 48, i8 46, i8 55, i8 53, i8 10, i8 0]
@.str24 = private constant [35 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 108, i8 111, i8 99, i8 97, i8 108, i8 32, i8 114, i8 97, i8 116, i8 105, i8 111, i8 110, i8 97, i8 108, i8 32, i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str25 = private constant [15 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 114, i8 97, i8 116, i8 105, i8 111, i8 110, i8 97, i8 108, i8 10, i8 0]
@.str26 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@.str27 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@.str28 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
define %Bool @main_testGenericAdaptation() {
	%1 = alloca %Float32, align 4
	store %Float32 0.5000000000000000, %Float32* %1
	%2 = alloca %Float64, align 8
	store %Float64 0.5000000000000000, %Float64* %2
; if_0
	%3 = load %Float32, %Float32* %1
	%4 = fcmp one %Float32 %3, 0.5000000000000000
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str1 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%7 = load %Float64, %Float64* %2
	%8 = fcmp one %Float64 %7, 0.5000000000000000
	br %Bool %8 , label %then_1, label %endif_1
then_1:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str2 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @.str3 to [0 x i8]*))
	ret %Bool 1
}
; 1.5 (unary + is a no-op, but still a constant expression)
define %Bool @main_testConstFolding() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str4 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str5 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	br %Bool 0 , label %then_2, label %endif_2
then_2:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str6 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	br %Bool 0 , label %then_3, label %endif_3
then_3:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str7 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	br %Bool 0 , label %then_4, label %endif_4
then_4:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str8 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
; if_5
	br %Bool 0 , label %then_5, label %endif_5
then_5:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str9 to [0 x i8]*))
	ret %Bool 0
	br label %endif_5
endif_5:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @.str10 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testTruncatingConstruction() {
	%1 = alloca %Int32, align 4
	store %Int32 3, %Int32* %1
; if_0
	%2 = load %Int32, %Int32* %1
	%3 = icmp ne %Int32 %2, 3
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = load %Int32, %Int32* %1
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str11 to [0 x i8]*), %Int32 %4)
	ret %Bool 0
	br label %endif_0
endif_0:
	%7 = alloca %Int32, align 4
	store %Int32 -3, %Int32* %7
; if_1
	%8 = load %Int32, %Int32* %7
	%9 = icmp ne %Int32 %8, -3
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = load %Int32, %Int32* %7
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @.str12 to [0 x i8]*), %Int32 %10)
	ret %Bool 0
	br label %endif_1
endif_1:
	%13 = alloca %Int8, align 1
	store %Int8 -3, %Int8* %13
; if_2
	%14 = sub i8 0, 3
	%15 = load %Int8, %Int8* %13
	%16 = icmp ne %Int8 %15, %14
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str13 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
	%19 = alloca %Nat32, align 4
	store %Nat32 3, %Nat32* %19
; if_3
	%20 = load %Nat32, %Nat32* %19
	%21 = icmp ne %Nat32 %20, 3
	br %Bool %21 , label %then_3, label %endif_3
then_3:
	%22 = load %Nat32, %Nat32* %19
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str14 to [0 x i8]*), %Nat32 %22)
	ret %Bool 0
	br label %endif_3
endif_3:
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @.str15 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testFloatComparison() {
	%1 = alloca %Float64, align 8
	store %Float64 3.1415899999999999, %Float64* %1
	%2 = alloca %Float32, align 4
	store %Float32 3.1415901184082031, %Float32* %2
; if_0
	%3 = load %Float64, %Float64* %1
	%4 = fcmp ole %Float64 %3, 3.0000000000000000
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @.str16 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	%7 = load %Float64, %Float64* %1
	%8 = fcmp olt %Float64 %7, 3.2000000000000002
	%9 = xor %Bool %8, 1
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str17 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
; if_2
	%12 = load %Float64, %Float64* %1
	%13 = fcmp oge %Float64 %12, 3.1415899999999999
	%14 = xor %Bool %13, 1
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str18 to [0 x i8]*))
	ret %Bool 0
	br label %endif_2
endif_2:
; if_3
	%17 = load %Float64, %Float64* %1
	%18 = fcmp one %Float64 %17, 3.1415899999999999
	br %Bool %18 , label %then_3, label %endif_3
then_3:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str19 to [0 x i8]*))
	ret %Bool 0
	br label %endif_3
endif_3:
; if_4
	%21 = load %Float32, %Float32* %2
	%22 = fcmp one %Float32 %21, 3.1415901184082031
	br %Bool %22 , label %then_4, label %endif_4
then_4:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str20 to [0 x i8]*))
	ret %Bool 0
	br label %endif_4
endif_4:
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str21 to [0 x i8]*))
	ret %Bool 1
}

define %Bool @main_testLocalRationalConst() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @.str22 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	%3 = alloca %Float64, align 8
	store %Float64 0.7500000000000000, %Float64* %3
; if_1
	%4 = load %Float64, %Float64* %3
	%5 = fcmp one %Float64 %4, 0.7500000000000000
	br %Bool %5 , label %then_1, label %endif_1
then_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str23 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @.str24 to [0 x i8]*))
	ret %Bool 1
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str25 to [0 x i8]*))
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
	%9 = call %Bool @main_testTruncatingConstruction()
	%10 = load %Bool, %Bool* %2
	%11 = and %Bool %9, %10
	store %Bool %11, %Bool* %2
	%12 = call %Bool @main_testFloatComparison()
	%13 = load %Bool, %Bool* %2
	%14 = and %Bool %12, %13
	store %Bool %14, %Bool* %2
	%15 = call %Bool @main_testLocalRationalConst()
	%16 = load %Bool, %Bool* %2
	%17 = and %Bool %15, %16
	store %Bool %17, %Bool* %2
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @.str26 to [0 x i8]*))
; if_0
	%19 = load %Bool, %Bool* %2
	%20 = xor %Bool %19, 1
	br %Bool %20 , label %then_0, label %endif_0
then_0:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str27 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str28 to [0 x i8]*))
	ret %Int 0
}


