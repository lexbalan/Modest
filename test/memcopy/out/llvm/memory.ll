
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

; MODULE: memory

; -- print includes --
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
; -- endstrings --

;;


;$if (systemWidth == 64)
%Word = type %Word64;
%Nat = type %Int64;
;$elseif (systemWidth == 32)
;type Word Word32
;type Nat Nat32
;$endif
define void @zero(i8* %mem, %Int64 %len) {
	%1 = ptrtoint i8* %mem to %Nat
	%2 = urem %Nat %1, 8
	%3 = bitcast i8* %mem to [0 x %Word8]*

	; align the pointer
	%4 = alloca %Int64, align 8
	store %Int64 0, %Int64* %4
	br label %again_1
again_1:
	%5 = load %Int64, %Int64* %4
	%6 = icmp ult %Int64 %5, %2
	br %Bool %6 , label %body_1, label %break_1
body_1:
	%7 = load %Int64, %Int64* %4
	%8 = getelementptr [0 x %Word8], [0 x %Word8]* %3, %Int32 0, %Int64 %7
	store %Word8 0, %Word8* %8
	%9 = load %Int64, %Int64* %4
	%10 = add %Int64 %9, 1
	store %Int64 %10, %Int64* %4
	br label %again_1
break_1:

	; word operation
	%11 = sub %Int64 %len, %2
	%12 = udiv %Int64 %11, 8
	%13 = load %Int64, %Int64* %4
	%14 = getelementptr [0 x %Word8], [0 x %Word8]* %3, %Int32 0, %Int64 %13
	%15 = bitcast %Word8* %14 to [0 x %Word]*
	store %Int64 0, %Int64* %4
	br label %again_2
again_2:
	%16 = load %Int64, %Int64* %4
	%17 = icmp ult %Int64 %16, %12
	br %Bool %17 , label %body_2, label %break_2
body_2:
	%18 = load %Int64, %Int64* %4
	%19 = getelementptr [0 x %Word], [0 x %Word]* %15, %Int32 0, %Int64 %18
	store %Word 0, %Word* %19
	%20 = load %Int64, %Int64* %4
	%21 = add %Int64 %20, 1
	store %Int64 %21, %Int64* %4
	br label %again_2
break_2:

	; byte operation
	%22 = sub %Int64 %len, %2
	%23 = urem %Int64 %22, 8
	%24 = load %Int64, %Int64* %4
	%25 = getelementptr [0 x %Word], [0 x %Word]* %15, %Int32 0, %Int64 %24
	%26 = bitcast %Word* %25 to [0 x %Word8]*
	store %Int64 0, %Int64* %4
	br label %again_3
again_3:
	%27 = load %Int64, %Int64* %4
	%28 = icmp ult %Int64 %27, %23
	br %Bool %28 , label %body_3, label %break_3
body_3:
	%29 = load %Int64, %Int64* %4
	%30 = getelementptr [0 x %Word8], [0 x %Word8]* %26, %Int32 0, %Int64 %29
	store %Word8 0, %Word8* %30
	%31 = load %Int64, %Int64* %4
	%32 = add %Int64 %31, 1
	store %Int64 %32, %Int64* %4
	br label %again_3
break_3:
	ret void
}

