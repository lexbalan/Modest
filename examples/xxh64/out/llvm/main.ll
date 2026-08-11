
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
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [54 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 100, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 58, i8 32, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 88, i8 37, i8 48, i8 56, i8 88, i8 44, i8 32, i8 103, i8 111, i8 116, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 88, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]
@.str2 = private constant [29 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 100, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 58, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 88, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]
@.str3 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 88, i8 88, i8 72, i8 54, i8 52, i8 10, i8 0]
@.str4 = private constant [15 x i8] [i8 88, i8 88, i8 72, i8 54, i8 52, i8 58, i8 32, i8 70, i8 65, i8 73, i8 76, i8 69, i8 68, i8 10, i8 0]
@.str5 = private constant [36 x i8] [i8 88, i8 88, i8 72, i8 54, i8 52, i8 32, i8 114, i8 101, i8 102, i8 101, i8 114, i8 101, i8 110, i8 99, i8 101, i8 32, i8 105, i8 109, i8 112, i8 108, i8 101, i8 109, i8 101, i8 110, i8 116, i8 97, i8 116, i8 105, i8 111, i8 110, i8 58, i8 32, i8 79, i8 75, i8 10, i8 0]
; -- endstrings --

; thx: https://github.com/Cyan4973/xxHash
;
; Арифметика хэша — по модулю 2^64 (обёртка), поэтому значения живут
; в Word64 (битовые операции), а сложение/умножение делаются через Nat64.


; wrapping-арифметика над Word64
define internal %Word64 @add(%Word64 %a, %Word64 %b) alwaysinline {
	%1 = bitcast %Word64 %a to %Nat64
	%2 = bitcast %Word64 %b to %Nat64
	%3 = add %Nat64 %1, %2
	%4 = bitcast %Nat64 %3 to %Word64
	ret %Word64 %4
}

define internal %Word64 @sub(%Word64 %a, %Word64 %b) alwaysinline {
	%1 = bitcast %Word64 %a to %Nat64
	%2 = bitcast %Word64 %b to %Nat64
	%3 = sub %Nat64 %1, %2
	%4 = bitcast %Nat64 %3 to %Word64
	ret %Word64 %4
}

define internal %Word64 @mul(%Word64 %a, %Word64 %b) alwaysinline {
	%1 = bitcast %Word64 %a to %Nat64
	%2 = bitcast %Word64 %b to %Nat64
	%3 = mul %Nat64 %1, %2
	%4 = bitcast %Nat64 %3 to %Word64
	ret %Word64 %4
}

define internal %Word64 @rotl64(%Word64 %value, %Nat32 %amt) alwaysinline {
	%1 = urem %Nat32 %amt, 64
	%2 = zext %Nat32 %1 to %Word64
	%3 = shl %Word64 %value, %2
	%4 = urem %Nat32 %amt, 64
	%5 = sub %Nat32 64, %4
	%6 = zext %Nat32 %5 to %Word64
	%7 = lshr %Word64 %value, %6
	%8 = or %Word64 %3, %7
	ret %Word64 %8
}

define internal %Word64 @read32([0 x %Word8]* %data, %SizeT %offset) {
	%1 = alloca %Word64, align 8
	%2 = zext i8 0 to %Word64
	store %Word64 %2, %Word64* %1
	%3 = alloca %SizeT, align 8
	store %SizeT 0, %SizeT* %3
; while_1
	br label %again_1
again_1:
	%4 = load %SizeT, %SizeT* %3
	%5 = icmp ult %SizeT %4, 4
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %SizeT, %SizeT* %3
	%7 = add %SizeT %offset, %6
	%8 = trunc %SizeT %7 to %Nat32
	%9 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Nat32 %8
	%10 = load %Word8, %Word8* %9
	%11 = zext %Word8 %10 to %Word64
	%12 = load %SizeT, %SizeT* %3
	%13 = mul %SizeT %12, 8
	%14 = bitcast %SizeT %13 to %Word64
	%15 = shl %Word64 %11, %14
	%16 = load %Word64, %Word64* %1
	%17 = or %Word64 %16, %15
	store %Word64 %17, %Word64* %1
	%18 = load %SizeT, %SizeT* %3
	%19 = add %SizeT %18, 1
	store %SizeT %19, %SizeT* %3
	br label %again_1
break_1:
	%20 = load %Word64, %Word64* %1
	ret %Word64 %20
}

