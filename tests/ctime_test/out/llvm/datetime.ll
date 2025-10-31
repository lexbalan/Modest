
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

; MODULE: datetime

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included time
%TimeT = type %Int32;
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
; -- endstrings --

define internal %StructTM* @localTimeNow() {
	%1 = alloca %TimeT, align 4
	%2 = call %TimeT @time(%TimeT* %1)
	%3 = alloca %StructTM, align 8
	%4 = bitcast %StructTM* %3 to %StructTM*
	%5 = call %StructTM* @localtime_r(%TimeT* %1, %StructTM* %4)
	%6 = bitcast %StructTM* %5 to %StructTM*
	ret %StructTM* %6
}


%datetime_Date = type {
	%Int32,
	%Int8,
	%Int8
};

%datetime_Time = type {
	%Int8,
	%Int8,
	%Int8
};

%datetime_DateTime = type {
	%Int32,
	%Int8,
	%Int8,
	%Int8,
	%Int8,
	%Int8
};


define %datetime_Time @datetime_timeNow() {
	%1 = call %StructTM* @localTimeNow()
	%2 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 2
	%3 = load %Int, %Int* %2
	%4 = trunc %Int %3 to %Int8
	%5 = insertvalue %datetime_Time zeroinitializer, %Int8 %4, 0
	%6 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 1
	%7 = load %Int, %Int* %6
	%8 = trunc %Int %7 to %Int8
	%9 = insertvalue %datetime_Time %5, %Int8 %8, 1
	%10 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 0
	%11 = load %Int, %Int* %10
	%12 = trunc %Int %11 to %Int8
	%13 = insertvalue %datetime_Time %9, %Int8 %12, 2
	ret %datetime_Time %13
}

define %datetime_Date @datetime_dateNow() {
	%1 = call %StructTM* @localTimeNow()
	%2 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 5
	%3 = load %Int, %Int* %2
	%4 = bitcast %Int %3 to %Int32
	%5 = add %Int32 %4, 1900
	%6 = insertvalue %datetime_Date zeroinitializer, %Int32 %5, 0
	%7 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 4
	%8 = load %Int, %Int* %7
	%9 = trunc %Int %8 to %Int8
	%10 = add %Int8 %9, 1
	%11 = insertvalue %datetime_Date %6, %Int8 %10, 1
	%12 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 3
	%13 = load %Int, %Int* %12
	%14 = trunc %Int %13 to %Int8
	%15 = insertvalue %datetime_Date %11, %Int8 %14, 2
	ret %datetime_Date %15
}

define %datetime_DateTime @datetime_dateTimeNow() {
	%1 = call %StructTM* @localTimeNow()
	%2 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 5
	%3 = load %Int, %Int* %2
	%4 = bitcast %Int %3 to %Int32
	%5 = add %Int32 %4, 1900
	%6 = insertvalue %datetime_DateTime zeroinitializer, %Int32 %5, 0
	%7 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 4
	%8 = load %Int, %Int* %7
	%9 = trunc %Int %8 to %Int8
	%10 = add %Int8 %9, 1
	%11 = insertvalue %datetime_DateTime %6, %Int8 %10, 1
	%12 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 3
	%13 = load %Int, %Int* %12
	%14 = trunc %Int %13 to %Int8
	%15 = insertvalue %datetime_DateTime %11, %Int8 %14, 2
	%16 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 2
	%17 = load %Int, %Int* %16
	%18 = trunc %Int %17 to %Int8
	%19 = insertvalue %datetime_DateTime %15, %Int8 %18, 3
	%20 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 1
	%21 = load %Int, %Int* %20
	%22 = trunc %Int %21 to %Int8
	%23 = insertvalue %datetime_DateTime %19, %Int8 %22, 4
	%24 = getelementptr inbounds %StructTM, %StructTM* %1, %Int32 0, %Int32 0
	%25 = load %Int, %Int* %24
	%26 = trunc %Int %25 to %Int8
	%27 = insertvalue %datetime_DateTime %23, %Int8 %26, 5
	ret %datetime_DateTime %27
}


