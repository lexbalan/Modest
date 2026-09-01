
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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
%Float16 = type half
%Float32 = type float
%Float64 = type double
%Fixed32 = type i32
%Fixed64 = type i64
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
%Float = type %Float32;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type %Int64;
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
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [15 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 58, i8 10, i8 0]
@.str2 = private constant [2 x i8] [i8 10, i8 0]
@.str3 = private constant [14 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 97, i8 102, i8 116, i8 101, i8 114, i8 58, i8 10, i8 0]
@.str4 = private constant [2 x i8] [i8 10, i8 0]
@.str5 = private constant [2 x i8] [i8 10, i8 0]
@.str6 = private constant [16 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
; -- endstrings --
@testArray = internal global [23 x %Int32] [
	%Int32 -3,
	%Int32 -5,
	%Int32 2,
	%Int32 -11,
	%Int32 1,
	%Int32 -1,
	%Int32 0,
	%Int32 -2,
	%Int32 3,
	%Int32 -4,
	%Int32 4,
	%Int32 11,
	%Int32 -10,
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
define internal %Bool @bubble_sort32_iter([0 x %Int32]* %array, %Nat32 %len) {
	%1 = alloca %Bool, align 1
	store %Bool 0, %Bool* %1
	%2 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %2
; while_1
	br label %again_1
again_1:
	%3 = sub %Nat32 %len, 1
	%4 = load %Nat32, %Nat32* %2
	%5 = icmp ult %Nat32 %4, %3
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %Nat32, %Nat32* %2
	%7 = bitcast %Nat32 %6 to %Nat32
	%8 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %7
	%9 = load %Int32, %Int32* %8
	%10 = load %Nat32, %Nat32* %2
	%11 = add %Nat32 %10, 1
	%12 = bitcast %Nat32 %11 to %Nat32
	%13 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %12
	%14 = load %Int32, %Int32* %13
; if_0
	%15 = icmp sgt %Int32 %9, %14
	br %Bool %15 , label %then_0, label %endif_0
then_0:
	%16 = load %Nat32, %Nat32* %2
	%17 = bitcast %Nat32 %16 to %Nat32
	%18 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %17
	store %Int32 %14, %Int32* %18
	%19 = load %Nat32, %Nat32* %2
	%20 = add %Nat32 %19, 1
	%21 = bitcast %Nat32 %20 to %Nat32
	%22 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %21
	store %Int32 %9, %Int32* %22
	store %Bool 1, %Bool* %1
	br label %endif_0
endif_0:
	%23 = load %Nat32, %Nat32* %2
	%24 = add %Nat32 %23, 1
	store %Nat32 %24, %Nat32* %2
	br label %again_1
break_1:
	%25 = load %Bool, %Bool* %1
	ret %Bool %25
}

define internal void @bubble_sort32([0 x %Int32]* %array, %Nat32 %len) {
; while_1
	br label %again_1
again_1:
	%1 = call %Bool @bubble_sort32_iter([0 x %Int32]* %array, %Nat32 %len)
	br %Bool %1 , label %body_1, label %break_1
body_1:
	br label %again_1
break_1:
	ret void
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str1 to [0 x i8]*))
	%2 = bitcast [23 x %Int32]* @testArray to [0 x %Int32]*
	call void @print_array([0 x %Int32]* %2, %Nat32 23)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str2 to [0 x i8]*))
	%4 = bitcast [23 x %Int32]* @testArray to [0 x %Int32]*
	call void @bubble_sort32([0 x %Int32]* %4, %Nat32 23)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str3 to [0 x i8]*))
	%6 = bitcast [23 x %Int32]* @testArray to [0 x %Int32]*
	call void @print_array([0 x %Int32]* %6, %Nat32 23)
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str4 to [0 x i8]*))
	ret %Int32 0
}

define internal void @print_array([0 x %Int32]* %array, %Nat32 %len) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str5 to [0 x i8]*))
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
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str6 to [0 x i8]*), %Nat32 %5, %Int32 %9)
	%11 = load %Nat32, %Nat32* %2
	%12 = add %Nat32 %11, 1
	store %Nat32 %12, %Nat32* %2
	br label %again_1
break_1:
	ret void
}


