
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
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
; from included stdio
%File = type {
};

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
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
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
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; -- end print includes --
; -- print imports 'main' --
; -- 2

; from import "lib2"

; end from import "lib2"

; from import "lib"
%lib_PublicType = type %Int32;

; end from import "lib"

; from import "fixed32"
%fixed32_Fixed32 = type %Word32;
declare %fixed32_Fixed32 @fixed32_create(%Int16 %a, %Nat16 %b, %Nat16 %c)
declare %fixed32_Fixed32 @fixed32_fromInt16(%Int16 %x)
declare %Int16 @fixed32_toInt16(%fixed32_Fixed32 %x)
declare void @fixed32_print(%fixed32_Fixed32 %x)
declare %fixed32_Fixed32 @fixed32_add(%fixed32_Fixed32 %a, %fixed32_Fixed32 %b)
declare %fixed32_Fixed32 @fixed32_sub(%fixed32_Fixed32 %a, %fixed32_Fixed32 %b)
declare %fixed32_Fixed32 @fixed32_mul(%fixed32_Fixed32 %a, %fixed32_Fixed32 %b)
declare %fixed32_Fixed32 @fixed32_div(%fixed32_Fixed32 %a, %fixed32_Fixed32 %b)
declare %fixed32_Fixed32 @fixed32_trunc(%fixed32_Fixed32 %x)
declare %fixed32_Fixed32 @fixed32_fract(%fixed32_Fixed32 %x)
declare %fixed32_Fixed32 @fixed32_floor(%fixed32_Fixed32 %x)
declare %fixed32_Fixed32 @fixed32_ceil(%fixed32_Fixed32 %x)

