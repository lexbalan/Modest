
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

%CPU_Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU_Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU_Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %2, i32 0, i64 %7
	%9 = load %CPU_Word, %CPU_Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %3, i32 0, i64 %10
	%12 = load %CPU_Word, %CPU_Word* %11
	%13 = icmp ne %CPU_Word %9, %12
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
	%19 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU_Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU_Word* %22 to [0 x i8]*
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/lightfood/memory.cm




%CPU_Word = type i64

define void @memzero(i8* %mem, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem to [0 x %CPU_Word]*
	%3 = alloca i64
	store i64 0, i64* %3
	br label %again_1
again_1:
	%4 = load i64, i64* %3
	%5 = icmp ult i64 %4, %1
	br i1 %5 , label %body_1, label %break_1
body_1:
	%6 = load i64, i64* %3
	%7 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %2, i32 0, i64 %6
	store %CPU_Word 0, %CPU_Word* %7
	%8 = load i64, i64* %3
	%9 = add i64 %8, 1
	store i64 %9, i64* %3
	br label %again_1
break_1:
	%10 = urem i64 %len, 8
	%11 = load i64, i64* %3
	%12 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %2, i32 0, i64 %11
	%13 = bitcast %CPU_Word* %12 to [0 x i8]*
	store i64 0, i64* %3
	br label %again_2
again_2:
	%14 = load i64, i64* %3
	%15 = icmp ult i64 %14, %10
	br i1 %15 , label %body_2, label %break_2
body_2:
	%16 = load i64, i64* %3
	%17 = getelementptr inbounds [0 x i8], [0 x i8]* %13, i32 0, i64 %16
	store i8 0, i8* %17
	%18 = load i64, i64* %3
	%19 = add i64 %18, 1
	store i64 %19, i64* %3
	br label %again_2
break_2:
	ret void
}

define void @memcopy(i8* %dst, i8* %src, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %src to [0 x %CPU_Word]*
	%3 = bitcast i8* %dst to [0 x %CPU_Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %3, i32 0, i64 %7
	%9 = load i64, i64* %4
	%10 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %2, i32 0, i64 %9
	%11 = load %CPU_Word, %CPU_Word* %10
	store %CPU_Word %11, %CPU_Word* %8
	%12 = load i64, i64* %4
	%13 = add i64 %12, 1
	store i64 %13, i64* %4
	br label %again_1
break_1:
	%14 = urem i64 %len, 8
	%15 = load i64, i64* %4
	%16 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %2, i32 0, i64 %15
	%17 = bitcast %CPU_Word* %16 to [0 x i8]*
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %3, i32 0, i64 %18
	%20 = bitcast %CPU_Word* %19 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%21 = load i64, i64* %4
	%22 = icmp ult i64 %21, %14
	br i1 %22 , label %body_2, label %break_2
body_2:
	%23 = load i64, i64* %4
	%24 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %23
	%25 = load i64, i64* %4
	%26 = getelementptr inbounds [0 x i8], [0 x i8]* %17, i32 0, i64 %25
	%27 = load i8, i8* %26
	store i8 %27, i8* %24
	%28 = load i64, i64* %4
	%29 = add i64 %28, 1
	store i64 %29, i64* %4
	br label %again_2
break_2:
	ret void
}

define i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU_Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU_Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %2, i32 0, i64 %7
	%9 = load %CPU_Word, %CPU_Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %3, i32 0, i64 %10
	%12 = load %CPU_Word, %CPU_Word* %11
	%13 = icmp ne %CPU_Word %9, %12
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
	%19 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU_Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU_Word], [0 x %CPU_Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU_Word* %22 to [0 x i8]*
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