define internal %Word64 @read64([0 x %Word8]* %data, %SizeT %offset) {
	%1 = alloca %Word64, align 8
	%2 = zext i8 0 to %Word64
	store %Word64 %2, %Word64* %1
	%3 = alloca %SizeT, align 8
	store %SizeT 0, %SizeT* %3
; while_1
	br label %again_1
again_1:
	%4 = load %SizeT, %SizeT* %3
	%5 = icmp ult %SizeT %4, 8
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %SizeT, %SizeT* %3
	%7 = add %SizeT %offset, %6
	%8 = trunc %SizeT %7 to %Nat32
	%9 = getelementptr [0 x %Word8], [0 x %Word8]* %data, %Int32 0, %Nat32 %8
	%10 = load %Word8, %Word8* %9
	%11 = zext %Word8 %10 to %Word64
	%12 = load %SizeT, %SizeT* %3
	%13 = mul %SizeT %12, 8
	%14 = bitcast %SizeT %13 to %Word64
	%15 = shl %Word64 %11, %14
	%16 = load %Word64, %Word64* %1
	%17 = or %Word64 %16, %15
	store %Word64 %17, %Word64* %1
	%18 = load %SizeT, %SizeT* %3
	%19 = add %SizeT %18, 1
	store %SizeT %19, %SizeT* %3
	br label %again_1
break_1:
	%20 = load %Word64, %Word64* %1
	ret %Word64 %20
}

define internal %Word64 @round(%Word64 %acc, %Word64 %input) {
	%1 = alloca %Word64, align 8
	%2 = bitcast i64 14029467366897019727 to %Word64
	%3 = call %Word64 @mul(%Word64 %input, %Word64 %2)
	%4 = call %Word64 @add(%Word64 %acc, %Word64 %3)
	store %Word64 %4, %Word64* %1
	%5 = load %Word64, %Word64* %1
	%6 = call %Word64 @rotl64(%Word64 %5, %Nat32 31)
	store %Word64 %6, %Word64* %1
	%7 = load %Word64, %Word64* %1
	%8 = bitcast i64 11400714785074694791 to %Word64
	%9 = call %Word64 @mul(%Word64 %7, %Word64 %8)
	ret %Word64 %9
}

define internal %Word64 @mergeRound(%Word64 %hash, %Word64 %acc) {
	%1 = alloca %Word64, align 8
	%2 = zext i8 0 to %Word64
	%3 = call %Word64 @round(%Word64 %2, %Word64 %acc)
	%4 = xor %Word64 %hash, %3
	store %Word64 %4, %Word64* %1
	%5 = load %Word64, %Word64* %1
	%6 = bitcast i64 11400714785074694791 to %Word64
	%7 = call %Word64 @mul(%Word64 %5, %Word64 %6)
	store %Word64 %7, %Word64* %1
	%8 = load %Word64, %Word64* %1
	%9 = bitcast i64 9650029242287828579 to %Word64
	%10 = call %Word64 @add(%Word64 %8, %Word64 %9)
	ret %Word64 %10
}

