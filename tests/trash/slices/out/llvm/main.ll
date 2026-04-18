
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
; -- end print includes --
; -- print imports private 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports private 'main' --
; -- print imports public 'main' --
; -- end print imports public 'main' --
; -- strings --
@str1 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [15 x i8] [i8 99, i8 104, i8 101, i8 99, i8 107, i8 80, i8 97, i8 114, i8 97, i8 109, i8 115, i8 73, i8 111, i8 10, i8 0]
@str3 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 115, i8 10, i8 0]
@str4 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 115, i8 49, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str7 = private constant [13 x i8] [i8 115, i8 50, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str9 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str11 = private constant [12 x i8] [i8 115, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str12 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str13 = private constant [23 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 32, i8 116, i8 111, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 10, i8 0]
@str14 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str15 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str16 = private constant [32 x i8] [i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 111, i8 102, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 32, i8 116, i8 111, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 10, i8 0]
@str17 = private constant [8 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 10, i8 0]
@str18 = private constant [7 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 10, i8 0]
@str19 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str20 = private constant [19 x i8] [i8 122, i8 101, i8 114, i8 111, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 98, i8 121, i8 32, i8 118, i8 97, i8 114, i8 10, i8 0]
@str21 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str22 = private constant [19 x i8] [i8 99, i8 111, i8 112, i8 121, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 98, i8 121, i8 32, i8 118, i8 97, i8 114, i8 10, i8 0]
; -- endstrings --
define internal void @array_print([0 x %Int32]* %pa, %Nat32 %len) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ult %Nat32 %2, %len
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat32, %Nat32* %1
	%5 = load %Nat32, %Nat32* %1
	%6 = bitcast %Nat32 %5 to %Nat32
	%7 = getelementptr [0 x %Int32], [0 x %Int32]* %pa, %Int32 0, %Nat32 %6
	%8 = load %Int32, %Int32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*), %Nat32 %4, %Int32 %8)
	%10 = load %Nat32, %Nat32* %1
	%11 = add %Nat32 %10, 1
	store %Nat32 %11, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

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
; -- cons_composite_from_composite_by_value --
	%31 = alloca [4 x %Int32]
	%32 = zext i8 4 to %Nat32
	store [4 x %Int32] %30, [4 x %Int32]* %31
	%33 = bitcast [4 x %Int32]* %31 to [4 x %Int32]*
; -- end cons_composite_from_composite_by_value --
	%34 = load [4 x %Int32], [4 x %Int32]* %33
	%35 = zext i8 4 to %Nat32
	store [4 x %Int32] %34, [4 x %Int32]* %0
	ret void
}

define internal void @checkParamsIo() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*))
	%2 = alloca [8 x %Int32], align 4
	%3 = insertvalue [8 x %Int32] zeroinitializer, %Int32 1, 1
	%4 = insertvalue [8 x %Int32] %3, %Int32 2, 2
	%5 = insertvalue [8 x %Int32] %4, %Int32 3, 3
	%6 = insertvalue [8 x %Int32] %5, %Int32 4, 4
	%7 = insertvalue [8 x %Int32] %6, %Int32 5, 5
	%8 = insertvalue [8 x %Int32] %7, %Int32 6, 6
	%9 = insertvalue [8 x %Int32] %8, %Int32 7, 7
	%10 = zext i8 8 to %Nat32
	store [8 x %Int32] %9, [8 x %Int32]* %2
	%11 = zext i8 0 to %Nat32
	%12 = getelementptr [8 x %Int32], [8 x %Int32]* %2, %Int32 0, %Nat32 %11
	%13 = bitcast %Int32* %12 to [4 x %Int32]*
	%14 = zext i8 0 to %Nat32
	%15 = getelementptr [8 x %Int32], [8 x %Int32]* %2, %Int32 0, %Nat32 %14
	%16 = bitcast %Int32* %15 to [4 x %Int32]*
	%17 = load [4 x %Int32], [4 x %Int32]* %16; alloca memory for return value
	%18 = alloca [4 x %Int32]
	call void @array4intInc([4 x %Int32]* %18, [4 x %Int32] %17)
	%19 = load [4 x %Int32], [4 x %Int32]* %18
	%20 = zext i8 4 to %Nat32
	store [4 x %Int32] %19, [4 x %Int32]* %13
	%21 = zext i8 4 to %Nat32
	%22 = getelementptr [8 x %Int32], [8 x %Int32]* %2, %Int32 0, %Nat32 %21
	%23 = bitcast %Int32* %22 to [4 x %Int32]*
	%24 = zext i8 4 to %Nat32
	%25 = getelementptr [8 x %Int32], [8 x %Int32]* %2, %Int32 0, %Nat32 %24
	%26 = bitcast %Int32* %25 to [4 x %Int32]*
	%27 = load [4 x %Int32], [4 x %Int32]* %26; alloca memory for return value
	%28 = alloca [4 x %Int32]
	call void @array4intInc([4 x %Int32]* %28, [4 x %Int32] %27)
	%29 = load [4 x %Int32], [4 x %Int32]* %28
	%30 = zext i8 4 to %Nat32
	store [4 x %Int32] %29, [4 x %Int32]* %23
	%31 = bitcast [8 x %Int32]* %2 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %31, %Nat32 8)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*))
	call void @checkParamsIo()
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str4 to [0 x i8]*))
	%3 = alloca [10 x %Int32], align 4
	%4 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%5 = insertvalue [10 x %Int32] %4, %Int32 2, 2
	%6 = insertvalue [10 x %Int32] %5, %Int32 3, 3
	%7 = insertvalue [10 x %Int32] %6, %Int32 4, 4
	%8 = insertvalue [10 x %Int32] %7, %Int32 5, 5
	%9 = insertvalue [10 x %Int32] %8, %Int32 6, 6
	%10 = insertvalue [10 x %Int32] %9, %Int32 7, 7
	%11 = insertvalue [10 x %Int32] %10, %Int32 8, 8
	%12 = insertvalue [10 x %Int32] %11, %Int32 9, 9
	%13 = zext i8 10 to %Nat32
	store [10 x %Int32] %12, [10 x %Int32]* %3
	%14 = zext i8 1 to %Nat32
	%15 = getelementptr [10 x %Int32], [10 x %Int32]* %3, %Int32 0, %Nat32 %14
	%16 = bitcast %Int32* %15 to [1 x %Int32]*
	%17 = load [1 x %Int32], [1 x %Int32]* %16
	%18 = alloca [1 x %Int32]
	%19 = zext i8 1 to %Nat32
	store [1 x %Int32] %17, [1 x %Int32]* %18
	%20 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %20
