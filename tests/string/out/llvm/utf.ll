
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
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

; MODULE: utf

; -- print includes --
; -- end print includes --
; -- print imports 'utf' --
; -- 0
; -- end print imports 'utf' --
; -- strings --
; -- endstrings --

; декодирует символ UTF-32 в последовательность UTF-8
define %Int8 @utf_utf32_to_utf8(%Char32 %c, [4 x %Char8]* %buf) {
	%1 = bitcast %Char32 %c to %Int32
	%2 = icmp ule %Int32 %1, 127
	br %Bool %2 , label %then_0, label %else_0
then_0:
	%3 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%4 = trunc %Int32 %1 to %Char8
	store %Char8 %4, %Char8* %3
	ret %Int8 1
	br label %endif_0
else_0:
	%6 = icmp ule %Int32 %1, 2047
	br %Bool %6 , label %then_1, label %else_1
then_1:
	%7 = bitcast %Int32 %1 to %Word32
	%8 = zext i8 6 to %Word32
	%9 = lshr %Word32 %7, %8
	%10 = and %Word32 %9, 31
	%11 = zext i8 0 to %Word32
	%12 = lshr %Word32 %7, %11
	%13 = and %Word32 %12, 63
	%14 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%15 = or %Word32 192, %10
	%16 = trunc %Word32 %15 to %Char8
	store %Char8 %16, %Char8* %14
	%17 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%18 = or %Word32 128, %13
	%19 = trunc %Word32 %18 to %Char8
	store %Char8 %19, %Char8* %17
	ret %Int8 2
	br label %endif_1
else_1:
	%21 = icmp ule %Int32 %1, 65535
	br %Bool %21 , label %then_2, label %else_2
then_2:
	%22 = bitcast %Int32 %1 to %Word32
	%23 = zext i8 12 to %Word32
	%24 = lshr %Word32 %22, %23
	%25 = and %Word32 %24, 15
	%26 = zext i8 6 to %Word32
	%27 = lshr %Word32 %22, %26
	%28 = and %Word32 %27, 63
	%29 = zext i8 0 to %Word32
	%30 = lshr %Word32 %22, %29
	%31 = and %Word32 %30, 63
	%32 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%33 = or %Word32 224, %25
	%34 = trunc %Word32 %33 to %Char8
	store %Char8 %34, %Char8* %32
	%35 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%36 = or %Word32 128, %28
	%37 = trunc %Word32 %36 to %Char8
	store %Char8 %37, %Char8* %35
	%38 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 2
	%39 = or %Word32 128, %31
	%40 = trunc %Word32 %39 to %Char8
	store %Char8 %40, %Char8* %38
	ret %Int8 3
	br label %endif_2
else_2:
	%42 = icmp ule %Int32 %1, 1114111
	br %Bool %42 , label %then_3, label %endif_3
then_3:
	%43 = bitcast %Int32 %1 to %Word32
	%44 = zext i8 18 to %Word32
	%45 = lshr %Word32 %43, %44
	%46 = and %Word32 %45, 7
	%47 = zext i8 12 to %Word32
	%48 = lshr %Word32 %43, %47
	%49 = and %Word32 %48, 63
	%50 = zext i8 6 to %Word32
	%51 = lshr %Word32 %43, %50
	%52 = and %Word32 %51, 63
	%53 = zext i8 0 to %Word32
	%54 = lshr %Word32 %43, %53
	%55 = and %Word32 %54, 63
	%56 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%57 = or %Word32 240, %46
	%58 = trunc %Word32 %57 to %Char8
	store %Char8 %58, %Char8* %56
	%59 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%60 = or %Word32 128, %49
	%61 = trunc %Word32 %60 to %Char8
	store %Char8 %61, %Char8* %59
	%62 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 2
	%63 = or %Word32 128, %52
	%64 = trunc %Word32 %63 to %Char8
	store %Char8 %64, %Char8* %62
	%65 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 3
	%66 = or %Word32 128, %55
	%67 = trunc %Word32 %66 to %Char8
	store %Char8 %67, %Char8* %65
	ret %Int8 4
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %Int8 0
}



; returns n-symbols from input stream
define %Int8 @utf_utf16_to_utf32([0 x %Char16]* %c, %Char32* %result) {
	%1 = getelementptr [0 x %Char16], [0 x %Char16]* %c, %Int32 0, %Int32 0
	%2 = load %Char16, %Char16* %1
	%3 = zext %Char16 %2 to %Int32
	%4 = icmp ult %Int32 %3, 55296
	%5 = icmp ugt %Int32 %3, 57343
	%6 = or %Bool %4, %5
	br %Bool %6 , label %then_0, label %else_0
then_0:
	%7 = bitcast %Int32 %3 to %Char32
	store %Char32 %7, %Char32* %result
	ret %Int8 1
	br label %endif_0
else_0:
	%9 = icmp uge %Int32 %3, 56320
	br %Bool %9 , label %then_1, label %else_1
then_1:
	;error("Illegal code sequence")
	br label %endif_1
else_1:
	%10 = alloca %Word32, align 4
	%11 = bitcast %Int32 %3 to %Word32
	%12 = and %Word32 %11, 1023
	%13 = zext i8 10 to %Word32
	%14 = shl %Word32 %12, %13
	store %Word32 %14, %Word32* %10
	%15 = getelementptr [0 x %Char16], [0 x %Char16]* %c, %Int32 0, %Int32 1
	%16 = load %Char16, %Char16* %15
	%17 = zext %Char16 %16 to %Int32
	%18 = icmp ult %Int32 %17, 56320
	%19 = icmp ugt %Int32 %17, 57343
	%20 = or %Bool %18, %19
	br %Bool %20 , label %then_2, label %else_2
then_2:
	;error("Illegal code sequence")
	br label %endif_2
else_2:
	%21 = bitcast %Int32 %17 to %Word32
	%22 = and %Word32 %21, 1023
	%23 = load %Word32, %Word32* %10
	%24 = or %Word32 %23, %22
	store %Word32 %24, %Word32* %10
	%25 = load %Word32, %Word32* %10
	%26 = bitcast %Word32 %25 to %Int32
	%27 = add %Int32 %26, 65536
	%28 = bitcast %Int32 %27 to %Char32
	store %Char32 %28, %Char32* %result
	ret %Int8 2
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %Int8 0
}