define internal %Word64 @avalanche(%Word64 %hash) {
	%1 = alloca %Word64, align 8
	store %Word64 %hash, %Word64* %1
	%2 = load %Word64, %Word64* %1
	%3 = zext i8 33 to %Word64
	%4 = lshr %Word64 %2, %3
	%5 = load %Word64, %Word64* %1
	%6 = xor %Word64 %5, %4
	store %Word64 %6, %Word64* %1
	%7 = load %Word64, %Word64* %1
	%8 = bitcast i64 14029467366897019727 to %Word64
	%9 = call %Word64 @mul(%Word64 %7, %Word64 %8)
	store %Word64 %9, %Word64* %1
	%10 = load %Word64, %Word64* %1
	%11 = zext i8 29 to %Word64
	%12 = lshr %Word64 %10, %11
	%13 = load %Word64, %Word64* %1
	%14 = xor %Word64 %13, %12
	store %Word64 %14, %Word64* %1
	%15 = load %Word64, %Word64* %1
	%16 = bitcast i64 1609587929392839161 to %Word64
	%17 = call %Word64 @mul(%Word64 %15, %Word64 %16)
	store %Word64 %17, %Word64* %1
	%18 = load %Word64, %Word64* %1
	%19 = zext i8 32 to %Word64
	%20 = lshr %Word64 %18, %19
	%21 = load %Word64, %Word64* %1
	%22 = xor %Word64 %21, %20
	store %Word64 %22, %Word64* %1
	%23 = load %Word64, %Word64* %1
	ret %Word64 %23
}

