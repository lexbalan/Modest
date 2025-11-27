
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

; MODULE: memory

; -- print includes --
; -- end print includes --
; -- print imports 'memory' --
; -- 0
; -- end print imports 'memory' --
; -- strings --
; -- endstrings --;
%Word = type %Word64;
%Nat = type %Nat64;
;$elseif (systemWidth == 32)
;type Word Word32
;type Nat Nat32
;$endif
define void @memory_zero(i8* %mem, %Nat64 %len) {
	%1 = ptrtoint i8* %mem to %Nat
	%2 = urem %Nat %1, 8
	%3 = bitcast i8* %mem to [0 x %Word8]*

	; align the pointer
	%4 = alloca %Nat64, align 8
	store %Nat64 0, %Nat64* %4
; while_1
	br label %again_1
again_1:
	%5 = load %Nat64, %Nat64* %4
	%6 = icmp ult %Nat64 %5, %2
	br %Bool %6 , label %body_1, label %break_1
body_1:
	%7 = load %Nat64, %Nat64* %4
	%8 = trunc %Nat64 %7 to %Nat32
	%9 = getelementptr [0 x %Word8], [0 x %Word8]* %3, %Int32 0, %Nat32 %8
	%10 = bitcast i8 0 to %Word8
	store %Word8 %10, %Word8* %9
	%11 = load %Nat64, %Nat64* %4
	%12 = add %Nat64 %11, 1
	store %Nat64 %12, %Nat64* %4
	br label %again_1
break_1:

	; word operation
	%13 = sub %Nat64 %len, %2
	%14 = udiv %Nat64 %13, 8
	%15 = load %Nat64, %Nat64* %4
	%16 = trunc %Nat64 %15 to %Nat32
	%17 = getelementptr [0 x %Word8], [0 x %Word8]* %3, %Int32 0, %Nat32 %16
	%18 = bitcast %Word8* %17 to [0 x %Word]*
	store %Nat64 0, %Nat64* %4
; while_2
	br label %again_2
again_2:
	%19 = load %Nat64, %Nat64* %4
	%20 = icmp ult %Nat64 %19, %14
	br %Bool %20 , label %body_2, label %break_2
body_2:
	%21 = load %Nat64, %Nat64* %4
	%22 = trunc %Nat64 %21 to %Nat32
	%23 = getelementptr [0 x %Word], [0 x %Word]* %18, %Int32 0, %Nat32 %22
	%24 = zext i8 0 to %Word
	store %Word %24, %Word* %23
	%25 = load %Nat64, %Nat64* %4
	%26 = add %Nat64 %25, 1
	store %Nat64 %26, %Nat64* %4
	br label %again_2
break_2:

	; byte operation
	%27 = sub %Nat64 %len, %2
	%28 = urem %Nat64 %27, 8
	%29 = load %Nat64, %Nat64* %4
	%30 = trunc %Nat64 %29 to %Nat32
	%31 = getelementptr [0 x %Word], [0 x %Word]* %18, %Int32 0, %Nat32 %30
	%32 = bitcast %Word* %31 to [0 x %Word8]*
	store %Nat64 0, %Nat64* %4
; while_3
	br label %again_3
again_3:
	%33 = load %Nat64, %Nat64* %4
	%34 = icmp ult %Nat64 %33, %28
	br %Bool %34 , label %body_3, label %break_3
body_3:
	%35 = load %Nat64, %Nat64* %4
	%36 = trunc %Nat64 %35 to %Nat32
	%37 = getelementptr [0 x %Word8], [0 x %Word8]* %32, %Int32 0, %Nat32 %36
	%38 = bitcast i8 0 to %Word8
	store %Word8 %38, %Word8* %37
	%39 = load %Nat64, %Nat64* %4
	%40 = add %Nat64 %39, 1
	store %Nat64 %40, %Nat64* %4
	br label %again_3
break_3:
	ret void
}