; while_1
	br label %again_1
again_1:
	%21 = load %Nat32, %Nat32* %20
	%22 = icmp ult %Nat32 %21, 1
	br %Bool %22 , label %body_1, label %break_1
body_1:
	%23 = load %Nat32, %Nat32* %20
	%24 = load %Nat32, %Nat32* %20
	%25 = bitcast %Nat32 %24 to %Nat32
	%26 = getelementptr [1 x %Int32], [1 x %Int32]* %18, %Int32 0, %Nat32 %25
	%27 = load %Int32, %Int32* %26
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), %Nat32 %23, %Int32 %27)
	%29 = load %Nat32, %Nat32* %20
	%30 = add %Nat32 %29, 1
	store %Nat32 %30, %Nat32* %20
	br label %again_1
break_1:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str6 to [0 x i8]*))
	%32 = zext i8 5 to %Nat32
	%33 = getelementptr [10 x %Int32], [10 x %Int32]* %3, %Int32 0, %Nat32 %32
;
	%34 = bitcast %Int32* %33 to [3 x %Int32]*
	%35 = load [3 x %Int32], [3 x %Int32]* %34
	%36 = alloca [3 x %Int32]
	%37 = zext i8 3 to %Nat32
	store [3 x %Int32] %35, [3 x %Int32]* %36
	store %Nat32 0, %Nat32* %20
; while_2
	br label %again_2
again_2:
	%38 = load %Nat32, %Nat32* %20
	%39 = icmp ult %Nat32 %38, 3
	br %Bool %39 , label %body_2, label %break_2
body_2:
	%40 = load %Nat32, %Nat32* %20
	%41 = load %Nat32, %Nat32* %20
	%42 = bitcast %Nat32 %41 to %Nat32
	%43 = getelementptr [3 x %Int32], [3 x %Int32]* %36, %Int32 0, %Nat32 %42
	%44 = load %Int32, %Int32* %43
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str7 to [0 x i8]*), %Nat32 %40, %Int32 %44)
	%46 = load %Nat32, %Nat32* %20
	%47 = add %Nat32 %46, 1
	store %Nat32 %47, %Nat32* %20
	br label %again_2
break_2:
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str8 to [0 x i8]*))
	%49 = alloca [1 x %Int32], align 4
	%50 = load [1 x %Int32], [1 x %Int32]* %18
	%51 = zext i8 1 to %Nat32
	store [1 x %Int32] %50, [1 x %Int32]* %49
	%52 = alloca [3 x %Int32], align 4
	%53 = load [3 x %Int32], [3 x %Int32]* %36
	%54 = zext i8 3 to %Nat32
	store [3 x %Int32] %53, [3 x %Int32]* %52
	%55 = zext i8 2 to %Nat32
	%56 = getelementptr [10 x %Int32], [10 x %Int32]* %3, %Int32 0, %Nat32 %55
	%57 = bitcast %Int32* %56 to [4 x %Int32]*
	%58 = insertvalue [4 x %Int32] zeroinitializer, %Int32 10, 0
	%59 = insertvalue [4 x %Int32] %58, %Int32 20, 1
	%60 = insertvalue [4 x %Int32] %59, %Int32 30, 2
	%61 = insertvalue [4 x %Int32] %60, %Int32 40, 3
	%62 = zext i8 4 to %Nat32
	store [4 x %Int32] %61, [4 x %Int32]* %57
	store %Nat32 0, %Nat32* %20