define internal %Word64 @xxh64([0 x %Word8]* %input, %SizeT %length, %Word64 %seed) {
	%1 = alloca %Word64, align 8
	%2 = zext i8 0 to %Word64
	store %Word64 %2, %Word64* %1
	%3 = alloca %SizeT, align 8
	store %SizeT %length, %SizeT* %3
	%4 = alloca %SizeT, align 8
	store %SizeT 0, %SizeT* %4
; if_0
	%5 = icmp eq [0 x %Word8]* %input, null
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	%6 = bitcast i64 2870177450012600261 to %Word64
	%7 = call %Word64 @add(%Word64 %seed, %Word64 %6)
	%8 = call %Word64 @avalanche(%Word64 %7)
	ret %Word64 %8
	br label %endif_0
endif_0:
; if_1
	%10 = load %SizeT, %SizeT* %3
	%11 = icmp uge %SizeT %10, 32
	br %Bool %11 , label %then_1, label %else_1
then_1:
	%12 = alloca %Word64, align 8
	%13 = bitcast i64 11400714785074694791 to %Word64
	%14 = call %Word64 @add(%Word64 %seed, %Word64 %13)
	%15 = bitcast i64 14029467366897019727 to %Word64
	%16 = call %Word64 @add(%Word64 %14, %Word64 %15)
	store %Word64 %16, %Word64* %12
	%17 = alloca %Word64, align 8
	%18 = bitcast i64 14029467366897019727 to %Word64
	%19 = call %Word64 @add(%Word64 %seed, %Word64 %18)
	store %Word64 %19, %Word64* %17
	%20 = alloca %Word64, align 8
	store %Word64 %seed, %Word64* %20
	%21 = alloca %Word64, align 8
	%22 = bitcast i64 11400714785074694791 to %Word64
	%23 = call %Word64 @sub(%Word64 %seed, %Word64 %22)
	store %Word64 %23, %Word64* %21
; while_1
	br label %again_1
again_1:
	%24 = load %SizeT, %SizeT* %3
	%25 = icmp uge %SizeT %24, 32
	br %Bool %25 , label %body_1, label %break_1
body_1:
	%26 = load %Word64, %Word64* %12
	%27 = load %SizeT, %SizeT* %4
	%28 = call %Word64 @read64([0 x %Word8]* %input, %SizeT %27)
	%29 = call %Word64 @round(%Word64 %26, %Word64 %28)
	store %Word64 %29, %Word64* %12
	%30 = load %SizeT, %SizeT* %4
	%31 = add %SizeT %30, 8
	store %SizeT %31, %SizeT* %4
	%32 = load %Word64, %Word64* %17
	%33 = load %SizeT, %SizeT* %4
	%34 = call %Word64 @read64([0 x %Word8]* %input, %SizeT %33)
	%35 = call %Word64 @round(%Word64 %32, %Word64 %34)
	store %Word64 %35, %Word64* %17
	%36 = load %SizeT, %SizeT* %4
	%37 = add %SizeT %36, 8
	store %SizeT %37, %SizeT* %4
	%38 = load %Word64, %Word64* %20
	%39 = load %SizeT, %SizeT* %4
	%40 = call %Word64 @read64([0 x %Word8]* %input, %SizeT %39)
	%41 = call %Word64 @round(%Word64 %38, %Word64 %40)
	store %Word64 %41, %Word64* %20
	%42 = load %SizeT, %SizeT* %4
	%43 = add %SizeT %42, 8
	store %SizeT %43, %SizeT* %4
	%44 = load %Word64, %Word64* %21
	%45 = load %SizeT, %SizeT* %4
	%46 = call %Word64 @read64([0 x %Word8]* %input, %SizeT %45)
	%47 = call %Word64 @round(%Word64 %44, %Word64 %46)
	store %Word64 %47, %Word64* %21
	%48 = load %SizeT, %SizeT* %4
	%49 = add %SizeT %48, 8
	store %SizeT %49, %SizeT* %4
	%50 = load %SizeT, %SizeT* %3
	%51 = sub %SizeT %50, 32
	store %SizeT %51, %SizeT* %3
	br label %again_1
break_1:
	%52 = load %Word64, %Word64* %12
	%53 = call %Word64 @rotl64(%Word64 %52, %Nat32 1)
	%54 = load %Word64, %Word64* %17
	%55 = call %Word64 @rotl64(%Word64 %54, %Nat32 7)
	%56 = call %Word64 @add(%Word64 %53, %Word64 %55)
	%57 = load %Word64, %Word64* %20
	%58 = call %Word64 @rotl64(%Word64 %57, %Nat32 12)
	%59 = load %Word64, %Word64* %21
	%60 = call %Word64 @rotl64(%Word64 %59, %Nat32 18)
	%61 = call %Word64 @add(%Word64 %58, %Word64 %60)
	%62 = call %Word64 @add(%Word64 %56, %Word64 %61)
	store %Word64 %62, %Word64* %1
	%63 = load %Word64, %Word64* %1
	%64 = load %Word64, %Word64* %12
	%65 = call %Word64 @mergeRound(%Word64 %63, %Word64 %64)
	store %Word64 %65, %Word64* %1
	%66 = load %Word64, %Word64* %1
	%67 = load %Word64, %Word64* %17
	%68 = call %Word64 @mergeRound(%Word64 %66, %Word64 %67)
	store %Word64 %68, %Word64* %1
	%69 = load %Word64, %Word64* %1
	%70 = load %Word64, %Word64* %20
	%71 = call %Word64 @mergeRound(%Word64 %69, %Word64 %70)
	store %Word64 %71, %Word64* %1
	%72 = load %Word64, %Word64* %1
	%73 = load %Word64, %Word64* %21
	%74 = call %Word64 @mergeRound(%Word64 %72, %Word64 %73)
	store %Word64 %74, %Word64* %1
	br label %endif_1
else_1:
	%75 = bitcast i64 2870177450012600261 to %Word64
	%76 = call %Word64 @add(%Word64 %seed, %Word64 %75)
	store %Word64 %76, %Word64* %1
	br label %endif_1
endif_1:
	%77 = load %Word64, %Word64* %1
	%78 = bitcast %SizeT %length to %Word64
	%79 = call %Word64 @add(%Word64 %77, %Word64 %78)
	store %Word64 %79, %Word64* %1
; while_2
	br label %again_2
again_2:
	%80 = load %SizeT, %SizeT* %3
	%81 = icmp uge %SizeT %80, 8
	br %Bool %81 , label %body_2, label %break_2
body_2:
	%82 = zext i8 0 to %Word64
	%83 = load %SizeT, %SizeT* %4
	%84 = call %Word64 @read64([0 x %Word8]* %input, %SizeT %83)
	%85 = call %Word64 @round(%Word64 %82, %Word64 %84)
	%86 = load %Word64, %Word64* %1
	%87 = xor %Word64 %86, %85
	store %Word64 %87, %Word64* %1
	%88 = load %Word64, %Word64* %1
	%89 = call %Word64 @rotl64(%Word64 %88, %Nat32 27)
	store %Word64 %89, %Word64* %1
	%90 = load %Word64, %Word64* %1
	%91 = bitcast i64 11400714785074694791 to %Word64
	%92 = call %Word64 @mul(%Word64 %90, %Word64 %91)
	store %Word64 %92, %Word64* %1
	%93 = load %Word64, %Word64* %1
	%94 = bitcast i64 9650029242287828579 to %Word64
	%95 = call %Word64 @add(%Word64 %93, %Word64 %94)
	store %Word64 %95, %Word64* %1
	%96 = load %SizeT, %SizeT* %4
	%97 = add %SizeT %96, 8
	store %SizeT %97, %SizeT* %4
	%98 = load %SizeT, %SizeT* %3
	%99 = sub %SizeT %98, 8
	store %SizeT %99, %SizeT* %3
	br label %again_2
break_2:
; if_2
	%100 = load %SizeT, %SizeT* %3
	%101 = icmp uge %SizeT %100, 4
	br %Bool %101 , label %then_2, label %endif_2
then_2:
	%102 = load %SizeT, %SizeT* %4
	%103 = call %Word64 @read32([0 x %Word8]* %input, %SizeT %102)
	%104 = bitcast i64 11400714785074694791 to %Word64
	%105 = call %Word64 @mul(%Word64 %103, %Word64 %104)
	%106 = load %Word64, %Word64* %1
	%107 = xor %Word64 %106, %105
	store %Word64 %107, %Word64* %1
	%108 = load %Word64, %Word64* %1
	%109 = call %Word64 @rotl64(%Word64 %108, %Nat32 23)
	store %Word64 %109, %Word64* %1
	%110 = load %Word64, %Word64* %1
	%111 = bitcast i64 14029467366897019727 to %Word64
	%112 = call %Word64 @mul(%Word64 %110, %Word64 %111)
	store %Word64 %112, %Word64* %1
	%113 = load %Word64, %Word64* %1
	%114 = bitcast i64 1609587929392839161 to %Word64
	%115 = call %Word64 @add(%Word64 %113, %Word64 %114)
	store %Word64 %115, %Word64* %1
	%116 = load %SizeT, %SizeT* %4
	%117 = add %SizeT %116, 4
	store %SizeT %117, %SizeT* %4
	%118 = load %SizeT, %SizeT* %3
	%119 = sub %SizeT %118, 4
	store %SizeT %119, %SizeT* %3
	br label %endif_2
endif_2:
; while_3
	br label %again_3
again_3:
	%120 = load %SizeT, %SizeT* %3
	%121 = icmp ne %SizeT %120, 0
	br %Bool %121 , label %body_3, label %break_3
body_3:
	%122 = load %SizeT, %SizeT* %4
	%123 = trunc %SizeT %122 to %Nat32
	%124 = getelementptr [0 x %Word8], [0 x %Word8]* %input, %Int32 0, %Nat32 %123
	%125 = load %Word8, %Word8* %124
	%126 = zext %Word8 %125 to %Word64
	%127 = bitcast i64 2870177450012600261 to %Word64
	%128 = call %Word64 @mul(%Word64 %126, %Word64 %127)
	%129 = load %Word64, %Word64* %1
	%130 = xor %Word64 %129, %128
	store %Word64 %130, %Word64* %1
	%131 = load %Word64, %Word64* %1
	%132 = call %Word64 @rotl64(%Word64 %131, %Nat32 11)
	store %Word64 %132, %Word64* %1
	%133 = load %Word64, %Word64* %1
	%134 = bitcast i64 11400714785074694791 to %Word64
	%135 = call %Word64 @mul(%Word64 %133, %Word64 %134)
	store %Word64 %135, %Word64* %1
	%136 = load %SizeT, %SizeT* %4
	%137 = add %SizeT %136, 1
	store %SizeT %137, %SizeT* %4
	%138 = load %SizeT, %SizeT* %3
	%139 = sub %SizeT %138, 1
	store %SizeT %139, %SizeT* %3
	br label %again_3
break_3:
	%140 = load %Word64, %Word64* %1
	%141 = call %Word64 @avalanche(%Word64 %140)
	ret %Word64 %141
}