define void @copy(i8* %dst, i8* %src, %Int64 %len) {
	%1 = udiv %Int64 %len, 8
	%2 = bitcast i8* %src to [0 x %Word]*
	%3 = bitcast i8* %dst to [0 x %Word]*
	%4 = alloca %Int64, align 8
	store %Int64 0, %Int64* %4
	br label %again_1
again_1:
	%5 = load %Int64, %Int64* %4
	%6 = icmp ult %Int64 %5, %1
	br %Bool %6 , label %body_1, label %break_1
body_1:
	%7 = load %Int64, %Int64* %4
	%8 = getelementptr [0 x %Word], [0 x %Word]* %3, %Int32 0, %Int64 %7
	%9 = load %Int64, %Int64* %4
	%10 = getelementptr [0 x %Word], [0 x %Word]* %2, %Int32 0, %Int64 %9
	%11 = load %Word, %Word* %10
	store %Word %11, %Word* %8
	%12 = load %Int64, %Int64* %4
	%13 = add %Int64 %12, 1
	store %Int64 %13, %Int64* %4
	br label %again_1
break_1:
	%14 = urem %Int64 %len, 8
	%15 = load %Int64, %Int64* %4
	%16 = getelementptr [0 x %Word], [0 x %Word]* %2, %Int32 0, %Int64 %15
	%17 = bitcast %Word* %16 to [0 x %Word8]*
	%18 = load %Int64, %Int64* %4
	%19 = getelementptr [0 x %Word], [0 x %Word]* %3, %Int32 0, %Int64 %18
	%20 = bitcast %Word* %19 to [0 x %Word8]*
	store %Int64 0, %Int64* %4
	br label %again_2
again_2:
	%21 = load %Int64, %Int64* %4
	%22 = icmp ult %Int64 %21, %14
	br %Bool %22 , label %body_2, label %break_2
body_2:
	%23 = load %Int64, %Int64* %4
	%24 = getelementptr [0 x %Word8], [0 x %Word8]* %20, %Int32 0, %Int64 %23
	%25 = load %Int64, %Int64* %4
	%26 = getelementptr [0 x %Word8], [0 x %Word8]* %17, %Int32 0, %Int64 %25
	%27 = load %Word8, %Word8* %26
	store %Word8 %27, %Word8* %24
	%28 = load %Int64, %Int64* %4
	%29 = add %Int64 %28, 1
	store %Int64 %29, %Int64* %4
	br label %again_2
break_2:
	ret void
}

define %Bool @eq(i8* %mem0, i8* %mem1, %Int64 %len) {
	%1 = udiv %Int64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %Word]*
	%3 = bitcast i8* %mem1 to [0 x %Word]*
	%4 = alloca %Int64, align 8
	store %Int64 0, %Int64* %4
	br label %again_1
again_1:
	%5 = load %Int64, %Int64* %4
	%6 = icmp ult %Int64 %5, %1
	br %Bool %6 , label %body_1, label %break_1
body_1:
	%7 = load %Int64, %Int64* %4
	%8 = getelementptr [0 x %Word], [0 x %Word]* %2, %Int32 0, %Int64 %7
	%9 = load %Int64, %Int64* %4
	%10 = getelementptr [0 x %Word], [0 x %Word]* %3, %Int32 0, %Int64 %9
	%11 = load %Word, %Word* %8
	%12 = load %Word, %Word* %10
	%13 = icmp ne %Word %11, %12
	br %Bool %13 , label %then_0, label %endif_0
then_0:
	ret %Bool 0
	br label %endif_0
endif_0:
	%15 = load %Int64, %Int64* %4
	%16 = add %Int64 %15, 1
	store %Int64 %16, %Int64* %4
	br label %again_1
break_1:
	%17 = urem %Int64 %len, 8
	%18 = load %Int64, %Int64* %4
	%19 = getelementptr [0 x %Word], [0 x %Word]* %2, %Int32 0, %Int64 %18
	%20 = bitcast %Word* %19 to [0 x %Word8]*
	%21 = load %Int64, %Int64* %4
	%22 = getelementptr [0 x %Word], [0 x %Word]* %3, %Int32 0, %Int64 %21
	%23 = bitcast %Word* %22 to [0 x %Word8]*
	store %Int64 0, %Int64* %4
	br label %again_2
again_2:
	%24 = load %Int64, %Int64* %4
	%25 = icmp ult %Int64 %24, %17
	br %Bool %25 , label %body_2, label %break_2
body_2:
	%26 = load %Int64, %Int64* %4
	%27 = getelementptr [0 x %Word8], [0 x %Word8]* %20, %Int32 0, %Int64 %26
	%28 = load %Int64, %Int64* %4
	%29 = getelementptr [0 x %Word8], [0 x %Word8]* %23, %Int32 0, %Int64 %28
	%30 = load %Word8, %Word8* %27
	%31 = load %Word8, %Word8* %29
	%32 = icmp ne %Word8 %30, %31
	br %Bool %32 , label %then_1, label %endif_1
then_1:
	ret %Bool 0
	br label %endif_1
endif_1:
	%34 = load %Int64, %Int64* %4
	%35 = add %Int64 %34, 1
	store %Int64 %35, %Int64* %4
	br label %again_2
break_2:
	ret %Bool 1
}


