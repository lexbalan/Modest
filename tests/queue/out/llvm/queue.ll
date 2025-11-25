
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

; MODULE: queue

; -- print includes --
; -- end print includes --
; -- print imports 'queue' --
; -- 0
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



; you must check isFull(queue) before call 'getPutPosition'
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
	%15 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%16 = load %Nat32, %Nat32* %15
	%17 = add %Nat32 %16, 1
	store %Nat32 %17, %Nat32* %14
	br label %endif_0
endif_0:
	ret %Nat32 %2
}



; you must check isEmpty(queue) before call 'getGetPosition'
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
	%13 = getelementptr %queue_Queue, %queue_Queue* %q, %Int32 0, %Int32 1
	%14 = load %Nat32, %Nat32* %13
	%15 = sub %Nat32 %14, 1
	store %Nat32 %15, %Nat32* %12
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


