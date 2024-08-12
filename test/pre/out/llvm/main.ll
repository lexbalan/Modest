
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


; -- SOURCE: /Users/alexbalan/p/Modest/test/pre/src/console.m


declare void @printf(%Str8* %s, ...)


; -- SOURCE: /Users/alexbalan/p/Modest/test/pre/src/sub2.m



; -- SOURCE: /Users/alexbalan/p/Modest/test/pre/src/sub.m



%Int = type i32;

@subCnt = external global %Int

declare %Int @div(%Int %a, %Int %b)


; -- SOURCE: src/main.m

@str1 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [21 x i8] [i8 115, i8 117, i8 98, i8 58, i8 58, i8 115, i8 117, i8 98, i8 78, i8 97, i8 109, i8 101, i8 32, i8 61, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@str3 = private constant [8 x i8] [i8 83, i8 117, i8 98, i8 78, i8 97, i8 109, i8 101, i8 0]
@str4 = private constant [23 x i8] [i8 115, i8 117, i8 98, i8 50, i8 58, i8 58, i8 115, i8 117, i8 98, i8 50, i8 78, i8 97, i8 109, i8 101, i8 32, i8 61, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@str5 = private constant [9 x i8] [i8 83, i8 117, i8 98, i8 50, i8 78, i8 97, i8 109, i8 101, i8 0]
@str6 = private constant [8 x i8] [i8 115, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [12 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 83, i8 104, i8 111, i8 119, i8 58, i8 10, i8 0]
@str8 = private constant [16 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]


%Data = type i32;
%Node = type {
	%Node*, 
	%Data*
};



%Arr = type [10 x %Int];


@x = global %Int zeroinitializer


define void @increment() {
	%1 = load %Int, %Int* @subCnt
	%2 = add %Int %1, 1
	store %Int %2, %Int* @subCnt
	ret void
}

define %Int @main() {
	call void (%Str8*, ...) @printf(%Str8* bitcast ([6 x i8]* @str1 to [0 x i8]*))
	call void (%Str8*, ...) @printf(%Str8* bitcast ([21 x i8]* @str2 to [0 x i8]*), %Str8* bitcast ([8 x i8]* @str3 to [0 x i8]*))
	call void (%Str8*, ...) @printf(%Str8* bitcast ([23 x i8]* @str4 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str5 to [0 x i8]*))
	%1 = alloca %Int, align 4
	store %Int 5, %Int* %1
	%2 = call %Int @mid(%Int 10, %Int 20)
	call void (%Str8*, ...) @printf(%Str8* bitcast ([8 x i8]* @str6 to [0 x i8]*), %Int %2)
	%3 = alloca %Int, align 4
	;var arr = getArr()
	;arrayShow(&arr, 10)
	store %Int 12, %Int* @x
	ret %Int 0
}

define void @arrayShow(%Arr* %array, %Int %size) {
	call void (%Str8*, ...) @printf(%Str8* bitcast ([12 x i8]* @str7 to [0 x i8]*))
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	%2 = load i32, i32* %1
	%3 = icmp slt i32 %2, 10
	br i1 %3 , label %body_1, label %break_1
body_1:
	%4 = load i32, i32* %1
	%5 = load i32, i32* %1
	%6 = getelementptr inbounds %Arr, %Arr* %array, i32 0, i32 %5
	%7 = load %Int, %Int* %6
	call void (%Str8*, ...) @printf(%Str8* bitcast ([16 x i8]* @str8 to [0 x i8]*), i32 %4, %Int %7)
	%8 = load i32, i32* %1
	%9 = add i32 %8, 1
	store i32 %9, i32* %1
	br label %again_1
break_1:
	ret void
}

define %Int @mid(%Int %a, %Int %b) {
	%1 = add %Int %a, %b
	%2 = call %Int @div(%Int %1, %Int 2)
	ret %Int %2
}


