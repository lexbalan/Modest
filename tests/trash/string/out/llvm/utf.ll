
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


; MODULE: utf

; -- print includes --
; -- end print includes --
; -- print imports 'utf' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'utf' --
; -- strings --
; -- endstrings --
define %Nat8 @utf_utf32_to_utf8(%Char32 %c, [4 x %Char8]* %buf) {
	%1 = bitcast %Char32 %c to %Word32
; if_0
	%2 = bitcast %Word32 %1 to %Nat32
	%3 = icmp ule %Nat32 %2, 127
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%5 = trunc %Word32 %1 to %Char8
	store %Char8 %5, %Char8* %4
	ret %Nat8 1
	br label %endif_0
else_0:
; if_1
	%7 = bitcast %Word32 %1 to %Nat32
	%8 = icmp ule %Nat32 %7, 2047
	br %Bool %8 , label %then_1, label %else_1
then_1:
	%9 = zext i8 6 to %Word32
	%10 = lshr %Word32 %1, %9
	%11 = zext i8 31 to %Word32
	%12 = and %Word32 %10, %11
	%13 = zext i8 0 to %Word32
	%14 = lshr %Word32 %1, %13
	%15 = zext i8 63 to %Word32
	%16 = and %Word32 %14, %15
	%17 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%18 = zext i8 192 to %Word32
	%19 = or %Word32 %18, %12
	%20 = trunc %Word32 %19 to %Char8
	store %Char8 %20, %Char8* %17
	%21 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%22 = zext i8 128 to %Word32
	%23 = or %Word32 %22, %16
	%24 = trunc %Word32 %23 to %Char8
	store %Char8 %24, %Char8* %21
	ret %Nat8 2
	br label %endif_1
else_1:
; if_2
	%26 = bitcast %Word32 %1 to %Nat32
	%27 = icmp ule %Nat32 %26, 65535
	br %Bool %27 , label %then_2, label %else_2
then_2:
	%28 = zext i8 12 to %Word32
	%29 = lshr %Word32 %1, %28
	%30 = zext i8 15 to %Word32
	%31 = and %Word32 %29, %30
	%32 = zext i8 6 to %Word32
	%33 = lshr %Word32 %1, %32
	%34 = zext i8 63 to %Word32
	%35 = and %Word32 %33, %34
	%36 = zext i8 0 to %Word32
	%37 = lshr %Word32 %1, %36
	%38 = zext i8 63 to %Word32
	%39 = and %Word32 %37, %38
	%40 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%41 = zext i8 224 to %Word32
	%42 = or %Word32 %41, %31
	%43 = trunc %Word32 %42 to %Char8
	store %Char8 %43, %Char8* %40
	%44 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%45 = zext i8 128 to %Word32
	%46 = or %Word32 %45, %35
	%47 = trunc %Word32 %46 to %Char8
	store %Char8 %47, %Char8* %44
	%48 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 2
	%49 = zext i8 128 to %Word32
	%50 = or %Word32 %49, %39
	%51 = trunc %Word32 %50 to %Char8
	store %Char8 %51, %Char8* %48
	ret %Nat8 3
	br label %endif_2
else_2:
; if_3
	%53 = bitcast %Word32 %1 to %Nat32
	%54 = icmp ule %Nat32 %53, 1114111
	br %Bool %54 , label %then_3, label %endif_3
then_3:
	%55 = zext i8 18 to %Word32
	%56 = lshr %Word32 %1, %55
	%57 = zext i8 7 to %Word32
	%58 = and %Word32 %56, %57
	%59 = zext i8 12 to %Word32
	%60 = lshr %Word32 %1, %59
	%61 = zext i8 63 to %Word32
	%62 = and %Word32 %60, %61
	%63 = zext i8 6 to %Word32
	%64 = lshr %Word32 %1, %63
	%65 = zext i8 63 to %Word32
	%66 = and %Word32 %64, %65
	%67 = zext i8 0 to %Word32
	%68 = lshr %Word32 %1, %67
	%69 = zext i8 63 to %Word32
	%70 = and %Word32 %68, %69
	%71 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%72 = zext i8 240 to %Word32
	%73 = or %Word32 %72, %58
	%74 = trunc %Word32 %73 to %Char8
	store %Char8 %74, %Char8* %71
	%75 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%76 = zext i8 128 to %Word32
	%77 = or %Word32 %76, %62
	%78 = trunc %Word32 %77 to %Char8
	store %Char8 %78, %Char8* %75
	%79 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 2
	%80 = zext i8 128 to %Word32
	%81 = or %Word32 %80, %66
	%82 = trunc %Word32 %81 to %Char8
	store %Char8 %82, %Char8* %79
	%83 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 3
	%84 = zext i8 128 to %Word32
	%85 = or %Word32 %84, %70
	%86 = trunc %Word32 %85 to %Char8
	store %Char8 %86, %Char8* %83
	ret %Nat8 4
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %Nat8 0
}

define %Nat8 @utf_utf16_to_utf32([0 x %Char16]* %c, %Char32* %result) {
	%1 = getelementptr [0 x %Char16], [0 x %Char16]* %c, %Int32 0, %Int32 0
	%2 = load %Char16, %Char16* %1
	%3 = zext %Char16 %2 to %Word32
; if_0
	%4 = bitcast %Word32 %3 to %Nat32
	%5 = icmp ult %Nat32 %4, 55296
	%6 = bitcast %Word32 %3 to %Nat32
	%7 = icmp ugt %Nat32 %6, 57343
	%8 = or %Bool %5, %7
	br %Bool %8 , label %then_0, label %else_0
then_0:
	%9 = bitcast %Word32 %3 to %Char32
	store %Char32 %9, %Char32* %result
	ret %Nat8 1
	br label %endif_0
else_0:
; if_1
	%11 = bitcast %Word32 %3 to %Nat32
	%12 = icmp uge %Nat32 %11, 56320
	br %Bool %12 , label %then_1, label %else_1
then_1:
	br label %endif_1
else_1:
	%13 = alloca %Word32, align 4
	%14 = zext i16 1023 to %Word32
	%15 = and %Word32 %3, %14
	%16 = zext i8 10 to %Word32
	%17 = shl %Word32 %15, %16
	store %Word32 %17, %Word32* %13
	%18 = getelementptr [0 x %Char16], [0 x %Char16]* %c, %Int32 0, %Int32 1
	%19 = load %Char16, %Char16* %18
	%20 = zext %Char16 %19 to %Word32
; if_2
	%21 = bitcast %Word32 %20 to %Nat32
	%22 = icmp ult %Nat32 %21, 56320
	%23 = bitcast %Word32 %20 to %Nat32
	%24 = icmp ugt %Nat32 %23, 57343
	%25 = or %Bool %22, %24
	br %Bool %25 , label %then_2, label %else_2
then_2:
	br label %endif_2
else_2:
	%26 = zext i16 1023 to %Word32
	%27 = and %Word32 %20, %26
	%28 = load %Word32, %Word32* %13
	%29 = or %Word32 %28, %27
	store %Word32 %29, %Word32* %13
	%30 = load %Word32, %Word32* %13
	%31 = bitcast %Word32 %30 to %Nat32
	%32 = add %Nat32 %31, 65536
	%33 = bitcast %Nat32 %32 to %Word32
	%34 = bitcast %Word32 %33 to %Char32
	store %Char32 %34, %Char32* %result
	ret %Nat8 2
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %Nat8 0
}