; end from import "fixed32"
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [14 x i8] [i8 102, i8 112, i8 48, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str2 = private constant [2 x i8] [i8 10, i8 0]
@str3 = private constant [14 x i8] [i8 102, i8 112, i8 49, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str4 = private constant [2 x i8] [i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 102, i8 112, i8 50, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str6 = private constant [2 x i8] [i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 102, i8 112, i8 51, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str8 = private constant [2 x i8] [i8 10, i8 0]
@str9 = private constant [14 x i8] [i8 102, i8 112, i8 52, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str10 = private constant [2 x i8] [i8 10, i8 0]
@str11 = private constant [14 x i8] [i8 102, i8 112, i8 53, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str12 = private constant [2 x i8] [i8 10, i8 0]
@str13 = private constant [13 x i8] [i8 100, i8 118, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str14 = private constant [2 x i8] [i8 10, i8 0]
@str15 = private constant [13 x i8] [i8 112, i8 105, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str16 = private constant [2 x i8] [i8 10, i8 0]
@str17 = private constant [20 x i8] [i8 116, i8 114, i8 117, i8 110, i8 99, i8 40, i8 112, i8 105, i8 41, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str18 = private constant [2 x i8] [i8 10, i8 0]
@str19 = private constant [20 x i8] [i8 102, i8 114, i8 97, i8 99, i8 116, i8 40, i8 112, i8 105, i8 41, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str20 = private constant [2 x i8] [i8 10, i8 0]
@str21 = private constant [15 x i8] [i8 109, i8 111, i8 110, i8 101, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str22 = private constant [2 x i8] [i8 10, i8 0]
@str23 = private constant [15 x i8] [i8 111, i8 111, i8 110, i8 101, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str24 = private constant [2 x i8] [i8 10, i8 0]
@str25 = private constant [15 x i8] [i8 115, i8 101, i8 109, i8 105, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str26 = private constant [2 x i8] [i8 10, i8 0]
@str27 = private constant [14 x i8] [i8 100, i8 118, i8 50, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 0]
@str28 = private constant [2 x i8] [i8 10, i8 0]
@str29 = private constant [14 x i8] [i8 37, i8 100, i8 32, i8 47, i8 32, i8 37, i8 100, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str30 = private constant [15 x i8] [i8 37, i8 100, i8 32, i8 37, i8 37, i8 32, i8 37, i8 100, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str31 = private constant [9 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 37, i8 115, i8 10, i8 0]
@str32 = private constant [4 x i8] [i8 72, i8 105, i8 33, i8 0]
@str33 = private constant [9 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 37, i8 100, i8 10, i8 0]
@str34 = private constant [11 x i8] [i8 112, i8 48, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str35 = private constant [5 x i8] [i8 101, i8 113, i8 33, i8 10, i8 0]
@str36 = private constant [5 x i8] [i8 101, i8 113, i8 33, i8 10, i8 0]
@str37 = private constant [35 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 40, i8 45, i8 49, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str38 = private constant [30 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str39 = private constant [34 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 40, i8 49, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str40 = private constant [30 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str41 = private constant [38 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 32, i8 40, i8 48, i8 120, i8 102, i8 102, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str42 = private constant [31 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
define internal void @testFixed() {
	%1 = call %fixed32_Fixed32 @fixed32_create(%Int16 1, %Nat16 2, %Nat16 4)
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str1 to [0 x i8]*), %fixed32_Fixed32 %1)
	call void @fixed32_print(%fixed32_Fixed32 %1)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
	%4 = call %fixed32_Fixed32 @fixed32_create(%Int16 1, %Nat16 1, %Nat16 2)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str3 to [0 x i8]*), %fixed32_Fixed32 %4)
	call void @fixed32_print(%fixed32_Fixed32 %4)
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
	%7 = call %fixed32_Fixed32 @fixed32_create(%Int16 1, %Nat16 1, %Nat16 3)
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*), %fixed32_Fixed32 %7)
	call void @fixed32_print(%fixed32_Fixed32 %7)
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str6 to [0 x i8]*))
	%10 = call %fixed32_Fixed32 @fixed32_create(%Int16 1, %Nat16 2, %Nat16 128)
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*), %fixed32_Fixed32 %10)
	call void @fixed32_print(%fixed32_Fixed32 %10)
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str8 to [0 x i8]*))
	%13 = call %fixed32_Fixed32 @fixed32_add(%fixed32_Fixed32 %1, %fixed32_Fixed32 %4)
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str9 to [0 x i8]*), %fixed32_Fixed32 %13)
	call void @fixed32_print(%fixed32_Fixed32 %13)
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str10 to [0 x i8]*))
	%16 = call %fixed32_Fixed32 @fixed32_mul(%fixed32_Fixed32 %1, %fixed32_Fixed32 %4)
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str11 to [0 x i8]*), %fixed32_Fixed32 %16)
	call void @fixed32_print(%fixed32_Fixed32 %16)
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str12 to [0 x i8]*))
	%19 = call %fixed32_Fixed32 @fixed32_create(%Int16 1, %Nat16 0, %Nat16 1)
	%20 = call %fixed32_Fixed32 @fixed32_create(%Int16 2, %Nat16 0, %Nat16 1)
	%21 = call %fixed32_Fixed32 @fixed32_div(%fixed32_Fixed32 %19, %fixed32_Fixed32 %20)
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str13 to [0 x i8]*), %fixed32_Fixed32 %21)
	call void @fixed32_print(%fixed32_Fixed32 %21)
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str14 to [0 x i8]*))
	%24 = call %fixed32_Fixed32 @fixed32_create(%Int16 3, %Nat16 1415, %Nat16 10000)
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str15 to [0 x i8]*), %fixed32_Fixed32 %24)
	call void @fixed32_print(%fixed32_Fixed32 %24)
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str16 to [0 x i8]*))
	%27 = call %fixed32_Fixed32 @fixed32_trunc(%fixed32_Fixed32 %24)
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str17 to [0 x i8]*), %fixed32_Fixed32 %27)
	call void @fixed32_print(%fixed32_Fixed32 %27)
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str18 to [0 x i8]*))
	%30 = call %fixed32_Fixed32 @fixed32_fract(%fixed32_Fixed32 %24)
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str19 to [0 x i8]*), %fixed32_Fixed32 %30)
	call void @fixed32_print(%fixed32_Fixed32 %30)
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str20 to [0 x i8]*))

	; ok!
	;	let dv2 = fixed32.div(pi, two)
	;	printf("dv2 = 0x%08x ", dv2)
	;	fixed32.print(dv2)
	;	printf("\n")
	%33 = call %fixed32_Fixed32 @fixed32_fromInt16(%Int16 0)

	; -1+0/1 = ok
	%34 = call %fixed32_Fixed32 @fixed32_sub(%fixed32_Fixed32 %33, %fixed32_Fixed32 %19)
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str21 to [0 x i8]*), %fixed32_Fixed32 %34)
	call void @fixed32_print(%fixed32_Fixed32 %34)
	%36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str22 to [0 x i8]*))
	%37 = alloca %fixed32_Fixed32, align 4
	store %fixed32_Fixed32 %20, %fixed32_Fixed32* %37
	%38 = load %fixed32_Fixed32, %fixed32_Fixed32* %37
	%39 = call %fixed32_Fixed32 @fixed32_add(%fixed32_Fixed32 %38, %fixed32_Fixed32 %34)
	%40 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str23 to [0 x i8]*), %fixed32_Fixed32 %39)
	call void @fixed32_print(%fixed32_Fixed32 %39)
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str24 to [0 x i8]*))
	%42 = call %fixed32_Fixed32 @fixed32_fromInt16(%Int16 180)
	%43 = call %fixed32_Fixed32 @fixed32_sub(%fixed32_Fixed32 %33, %fixed32_Fixed32 %42)
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str25 to [0 x i8]*), %fixed32_Fixed32 %43)
	call void @fixed32_print(%fixed32_Fixed32 %43)
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str26 to [0 x i8]*))

	;let xx = fixed32.fromInt16(380)
	%46 = call %fixed32_Fixed32 @fixed32_div(%fixed32_Fixed32 %43, %fixed32_Fixed32 %20)
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str27 to [0 x i8]*), %fixed32_Fixed32 %46)
	call void @fixed32_print(%fixed32_Fixed32 %46)
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str28 to [0 x i8]*))
	ret void
}