define void @memory_copy(i8* %dst, i8* %src, %Nat64 %len) {
	%1 = udiv %Nat64 %len, 8
	%2 = bitcast i8* %src to [0 x %Word]*
	%3 = bitcast i8* %dst to [0 x %Word]*
	%4 = alloca %Nat64, align 8
	store %Nat64 0, %Nat64* %4
; while_1
	br label %again_1
again_1:
	%5 = load %Nat64, %Nat64* %4
	%6 = icmp ult %Nat64 %5, %1
	br %Bool %6 , label %body_1, label %break_1
body_1:
	%7 = load %Nat64, %Nat64* %4
	%8 = trunc %Nat64 %7 to %Nat32
	%9 = getelementptr [0 x %Word], [0 x %Word]* %3, %Int32 0, %Nat32 %8
	%10 = load %Nat64, %Nat64* %4
	%11 = trunc %Nat64 %10 to %Nat32
	%12 = getelementptr [0 x %Word], [0 x %Word]* %2, %Int32 0, %Nat32 %11
	%13 = load %Word, %Word* %12
	store %Word %13, %Word* %9
	%14 = load %Nat64, %Nat64* %4
	%15 = add %Nat64 %14, 1
	store %Nat64 %15, %Nat64* %4
	br label %again_1
break_1:
	%16 = urem %Nat64 %len, 8
	%17 = load %Nat64, %Nat64* %4
	%18 = trunc %Nat64 %17 to %Nat32
	%19 = getelementptr [0 x %Word], [0 x %Word]* %2, %Int32 0, %Nat32 %18
	%20 = bitcast %Word* %19 to [0 x %Word8]*
	%21 = load %Nat64, %Nat64* %4
	%22 = trunc %Nat64 %21 to %Nat32
	%23 = getelementptr [0 x %Word], [0 x %Word]* %3, %Int32 0, %Nat32 %22
	%24 = bitcast %Word* %23 to [0 x %Word8]*
	store %Nat64 0, %Nat64* %4
; while_2
	br label %again_2
again_2:
	%25 = load %Nat64, %Nat64* %4
	%26 = icmp ult %Nat64 %25, %16
	br %Bool %26 , label %body_2, label %break_2
body_2:
	%27 = load %Nat64, %Nat64* %4
	%28 = trunc %Nat64 %27 to %Nat32
	%29 = getelementptr [0 x %Word8], [0 x %Word8]* %24, %Int32 0, %Nat32 %28
	%30 = load %Nat64, %Nat64* %4
	%31 = trunc %Nat64 %30 to %Nat32
	%32 = getelementptr [0 x %Word8], [0 x %Word8]* %20, %Int32 0, %Nat32 %31
	%33 = load %Word8, %Word8* %32
	store %Word8 %33, %Word8* %29
	%34 = load %Nat64, %Nat64* %4
	%35 = add %Nat64 %34, 1
	store %Nat64 %35, %Nat64* %4
	br label %again_2
break_2:
	ret void
}

define %Bool @memory_eq(i8* %mem0, i8* %mem1, %Nat64 %len) {
	%1 = udiv %Nat64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %Word]*
	%3 = bitcast i8* %mem1 to [0 x %Word]*
	%4 = alloca %Nat64, align 8
	store %Nat64 0, %Nat64* %4
; while_1
	br label %again_1
again_1:
	%5 = load %Nat64, %Nat64* %4
	%6 = icmp ult %Nat64 %5, %1
	br %Bool %6 , label %body_1, label %break_1
body_1:
; if_0
	%7 = load %Nat64, %Nat64* %4
	%8 = trunc %Nat64 %7 to %Nat32
	%9 = getelementptr [0 x %Word], [0 x %Word]* %2, %Int32 0, %Nat32 %8
	%10 = load %Nat64, %Nat64* %4
	%11 = trunc %Nat64 %10 to %Nat32
	%12 = getelementptr [0 x %Word], [0 x %Word]* %3, %Int32 0, %Nat32 %11
	%13 = load %Word, %Word* %9
	%14 = load %Word, %Word* %12
	%15 = icmp ne %Word %13, %14
	br %Bool %15 , label %then_0, label %endif_0
then_0:
	ret %Bool 0
	br label %endif_0
endif_0:
	%17 = load %Nat64, %Nat64* %4
	%18 = add %Nat64 %17, 1
	store %Nat64 %18, %Nat64* %4
	br label %again_1
break_1:
	%19 = urem %Nat64 %len, 8
	%20 = load %Nat64, %Nat64* %4
	%21 = trunc %Nat64 %20 to %Nat32
	%22 = getelementptr [0 x %Word], [0 x %Word]* %2, %Int32 0, %Nat32 %21
	%23 = bitcast %Word* %22 to [0 x %Word8]*
	%24 = load %Nat64, %Nat64* %4
	%25 = trunc %Nat64 %24 to %Nat32
	%26 = getelementptr [0 x %Word], [0 x %Word]* %3, %Int32 0, %Nat32 %25
	%27 = bitcast %Word* %26 to [0 x %Word8]*
	store %Nat64 0, %Nat64* %4
; while_2
	br label %again_2
again_2:
	%28 = load %Nat64, %Nat64* %4
	%29 = icmp ult %Nat64 %28, %19
	br %Bool %29 , label %body_2, label %break_2
body_2:
; if_1
	%30 = load %Nat64, %Nat64* %4
	%31 = trunc %Nat64 %30 to %Nat32
	%32 = getelementptr [0 x %Word8], [0 x %Word8]* %23, %Int32 0, %Nat32 %31
	%33 = load %Nat64, %Nat64* %4
	%34 = trunc %Nat64 %33 to %Nat32
	%35 = getelementptr [0 x %Word8], [0 x %Word8]* %27, %Int32 0, %Nat32 %34
	%36 = load %Word8, %Word8* %32
	%37 = load %Word8, %Word8* %35
	%38 = icmp ne %Word8 %36, %37
	br %Bool %38 , label %then_1, label %endif_1
then_1:
	ret %Bool 0
	br label %endif_1
endif_1:
	%40 = load %Nat64, %Nat64* %4
	%41 = add %Nat64 %40, 1
	store %Nat64 %41, %Nat64* %4
	br label %again_2
break_2:
	ret %Bool 1
}


