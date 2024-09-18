
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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

; print includes
; end print includes
; -- strings --

define i32 @doHash([0 x %Byte]* %buf, i32 %len) {
	%1 = alloca [256 x i32], align 4
	%2 = alloca i32, align 4
	;
	; create table before
	;
	%3 = alloca i32, align 4
	store i32 0, i32* %3
	br label %again_1
again_1:
	%4 = load i32, i32* %3
	%5 = icmp ult i32 %4, 256
	br i1 %5 , label %body_1, label %break_1
body_1:
	%6 = load i32, i32* %3
	store i32 %6, i32* %2
	%7 = alloca i32, align 4
	store i32 0, i32* %7
	br label %again_2
again_2:
	%8 = load i32, i32* %7
	%9 = icmp ult i32 %8, 8
	br i1 %9 , label %body_2, label %break_2
body_2:
	%10 = load i32, i32* %2
	%11 = and i32 %10, 1
	%12 = icmp ne i32 %11, 0
	br i1 %12 , label %then_0, label %else_0
then_0:
	%13 = load i32, i32* %2
	%14 = lshr i32 %13, 1
	%15 = xor i32 %14, 3988292384
	store i32 %15, i32* %2
	br label %endif_0
else_0:
	%16 = load i32, i32* %2
	%17 = lshr i32 %16, 1
	store i32 %17, i32* %2
	br label %endif_0
endif_0:
	%18 = load i32, i32* %7
	%19 = add i32 %18, 1
	store i32 %19, i32* %7
	br label %again_2
break_2:
	%20 = load i32, i32* %3
	%21 = getelementptr inbounds [256 x i32], [256 x i32]* %1, i32 0, i32 %20
	%22 = load i32, i32* %2
	store i32 %22, i32* %21
	%23 = load i32, i32* %3
	%24 = add i32 %23, 1
	store i32 %24, i32* %3
	br label %again_1
break_1:
	;
	; calculate CRC32
	;
	store i32 4294967295, i32* %2
	store i32 0, i32* %3
	br label %again_3
again_3:
	%25 = load i32, i32* %3
	%26 = icmp ult i32 %25, %len
	br i1 %26 , label %body_3, label %break_3
body_3:
	%27 = load i32, i32* %2
	%28 = load i32, i32* %3
	%29 = getelementptr inbounds [0 x %Byte], [0 x %Byte]* %buf, i32 0, i32 %28
	%30 = load %Byte, %Byte* %29
	%31 = zext %Byte %30 to i32
	%32 = xor i32 %27, %31
	%33 = and i32 %32, 255
	%34 = getelementptr inbounds [256 x i32], [256 x i32]* %1, i32 0, i32 %33
	%35 = load i32, i32* %34
	%36 = load i32, i32* %2
	%37 = lshr i32 %36, 8
	%38 = xor i32 %35, %37
	store i32 %38, i32* %2
	%39 = load i32, i32* %3
	%40 = add i32 %39, 1
	store i32 %40, i32* %3
	br label %again_3
break_3:
	%41 = load i32, i32* %2
	%42 = xor i32 %41, 4294967295
	ret i32 %42
}


