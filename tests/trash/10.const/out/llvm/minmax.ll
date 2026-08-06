
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


; MODULE: minmax

; -- print includes --
; -- end print includes --
; -- print imports 'minmax' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'minmax' --
; -- strings --
; -- endstrings --
define %Int32 @minmax_minInt32(%Int32 %a, %Int32 %b) {
; if_0
	%1 = icmp slt %Int32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int32 %a
	br label %endif_0
endif_0:
	ret %Int32 %b
}

define %Int32 @minmax_maxInt32(%Int32 %a, %Int32 %b) {
; if_0
	%1 = icmp sgt %Int32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int32 %a
	br label %endif_0
endif_0:
	ret %Int32 %b
}

define %Int64 @minmax_minInt64(%Int64 %a, %Int64 %b) {
; if_0
	%1 = icmp slt %Int64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int64 %a
	br label %endif_0
endif_0:
	ret %Int64 %b
}

define %Int64 @minmax_maxInt64(%Int64 %a, %Int64 %b) {
; if_0
	%1 = icmp sgt %Int64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int64 %a
	br label %endif_0
endif_0:
	ret %Int64 %b
}

define %Nat32 @minmax_minNat32(%Nat32 %a, %Nat32 %b) {
; if_0
	%1 = icmp ult %Nat32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Nat32 %a
	br label %endif_0
endif_0:
	ret %Nat32 %b
}

define %Nat32 @minmax_maxNat32(%Nat32 %a, %Nat32 %b) {
; if_0
	%1 = icmp ugt %Nat32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Nat32 %a
	br label %endif_0
endif_0:
	ret %Nat32 %b
}

define %Nat64 @minmax_minNat64(%Nat64 %a, %Nat64 %b) {
; if_0
	%1 = icmp ult %Nat64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Nat64 %a
	br label %endif_0
endif_0:
	ret %Nat64 %b
}

define %Nat64 @minmax_maxNat64(%Nat64 %a, %Nat64 %b) {
; if_0
	%1 = icmp ugt %Nat64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Nat64 %a
	br label %endif_0
endif_0:
	ret %Nat64 %b
}

define %Float32 @minmax_min_float32(%Float32 %a, %Float32 %b) {
; if_0
	%1 = fcmp olt %Float32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Float32 %a
	br label %endif_0
endif_0:
	ret %Float32 %b
}

define %Float32 @minmax_max_float32(%Float32 %a, %Float32 %b) {
; if_0
	%1 = fcmp ogt %Float32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Float32 %a
	br label %endif_0
endif_0:
	ret %Float32 %b
}

define %Float64 @minmax_min_float64(%Float64 %a, %Float64 %b) {
; if_0
	%1 = fcmp olt %Float64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Float64 %a
	br label %endif_0
endif_0:
	ret %Float64 %b
}

define %Float64 @minmax_max_float64(%Float64 %a, %Float64 %b) {
; if_0
	%1 = fcmp ogt %Float64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Float64 %a
	br label %endif_0
endif_0:
	ret %Float64 %b
}