; while_3
	br label %again_3
again_3:
	%63 = load %Nat32, %Nat32* %20
	%64 = icmp ult %Nat32 %63, 10
	br %Bool %64 , label %body_3, label %break_3
body_3:
	%65 = load %Nat32, %Nat32* %20
	%66 = load %Nat32, %Nat32* %20
	%67 = bitcast %Nat32 %66 to %Nat32
	%68 = getelementptr [10 x %Int32], [10 x %Int32]* %3, %Int32 0, %Nat32 %67
	%69 = load %Int32, %Int32* %68
	%70 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str9 to [0 x i8]*), %Nat32 %65, %Int32 %69)
	%71 = load %Nat32, %Nat32* %20
	%72 = add %Nat32 %71, 1
	store %Nat32 %72, %Nat32* %20
	br label %again_3
break_3:
	%73 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str10 to [0 x i8]*))
	%74 = alloca [10 x %Int32], align 1
	%75 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 0
	%76 = insertvalue [10 x %Int32] %75, %Int32 20, 1
	%77 = insertvalue [10 x %Int32] %76, %Int32 30, 2
	%78 = insertvalue [10 x %Int32] %77, %Int32 40, 3
	%79 = insertvalue [10 x %Int32] %78, %Int32 50, 4
	%80 = insertvalue [10 x %Int32] %79, %Int32 60, 5
	%81 = insertvalue [10 x %Int32] %80, %Int32 70, 6
	%82 = insertvalue [10 x %Int32] %81, %Int32 80, 7
	%83 = insertvalue [10 x %Int32] %82, %Int32 90, 8
	%84 = insertvalue [10 x %Int32] %83, %Int32 100, 9
	%85 = zext i8 10 to %Nat32
	store [10 x %Int32] %84, [10 x %Int32]* %74
	%86 = zext i8 2 to %Nat32
	%87 = getelementptr [10 x %Int32], [10 x %Int32]* %74, %Int32 0, %Nat32 %86
	%88 = bitcast %Int32* %87 to [3 x %Int32]*
	%89 = zext i8 3 to %Nat32
	%90 = mul %Nat32 %89, 4
	%91 = bitcast [3 x %Int32]* %88 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %91, i8 0, %Nat32 %90, i1 0)
	store %Nat32 0, %Nat32* %20
; while_4
	br label %again_4
again_4:
	%92 = load %Nat32, %Nat32* %20
	%93 = icmp ult %Nat32 %92, 10
	br %Bool %93 , label %body_4, label %break_4
body_4:
	%94 = load %Nat32, %Nat32* %20
	%95 = load %Nat32, %Nat32* %20
	%96 = bitcast %Nat32 %95 to %Nat32
	%97 = getelementptr [10 x %Int32], [10 x %Int32]* %74, %Int32 0, %Nat32 %96
	%98 = load %Int32, %Int32* %97
	%99 = bitcast %Int32 %98 to %Nat32
	%100 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str11 to [0 x i8]*), %Nat32 %94, %Nat32 %99)
	%101 = load %Nat32, %Nat32* %20
	%102 = add %Nat32 %101, 1
	store %Nat32 %102, %Nat32* %20
	br label %again_4
break_4:
	%103 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str12 to [0 x i8]*))
	%104 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str13 to [0 x i8]*))
	%105 = zext i8 2 to %Nat32
	%106 = getelementptr [10 x %Int32], [10 x %Int32]* %74, %Int32 0, %Nat32 %105
	%107 = bitcast %Int32* %106 to [6 x %Int32]*
	%108 = bitcast [6 x %Int32]* %107 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %108, %Nat32 6)
	%109 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str14 to [0 x i8]*))
	%110 = getelementptr [6 x %Int32], [6 x %Int32]* %107, %Int32 0, %Int32 0
	store %Int32 123, %Int32* %110
	%111 = bitcast [6 x %Int32]* %107 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %111, %Nat32 6)
	%112 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str15 to [0 x i8]*))
	%113 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @str16 to [0 x i8]*))
	%114 = alloca [0 x %Int32]*, align 8
	%115 = bitcast [10 x %Int32]* %74 to [0 x %Int32]*
	store [0 x %Int32]* %115, [0 x %Int32]** %114
	%116 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str17 to [0 x i8]*))
	%117 = load [0 x %Int32]*, [0 x %Int32]** %114
	call void @array_print([0 x %Int32]* %117, %Nat32 10)
	%118 = alloca %Int32, align 4
	store %Int32 1, %Int32* %118
	%119 = load [0 x %Int32]*, [0 x %Int32]** %114
	%120 = load %Int32, %Int32* %118
	%121 = getelementptr [0 x %Int32], [0 x %Int32]* %119, %Int32 0, %Int32 %120
