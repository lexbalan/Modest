
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


; -----------------------------------------------------------------------------
; -- SOURCE: /Users/alexbalan/p/Modest/test/slices/src/main.m
; -----------------------------------------------------------------------------
@str1 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 115, i8 10, i8 0]
@str3 = private constant [13 x i8] [i8 115, i8 49, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 115, i8 50, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str7 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str9 = private constant [12 x i8] [i8 115, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str11 = private constant [23 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 32, i8 116, i8 111, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 10, i8 0]
@str12 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str13 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str14 = private constant [32 x i8] [i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 111, i8 102, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 32, i8 116, i8 111, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 10, i8 0]
@str15 = private constant [8 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 10, i8 0]
@str16 = private constant [7 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 10, i8 0]
@str17 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str18 = private constant [19 x i8] [i8 122, i8 101, i8 114, i8 111, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 98, i8 121, i8 32, i8 118, i8 97, i8 114, i8 10, i8 0]
@str19 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str20 = private constant [19 x i8] [i8 99, i8 111, i8 112, i8 121, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 98, i8 121, i8 32, i8 118, i8 97, i8 114, i8 10, i8 0]
@str21 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]


define void @array_print([0 x i32]* %pa, i32 %len) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	%2 = load i32, i32* %1
	%3 = icmp slt i32 %2, %len
	br i1 %3 , label %body_1, label %break_1
body_1:
	%4 = load i32, i32* %1
	%5 = load i32, i32* %1
	%6 = getelementptr inbounds [0 x i32], [0 x i32]* %pa, i32 0, i32 %5
	%7 = load i32, i32* %6
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*), i32 %4, i32 %7)
	%9 = load i32, i32* %1
	%10 = add i32 %9, 1
	store i32 %10, i32* %1
	br label %again_1
break_1:
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*))
	;
	; by value
	;
	%2 = alloca [10 x i32], align 4
	%3 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%4 = insertvalue [10 x i32] %3, i32 1, 1
	%5 = insertvalue [10 x i32] %4, i32 2, 2
	%6 = insertvalue [10 x i32] %5, i32 3, 3
	%7 = insertvalue [10 x i32] %6, i32 4, 4
	%8 = insertvalue [10 x i32] %7, i32 5, 5
	%9 = insertvalue [10 x i32] %8, i32 6, 6
	%10 = insertvalue [10 x i32] %9, i32 7, 7
	%11 = insertvalue [10 x i32] %10, i32 8, 8
	%12 = insertvalue [10 x i32] %11, i32 9, 9
	store [10 x i32] %12, [10 x i32]* %2
	%13 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i1 1
	%14 = bitcast i32* %13 to [1 x i32]*
	%15 = load [1 x i32], [1 x i32]* %14
	%16 = alloca [1 x i32]
	store [1 x i32] %15, [1 x i32]* %16
	%17 = alloca i32, align 4
	store i32 0, i32* %17
	br label %again_1
again_1:
	%18 = load i32, i32* %17
	%19 = icmp slt i32 %18, 1
	br i1 %19 , label %body_1, label %break_1
body_1:
	%20 = load i32, i32* %17
	%21 = load i32, i32* %17
	%22 = getelementptr inbounds [1 x i32], [1 x i32]* %16, i32 0, i32 %21
	%23 = load i32, i32* %22
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), i32 %20, i32 %23)
	%25 = load i32, i32* %17
	%26 = add i32 %25, 1
	store i32 %26, i32* %17
	br label %again_1
break_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str4 to [0 x i8]*))
	;
	; by ptr
	;
	%28 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i3 5
;
	%29 = bitcast i32* %28 to [3 x i32]*
	%30 = load [3 x i32], [3 x i32]* %29
	%31 = alloca [3 x i32]
	store [3 x i32] %30, [3 x i32]* %31
	store i32 0, i32* %17
	br label %again_2
again_2:
	%32 = load i32, i32* %17
	%33 = icmp slt i32 %32, 3
	br i1 %33 , label %body_2, label %break_2