%NewType = type %Int32;
define internal void @brandCheck() {
	%1 = alloca %NewType, align 4
	%2 = alloca %NewType, align 4
	%3 = load %NewType, %NewType* %1
	%4 = load %NewType, %NewType* %2
	%5 = add %NewType %3, %4
	%6 = add %NewType %5, 0
	%7 = add %NewType %6, 0
	%8 = alloca %Int16, align 2
	%9 = trunc %NewType %7 to %Int16
	store %Int16 %9, %Int16* %8
	%10 = alloca %Int32, align 4
	%11 = bitcast %NewType %7 to %Int32
	store %Int32 %11, %Int32* %10
	;
	ret void
}

define internal %Int32 @add(%Int32 %a, %Int32 %b) {
	%1 = add %Int32 %a, %b
	ret %Int32 %1
}


;const yx = add(2, 2)
%main_Point = type <{
	%Int32,
	%Int32
}>;

@v0 = internal global %Int32 zeroinitializer
define void @main_f0() {
	ret void
}

@i32 = internal global %Int32 zeroinitializer
@u32 = internal global %Nat32 zeroinitializer, align 4
@a32 = internal global %Word32 zeroinitializer
@prev_p = internal global [10 x %Word8] zeroinitializer
define internal void @xxx([0 x %Word8]* %p) {
	%1 = bitcast [0 x %Word8]* %p to [10 x %Word8]*
; if_0
	%2 = bitcast [10 x %Word8]* @prev_p to i8*
	%3 = bitcast [10 x %Word8]* %1 to i8*
	%4 = call i1 (i8*, i8*, i64) @memeq(i8* %2, i8* %3, %Int64 10)
	%5 = icmp eq %Bool %4, 0
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	%6 = load [10 x %Word8], [10 x %Word8]* %1
	%7 = zext i8 10 to %Nat32
	store [10 x %Word8] %6, [10 x %Word8]* @prev_p
	br label %endif_0
endif_0:
	ret void
}

define internal void @mzero(i8* %p, %Nat32 %size) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = bitcast i8* %p to [0 x %Word8]*
	%4 = mul %Nat32 %size, 1
	%5 = mul %Nat32 %size, 1
	%6 = mul %Nat32 %size, 1
	%7 = bitcast [0 x %Word8]* %3 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %7, i8 0, %Nat32 %6, i1 0)
	%8 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %8)
	ret void
}

define internal void @mcopy(i8* %dst, i8* %src, %Nat32 %size) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = bitcast i8* %dst to [0 x %Word8]*
	%4 = mul %Nat32 %size, 1
	%5 = mul %Nat32 %size, 1
	%6 = bitcast i8* %src to [0 x %Word8]*
	%7 = mul %Nat32 %size, 1
	%8 = mul %Nat32 %size, 1
	%9 = load [0 x %Word8], [0 x %Word8]* %6
	store [0 x %Word8] %9, [0 x %Word8]* %3
	%10 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %10)
	ret void
}