;
	%122 = bitcast %Int32* %121 to [0 x %Int32]*
	store [0 x %Int32]* %122, [0 x %Int32]** %114
	%123 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str18 to [0 x i8]*))
	%124 = load [0 x %Int32]*, [0 x %Int32]** %114
	call void @array_print([0 x %Int32]* %124, %Nat32 10)
	%125 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str19 to [0 x i8]*))
	%126 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str20 to [0 x i8]*))
	%127 = alloca [10 x %Int32], align 1
	%128 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%129 = insertvalue [10 x %Int32] %128, %Int32 2, 2
	%130 = insertvalue [10 x %Int32] %129, %Int32 3, 3
	%131 = insertvalue [10 x %Int32] %130, %Int32 4, 4
	%132 = insertvalue [10 x %Int32] %131, %Int32 5, 5
	%133 = insertvalue [10 x %Int32] %132, %Int32 6, 6
	%134 = insertvalue [10 x %Int32] %133, %Int32 7, 7
	%135 = insertvalue [10 x %Int32] %134, %Int32 8, 8
	%136 = insertvalue [10 x %Int32] %135, %Int32 9, 9
	%137 = zext i8 10 to %Nat32
	store [10 x %Int32] %136, [10 x %Int32]* %127
	%138 = alloca %Int32, align 4
	store %Int32 4, %Int32* %138
	%139 = alloca %Int32, align 4
	store %Int32 7, %Int32* %139
	%140 = load %Int32, %Int32* %138
	%141 = getelementptr [10 x %Int32], [10 x %Int32]* %127, %Int32 0, %Int32 %140
	%142 = bitcast %Int32* %141 to [0 x %Int32]*
	%143 = load %Int32, %Int32* %139
	%144 = load %Int32, %Int32* %138
	%145 = sub %Int32 %143, %144
	%146 = mul %Int32 %145, 4
	%147 = bitcast [0 x %Int32]* %142 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %147, i8 0, %Int32 %146, i1 0)
	%148 = bitcast [10 x %Int32]* %127 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %148, %Nat32 10)
	%149 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str21 to [0 x i8]*))
	%150 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str22 to [0 x i8]*))
	%151 = alloca [5 x %Int32], align 1
	%152 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%153 = insertvalue [5 x %Int32] %152, %Int32 20, 1
	%154 = insertvalue [5 x %Int32] %153, %Int32 30, 2
	%155 = insertvalue [5 x %Int32] %154, %Int32 40, 3
	%156 = insertvalue [5 x %Int32] %155, %Int32 50, 4
	%157 = zext i8 5 to %Nat32
	store [5 x %Int32] %156, [5 x %Int32]* %151
	%158 = alloca [10 x %Int32], align 1
	%159 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%160 = insertvalue [10 x %Int32] %159, %Int32 2, 2
	%161 = insertvalue [10 x %Int32] %160, %Int32 3, 3
	%162 = insertvalue [10 x %Int32] %161, %Int32 4, 4
	%163 = insertvalue [10 x %Int32] %162, %Int32 5, 5
	%164 = insertvalue [10 x %Int32] %163, %Int32 6, 6
	%165 = insertvalue [10 x %Int32] %164, %Int32 7, 7
	%166 = insertvalue [10 x %Int32] %165, %Int32 8, 8
	%167 = insertvalue [10 x %Int32] %166, %Int32 9, 9
	%168 = zext i8 10 to %Nat32
	store [10 x %Int32] %167, [10 x %Int32]* %158
	%169 = zext i8 3 to %Nat32
	%170 = getelementptr [10 x %Int32], [10 x %Int32]* %158, %Int32 0, %Nat32 %169
	%171 = bitcast %Int32* %170 to [5 x %Int32]*
	%172 = insertvalue [5 x %Int32] zeroinitializer, %Int32 11, 0
	%173 = insertvalue [5 x %Int32] %172, %Int32 22, 1
	%174 = insertvalue [5 x %Int32] %173, %Int32 33, 2
	%175 = insertvalue [5 x %Int32] %174, %Int32 44, 3
	%176 = insertvalue [5 x %Int32] %175, %Int32 55, 4
	%177 = zext i8 5 to %Nat32
	store [5 x %Int32] %176, [5 x %Int32]* %171
	%178 = bitcast [10 x %Int32]* %158 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %178, %Nat32 10)
	ret %Int 0
}


