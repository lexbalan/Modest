
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

; MODULE: datetime

; -- print includes --

%Str = type %Str8;
%Char = type i8;
%ConstChar = type %Char;
%SignedChar = type i8;
%UnsignedChar = type i8;
%Short = type i16;
%UnsignedShort = type i16;
%Int = type i32;
%UnsignedInt = type i32;
%LongInt = type i64;
%UnsignedLongInt = type i64;
%Long = type i64;
%UnsignedLong = type i64;
%LongLong = type i64;
%UnsignedLongLong = type i64;
%LongLongInt = type i64;
%UnsignedLongLongInt = type i64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type i64;
%PtrDiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PIDT = type i32;
%UIDT = type i32;
%GIDT = type i32;

%TimeT = type i32;
%ClockT = type %UnsignedLong;
%StructTM = type {
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%Int, 
	%LongInt, 
	%ConstChar*
};


declare %ClockT @clock()
declare %Double @difftime(%TimeT %end, %TimeT %beginning)
declare %TimeT @mktime(%StructTM* %timeptr)
declare %TimeT @time(%TimeT* %timer)
declare %Char* @asctime(%StructTM* %timeptr)
declare %Char* @ctime(%TimeT* %timer)
declare %StructTM* @gmtime(%TimeT* %timer)
declare %StructTM* @localtime(%TimeT* %timer)
declare %SizeT @strftime(%Char* %ptr, %SizeT %maxsize, %ConstChar* %format, %StructTM* %timeptr)
declare %StructTM* @localtime_s(%TimeT* %timer, %StructTM* %tmptr)
declare %StructTM* @localtime_r(%TimeT* %timer, %StructTM* %tmptr)
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --

define %StructTM* @localTimeNow() {
	%1 = alloca %TimeT, align 4
	%2 = call %TimeT @time(%TimeT* %1)
	%3 = alloca %StructTM, align 8
	%4 = bitcast %StructTM* %3 to %StructTM*
	%5 = call %StructTM* @localtime_r(%TimeT* %1, %StructTM* %4)
	%6 = bitcast %StructTM* %5 to %StructTM*
	ret %StructTM* %6
}


%Date = type {
	i32, 
	i8, 
	i8
};

%Time = type {
	i8, 
	i8, 
	i8
};

%DateTime = type {
	i32, 
	i8, 
	i8, 
	i8, 
	i8, 
	i8
};


define %Time @datetime_timeNow() {
	%1 = call %StructTM* @localTimeNow()
	%2 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 2
	%3 = load %Int, %Int* %2
	%4 = trunc %Int %3 to i8
	%5 = insertvalue %Time zeroinitializer, i8 %4, 0
	%6 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 1
	%7 = load %Int, %Int* %6
	%8 = trunc %Int %7 to i8
	%9 = insertvalue %Time %5, i8 %8, 1
	%10 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 0
	%11 = load %Int, %Int* %10
	%12 = trunc %Int %11 to i8
	%13 = insertvalue %Time %9, i8 %12, 2
	ret %Time %13
}

define %Date @datetime_dateNow() {
	%1 = call %StructTM* @localTimeNow()
	%2 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 5
	%3 = load %Int, %Int* %2
	%4 = bitcast %Int %3 to i32
	%5 = add i32 %4, 1900
	%6 = insertvalue %Date zeroinitializer, i32 %5, 0
	%7 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 4
	%8 = load %Int, %Int* %7
	%9 = trunc %Int %8 to i8
	%10 = add i8 %9, 1
	%11 = insertvalue %Date %6, i8 %10, 1
	%12 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 3
	%13 = load %Int, %Int* %12
	%14 = trunc %Int %13 to i8
	%15 = insertvalue %Date %11, i8 %14, 2
	ret %Date %15
}

define %DateTime @datetime_dateTimeNow() {
	%1 = call %StructTM* @localTimeNow()
	%2 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 5
	%3 = load %Int, %Int* %2
	%4 = bitcast %Int %3 to i32
	%5 = add i32 %4, 1900
	%6 = insertvalue %DateTime zeroinitializer, i32 %5, 0
	%7 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 4
	%8 = load %Int, %Int* %7
	%9 = trunc %Int %8 to i8
	%10 = add i8 %9, 1
	%11 = insertvalue %DateTime %6, i8 %10, 1
	%12 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 3
	%13 = load %Int, %Int* %12
	%14 = trunc %Int %13 to i8
	%15 = insertvalue %DateTime %11, i8 %14, 2
	%16 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 2
	%17 = load %Int, %Int* %16
	%18 = trunc %Int %17 to i8
	%19 = insertvalue %DateTime %15, i8 %18, 3
	%20 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 1
	%21 = load %Int, %Int* %20
	%22 = trunc %Int %21 to i8
	%23 = insertvalue %DateTime %19, i8 %22, 4
	%24 = getelementptr inbounds %StructTM, %StructTM* %1, i32 0, i32 0
	%25 = load %Int, %Int* %24
	%26 = trunc %Int %25 to i8
	%27 = insertvalue %DateTime %23, i8 %26, 5
	ret %DateTime %27
}


