
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


; MODULE: ringWord8

; -- print includes --
; -- end print includes --
; -- print imports 'ringWord8' --

; from import "builtin"

; end from import "builtin"

; from import "queue"
%queue_Queue = type {
	%Nat32,
	%Nat32,
	%Nat32,
	%Nat32
};

declare %Bool @queue_init(%queue_Queue* %q, %Nat32 %capacity)
declare void @queue_deinit(%queue_Queue* %q)
declare void @queue_clear(%queue_Queue* %q)
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

define %Bool @ringWord8_init(%ringWord8_RingWord8* %q, [0 x %Word8]* %buf, %Nat32 %capacity) {
; if_0
	%1 = icmp eq [0 x %Word8]* %buf, null
	%2 = icmp eq %Nat32 %capacity, 0
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %Bool 0
	br label %endif_0
endif_0:
	%5 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 1
	store [0 x %Word8]* %buf, [0 x %Word8]** %5
	%6 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%7 = call %Bool @queue_init(%queue_Queue* %6, %Nat32 %capacity)
	ret %Bool %7
}

define void @ringWord8_deinit(%ringWord8_RingWord8* %q) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%4 = call %Nat32 @queue_capacity(%queue_Queue* %3)
	%5 = mul %Nat32 %4, 1
	%6 = mul %Nat32 %4, 1
	%7 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 1
	%8 = load [0 x %Word8]*, [0 x %Word8]** %7
	%9 = bitcast [0 x %Word8]* %8 to [0 x %Word8]*
	%10 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%11 = call %Nat32 @queue_capacity(%queue_Queue* %10)
	%12 = mul %Nat32 %11, 1
	%13 = bitcast [0 x %Word8]* %9 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %13, i8 0, %Nat32 %12, i1 0)
	%14 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	call void @queue_deinit(%queue_Queue* %14)
	%15 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 1
	store [0 x %Word8]* null, [0 x %Word8]** %15
	%16 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %16)
	ret void
}

define void @ringWord8_clear(%ringWord8_RingWord8* %q) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%4 = call %Nat32 @queue_capacity(%queue_Queue* %3)
	%5 = mul %Nat32 %4, 1
	%6 = mul %Nat32 %4, 1
	%7 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 1
	%8 = load [0 x %Word8]*, [0 x %Word8]** %7
	%9 = bitcast [0 x %Word8]* %8 to [0 x %Word8]*
	%10 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	%11 = call %Nat32 @queue_capacity(%queue_Queue* %10)
	%12 = mul %Nat32 %11, 1
	%13 = bitcast [0 x %Word8]* %9 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %13, i8 0, %Nat32 %12, i1 0)
	%14 = getelementptr %ringWord8_RingWord8, %ringWord8_RingWord8* %q, %Int32 0, %Int32 0
	call void @queue_clear(%queue_Queue* %14)
	%15 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %15)
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