body_2:
	%34 = load i32, i32* %17
	%35 = load i32, i32* %17
	%36 = getelementptr inbounds [3 x i32], [3 x i32]* %31, i32 0, i32 %35
	%37 = load i32, i32* %36
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), i32 %34, i32 %37)
	%39 = load i32, i32* %17
	%40 = add i32 %39, 1
	store i32 %40, i32* %17
	br label %again_2
break_2:
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str6 to [0 x i8]*))
	%42 = alloca [1 x i32], align 4
	%43 = load [1 x i32], [1 x i32]* %16
	store [1 x i32] %43, [1 x i32]* %42
	%44 = alloca [3 x i32], align 4
	%45 = load [3 x i32], [3 x i32]* %31
	store [3 x i32] %45, [3 x i32]* %44
	; -- STMT ASSIGN ARRAY --
	%46 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i2 2
	%47 = bitcast i32* %46 to [4 x i32]*
	; -- start vol eval --
	%48 = zext i3 4 to i32
	; -- end vol eval --
	%49 = insertvalue [4 x i32] zeroinitializer, i32 10, 0
	%50 = insertvalue [4 x i32] %49, i32 20, 1
	%51 = insertvalue [4 x i32] %50, i32 30, 2
	%52 = insertvalue [4 x i32] %51, i32 40, 3
	store [4 x i32] %52, [4 x i32]* %47
	store i32 0, i32* %17
	br label %again_3
again_3:
	%53 = load i32, i32* %17
	%54 = icmp slt i32 %53, 10
	br i1 %54 , label %body_3, label %break_3
body_3:
	%55 = load i32, i32* %17
	%56 = load i32, i32* %17
	%57 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i32 %56
	%58 = load i32, i32* %57
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str7 to [0 x i8]*), i32 %55, i32 %58)
	%60 = load i32, i32* %17
	%61 = add i32 %60, 1
	store i32 %61, i32* %17
	br label %again_3
break_3:
	%62 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str8 to [0 x i8]*))
	%63 = alloca [10 x i32], align 4
	%64 = insertvalue [10 x i32] zeroinitializer, i32 10, 0
	%65 = insertvalue [10 x i32] %64, i32 20, 1
	%66 = insertvalue [10 x i32] %65, i32 30, 2
	%67 = insertvalue [10 x i32] %66, i32 40, 3
	%68 = insertvalue [10 x i32] %67, i32 50, 4
	%69 = insertvalue [10 x i32] %68, i32 60, 5
	%70 = insertvalue [10 x i32] %69, i32 70, 6
	%71 = insertvalue [10 x i32] %70, i32 80, 7
	%72 = insertvalue [10 x i32] %71, i32 90, 8
	%73 = insertvalue [10 x i32] %72, i32 100, 9
	store [10 x i32] %73, [10 x i32]* %63
	; -- STMT ASSIGN ARRAY --
	%74 = getelementptr inbounds [10 x i32], [10 x i32]* %63, i32 0, i2 2
	%75 = bitcast i32* %74 to [3 x i32]*
	; -- start vol eval --
	%76 = zext i2 3 to i32
	; -- end vol eval --
	; -- ZERO
	%77 = mul i32 %76, 4
	%78 = bitcast [3 x i32]* %75 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %78, i8 0, i32 %77, i1 0)
	store i32 0, i32* %17
	br label %again_4
again_4:
	%79 = load i32, i32* %17
	%80 = icmp slt i32 %79, 10
	br i1 %80 , label %body_4, label %break_4
body_4:
	%81 = load i32, i32* %17
	%82 = load i32, i32* %17
	%83 = getelementptr inbounds [10 x i32], [10 x i32]* %63, i32 0, i32 %82
	%84 = load i32, i32* %83
	%85 = bitcast i32 %84 to i32
	%86 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str9 to [0 x i8]*), i32 %81, i32 %85)
	%87 = load i32, i32* %17
	%88 = add i32 %87, 1
	store i32 %88, i32* %17
	br label %again_4
