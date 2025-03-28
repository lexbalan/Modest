
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

; MODULE: minmax

; -- print includes --
; -- end print includes --
; -- print imports 'minmax' --
; -- 0
; -- end print imports 'minmax' --
; -- strings --
; -- endstrings --
define %Int32 @minmax_min_int32(%Int32 %a, %Int32 %b) {
; if_0
	%1 = icmp slt %Int32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int32 %a
	br label %endif_0
endif_0:
	ret %Int32 %b
}

define %Int32 @minmax_max_int32(%Int32 %a, %Int32 %b) {
; if_0
	%1 = icmp sgt %Int32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int32 %a
	br label %endif_0
endif_0:
	ret %Int32 %b
}

define %Int64 @minmax_min_int64(%Int64 %a, %Int64 %b) {
; if_0
	%1 = icmp slt %Int64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int64 %a
	br label %endif_0
endif_0:
	ret %Int64 %b
}

define %Int64 @minmax_max_int64(%Int64 %a, %Int64 %b) {
; if_0
	%1 = icmp sgt %Int64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int64 %a
	br label %endif_0
endif_0:
	ret %Int64 %b
}

define %Int32 @minmax_min_nat32(%Int32 %a, %Int32 %b) {
; if_0
	%1 = icmp ult %Int32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int32 %a
	br label %endif_0
endif_0:
	ret %Int32 %b
}

define %Int32 @minmax_max_nat32(%Int32 %a, %Int32 %b) {
; if_0
	%1 = icmp ugt %Int32 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int32 %a
	br label %endif_0
endif_0:
	ret %Int32 %b
}

define %Int64 @minmax_min_nat64(%Int64 %a, %Int64 %b) {
; if_0
	%1 = icmp ult %Int64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int64 %a
	br label %endif_0
endif_0:
	ret %Int64 %b
}

define %Int64 @minmax_max_nat64(%Int64 %a, %Int64 %b) {
; if_0
	%1 = icmp ugt %Int64 %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int64 %a
	br label %endif_0
endif_0:
	ret %Int64 %b
}

define float @minmax_min_float32(float %a, float %b) {
; if_0
	%1 = fcmp olt float %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret float %a
	br label %endif_0
endif_0:
	ret float %b
}

define float @minmax_max_float32(float %a, float %b) {
; if_0
	%1 = fcmp ogt float %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret float %a
	br label %endif_0
endif_0:
	ret float %b
}

define double @minmax_min_float64(double %a, double %b) {
; if_0
	%1 = fcmp olt double %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret double %a
	br label %endif_0
endif_0:
	ret double %b
}

define double @minmax_max_float64(double %a, double %b) {
; if_0
	%1 = fcmp ogt double %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret double %a
	br label %endif_0
endif_0:
	ret double %b
}