define internal %Bool @mcmp(i8* %a, i8* %b, %Nat32 %size) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = bitcast i8* %a to [0 x %Word8]*
	%4 = mul %Nat32 %size, 1
	%5 = mul %Nat32 %size, 1
	%6 = bitcast i8* %b to [0 x %Word8]*
	%7 = mul %Nat32 %size, 1
	%8 = mul %Nat32 %size, 1
	%9 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %9)
	%10 = bitcast [0 x %Word8]* %3 to i8*
	%11 = bitcast [0 x %Word8]* %6 to i8*
	%12 = call i1 (i8*, i8*, i64) @memeq(i8* %10, i8* %11, %Int64 0)
	%13 = icmp ne %Bool %12, 0
	ret %Bool %13
}

define void @main_sbuf(i8* %p, %Nat32 %size) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = bitcast i8* %p to [0 x %Word8]*
	%4 = mul %Nat32 %size, 1
	%5 = mul %Nat32 %size, 1
	%6 = mul %Nat32 %size, 1
	%7 = mul %Nat32 %size, 1
	%8 = alloca %Word8, %Nat32 %6, align 1
	%9 = load [0 x %Word8], [0 x %Word8]* %3
	store [0 x %Word8] %9, %Word8* %8
	%10 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %10
; while_1
	br label %again_1
again_1:
	%11 = load %Nat32, %Nat32* %10
	%12 = icmp ult %Nat32 %11, %size
	br %Bool %12 , label %body_1, label %break_1
body_1:
	%13 = load %Nat32, %Nat32* %10
	%14 = mul %Nat32 %13, 1
	%15 = add %Int32 0, %14
	%16 = getelementptr %Word8, [0 x %Word8]* %8, %Int32 %15
	%17 = load %Word8, %Word8* %16
	%18 = load %Nat32, %Nat32* %10
	%19 = add %Nat32 %18, 1
	store %Nat32 %19, %Nat32* %10
	br label %again_1
break_1:
	%20 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %20)
	ret void
}

@xx = internal global [0 x [10 x %Int]*]* zeroinitializer
@yy = internal global [10 x %Int] zeroinitializer
declare external %Int32 @ma()


;func ab_ret (a: Int32, b: Int32) -> record {a: Int32, b: Int32} {
;	return {a=a, b=b}
;}
;
;func ab_test () -> Unit {
;	let x = ab_ret(9, 11)
;	printf("x.a = %i\n", x.a)
;	printf("x.a = %i\n", x.b)
;}
@va = internal global %Int32 4
@p = internal global {
	i8,
	i8
} {
	i8 1,
	i8 2
}
@ini = constant [10 x i8] [
	i8 0,
	i8 1,
	i8 2,
	i8 3,
	i8 4,
	i8 5,
	i8 6,
	i8 7,
	i8 8,
	i8 9
]
@yyy = external global [32 x %Int32]
define internal void @divtest() {
	%1 = alloca %Int32, align 4
	store %Int32 7, %Int32* %1
	%2 = alloca %Int32, align 4
	store %Int32 -3, %Int32* %2
	%3 = load %Int32, %Int32* %1
	%4 = load %Int32, %Int32* %2
	%5 = load %Int32, %Int32* %1
	%6 = load %Int32, %Int32* %2
	%7 = sdiv %Int32 %5, %6
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str29 to [0 x i8]*), %Int32 %3, %Int32 %4, %Int32 %7)
	%9 = load %Int32, %Int32* %1
	%10 = load %Int32, %Int32* %2
	%11 = load %Int32, %Int32* %1
	%12 = load %Int32, %Int32* %2
	%13 = srem %Int32 %11, %12
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str30 to [0 x i8]*), %Int32 %9, %Int32 %10, %Int32 %13)
	ret void
}

define internal %Int32 @argtest(%Int32 %a, %Int32 %b) {
	%1 = add %Int32 %a, %b
	ret %Int32 %1
}

