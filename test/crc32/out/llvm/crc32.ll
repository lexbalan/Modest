
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
%VA_List = type i8*
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

; MODULE: crc32

; -- print includes --
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --

define %Word32 @crc32_doHash([0 x %Word8]* %buf, %Int32 %len) {
	%1 = alloca [256 x %Word32], align 4
	%2 = alloca %Word32, align 4
	;
	; create table before
	;
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%4 = load %Int32, %Int32* %3
	%5 = icmp ult %Int32 %4, 256
	br i1 %5 , label %body_1, label %break_1
body_1:
	%6 = load %Int32, %Int32* %3
	%7 = bitcast %Int32 %6 to %Word32
	store %Word32 %7, %Word32* %2
	%8 = alloca %Int32, align 4
	store %Int32 0, %Int32* %8
	br label %again_2
again_2:
	%9 = load %Int32, %Int32* %8
	%10 = icmp ult %Int32 %9, 8
	br i1 %10 , label %body_2, label %break_2
body_2:
	%11 = load %Word32, %Word32* %2
	%12 = and %Word32 %11, 1
	%13 = icmp ne %Word32 %12, 0
	br i1 %13 , label %then_0, label %else_0
then_0:
	%14 = load %Word32, %Word32* %2
	%15 = lshr %Word32 %14, 1
	%16 = xor %Word32 %15, 3988292384
	store %Word32 %16, %Word32* %2
	br label %endif_0
else_0:
	%17 = load %Word32, %Word32* %2
	%18 = lshr %Word32 %17, 1
	store %Word32 %18, %Word32* %2
	br label %endif_0
endif_0:
	%19 = load %Int32, %Int32* %8
	%20 = add %Int32 %19, 1
	store %Int32 %20, %Int32* %8
	br label %again_2
break_2:
	%21 = load %Int32, %Int32* %3
	%22 = getelementptr inbounds [256 x %Word32], [256 x %Word32]* %1, %Int32 0, %Int32 %21
	%23 = load %Word32, %Word32* %2
	store %Word32 %23, %Word32* %22
	%24 = load %Int32, %Int32* %3
	%25 = add %Int32 %24, 1
	store %Int32 %25, %Int32* %3
	br label %again_1
break_1:
	;
	; calculate CRC32
	;
	store %Word32 4294967295, %Word32* %2
	store %Int32 0, %Int32* %3
	br label %again_3
again_3:
	%26 = load %Int32, %Int32* %3
	%27 = icmp ult %Int32 %26, %len
	br i1 %27 , label %body_3, label %break_3
body_3:
	%28 = load %Word32, %Word32* %2
	%29 = load %Int32, %Int32* %3
	%30 = getelementptr inbounds [0 x %Word8], [0 x %Word8]* %buf, %Int32 0, %Int32 %29
	%31 = load %Word8, %Word8* %30
	%32 = zext %Word8 %31 to %Word32
	%33 = xor %Word32 %28, %32
	%34 = and %Word32 %33, 255
	%35 = trunc %Word32 %34 to %Int8
	%36 = getelementptr inbounds [256 x %Word32], [256 x %Word32]* %1, %Int32 0, %Int8 %35
	%37 = load %Word32, %Word32* %36
	%38 = load %Word32, %Word32* %2
	%39 = lshr %Word32 %38, 8
	%40 = xor %Word32 %37, %39
	store %Word32 %40, %Word32* %2
	%41 = load %Int32, %Int32* %3
	%42 = add %Int32 %41, 1
	store %Int32 %42, %Int32* %3
	br label %again_3
break_3:
	%43 = load %Word32, %Word32* %2
	%44 = xor %Word32 %43, 4294967295
	ret %Word32 %44
}


