
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

; MODULE: main

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [7 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 33, i8 0]
@str2 = private constant [7 x i16] [i16 72, i16 101, i16 108, i16 108, i16 111, i16 33, i16 0]
@str3 = private constant [7 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 33, i32 0]
@str4 = private constant [12 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str5 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 39, i8 37, i8 99, i8 39, i8 10, i8 0]
; -- endstrings --
@c0 = constant [10 x i8] [
	i8 0,
	i8 1,
	i8 2,
	i8 3,
	i8 4,
	i8 5,
	i8 6,
	i8 7,
	i8 8,
	i8 9
]
@arr0 = internal global [10 x %Int32] zeroinitializer
@arr1 = internal global [10 x %Int32] [
	%Int32 0,
	%Int32 1,
	%Int32 2,
	%Int32 3,
	%Int32 4,
	%Int32 5,
	%Int32 6,
	%Int32 7,
	%Int32 8,
	%Int32 9
]
@arr2 = internal global [10 x %Char32] [
	%Char32 72,
	%Char32 101,
	%Char32 108,
	%Char32 108,
	%Char32 111,
	%Char32 33,
	%Char32 0,
	%Char32 0,
	%Char32 0,
	%Char32 0
]


;func f0 (x: []Int32) -> []Int32 {
;	var aa: []Int32
;	var ab: [0]Int32
;}
define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str4 to [0 x i8]*))
	%2 = alloca [10 x %Int32], align 1
	%3 = alloca [10 x %Int32], align 1
	%4 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 1
	%5 = insertvalue [10 x %Int32] %4, %Int32 20, 2
	%6 = insertvalue [10 x %Int32] %5, %Int32 30, 3
	%7 = insertvalue [10 x %Int32] %6, %Int32 40, 4
	%8 = insertvalue [10 x %Int32] %7, %Int32 50, 5
	%9 = insertvalue [10 x %Int32] %8, %Int32 60, 6
	%10 = insertvalue [10 x %Int32] %9, %Int32 70, 7
	%11 = insertvalue [10 x %Int32] %10, %Int32 80, 8
	%12 = insertvalue [10 x %Int32] %11, %Int32 90, 9
	%13 = zext i8 10 to %Nat32
	store [10 x %Int32] %12, [10 x %Int32]* %3
	%14 = alloca [10 x %Char32], align 1
	%15 = load [10 x %Char32], [10 x %Char32]* @arr2
	%16 = zext i8 10 to %Nat32
	store [10 x %Char32] %15, [10 x %Char32]* %14
	%17 = load [10 x %Char32], [10 x %Char32]* %14
	call void @printArrayOf10Char32([10 x %Char32] %17)
	%18 = load [10 x %Int32], [10 x %Int32]* @arr1
	%19 = load [10 x %Int32], [10 x %Int32]* %3; alloca memory for return value
	%20 = alloca [10 x %Int32]
	call void @sum10IntArrays([10 x %Int32]* %20, [10 x %Int32] %18, [10 x %Int32] %19)
	%21 = load [10 x %Int32], [10 x %Int32]* %20
	%22 = zext i8 10 to %Nat32
	store [10 x %Int32] %21, [10 x %Int32]* %2
	%23 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %23
; while_1
	br label %again_1
again_1:
	%24 = load %Nat32, %Nat32* %23
	%25 = icmp ult %Nat32 %24, 10
	br %Bool %25 , label %body_1, label %break_1
body_1:
	%26 = load %Nat32, %Nat32* %23
	%27 = load %Nat32, %Nat32* %23
	%28 = bitcast %Nat32 %27 to %Nat32
	%29 = getelementptr [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Nat32 %28
	%30 = load %Int32, %Int32* %29
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str5 to [0 x i8]*), %Nat32 %26, %Int32 %30)
	%32 = load %Nat32, %Nat32* %23
	%33 = add %Nat32 %32, 1
	store %Nat32 %33, %Nat32* %23
	br label %again_1
break_1:
	ret %Int 0
}

define internal void @printArrayOf10Char32([10 x %Char32] %__a) {
	%a = alloca [10 x %Char32]
	%1 = zext i8 10 to %Nat32
	store [10 x %Char32] %__a, [10 x %Char32]* %a
	%2 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %2
; while_1
	br label %again_1
again_1:
	%3 = load %Nat32, %Nat32* %2
	%4 = icmp ult %Nat32 %3, 10
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = load %Nat32, %Nat32* %2
	%6 = load %Nat32, %Nat32* %2
	%7 = bitcast %Nat32 %6 to %Nat32
	%8 = getelementptr [10 x %Char32], [10 x %Char32]* %a, %Int32 0, %Nat32 %7
	%9 = load %Char32, %Char32* %8
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), %Nat32 %5, %Char32 %9)
	%11 = load %Nat32, %Nat32* %2
	%12 = add %Nat32 %11, 1
	store %Nat32 %12, %Nat32* %2
	br label %again_1
break_1:
	ret void
}

define internal void @sum10IntArrays([10 x %Int32]* %0, [10 x %Int32] %__a, [10 x %Int32] %__b) {
	%a = alloca [10 x %Int32]
	%2 = zext i8 10 to %Nat32
	store [10 x %Int32] %__a, [10 x %Int32]* %a
	%b = alloca [10 x %Int32]
	%3 = zext i8 10 to %Nat32
	store [10 x %Int32] %__b, [10 x %Int32]* %b
	%4 = alloca [10 x %Int32], align 1
	%5 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %5
; while_1
	br label %again_1
again_1:
	%6 = load %Nat32, %Nat32* %5
	%7 = icmp ult %Nat32 %6, 10
	br %Bool %7 , label %body_1, label %break_1
body_1:
	%8 = load %Nat32, %Nat32* %5
	%9 = bitcast %Nat32 %8 to %Nat32
	%10 = getelementptr [10 x %Int32], [10 x %Int32]* %4, %Int32 0, %Nat32 %9
	%11 = load %Nat32, %Nat32* %5
	%12 = bitcast %Nat32 %11 to %Nat32
	%13 = getelementptr [10 x %Int32], [10 x %Int32]* %a, %Int32 0, %Nat32 %12
	%14 = load %Nat32, %Nat32* %5
	%15 = bitcast %Nat32 %14 to %Nat32
	%16 = getelementptr [10 x %Int32], [10 x %Int32]* %b, %Int32 0, %Nat32 %15
	%17 = load %Int32, %Int32* %13
	%18 = load %Int32, %Int32* %16
	%19 = add %Int32 %17, %18
	store %Int32 %19, %Int32* %10
	%20 = load %Nat32, %Nat32* %5
	%21 = add %Nat32 %20, 1
	store %Nat32 %21, %Nat32* %5
	br label %again_1
break_1:
	%22 = load [10 x %Int32], [10 x %Int32]* %4
	%23 = zext i8 10 to %Nat32
	store [10 x %Int32] %22, [10 x %Int32]* %0
	ret void
}