define %Int32 @main() {
	;ab_test()
	%1 = call %Int32 @argtest(%Int32 1, %Int32 0)
	%2 = call %Int32 @argtest(%Int32 1, %Int32 2)
	%3 = call %Int32 @argtest(%Int32 1, %Int32 3)
	call void @testFixed()
	call void @divtest()
	%4 = alloca %main_Point, align 8
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str31 to [0 x i8]*), %Str8* bitcast ([4 x i8]* @str32 to [0 x i8]*))
	%6 = load %Int32, %Int32* @v0
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str33 to [0 x i8]*), %Int32 %6)
	;f0()
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str34 to [0 x i8]*), %Int32 1)
	%9 = alloca %Int32, align 4
	store %Int32 5, %Int32* %9
	%10 = alloca %Int32, align 4
	store %Int32 15, %Int32* %10
	%11 = alloca [10 x %Word8], align 1
	%12 = bitcast i8 0 to %Word8
	%13 = bitcast i8 1 to %Word8
	%14 = bitcast i8 2 to %Word8
	%15 = bitcast i8 3 to %Word8
	%16 = bitcast i8 4 to %Word8
	%17 = bitcast i8 5 to %Word8
	%18 = bitcast i8 6 to %Word8
	%19 = bitcast i8 7 to %Word8
	%20 = bitcast i8 8 to %Word8
	%21 = bitcast i8 9 to %Word8
	%22 = bitcast i8 1 to %Word8
	%23 = insertvalue [10 x %Word8] zeroinitializer, %Word8 %22, 1
	%24 = bitcast i8 2 to %Word8
	%25 = insertvalue [10 x %Word8] %23, %Word8 %24, 2
	%26 = bitcast i8 3 to %Word8
	%27 = insertvalue [10 x %Word8] %25, %Word8 %26, 3
	%28 = bitcast i8 4 to %Word8
	%29 = insertvalue [10 x %Word8] %27, %Word8 %28, 4
	%30 = bitcast i8 5 to %Word8
	%31 = insertvalue [10 x %Word8] %29, %Word8 %30, 5
	%32 = bitcast i8 6 to %Word8
	%33 = insertvalue [10 x %Word8] %31, %Word8 %32, 6
	%34 = bitcast i8 7 to %Word8
	%35 = insertvalue [10 x %Word8] %33, %Word8 %34, 7
	%36 = bitcast i8 8 to %Word8
	%37 = insertvalue [10 x %Word8] %35, %Word8 %36, 8
	%38 = bitcast i8 9 to %Word8
	%39 = insertvalue [10 x %Word8] %37, %Word8 %38, 9
	%40 = zext i8 10 to %Nat32
	store [10 x %Word8] %39, [10 x %Word8]* %11
	%41 = alloca [10 x %Int32], align 1
	%42 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%43 = insertvalue [10 x %Int32] %42, %Int32 2, 2
	%44 = insertvalue [10 x %Int32] %43, %Int32 3, 3
	%45 = insertvalue [10 x %Int32] %44, %Int32 4, 4
	%46 = insertvalue [10 x %Int32] %45, %Int32 5, 5
	%47 = insertvalue [10 x %Int32] %46, %Int32 6, 6
	%48 = insertvalue [10 x %Int32] %47, %Int32 7, 7
	%49 = insertvalue [10 x %Int32] %48, %Int32 8, 8
	%50 = insertvalue [10 x %Int32] %49, %Int32 9, 9
	%51 = zext i8 10 to %Nat32
	store [10 x %Int32] %50, [10 x %Int32]* %41
	;
	%52 = alloca [5 x %Int32], align 1
	%53 = zext i8 2 to %Nat32
	%54 = getelementptr [10 x %Int32], [10 x %Int32]* %41, %Int32 0, %Nat32 %53
	%55 = bitcast %Int32* %54 to [5 x %Int32]*
	%56 = load [5 x %Int32], [5 x %Int32]* %55
	%57 = zext i8 5 to %Nat32
	store [5 x %Int32] %56, [5 x %Int32]* %52
	;
	%58 = alloca [20 x %Int32], align 1
	%59 = zext i8 5 to %Nat32
	%60 = getelementptr [20 x %Int32], [20 x %Int32]* %58, %Int32 0, %Nat32 %59
	%61 = bitcast %Int32* %60 to [10 x %Int32]*
	%62 = load [10 x %Int32], [10 x %Int32]* %41
	%63 = zext i8 10 to %Nat32
	store [10 x %Int32] %62, [10 x %Int32]* %61
	;
	%64 = alloca [20 x %Int32], align 1
	%65 = load %Int32, %Int32* %9
	%66 = getelementptr [20 x %Int32], [20 x %Int32]* %64, %Int32 0, %Int32 %65
	%67 = bitcast %Int32* %66 to [0 x %Int32]*
	%68 = load [10 x %Int32], [10 x %Int32]* %41
	%69 = zext i8 10 to %Nat32
	store [10 x %Int32] %68, [0 x %Int32]* %67
	;
	%70 = zext i8 3 to %Nat32
	%71 = getelementptr [20 x %Int32], [20 x %Int32]* %64, %Int32 0, %Nat32 %70
	%72 = bitcast %Int32* %71 to [9 x %Int32]*
	%73 = zext i8 4 to %Nat32
	%74 = getelementptr [20 x %Int32], [20 x %Int32]* %58, %Int32 0, %Nat32 %73
	%75 = bitcast %Int32* %74 to [9 x %Int32]*
	%76 = load [9 x %Int32], [9 x %Int32]* %75
	%77 = zext i8 9 to %Nat32
	store [9 x %Int32] %76, [9 x %Int32]* %72
	;
	%78 = zext i8 3 to %Nat32
	%79 = getelementptr [20 x %Int32], [20 x %Int32]* %64, %Int32 0, %Nat32 %78
	%80 = bitcast %Int32* %79 to [10 x %Int32]*
	%81 = load [10 x %Int32], [10 x %Int32]* %80
	%82 = zext i8 10 to %Nat32
	store [10 x %Int32] %81, [10 x %Int32]* %41
	;
	%83 = zext i8 3 to %Nat32
	%84 = getelementptr [20 x %Int32], [20 x %Int32]* %64, %Int32 0, %Nat32 %83
	%85 = bitcast %Int32* %84 to [10 x %Int32]*
	%86 = zext i8 10 to %Nat32
	%87 = mul %Nat32 %86, 4
	%88 = bitcast [10 x %Int32]* %85 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %88, i8 0, %Nat32 %87, i1 0)
	%89 = alloca [10 x %Int32], align 1
	%90 = zext i8 10 to %Nat32
	%91 = mul %Nat32 %90, 4
	%92 = bitcast [10 x %Int32]* %89 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %92, i8 0, %Nat32 %91, i1 0)
	%93 = bitcast [10 x %Word8]* %11 to [0 x %Word8]*
	call void @xxx([0 x %Word8]* %93)
	%94 = alloca %Word8, align 1
	%95 = bitcast i8 1 to %Word8
	store %Word8 %95, %Word8* %94
	%96 = alloca %Word8, align 1
	%97 = load %Word8, %Word8* %94
	%98 = bitcast %Word8 %97 to %Nat8
	%99 = bitcast %Nat8 %98 to %Word8
	store %Word8 %99, %Word8* %96
	%100 = bitcast [20 x %Int32]* %58 to [10 x %Int]*