; --- self test ---
@testNum = internal global %Int32 0
define internal %Nat32 @hi32(%Word64 %w) alwaysinline {
	%1 = zext i8 32 to %Word64
	%2 = lshr %Word64 %w, %1
	%3 = trunc %Word64 %2 to %Nat32
	ret %Nat32 %3
}

define internal %Nat32 @lo32(%Word64 %w) alwaysinline {
	%1 = zext i32 4294967295 to %Word64
	%2 = and %Word64 %w, %1
	%3 = trunc %Word64 %2 to %Nat32
	ret %Nat32 %3
}

define internal %Bool @testSequence([0 x %Word8]* %data, %SizeT %length, %Word64 %seed, %Word64 %expected) {
	%1 = call %Word64 @xxh64([0 x %Word8]* %data, %SizeT %length, %Word64 %seed)
	%2 = load %Int32, %Int32* @testNum
	%3 = add %Int32 %2, 1
	store %Int32 %3, %Int32* @testNum
; if_0
	%4 = icmp ne %Word64 %1, %expected
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = load %Int32, %Int32* @testNum
	%6 = call %Nat32 @hi32(%Word64 %expected)
	%7 = call %Nat32 @lo32(%Word64 %expected)
	%8 = call %Nat32 @hi32(%Word64 %1)
	%9 = call %Nat32 @lo32(%Word64 %1)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([54 x i8]* @.str1 to [0 x i8]*), %Int32 %5, %Nat32 %6, %Nat32 %7, %Nat32 %8, %Nat32 %9)
	ret %Bool 0
	br label %endif_0
