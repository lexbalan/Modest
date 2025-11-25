
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

; MODULE: ringWord8

; -- print includes --
; -- end print includes --
; -- print imports 'ringWord8' --
; -- 1

; from import "queue"
%queue_Queue = type {
	%Nat32,
	%Nat32,
	%Nat32,
	%Nat32
};

declare void @queue_init(%queue_Queue* %q, %Nat32 %capacity)
declare %Nat32 @queue_capacity(%queue_Queue* %q)
declare %Nat32 @queue_size(%queue_Queue* %q)
declare %Bool @queue_isEmpty(%queue_Queue* %q)
declare %Bool @queue_isFull(%queue_Queue* %q)
declare %Nat32 @queue_getPutPosition(%queue_Queue* %q)
declare %Nat32 @queue_getGetPosition(%queue_Queue* %q)

; end from import "queue"
; -- end print imports 'ringWord8' --
; -- strings --
; -- endstrings --
%ringWord8_RingWord8 = type {
	%queue_Queue,
	[0 x %Word8]*
};

define void @ringWord8_init(%ringWord8_RingWord8* %q, [0 x %Word8]* %buf, %Nat32 %capacity) {
	%1 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	call void @queue_init(%queue_Queue* %1, %Nat32 %capacity)
	%2 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 1
	store [0 x %Word8]* %buf, [0 x %Word8]** %2
	ret void
}

define %Nat32 @ringWord8_capacity(%ringWord8_RingWord8* %q) {
	%1 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%2 = call %Nat32 @queue_capacity(%queue_Queue* %1)
	ret %Nat32 %2
}

define %Nat32 @ringWord8_size(%ringWord8_RingWord8* %q) {
	%1 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%2 = call %Nat32 @queue_size(%queue_Queue* %1)
	ret %Nat32 %2
}

define %Bool @ringWord8_isFull(%ringWord8_RingWord8* %q) {
	%1 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%2 = call %Bool @queue_isFull(%queue_Queue* %1)
	ret %Bool %2
}

define %Bool @ringWord8_isEmpty(%ringWord8_RingWord8* %q) {
	%1 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%2 = call %Bool @queue_isEmpty(%queue_Queue* %1)
	ret %Bool %2
}

define %Bool @ringWord8_put(%ringWord8_RingWord8* %q, %Word8 %b) {
;
;	if queue.isFull(&q.queue) {
;		return false
;	}
;	
	%1 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%2 = call %Nat32 @queue_getPutPosition(%queue_Queue* %1)
	%3 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 1
	%4 = load [0 x %Word8]*, [0 x %Word8]** %3
	%5 = bitcast %Nat32 %2 to %Nat32
	%6 = getelementptr [0 x %Word8], [0 x %Word8]* %4, %Int32 0, %Nat32 %5
	store %Word8 %b, %Word8* %6
	ret %Bool 1
}

define %Bool @ringWord8_get(%ringWord8_RingWord8* %q, %Word8* %b) {
; if_0
	%1 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%2 = call %Bool @queue_isEmpty(%queue_Queue* %1)
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	ret %Bool 0
	br label %endif_0
endif_0:
	%4 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%5 = call %Nat32 @queue_getGetPosition(%queue_Queue* %4)
	%6 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 1
	%7 = load [0 x %Word8]*, [0 x %Word8]** %6
	%8 = bitcast %Nat32 %5 to %Nat32
	%9 = getelementptr [0 x %Word8], [0 x %Word8]* %7, %Int32 0, %Nat32 %8
	%10 = load %Word8, %Word8* %9
	store %Word8 %10, %Word8* %b
	ret %Bool 1
}