break_4:
	%89 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str10 to [0 x i8]*))
	%90 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str11 to [0 x i8]*))
	%91 = getelementptr inbounds [10 x i32], [10 x i32]* %63, i32 0, i2 2
	%92 = bitcast i32* %91 to [6 x i32]*
	%93 = bitcast [6 x i32]* %92 to [0 x i32]*
	call void @array_print([0 x i32]* %93, i32 6)
	%94 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str12 to [0 x i8]*))
	%95 = getelementptr inbounds [6 x i32], [6 x i32]* %92, i32 0, i32 0
	store i32 123, i32* %95
	%96 = bitcast [6 x i32]* %92 to [0 x i32]*
	call void @array_print([0 x i32]* %96, i32 6)
	%97 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str13 to [0 x i8]*))
	%98 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @str14 to [0 x i8]*))
	; за каким то хером это работает, то что мне сейчас нужно
	; но тут еще куча работы впереди
	%99 = alloca [0 x i32]*, align 8
	%100 = bitcast [10 x i32]* %63 to [0 x i32]*
	store [0 x i32]* %100, [0 x i32]** %99
	%101 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str15 to [0 x i8]*))
	%102 = load [0 x i32]*, [0 x i32]** %99
	call void @array_print([0 x i32]* %102, i32 10)
	%103 = alloca i32, align 4
	store i32 1, i32* %103
	%104 = load [0 x i32]*, [0 x i32]** %99
	%105 = load i32, i32* %103
	%106 = getelementptr inbounds [0 x i32], [0 x i32]* %104, i32 0, i32 %105