endif_0:
	%12 = load %Int32, %Int32* @testNum
	%13 = call %Nat32 @hi32(%Word64 %1)
	%14 = call %Nat32 @lo32(%Word64 %1)
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str2 to [0 x i8]*), %Int32 %12, %Nat32 %13, %Nat32 %14)
	ret %Bool 1
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str3 to [0 x i8]*))
	%2 = alloca [101 x %Word8], align 1
	%3 = alloca %Word32, align 4
	%4 = bitcast i32 2654435761 to %Word32
	store %Word32 %4, %Word32* %3
	%5 = alloca %SizeT, align 8
	store %SizeT 0, %SizeT* %5
; while_1
	br label %again_1
again_1:
	%6 = load %SizeT, %SizeT* %5
	%7 = icmp ult %SizeT %6, 101
	br %Bool %7 , label %body_1, label %break_1
body_1:
	%8 = load %SizeT, %SizeT* %5
	%9 = trunc %SizeT %8 to %Nat32
	%10 = getelementptr [101 x %Word8], [101 x %Word8]* %2, %Int32 0, %Nat32 %9
	%11 = load %Word32, %Word32* %3
	%12 = zext i8 24 to %Word32
	%13 = lshr %Word32 %11, %12
	%14 = trunc %Word32 %13 to %Word8
	store %Word8 %14, %Word8* %10
	%15 = load %Word32, %Word32* %3
	%16 = bitcast %Word32 %15 to %Nat32
	%17 = load %Word32, %Word32* %3
	%18 = bitcast %Word32 %17 to %Nat32
	%19 = mul %Nat32 %16, %18
	%20 = bitcast %Nat32 %19 to %Word32
	store %Word32 %20, %Word32* %3
	%21 = load %SizeT, %SizeT* %5
	%22 = add %SizeT %21, 1
	store %SizeT %22, %SizeT* %5
	br label %again_1
