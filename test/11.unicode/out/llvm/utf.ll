
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

; MODULE: utf

; print includes
; end print includes
; -- strings --

define i8 @utf_utf32_to_utf8(i32 %c, [4 x i8]* %buf) {
	%1 = bitcast i32 %c to i32
	%2 = icmp ule i32 %1, 127
	br i1 %2 , label %then_0, label %else_0
then_0:
	%3 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 0
	%4 = trunc i32 %1 to i8
	store i8 %4, i8* %3
	ret i8 1
	br label %endif_0
else_0:
	%6 = icmp ule i32 %1, 2047
	br i1 %6 , label %then_1, label %else_1
then_1:
	%7 = lshr i32 %1, 6
	%8 = and i32 %7, 31
	%9 = lshr i32 %1, 0
	%10 = and i32 %9, 63
	%11 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 0
	%12 = or i32 192, %8
	%13 = trunc i32 %12 to i8
	store i8 %13, i8* %11
	%14 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 1
	%15 = or i32 128, %10
	%16 = trunc i32 %15 to i8
	store i8 %16, i8* %14
	ret i8 2
	br label %endif_1
else_1:
	%18 = icmp ule i32 %1, 65535
	br i1 %18 , label %then_2, label %else_2
then_2:
	%19 = lshr i32 %1, 12
	%20 = and i32 %19, 15
	%21 = lshr i32 %1, 6
	%22 = and i32 %21, 63
	%23 = lshr i32 %1, 0
	%24 = and i32 %23, 63
	%25 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 0
	%26 = or i32 224, %20
	%27 = trunc i32 %26 to i8
	store i8 %27, i8* %25
	%28 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 1
	%29 = or i32 128, %22
	%30 = trunc i32 %29 to i8
	store i8 %30, i8* %28
	%31 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 2
	%32 = or i32 128, %24
	%33 = trunc i32 %32 to i8
	store i8 %33, i8* %31
	ret i8 3
	br label %endif_2
else_2:
	%35 = icmp ule i32 %1, 1114111
	br i1 %35 , label %then_3, label %endif_3
then_3:
	%36 = lshr i32 %1, 18
	%37 = and i32 %36, 7
	%38 = lshr i32 %1, 12
	%39 = and i32 %38, 63
	%40 = lshr i32 %1, 6
	%41 = and i32 %40, 63
	%42 = lshr i32 %1, 0
	%43 = and i32 %42, 63
	%44 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 0
	%45 = or i32 240, %37
	%46 = trunc i32 %45 to i8
	store i8 %46, i8* %44
	%47 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 1
	%48 = or i32 128, %39
	%49 = trunc i32 %48 to i8
	store i8 %49, i8* %47
	%50 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 2
	%51 = or i32 128, %41
	%52 = trunc i32 %51 to i8
	store i8 %52, i8* %50
	%53 = getelementptr inbounds [4 x i8], [4 x i8]* %buf, i32 0, i32 3
	%54 = or i32 128, %43
	%55 = trunc i32 %54 to i8
	store i8 %55, i8* %53
	ret i8 4
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret i8 0
}

define i8 @utf_utf16_to_utf32([0 x i16]* %c, i32* %result) {
	%1 = getelementptr inbounds [0 x i16], [0 x i16]* %c, i32 0, i32 0
	%2 = load i16, i16* %1
	%3 = zext i16 %2 to i32
	%4 = icmp ult i32 %3, 55296
	%5 = icmp ugt i32 %3, 57343
	%6 = or i1 %4, %5
	br i1 %6 , label %then_0, label %else_0
then_0:
	%7 = bitcast i32 %3 to i32
	store i32 %7, i32* %result
	ret i8 1
	br label %endif_0
else_0:
	%9 = icmp uge i32 %3, 56320
	br i1 %9 , label %then_1, label %else_1
then_1:
	;error("Illegal code sequence")
	br label %endif_1
else_1:
	%10 = alloca i32, align 4
	%11 = and i32 %3, 1023
	%12 = shl i32 %11, 10
	store i32 %12, i32* %10
	%13 = getelementptr inbounds [0 x i16], [0 x i16]* %c, i32 0, i32 1
	%14 = load i16, i16* %13
	%15 = zext i16 %14 to i32
	%16 = icmp ult i32 %15, 56320
	%17 = icmp ugt i32 %15, 57343
	%18 = or i1 %16, %17
	br i1 %18 , label %then_2, label %else_2
then_2:
	;error("Illegal code sequence")
	br label %endif_2
else_2:
	%19 = load i32, i32* %10
	%20 = and i32 %15, 1023
	%21 = or i32 %19, %20
	store i32 %21, i32* %10
	%22 = load i32, i32* %10
	%23 = add i32 %22, 65536
	%24 = bitcast i32 %23 to i32
	store i32 %24, i32* %result
	ret i8 2
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret i8 0
}


