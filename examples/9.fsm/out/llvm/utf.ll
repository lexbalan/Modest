
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

; MODULE: utf

; -- print includes --
; -- end print includes --
; -- print imports 'utf' --
; -- 0
; -- end print imports 'utf' --
; -- strings --
; -- endstrings --; utf.m
; algorithms from wikipedia
; (https://ru.wikipedia.org/wiki/UTF-16)

; декодирует символ UTF-32 в последовательность UTF-8
define %Nat8 @utf_utf32_to_utf8(%Char32 %c, [4 x %Char8]* %buf) {
	%1 = bitcast %Char32 %c to %Word32
; if_0
	%2 = bitcast %Word32 %1 to %Nat32
	%3 = icmp ule %Nat32 %2, 127
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%5 = trunc %Word32 %1 to %Char8
	store %Char8 %5, %Char8* %4
	ret %Nat8 1
	br label %endif_0
else_0:
; if_1
	%7 = bitcast %Word32 %1 to %Nat32
	%8 = icmp ule %Nat32 %7, 2047
	br %Bool %8 , label %then_1, label %else_1
then_1:
	%9 = zext i8 6 to %Word32
	%10 = lshr %Word32 %1, %9
	%11 = and %Word32 %10, 31
	%12 = zext i8 0 to %Word32
	%13 = lshr %Word32 %1, %12
	%14 = and %Word32 %13, 63
	%15 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%16 = or %Word32 192, %11
	%17 = trunc %Word32 %16 to %Char8
	store %Char8 %17, %Char8* %15
	%18 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%19 = or %Word32 128, %14
	%20 = trunc %Word32 %19 to %Char8
	store %Char8 %20, %Char8* %18
	ret %Nat8 2
	br label %endif_1
else_1:
; if_2
	%22 = bitcast %Word32 %1 to %Nat32
	%23 = icmp ule %Nat32 %22, 65535
	br %Bool %23 , label %then_2, label %else_2
then_2:
	%24 = zext i8 12 to %Word32
	%25 = lshr %Word32 %1, %24
	%26 = and %Word32 %25, 15
	%27 = zext i8 6 to %Word32
	%28 = lshr %Word32 %1, %27
	%29 = and %Word32 %28, 63
	%30 = zext i8 0 to %Word32
	%31 = lshr %Word32 %1, %30
	%32 = and %Word32 %31, 63
	%33 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%34 = or %Word32 224, %26
	%35 = trunc %Word32 %34 to %Char8
	store %Char8 %35, %Char8* %33
	%36 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%37 = or %Word32 128, %29
	%38 = trunc %Word32 %37 to %Char8
	store %Char8 %38, %Char8* %36
	%39 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 2
	%40 = or %Word32 128, %32
	%41 = trunc %Word32 %40 to %Char8
	store %Char8 %41, %Char8* %39
	ret %Nat8 3
	br label %endif_2
else_2:
; if_3
	%43 = bitcast %Word32 %1 to %Nat32
	%44 = icmp ule %Nat32 %43, 1114111
	br %Bool %44 , label %then_3, label %endif_3
then_3:
	%45 = zext i8 18 to %Word32
	%46 = lshr %Word32 %1, %45
	%47 = and %Word32 %46, 7
	%48 = zext i8 12 to %Word32
	%49 = lshr %Word32 %1, %48
	%50 = and %Word32 %49, 63
	%51 = zext i8 6 to %Word32
	%52 = lshr %Word32 %1, %51
	%53 = and %Word32 %52, 63
	%54 = zext i8 0 to %Word32
	%55 = lshr %Word32 %1, %54
	%56 = and %Word32 %55, 63
	%57 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 0
	%58 = or %Word32 240, %47
	%59 = trunc %Word32 %58 to %Char8
	store %Char8 %59, %Char8* %57
	%60 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 1
	%61 = or %Word32 128, %50
	%62 = trunc %Word32 %61 to %Char8
	store %Char8 %62, %Char8* %60
	%63 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 2
	%64 = or %Word32 128, %53
	%65 = trunc %Word32 %64 to %Char8
	store %Char8 %65, %Char8* %63
	%66 = getelementptr [4 x %Char8], [4 x %Char8]* %buf, %Int32 0, %Int32 3
	%67 = or %Word32 128, %56
	%68 = trunc %Word32 %67 to %Char8
	store %Char8 %68, %Char8* %66
	ret %Nat8 4
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %Nat8 0
}



; returns n-symbols from input stream
define %Nat8 @utf_utf16_to_utf32([0 x %Char16]* %c, %Char32* %result) {
	%1 = getelementptr [0 x %Char16], [0 x %Char16]* %c, %Int32 0, %Int32 0
	%2 = load %Char16, %Char16* %1
	%3 = zext %Char16 %2 to %Word32
; if_0
	%4 = bitcast %Word32 %3 to %Nat32
	%5 = icmp ult %Nat32 %4, 55296
	%6 = bitcast %Word32 %3 to %Nat32
	%7 = icmp ugt %Nat32 %6, 57343
	%8 = or %Bool %5, %7
	br %Bool %8 , label %then_0, label %else_0
then_0:
	%9 = bitcast %Word32 %3 to %Char32
	store %Char32 %9, %Char32* %result
	ret %Nat8 1
	br label %endif_0
else_0:
; if_1
	%11 = bitcast %Word32 %3 to %Nat32
	%12 = icmp uge %Nat32 %11, 56320
	br %Bool %12 , label %then_1, label %else_1
then_1:
	;error("Illegal code sequence")
	br label %endif_1
else_1:
	%13 = alloca %Word32, align 4
	%14 = and %Word32 %3, 1023
	%15 = zext i8 10 to %Word32
	%16 = shl %Word32 %14, %15
	store %Word32 %16, %Word32* %13
	%17 = getelementptr [0 x %Char16], [0 x %Char16]* %c, %Int32 0, %Int32 1
	%18 = load %Char16, %Char16* %17
	%19 = zext %Char16 %18 to %Word32
; if_2
	%20 = bitcast %Word32 %19 to %Nat32
	%21 = icmp ult %Nat32 %20, 56320
	%22 = bitcast %Word32 %19 to %Nat32
	%23 = icmp ugt %Nat32 %22, 57343
	%24 = or %Bool %21, %23
	br %Bool %24 , label %then_2, label %else_2
then_2:
	;error("Illegal code sequence")
	br label %endif_2
else_2:
	%25 = and %Word32 %19, 1023
	%26 = load %Word32, %Word32* %13
	%27 = or %Word32 %26, %25
	store %Word32 %27, %Word32* %13
	%28 = load %Word32, %Word32* %13
	%29 = bitcast %Word32 %28 to %Nat32
	%30 = add %Nat32 %29, 65536
	%31 = bitcast %Nat32 %30 to %Word32
	%32 = bitcast %Word32 %31 to %Char32
	store %Char32 %32, %Char32* %result
	ret %Nat8 2
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret %Nat8 0
}