break_1:
	%23 = bitcast [101 x %Word8]* %2 to [0 x %Word8]*
	%24 = alloca %Bool, align 1
	store %Bool 1, %Bool* %24
; if_0
	%25 = zext i8 0 to %Word64
	%26 = bitcast i64 17241709254077376921 to %Word64
	%27 = call %Bool @testSequence([0 x %Word8]* null, %SizeT 0, %Word64 %25, %Word64 %26)
	%28 = xor %Bool %27, 1
	br %Bool %28 , label %then_0, label %endif_0
then_0:
	store %Bool 0, %Bool* %24
	br label %endif_0
endif_0:
; if_1
	%29 = bitcast i64 12427117621484918767 to %Word64
	%30 = call %Bool @testSequence([0 x %Word8]* null, %SizeT 0, %Word64 2654435761, %Word64 %29)
	%31 = xor %Bool %30, 1
	br %Bool %31 , label %then_1, label %endif_1
then_1:
	store %Bool 0, %Bool* %24
	br label %endif_1
endif_1:
; if_2
	%32 = zext i8 0 to %Word64
	%33 = bitcast i64 5750596776143442648 to %Word64
	%34 = call %Bool @testSequence([0 x %Word8]* %23, %SizeT 1, %Word64 %32, %Word64 %33)
	%35 = xor %Bool %34, 1
	br %Bool %35 , label %then_2, label %endif_2
then_2:
	store %Bool 0, %Bool* %24
	br label %endif_2
endif_2:
; if_3
	%36 = bitcast i64 8329478753618994979 to %Word64
	%37 = call %Bool @testSequence([0 x %Word8]* %23, %SizeT 1, %Word64 2654435761, %Word64 %36)
	%38 = xor %Bool %37, 1
	br %Bool %38 , label %then_3, label %endif_3
then_3:
	store %Bool 0, %Bool* %24
	br label %endif_3
endif_3:
; if_4
	%39 = zext i8 0 to %Word64
	%40 = bitcast i64 14986446533618842173 to %Word64
	%41 = call %Bool @testSequence([0 x %Word8]* %23, %SizeT 14, %Word64 %39, %Word64 %40)
	%42 = xor %Bool %41, 1
	br %Bool %42 , label %then_4, label %endif_4
then_4:
	store %Bool 0, %Bool* %24
	br label %endif_4
endif_4:
; if_5
	%43 = bitcast i64 6599481375206459851 to %Word64
	%44 = call %Bool @testSequence([0 x %Word8]* %23, %SizeT 14, %Word64 2654435761, %Word64 %43)
	%45 = xor %Bool %44, 1
	br %Bool %45 , label %then_5, label %endif_5
then_5:
	store %Bool 0, %Bool* %24
	br label %endif_5
endif_5:
; if_6
	%46 = zext i8 0 to %Word64
	%47 = bitcast i64 1057031117799454893 to %Word64
	%48 = call %Bool @testSequence([0 x %Word8]* %23, %SizeT 101, %Word64 %46, %Word64 %47)
	%49 = xor %Bool %48, 1
	br %Bool %49 , label %then_6, label %endif_6
then_6:
	store %Bool 0, %Bool* %24
	br label %endif_6
endif_6:
; if_7
	%50 = bitcast i64 14602456943956008481 to %Word64
	%51 = call %Bool @testSequence([0 x %Word8]* %23, %SizeT 101, %Word64 2654435761, %Word64 %50)
	%52 = xor %Bool %51, 1
	br %Bool %52 , label %then_7, label %endif_7
then_7:
	store %Bool 0, %Bool* %24
	br label %endif_7
endif_7:
; if_8
	%53 = load %Bool, %Bool* %24
	%54 = xor %Bool %53, 1
	br %Bool %54 , label %then_8, label %endif_8
then_8:
	%55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str4 to [0 x i8]*))
	ret %Int 1
	br label %endif_8
endif_8:
	%57 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([36 x i8]* @.str5 to [0 x i8]*))
	ret %Int 0
}


