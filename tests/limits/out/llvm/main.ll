
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
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
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
@str1 = private constant [19 x i8] [i8 65, i8 83, i8 83, i8 69, i8 82, i8 84, i8 32, i8 70, i8 65, i8 73, i8 76, i8 69, i8 68, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 109, i8 105, i8 110, i8 32, i8 60, i8 32, i8 48, i8 0]
@str3 = private constant [13 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 109, i8 97, i8 120, i8 32, i8 62, i8 32, i8 48, i8 0]
@str4 = private constant [10 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 115, i8 105, i8 103, i8 110, i8 0]
@str5 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 112, i8 111, i8 115, i8 105, i8 116, i8 105, i8 118, i8 101, i8 0]
@str6 = private constant [17 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 117, i8 112, i8 0]
@str7 = private constant [19 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 100, i8 111, i8 119, i8 110, i8 0]
@str8 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 49, i8 54, i8 32, i8 109, i8 105, i8 110, i8 32, i8 60, i8 32, i8 48, i8 0]
@str9 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 49, i8 54, i8 32, i8 109, i8 97, i8 120, i8 32, i8 62, i8 32, i8 48, i8 0]
@str10 = private constant [18 x i8] [i8 73, i8 110, i8 116, i8 49, i8 54, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 117, i8 112, i8 0]
@str11 = private constant [20 x i8] [i8 73, i8 110, i8 116, i8 49, i8 54, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 100, i8 111, i8 119, i8 110, i8 0]
@str12 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 109, i8 105, i8 110, i8 32, i8 60, i8 32, i8 48, i8 0]
@str13 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 109, i8 97, i8 120, i8 32, i8 62, i8 32, i8 48, i8 0]
@str14 = private constant [18 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 117, i8 112, i8 0]
@str15 = private constant [20 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 100, i8 111, i8 119, i8 110, i8 0]
@str16 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 54, i8 52, i8 32, i8 109, i8 105, i8 110, i8 32, i8 60, i8 32, i8 48, i8 0]
@str17 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 54, i8 52, i8 32, i8 109, i8 97, i8 120, i8 32, i8 62, i8 32, i8 48, i8 0]
@str18 = private constant [18 x i8] [i8 73, i8 110, i8 116, i8 54, i8 52, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 117, i8 112, i8 0]
@str19 = private constant [20 x i8] [i8 73, i8 110, i8 116, i8 54, i8 52, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 100, i8 111, i8 119, i8 110, i8 0]
@str20 = private constant [17 x i8] [i8 78, i8 97, i8 116, i8 56, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 117, i8 112, i8 0]
@str21 = private constant [18 x i8] [i8 78, i8 97, i8 116, i8 49, i8 54, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 117, i8 112, i8 0]
@str22 = private constant [18 x i8] [i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 117, i8 112, i8 0]
@str23 = private constant [18 x i8] [i8 78, i8 97, i8 116, i8 54, i8 52, i8 32, i8 111, i8 118, i8 101, i8 114, i8 102, i8 108, i8 111, i8 119, i8 32, i8 117, i8 112, i8 0]
@str24 = private constant [17 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 112, i8 111, i8 115, i8 105, i8 116, i8 105, i8 118, i8 101, i8 0]
@str25 = private constant [17 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 110, i8 101, i8 103, i8 97, i8 116, i8 105, i8 118, i8 101, i8 0]
@str26 = private constant [17 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 100, i8 105, i8 118, i8 105, i8 115, i8 105, i8 111, i8 110, i8 0]
@str27 = private constant [13 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 43, i8 105, i8 110, i8 102, i8 0]
@str28 = private constant [12 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 78, i8 97, i8 78, i8 0]
@str29 = private constant [13 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 54, i8 52, i8 32, i8 43, i8 105, i8 110, i8 102, i8 0]
@str30 = private constant [12 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 54, i8 52, i8 32, i8 78, i8 97, i8 78, i8 0]
@str31 = private constant [35 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 56, i8 77, i8 97, i8 120, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 95, i8 110, i8 97, i8 116, i8 56, i8 77, i8 105, i8 110, i8 10, i8 0]
@str32 = private constant [36 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 56, i8 77, i8 105, i8 110, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 95, i8 110, i8 97, i8 116, i8 56, i8 77, i8 97, i8 120, i8 10, i8 0]
@str33 = private constant [19 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 78, i8 97, i8 116, i8 56, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str34 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 95, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 10, i8 0]
@str35 = private constant [38 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 105, i8 110, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 95, i8 110, i8 97, i8 116, i8 49, i8 54, i8 77, i8 97, i8 120, i8 10, i8 0]
@str36 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 78, i8 97, i8 116, i8 49, i8 54, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str37 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 95, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 10, i8 0]
@str38 = private constant [38 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 105, i8 110, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 95, i8 110, i8 97, i8 116, i8 51, i8 50, i8 77, i8 97, i8 120, i8 10, i8 0]
@str39 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str40 = private constant [37 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 95, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 10, i8 0]
@str41 = private constant [38 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 105, i8 110, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 33, i8 61, i8 32, i8 95, i8 110, i8 97, i8 116, i8 54, i8 52, i8 77, i8 97, i8 120, i8 10, i8 0]
@str42 = private constant [20 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 78, i8 97, i8 116, i8 54, i8 52, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str43 = private constant [24 x i8] [i8 110, i8 117, i8 109, i8 101, i8 114, i8 105, i8 99, i8 32, i8 98, i8 111, i8 117, i8 110, i8 100, i8 97, i8 114, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 115, i8 10, i8 0]
@str44 = private constant [23 x i8] [i8 110, i8 97, i8 116, i8 56, i8 77, i8 97, i8 120, i8 80, i8 108, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str45 = private constant [24 x i8] [i8 110, i8 97, i8 116, i8 56, i8 77, i8 105, i8 110, i8 77, i8 105, i8 110, i8 117, i8 115, i8 79, i8 110, i8 101, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str46 = private constant [4 x i8] [i8 79, i8 75, i8 10, i8 0]
; -- endstrings --


;const float32Max       = Float32 3.4028234663852886e+38
;const float32MinNormal = Float32 1.1754943508222875e-38
;const float32MinSub    = Float32 1.401298464324817e-45
;const float32Epsilon   = Float32 1.1920928955078125e-7
;
;const float32PosInf    = Float32 1.0 / 0.0
;const float32NaN       = Float32 0.0 / 0.0
;const float32NegInf    = Float32 -1.0 / 0.0
;
;const float64PosInf    = Float64 1.0 / 0.0
;const float64NaN       = Float64 0.0 / 0.0
;const float64NegInf    = Float64 -1.0 / 0.0
define internal void @assert(%Bool %cond, %Str8* %msg) {
; if_0
	%1 = xor %Bool %cond, 1
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*), %Str8* %msg)
	call void @abort()
	br label %endif_0
endif_0:
	ret void
}



; ------------------------------------------------------------
; Signed integers
; ------------------------------------------------------------
define internal void @testInt8() {
	%1 = sub i8 0, 128
	call void @assert(%Bool 1, %Str8* bitcast ([13 x i8]* @str2 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([13 x i8]* @str3 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([10 x i8]* @str4 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([14 x i8]* @str5 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([17 x i8]* @str6 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([19 x i8]* @str7 to [0 x i8]*))
	ret void
}

define internal void @testInt16() {
	%1 = sub i16 0, 32768
	call void @assert(%Bool 1, %Str8* bitcast ([14 x i8]* @str8 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([14 x i8]* @str9 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([18 x i8]* @str10 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([20 x i8]* @str11 to [0 x i8]*))
	ret void
}

define internal void @testInt32() {
	%1 = sub i32 0, 2147483648
	call void @assert(%Bool 1, %Str8* bitcast ([14 x i8]* @str12 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([14 x i8]* @str13 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([18 x i8]* @str14 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([20 x i8]* @str15 to [0 x i8]*))
	ret void
}

define internal void @testInt64() {
	%1 = sub i64 0, 9223372036854775808
	call void @assert(%Bool 1, %Str8* bitcast ([14 x i8]* @str16 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([14 x i8]* @str17 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([18 x i8]* @str18 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([20 x i8]* @str19 to [0 x i8]*))
	ret void
}



; ------------------------------------------------------------
; Unsigned integers
; ------------------------------------------------------------
define internal void @testNat8() {
	call void @assert(%Bool 1, %Str8* bitcast ([17 x i8]* @str20 to [0 x i8]*))
	ret void
}

define internal void @testNat16() {
	call void @assert(%Bool 1, %Str8* bitcast ([18 x i8]* @str21 to [0 x i8]*))
	ret void
}

define internal void @testNat32() {
	call void @assert(%Bool 1, %Str8* bitcast ([18 x i8]* @str22 to [0 x i8]*))
	ret void
}

define internal void @testNat64() {
	call void @assert(%Bool 1, %Str8* bitcast ([18 x i8]* @str23 to [0 x i8]*))
	ret void
}



; ------------------------------------------------------------
; Float32
; ------------------------------------------------------------
define internal void @testFloat32() {
	call void @assert(%Bool 1, %Str8* bitcast ([17 x i8]* @str24 to [0 x i8]*))
	call void @assert(%Bool 1, %Str8* bitcast ([17 x i8]* @str25 to [0 x i8]*))

	; Проверка деления
	call void @assert(%Bool 1, %Str8* bitcast ([17 x i8]* @str26 to [0 x i8]*))

	; Infinity
	call void @assert(%Bool 1, %Str8* bitcast ([13 x i8]* @str27 to [0 x i8]*))

	; NaN
	%1 = xor %Bool 0, 1
	call void @assert(%Bool %1, %Str8* bitcast ([12 x i8]* @str28 to [0 x i8]*))
	ret void
}



; ------------------------------------------------------------
; Float64
; ------------------------------------------------------------
define internal void @testFloat64() {
	call void @assert(%Bool 1, %Str8* bitcast ([13 x i8]* @str29 to [0 x i8]*))
	%1 = xor %Bool 0, 1
	call void @assert(%Bool %1, %Str8* bitcast ([12 x i8]* @str30 to [0 x i8]*))
	ret void
}



; ------------------------------------------------------------
; Entry
; ------------------------------------------------------------
define internal %Bool @testNat8Static() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @str31 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([36 x i8]* @str32 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str33 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testNat16Static() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str34 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str35 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str36 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testNat32Static() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str37 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str38 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str39 to [0 x i8]*))
	ret %Bool 1
}

define internal %Bool @testNat64Static() {
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str40 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str41 to [0 x i8]*))
	ret %Bool 0
	br label %endif_1
endif_1:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str42 to [0 x i8]*))
	ret %Bool 1
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str43 to [0 x i8]*))
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str44 to [0 x i8]*), %Nat64 0)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str45 to [0 x i8]*), %Nat64 255)
	%4 = call %Bool @testNat8Static()
	%5 = call %Bool @testNat16Static()
	%6 = call %Bool @testNat32Static()
	%7 = call %Bool @testNat64Static()
	;	printf("cC = %llu\n", Nat64 cC)
	;	printf("dD = %lli\n", Nat64 dD)

	;
	;	let f = 3.1415926535897932384626433832795028841971693993751058209749445923
	;	var f32 = Float32 f
	;	var f64 = Float64 f
	;
	;	printf("f32 = %.9g\n", f32)
	;	printf("f64 = %.17g\n", f64)
	;
	;//	if f32 == 3.14 {
	;//		printf("ok1\n")
	;//	}
	;
	;	if f64 == 3.1415926535897931 {
	;		printf("ok2\n")
	;	}

	;	let n8 = Nat8 (_nat8Max + 1)
	;	printf("n8 = %i\n", Word32 n8)
	;
	;	let n16 = Nat16 (_nat16Max + 1)
	;	printf("n16 = %u\n", Word32 n16)
	;
	;	let n32 = Nat32 (_nat32Max + 1)
	;	printf("n32 = %u\n", Word32 n32)
	;
	;	let n64 = Nat64 (_nat64Max + 1)
	;	printf("n64 = %llu\n", Word64 n64)


	;	let i8 = Nat8 (127 + 1)
	;	printf("i8 = %i\n", i8)
	call void @testInt8()
	call void @testInt16()
	call void @testInt32()
	call void @testInt64()
	call void @testNat8()
	call void @testNat16()
	call void @testNat32()
	call void @testNat64()
	call void @testFloat32()
	call void @testFloat64()
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str46 to [0 x i8]*))
	ret %Int32 0
}