;
	%107 = bitcast i32* %106 to [0 x i32]*
	store [0 x i32]* %107, [0 x i32]** %99
	%108 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str16 to [0 x i8]*))
	%109 = load [0 x i32]*, [0 x i32]** %99
	call void @array_print([0 x i32]* %109, i32 10)
	%110 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str17 to [0 x i8]*))
	%111 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str18 to [0 x i8]*))
	; NOT WORKED NOW
	%112 = alloca [10 x i32], align 4
	%113 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%114 = insertvalue [10 x i32] %113, i32 1, 1
	%115 = insertvalue [10 x i32] %114, i32 2, 2
	%116 = insertvalue [10 x i32] %115, i32 3, 3
	%117 = insertvalue [10 x i32] %116, i32 4, 4
	%118 = insertvalue [10 x i32] %117, i32 5, 5
	%119 = insertvalue [10 x i32] %118, i32 6, 6
	%120 = insertvalue [10 x i32] %119, i32 7, 7
	%121 = insertvalue [10 x i32] %120, i32 8, 8
	%122 = insertvalue [10 x i32] %121, i32 9, 9
	store [10 x i32] %122, [10 x i32]* %112
	%123 = alloca i32, align 4
	store i32 4, i32* %123
	%124 = alloca i32, align 4
	store i32 7, i32* %124
	; -- STMT ASSIGN ARRAY --
	%125 = load i32, i32* %123
	%126 = getelementptr inbounds [10 x i32], [10 x i32]* %112, i32 0, i32 %125
	%127 = bitcast i32* %126 to [0 x i32]*
	; -- start vol eval --
	%128 = load i32, i32* %124
	%129 = load i32, i32* %123
	%130 = sub i32 %128, %129
	; -- end vol eval --
	; -- ZERO
	%131 = mul i32 %130, 4
	%132 = bitcast [0 x i32]* %127 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %132, i8 0, i32 %131, i1 0)
	%133 = bitcast [10 x i32]* %112 to [0 x i32]*
	call void @array_print([0 x i32]* %133, i32 10)
	%134 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str19 to [0 x i8]*))
	%135 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str20 to [0 x i8]*))
	%136 = alloca [5 x i32], align 4
	%137 = insertvalue [5 x i32] zeroinitializer, i32 10, 0
	%138 = insertvalue [5 x i32] %137, i32 20, 1
	%139 = insertvalue [5 x i32] %138, i32 30, 2
	%140 = insertvalue [5 x i32] %139, i32 40, 3
	%141 = insertvalue [5 x i32] %140, i32 50, 4
	store [5 x i32] %141, [5 x i32]* %136
	%142 = alloca [10 x i32], align 4
	%143 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%144 = insertvalue [10 x i32] %143, i32 1, 1
	%145 = insertvalue [10 x i32] %144, i32 2, 2
	%146 = insertvalue [10 x i32] %145, i32 3, 3
	%147 = insertvalue [10 x i32] %146, i32 4, 4
	%148 = insertvalue [10 x i32] %147, i32 5, 5
	%149 = insertvalue [10 x i32] %148, i32 6, 6
	%150 = insertvalue [10 x i32] %149, i32 7, 7
	%151 = insertvalue [10 x i32] %150, i32 8, 8
	%152 = insertvalue [10 x i32] %151, i32 9, 9
	store [10 x i32] %152, [10 x i32]* %142
	; test with let
	; -- STMT ASSIGN ARRAY --
	%153 = getelementptr inbounds [10 x i32], [10 x i32]* %142, i32 0, i2 3
	%154 = bitcast i32* %153 to [5 x i32]*
	; -- start vol eval --
	%155 = zext i3 5 to i32
	; -- end vol eval --
	%156 = insertvalue [5 x i32] zeroinitializer, i32 11, 0
	%157 = insertvalue [5 x i32] %156, i32 22, 1
	%158 = insertvalue [5 x i32] %157, i32 33, 2
	%159 = insertvalue [5 x i32] %158, i32 44, 3
	%160 = insertvalue [5 x i32] %159, i32 55, 4
	store [5 x i32] %160, [5 x i32]* %154
	%161 = bitcast [10 x i32]* %142 to [0 x i32]*
	call void @array_print([0 x i32]* %161, i32 10)
	%162 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str21 to [0 x i8]*))
	%163 = alloca [10 x i32], align 4
	%164 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%165 = insertvalue [10 x i32] %164, i32 10, 1
	%166 = insertvalue [10 x i32] %165, i32 20, 2
	%167 = insertvalue [10 x i32] %166, i32 30, 3
	%168 = insertvalue [10 x i32] %167, i32 40, 4
	%169 = insertvalue [10 x i32] %168, i32 50, 5
	%170 = insertvalue [10 x i32] %169, i32 60, 6
	%171 = insertvalue [10 x i32] %170, i32 70, 7
	%172 = insertvalue [10 x i32] %171, i32 80, 8
	%173 = insertvalue [10 x i32] %172, i32 90, 9
	store [10 x i32] %173, [10 x i32]* %163
	%174 = alloca i8, align 1
	store i8 111, i8* %174
	%175 = alloca i8, align 1
	store i8 222, i8* %175
	; test with var
	%176 = alloca i32, align 4
	store i32 3, i32* %176
	%177 = alloca i32, align 4
	store i32 5, i32* %177
	; -- STMT ASSIGN ARRAY --
	%178 = load i32, i32* %176
	%179 = getelementptr inbounds [10 x i32], [10 x i32]* %163, i32 0, i32 %178
	%180 = bitcast i32* %179 to [0 x i32]*
	; -- start vol eval --
	%181 = load i32, i32* %177
	%182 = load i32, i32* %176
	%183 = sub i32 %181, %182
	; -- end vol eval --
	%184 = load i8, i8* %174
	%185 = sext i8 %184 to i32
	%186 = load i8, i8* %175
	%187 = sext i8 %186 to i32
	%188 = insertvalue [2 x i32] zeroinitializer, i32 %185, 0
	%189 = insertvalue [2 x i32] %188, i32 %187, 1
	; cast_composite_to_composite
	; trunk
	%190 = alloca [2 x i32]
	store [2 x i32] %189, [2 x i32]* %190
	%191 = bitcast [2 x i32]* %190 to [0 x i32]*
	%192 = load [0 x i32], [0 x i32]* %191
	store [0 x i32] %192, [0 x i32]* %180
	%193 = bitcast [10 x i32]* %163 to [0 x i32]*
	call void @array_print([0 x i32]* %193, i32 10)
	ret %Int 0
}