; if_0
	%101 = bitcast [10 x %Int]* %100 to i8*
	%102 = bitcast [10 x %Int32]* %41 to i8*
	%103 = call i1 (i8*, i8*, i64) @memeq(i8* %101, i8* %102, %Int64 40)
	%104 = icmp ne %Bool %103, 0
	br %Bool %104 , label %then_0, label %else_0
then_0:
	%105 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str35 to [0 x i8]*))
	br label %endif_0
else_0:
	%106 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str36 to [0 x i8]*))
	br label %endif_0
endif_0:

	;	let x = Int8 -1
	;
	;	i32 = Int32 x
	;	u32 = Nat32 x

	; не проверяет дубликаты имен!
	%107 = alloca %Int32, align 4
	store %Int32 1, %Int32* %107
	;var y: Int32 = 0x1  // error!
	%108 = alloca %Word32, align 4
	%109 = zext i8 1 to %Word32
	store %Word32 %109, %Word32* %108
	%110 = alloca %Word32, align 4
	store %Word32 1, %Word32* %110
	%111 = sub i8 0, 1
	%112 = zext %Int8 %111 to %Word32
; if_1
	br %Bool 1 , label %then_1, label %else_1
then_1:
	%113 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @str37 to [0 x i8]*))
	br label %endif_1
else_1:
	%114 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str38 to [0 x i8]*))
	br label %endif_1
endif_1:
; if_2
	br %Bool 1 , label %then_2, label %else_2
then_2:
	%115 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str39 to [0 x i8]*))
	br label %endif_2
else_2:
	%116 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str40 to [0 x i8]*))
	br label %endif_2
endif_2:
; if_3
	br %Bool 1 , label %then_3, label %else_3
then_3:
	%117 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str41 to [0 x i8]*))
	br label %endif_3
else_3:
	%118 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @str42 to [0 x i8]*))
	br label %endif_3
endif_3:

	;printf("i32 = 0x%08x (%d)\n", i32, i32)
	;printf("u32 = 0x%08x (%d)\n", u32, u32)
	ret %Int32 0
}


