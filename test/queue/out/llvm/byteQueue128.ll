
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

; MODULE: byteQueue128

; print includes
; end print includes
; -----------------------------------------------------------------------------
; declarations from: queue
; -----------------------------------------------------------------------------

%Queue = type {
	i32, 
	i32, 
	i32, 
	i32
};


declare void @queue_init(%Queue* %q, i32 %capacity)
declare i32 @queue_capacity(%Queue* %q)
declare i32 @queue_size(%Queue* %q)
declare i1 @queue_isEmpty(%Queue* %q)
declare i1 @queue_isFull(%Queue* %q)
declare i32 @queue_putPosition(%Queue* %q)
declare i32 @queue_getPosition(%Queue* %q)


; -- strings --


%ByteQueue128 = type {
	%Queue, 
	[128 x %Byte]
};


define void @byteQueue128_init(%ByteQueue128* %q) {
	%1 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%2 = bitcast %Queue* %1 to %Queue*
	call void @queue_init(%Queue* %2, i32 128)
	; -- STMT ASSIGN ARRAY --
	%3 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 1
	; -- start vol eval --
	%4 = zext i8 128 to i32
	; -- end vol eval --
	; -- ZERO
	%5 = mul i32 %4, 1
	%6 = bitcast [128 x %Byte]* %3 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %6, i8 0, i32 %5, i1 0)
	ret void
}

define i32 @byteQueue128_capacity(%ByteQueue128* %q) {
	%1 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%2 = bitcast %Queue* %1 to %Queue*
	%3 = call i32 @queue_capacity(%Queue* %2)
	ret i32 %3
}

define i32 @byteQueue128_size(%ByteQueue128* %q) {
	%1 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%2 = bitcast %Queue* %1 to %Queue*
	%3 = call i32 @queue_size(%Queue* %2)
	ret i32 %3
}

define i1 @byteQueue128_isFull(%ByteQueue128* %q) {
	%1 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%2 = bitcast %Queue* %1 to %Queue*
	%3 = call i1 @queue_isFull(%Queue* %2)
	ret i1 %3
}

define i1 @byteQueue128_isEmpty(%ByteQueue128* %q) {
	%1 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%2 = bitcast %Queue* %1 to %Queue*
	%3 = call i1 @queue_isEmpty(%Queue* %2)
	ret i1 %3
}

define i1 @byteQueue128_put(%ByteQueue128* %q, %Byte %b) {
	%1 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%2 = bitcast %Queue* %1 to %Queue*
	%3 = call i1 @queue_isFull(%Queue* %2)
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%6 = bitcast %Queue* %5 to %Queue*
	%7 = call i32 @queue_putPosition(%Queue* %6)
	%8 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 1
	%9 = getelementptr inbounds [128 x %Byte], [128 x %Byte]* %8, i32 0, i32 %7
	store %Byte %b, %Byte* %9
	ret i1 1
}

define i1 @byteQueue128_get(%ByteQueue128* %q, %Byte* %b) {
	%1 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%2 = bitcast %Queue* %1 to %Queue*
	%3 = call i1 @queue_isEmpty(%Queue* %2)
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 0
	%6 = bitcast %Queue* %5 to %Queue*
	%7 = call i32 @queue_getPosition(%Queue* %6)
	%8 = getelementptr inbounds %ByteQueue128, %ByteQueue128* %q, i32 0, i32 1
	%9 = getelementptr inbounds [128 x %Byte], [128 x %Byte]* %8, i32 0, i32 %7
	%10 = load %Byte, %Byte* %9
	store %Byte %10, %Byte* %b
	ret i1 1
}


