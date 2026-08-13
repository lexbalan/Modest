
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


; MODULE: queue

; -- print includes --
; -- end print includes --
; -- print imports 'queue' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'queue' --
; -- strings --
; -- endstrings --
%queue_Queue = type {
	%Nat32,
	%Nat32,
	%Nat32,
	%Nat32
};

define void @queue_init(%queue_Queue* %q, %Nat32 %capacity) {
	store %queue_Queue zeroinitializer, %queue_Queue* %q
	%1 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 0
	store %Nat32 %capacity, %Nat32* %1
	ret void
}

define void @queue_deinit(%queue_Queue* %q) {
	store %queue_Queue zeroinitializer, %queue_Queue* %q
	ret void
}

define %Nat32 @queue_capacity(%queue_Queue* %q) {
	%1 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 0
	%2 = load %Nat32, %Nat32* %1
	ret %Nat32 %2
}

define %Nat32 @queue_size(%queue_Queue* %q) {
	%1 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%2 = load %Nat32, %Nat32* %1
	ret %Nat32 %2
}

define %Bool @queue_isEmpty(%queue_Queue* %q) {
	%1 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp eq %Nat32 %2, 0
	ret %Bool %3
}

define %Bool @queue_isFull(%queue_Queue* %q) {
	%1 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%2 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 0
	%3 = load %Nat32, %Nat32* %1
	%4 = load %Nat32, %Nat32* %2
	%5 = icmp eq %Nat32 %3, %4
	ret %Bool %5
}

define %Nat32 @queue_getPutPosition(%queue_Queue* %q) {
	%1 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 2
	%2 = load %Nat32, %Nat32* %1
	%3 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 2
	%4 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 0
	%5 = load %Nat32, %Nat32* %4
	%6 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 2
	%7 = load %Nat32, %Nat32* %6
	%8 = call %Nat32 @next(%Nat32 %5, %Nat32 %7)
	store %Nat32 %8, %Nat32* %3
; if_0
	%9 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%10 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 0
	%11 = load %Nat32, %Nat32* %9
	%12 = load %Nat32, %Nat32* %10
	%13 = icmp ult %Nat32 %11, %12
	br %Bool %13 , label %then_0, label %endif_0
then_0:
	%14 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%15 = load %Nat32, %Nat32* %14
	%16 = add %Nat32 %15, 1
	store %Nat32 %16, %Nat32* %14
	br label %endif_0
endif_0:
	ret %Nat32 %2
}

define %Nat32 @queue_getGetPosition(%queue_Queue* %q) {
	%1 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 3
	%2 = load %Nat32, %Nat32* %1
	%3 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 3
	%4 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 0
	%5 = load %Nat32, %Nat32* %4
	%6 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 3
	%7 = load %Nat32, %Nat32* %6
	%8 = call %Nat32 @next(%Nat32 %5, %Nat32 %7)
	store %Nat32 %8, %Nat32* %3
; if_0
	%9 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%10 = load %Nat32, %Nat32* %9
	%11 = icmp ugt %Nat32 %10, 0
	br %Bool %11 , label %then_0, label %endif_0
then_0:
	%12 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%13 = load %Nat32, %Nat32* %12
	%14 = sub %Nat32 %13, 1
	store %Nat32 %14, %Nat32* %12
	br label %endif_0
endif_0:
	ret %Nat32 %2
}

define internal %Nat32 @next(%Nat32 %capacity, %Nat32 %x) {
; if_0
	%1 = sub %Nat32 %capacity, 1
	%2 = icmp ult %Nat32 %x, %1
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	%3 = add %Nat32 %x, 1
	ret %Nat32 %3
	br label %endif_0
endif_0:
	ret %Nat32 0
}


