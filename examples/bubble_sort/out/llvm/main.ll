
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
@str1 = private constant [15 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 58, i8 10, i8 0]
@str2 = private constant [2 x i8] [i8 10, i8 0]
@str3 = private constant [14 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 97, i8 102, i8 116, i8 101, i8 114, i8 58, i8 10, i8 0]
@str4 = private constant [2 x i8] [i8 10, i8 0]
@str5 = private constant [2 x i8] [i8 10, i8 0]
@str6 = private constant [16 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
; -- endstrings --
@testArray = internal global [21 x %Int32] [
	%Int32 -3,
	%Int32 -5,
	%Int32 2,
	%Int32 1,
	%Int32 -1,
	%Int32 0,
	%Int32 -2,
	%Int32 3,
	%Int32 -4,
	%Int32 4,
	%Int32 11,
	%Int32 9,
	%Int32 6,
	%Int32 -7,
	%Int32 -8,
	%Int32 5,
	%Int32 7,
	%Int32 10,
	%Int32 8,
	%Int32 -6,
	%Int32 -9
]


; returns true if was swap
define internal %Bool @bubble_sort32_iter([0 x %Int32]* %array, %Nat32 %len) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = sub %Nat32 %len, 1
	%3 = load %Nat32, %Nat32* %1
	%4 = icmp ult %Nat32 %3, %2
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = load %Nat32, %Nat32* %1
	%6 = bitcast %Nat32 %5 to %Nat32
	%7 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %6
	%8 = load %Int32, %Int32* %7
	%9 = load %Nat32, %Nat32* %1
	%10 = add %Nat32 %9, 1
	%11 = bitcast %Nat32 %10 to %Nat32
	%12 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %11
	%13 = load %Int32, %Int32* %12
; if_0
	%14 = icmp sgt %Int32 %8, %13
	br %Bool %14 , label %then_0, label %endif_0
then_0:
	; swap
	%15 = load %Nat32, %Nat32* %1
	%16 = bitcast %Nat32 %15 to %Nat32
	%17 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %16
	store %Int32 %13, %Int32* %17
	%18 = load %Nat32, %Nat32* %1
	%19 = add %Nat32 %18, 1
	%20 = bitcast %Nat32 %19 to %Nat32
	%21 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %20
	store %Int32 %8, %Int32* %21
	ret %Bool 1
	br label %endif_0
endif_0:
	%23 = load %Nat32, %Nat32* %1
	%24 = add %Nat32 %23, 1
	store %Nat32 %24, %Nat32* %1
	br label %again_1
break_1:
	ret %Bool 0
}

define internal void @bubble_sort32([0 x %Int32]* %array, %Nat32 %len) noinline {
; while_1
	br label %again_1
again_1:
	%1 = call %Bool @bubble_sort32_iter([0 x %Int32]* %array, %Nat32 %len)
	br %Bool %1 , label %body_1, label %break_1
body_1:
	; continue iterations while is's necessary
	br label %again_1
break_1:
	ret void
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str1 to [0 x i8]*))
	%2 = bitcast [21 x %Int32]* @testArray to [0 x %Int32]*
	call void @print_array([0 x %Int32]* %2, %Nat32 21)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))

	; do sort
	%4 = bitcast [21 x %Int32]* @testArray to [0 x %Int32]*
	call void @bubble_sort32([0 x %Int32]* %4, %Nat32 21)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str3 to [0 x i8]*))
	%6 = bitcast [21 x %Int32]* @testArray to [0 x %Int32]*
	call void @print_array([0 x %Int32]* %6, %Nat32 21)
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
	ret %Int32 0
}

define internal void @print_array([0 x %Int32]* %array, %Nat32 %len) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str5 to [0 x i8]*))
	%2 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %2
; while_1
	br label %again_1
again_1:
	%3 = load %Nat32, %Nat32* %2
	%4 = icmp ult %Nat32 %3, %len
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = load %Nat32, %Nat32* %2
	%6 = load %Nat32, %Nat32* %2
	%7 = bitcast %Nat32 %6 to %Nat32
	%8 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %7
	%9 = load %Int32, %Int32* %8
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str6 to [0 x i8]*), %Nat32 %5, %Int32 %9)
	%11 = load %Nat32, %Nat32* %2
	%12 = add %Nat32 %11, 1
	store %Nat32 %12, %Nat32* %2
	br label %again_1
break_1:
	ret void
}


