
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
%Float = type %Float64;
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
@.str1 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str2 = private constant [15 x i8] [i8 99, i8 104, i8 101, i8 99, i8 107, i8 80, i8 97, i8 114, i8 97, i8 109, i8 115, i8 73, i8 111, i8 10, i8 0]
@.str3 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 115, i8 10, i8 0]
@.str4 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str5 = private constant [13 x i8] [i8 115, i8 49, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str6 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str7 = private constant [13 x i8] [i8 115, i8 50, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str8 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str9 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str10 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str11 = private constant [12 x i8] [i8 115, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str12 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str13 = private constant [23 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 32, i8 116, i8 111, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 10, i8 0]
@.str14 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str15 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str16 = private constant [35 x i8] [i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 111, i8 102, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 32, i8 116, i8 111, i8 32, i8 117, i8 110, i8 115, i8 105, i8 122, i8 101, i8 100, i8 32, i8 97, i8 114, i8 114, i8 97, i8 121, i8 10, i8 0]
@.str17 = private constant [8 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 10, i8 0]
@.str18 = private constant [7 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 10, i8 0]
@.str19 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str20 = private constant [19 x i8] [i8 122, i8 101, i8 114, i8 111, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 98, i8 121, i8 32, i8 118, i8 97, i8 114, i8 10, i8 0]
@.str21 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str22 = private constant [19 x i8] [i8 99, i8 111, i8 112, i8 121, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 32, i8 98, i8 121, i8 32, i8 118, i8 97, i8 114, i8 10, i8 0]
; -- endstrings --
define internal void @array_print([0 x %Int32]* %pa, %Nat32 %len) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ult %Nat32 %2, %len
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat32, %Nat32* %1
	%5 = load %Nat32, %Nat32* %1
	%6 = bitcast %Nat32 %5 to %Nat32
	%7 = getelementptr [0 x %Int32], [0 x %Int32]* %pa, %Int32 0, %Nat32 %6
	%8 = load %Int32, %Int32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str1 to [0 x i8]*), %Nat32 %4, %Int32 %8)
	%10 = load %Nat32, %Nat32* %1
	%11 = add %Nat32 %10, 1
	store %Nat32 %11, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

define internal void @array4intInc([4 x %Int32]* %0, [4 x %Int32] %__a) {
	%a = alloca [4 x %Int32]
	%2 = zext i8 4 to %Nat32
	store [4 x %Int32] %__a, [4 x %Int32]* %a
	%3 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 0
	%4 = load %Int32, %Int32* %3
	%5 = add %Int32 %4, 1
	%6 = insertvalue [4 x %Int32] zeroinitializer, %Int32 %5, 0
	%7 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 1
	%8 = load %Int32, %Int32* %7
	%9 = add %Int32 %8, 1
	%10 = insertvalue [4 x %Int32] %6, %Int32 %9, 1
	%11 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 2
	%12 = load %Int32, %Int32* %11
	%13 = add %Int32 %12, 1
	%14 = insertvalue [4 x %Int32] %10, %Int32 %13, 2
	%15 = getelementptr [4 x %Int32], [4 x %Int32]* %a, %Int32 0, %Int32 3
	%16 = load %Int32, %Int32* %15
	%17 = add %Int32 %16, 1
	%18 = insertvalue [4 x %Int32] %14, %Int32 %17, 3
	%19 = zext i8 4 to %Nat32
	store [4 x %Int32] %18, [4 x %Int32]* %0
	ret void
}

define internal void @checkParamsIo() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str2 to [0 x i8]*))
	%2 = alloca [8 x %Int32], align 4
	%3 = insertvalue [8 x %Int32] zeroinitializer, %Int32 1, 1
	%4 = insertvalue [8 x %Int32] %3, %Int32 2, 2
	%5 = insertvalue [8 x %Int32] %4, %Int32 3, 3
	%6 = insertvalue [8 x %Int32] %5, %Int32 4, 4
	%7 = insertvalue [8 x %Int32] %6, %Int32 5, 5
	%8 = insertvalue [8 x %Int32] %7, %Int32 6, 6
	%9 = insertvalue [8 x %Int32] %8, %Int32 7, 7
	%10 = zext i8 8 to %Nat32
	store [8 x %Int32] %9, [8 x %Int32]* %2
	%11 = zext i8 0 to %Nat32
	%12 = getelementptr [8 x %Int32], [8 x %Int32]* %2, %Int32 0, %Nat32 %11
	%13 = bitcast %Int32* %12 to [4 x %Int32]*
	%14 = zext i8 0 to %Nat32
	%15 = getelementptr [8 x %Int32], [8 x %Int32]* %2, %Int32 0, %Nat32 %14
	%16 = bitcast %Int32* %15 to [4 x %Int32]*
	%17 = load [4 x %Int32], [4 x %Int32]* %16; alloca memory for return value
	%18 = alloca [4 x %Int32]
	call void @array4intInc([4 x %Int32]* %18, [4 x %Int32] %17)
	%19 = load [4 x %Int32], [4 x %Int32]* %18
	%20 = zext i8 4 to %Nat32
	store [4 x %Int32] %19, [4 x %Int32]* %13
	%21 = zext i8 4 to %Nat32
	%22 = getelementptr [8 x %Int32], [8 x %Int32]* %2, %Int32 0, %Nat32 %21
	%23 = bitcast %Int32* %22 to [4 x %Int32]*
	%24 = zext i8 4 to %Nat32
	%25 = getelementptr [8 x %Int32], [8 x %Int32]* %2, %Int32 0, %Nat32 %24
	%26 = bitcast %Int32* %25 to [4 x %Int32]*
	%27 = load [4 x %Int32], [4 x %Int32]* %26; alloca memory for return value
	%28 = alloca [4 x %Int32]
	call void @array4intInc([4 x %Int32]* %28, [4 x %Int32] %27)
	%29 = load [4 x %Int32], [4 x %Int32]* %28
	%30 = zext i8 4 to %Nat32
	store [4 x %Int32] %29, [4 x %Int32]* %23
	%31 = bitcast [8 x %Int32]* %2 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %31, %Nat32 8)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str3 to [0 x i8]*))
	call void @checkParamsIo()
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str4 to [0 x i8]*))
	%3 = alloca [10 x %Int32], align 4
	%4 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%5 = insertvalue [10 x %Int32] %4, %Int32 2, 2
	%6 = insertvalue [10 x %Int32] %5, %Int32 3, 3
	%7 = insertvalue [10 x %Int32] %6, %Int32 4, 4
	%8 = insertvalue [10 x %Int32] %7, %Int32 5, 5
	%9 = insertvalue [10 x %Int32] %8, %Int32 6, 6
	%10 = insertvalue [10 x %Int32] %9, %Int32 7, 7
	%11 = insertvalue [10 x %Int32] %10, %Int32 8, 8
	%12 = insertvalue [10 x %Int32] %11, %Int32 9, 9
	%13 = zext i8 10 to %Nat32
	store [10 x %Int32] %12, [10 x %Int32]* %3
	%14 = zext i8 1 to %Nat32
	%15 = getelementptr [10 x %Int32], [10 x %Int32]* %3, %Int32 0, %Nat32 %14
	%16 = bitcast %Int32* %15 to [1 x %Int32]*
	%17 = load [1 x %Int32], [1 x %Int32]* %16
	%18 = alloca [1 x %Int32]
	%19 = zext i8 1 to %Nat32
	store [1 x %Int32] %17, [1 x %Int32]* %18
	%20 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %20
; while_1
	br label %again_1
again_1:
	%21 = load %Nat32, %Nat32* %20
	%22 = icmp ult %Nat32 %21, 1
	br %Bool %22 , label %body_1, label %break_1
body_1:
	%23 = load %Nat32, %Nat32* %20
	%24 = load %Nat32, %Nat32* %20
	%25 = bitcast %Nat32 %24 to %Nat32
	%26 = getelementptr [1 x %Int32], [1 x %Int32]* %18, %Int32 0, %Nat32 %25
	%27 = load %Int32, %Int32* %26
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str5 to [0 x i8]*), %Nat32 %23, %Int32 %27)
	%29 = load %Nat32, %Nat32* %20
	%30 = add %Nat32 %29, 1
	store %Nat32 %30, %Nat32* %20
	br label %again_1
break_1:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str6 to [0 x i8]*))
	%32 = zext i8 5 to %Nat32
	%33 = getelementptr [10 x %Int32], [10 x %Int32]* %3, %Int32 0, %Nat32 %32
;
	%34 = bitcast %Int32* %33 to [3 x %Int32]*
	%35 = load [3 x %Int32], [3 x %Int32]* %34
	%36 = alloca [3 x %Int32]
	%37 = zext i8 3 to %Nat32
	store [3 x %Int32] %35, [3 x %Int32]* %36
	store %Nat32 0, %Nat32* %20
; while_2
	br label %again_2
again_2:
	%38 = load %Nat32, %Nat32* %20
	%39 = icmp ult %Nat32 %38, 3
	br %Bool %39 , label %body_2, label %break_2
body_2:
	%40 = load %Nat32, %Nat32* %20
	%41 = load %Nat32, %Nat32* %20
	%42 = bitcast %Nat32 %41 to %Nat32
	%43 = getelementptr [3 x %Int32], [3 x %Int32]* %36, %Int32 0, %Nat32 %42
	%44 = load %Int32, %Int32* %43
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str7 to [0 x i8]*), %Nat32 %40, %Int32 %44)
	%46 = load %Nat32, %Nat32* %20
	%47 = add %Nat32 %46, 1
	store %Nat32 %47, %Nat32* %20
	br label %again_2
break_2:
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str8 to [0 x i8]*))
	%49 = alloca [1 x %Int32], align 4
	%50 = load [1 x %Int32], [1 x %Int32]* %18
	%51 = zext i8 1 to %Nat32
	store [1 x %Int32] %50, [1 x %Int32]* %49
	%52 = alloca [3 x %Int32], align 4
	%53 = load [3 x %Int32], [3 x %Int32]* %36
	%54 = zext i8 3 to %Nat32
	store [3 x %Int32] %53, [3 x %Int32]* %52
	%55 = zext i8 2 to %Nat32
	%56 = getelementptr [10 x %Int32], [10 x %Int32]* %3, %Int32 0, %Nat32 %55
	%57 = bitcast %Int32* %56 to [4 x %Int32]*
	%58 = insertvalue [4 x %Int32] zeroinitializer, %Int32 10, 0
	%59 = insertvalue [4 x %Int32] %58, %Int32 20, 1
	%60 = insertvalue [4 x %Int32] %59, %Int32 30, 2
	%61 = insertvalue [4 x %Int32] %60, %Int32 40, 3
	%62 = zext i8 4 to %Nat32
	store [4 x %Int32] %61, [4 x %Int32]* %57
	store %Nat32 0, %Nat32* %20
; while_3
	br label %again_3
again_3:
	%63 = load %Nat32, %Nat32* %20
	%64 = icmp ult %Nat32 %63, 10
	br %Bool %64 , label %body_3, label %break_3
body_3:
	%65 = load %Nat32, %Nat32* %20
	%66 = load %Nat32, %Nat32* %20
	%67 = bitcast %Nat32 %66 to %Nat32
	%68 = getelementptr [10 x %Int32], [10 x %Int32]* %3, %Int32 0, %Nat32 %67
	%69 = load %Int32, %Int32* %68
	%70 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str9 to [0 x i8]*), %Nat32 %65, %Int32 %69)
	%71 = load %Nat32, %Nat32* %20
	%72 = add %Nat32 %71, 1
	store %Nat32 %72, %Nat32* %20
	br label %again_3
break_3:
	%73 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str10 to [0 x i8]*))
	%74 = alloca [10 x %Int32], align 1
	%75 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 0
	%76 = insertvalue [10 x %Int32] %75, %Int32 20, 1
	%77 = insertvalue [10 x %Int32] %76, %Int32 30, 2
	%78 = insertvalue [10 x %Int32] %77, %Int32 40, 3
	%79 = insertvalue [10 x %Int32] %78, %Int32 50, 4
	%80 = insertvalue [10 x %Int32] %79, %Int32 60, 5
	%81 = insertvalue [10 x %Int32] %80, %Int32 70, 6
	%82 = insertvalue [10 x %Int32] %81, %Int32 80, 7
	%83 = insertvalue [10 x %Int32] %82, %Int32 90, 8
	%84 = insertvalue [10 x %Int32] %83, %Int32 100, 9
	%85 = zext i8 10 to %Nat32
	store [10 x %Int32] %84, [10 x %Int32]* %74
	%86 = zext i8 2 to %Nat32
	%87 = getelementptr [10 x %Int32], [10 x %Int32]* %74, %Int32 0, %Nat32 %86
	%88 = bitcast %Int32* %87 to [3 x %Int32]*
	%89 = zext i8 3 to %Nat32
	%90 = mul %Nat32 %89, 4
	%91 = bitcast [3 x %Int32]* %88 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %91, i8 0, %Nat32 %90, i1 0)
	store %Nat32 0, %Nat32* %20
; while_4
	br label %again_4
again_4:
	%92 = load %Nat32, %Nat32* %20
	%93 = icmp ult %Nat32 %92, 10
	br %Bool %93 , label %body_4, label %break_4
body_4:
	%94 = load %Nat32, %Nat32* %20
	%95 = load %Nat32, %Nat32* %20
	%96 = bitcast %Nat32 %95 to %Nat32
	%97 = getelementptr [10 x %Int32], [10 x %Int32]* %74, %Int32 0, %Nat32 %96
	%98 = load %Int32, %Int32* %97
	%99 = bitcast %Int32 %98 to %Nat32
	%100 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str11 to [0 x i8]*), %Nat32 %94, %Nat32 %99)
	%101 = load %Nat32, %Nat32* %20
	%102 = add %Nat32 %101, 1
	store %Nat32 %102, %Nat32* %20
	br label %again_4
break_4:
	%103 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str12 to [0 x i8]*))
	%104 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str13 to [0 x i8]*))
	%105 = zext i8 2 to %Nat32
	%106 = getelementptr [10 x %Int32], [10 x %Int32]* %74, %Int32 0, %Nat32 %105
	%107 = bitcast %Int32* %106 to [6 x %Int32]*
	%108 = bitcast [6 x %Int32]* %107 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %108, %Nat32 6)
	%109 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str14 to [0 x i8]*))
	%110 = getelementptr [6 x %Int32], [6 x %Int32]* %107, %Int32 0, %Int32 0
	store %Int32 123, %Int32* %110
	%111 = bitcast [6 x %Int32]* %107 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %111, %Nat32 6)
	%112 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str15 to [0 x i8]*))
	%113 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @.str16 to [0 x i8]*))
	%114 = alloca [0 x %Int32]*, align 8
	%115 = bitcast [10 x %Int32]* %74 to [0 x %Int32]*
	store [0 x %Int32]* %115, [0 x %Int32]** %114
	%116 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str17 to [0 x i8]*))
	%117 = load [0 x %Int32]*, [0 x %Int32]** %114
	call void @array_print([0 x %Int32]* %117, %Nat32 10)
	%118 = alloca %Int32, align 4
	store %Int32 1, %Int32* %118
	%119 = load [0 x %Int32]*, [0 x %Int32]** %114
	%120 = load %Int32, %Int32* %118
	%121 = getelementptr [0 x %Int32], [0 x %Int32]* %119, %Int32 0, %Int32 %120
;
	%122 = bitcast %Int32* %121 to [0 x %Int32]*
	%123 = bitcast [0 x %Int32]* %122 to [0 x %Int32]*
	store [0 x %Int32]* %123, [0 x %Int32]** %114
	%124 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @.str18 to [0 x i8]*))
	%125 = load [0 x %Int32]*, [0 x %Int32]** %114
	call void @array_print([0 x %Int32]* %125, %Nat32 10)
	%126 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str19 to [0 x i8]*))
	%127 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @.str20 to [0 x i8]*))
	%128 = alloca [10 x %Int32], align 1
	%129 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%130 = insertvalue [10 x %Int32] %129, %Int32 2, 2
	%131 = insertvalue [10 x %Int32] %130, %Int32 3, 3
	%132 = insertvalue [10 x %Int32] %131, %Int32 4, 4
	%133 = insertvalue [10 x %Int32] %132, %Int32 5, 5
	%134 = insertvalue [10 x %Int32] %133, %Int32 6, 6
	%135 = insertvalue [10 x %Int32] %134, %Int32 7, 7
	%136 = insertvalue [10 x %Int32] %135, %Int32 8, 8
	%137 = insertvalue [10 x %Int32] %136, %Int32 9, 9
	%138 = zext i8 10 to %Nat32
	store [10 x %Int32] %137, [10 x %Int32]* %128
	%139 = alloca %Int32, align 4
	store %Int32 4, %Int32* %139
	%140 = alloca %Int32, align 4
	store %Int32 7, %Int32* %140
	%141 = load %Int32, %Int32* %139
	%142 = getelementptr [10 x %Int32], [10 x %Int32]* %128, %Int32 0, %Int32 %141
	%143 = bitcast %Int32* %142 to [0 x %Int32]*
	%144 = load %Int32, %Int32* %140
	%145 = load %Int32, %Int32* %139
	%146 = sub %Int32 %144, %145
	%147 = mul %Int32 %146, 4
	%148 = bitcast [0 x %Int32]* %143 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %148, i8 0, %Int32 %147, i1 0)
	%149 = bitcast [10 x %Int32]* %128 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %149, %Nat32 10)
	%150 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @.str21 to [0 x i8]*))
	%151 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @.str22 to [0 x i8]*))
	%152 = alloca [5 x %Int32], align 1
	%153 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%154 = insertvalue [5 x %Int32] %153, %Int32 20, 1
	%155 = insertvalue [5 x %Int32] %154, %Int32 30, 2
	%156 = insertvalue [5 x %Int32] %155, %Int32 40, 3
	%157 = insertvalue [5 x %Int32] %156, %Int32 50, 4
	%158 = zext i8 5 to %Nat32
	store [5 x %Int32] %157, [5 x %Int32]* %152
	%159 = alloca [10 x %Int32], align 1
	%160 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%161 = insertvalue [10 x %Int32] %160, %Int32 2, 2
	%162 = insertvalue [10 x %Int32] %161, %Int32 3, 3
	%163 = insertvalue [10 x %Int32] %162, %Int32 4, 4
	%164 = insertvalue [10 x %Int32] %163, %Int32 5, 5
	%165 = insertvalue [10 x %Int32] %164, %Int32 6, 6
	%166 = insertvalue [10 x %Int32] %165, %Int32 7, 7
	%167 = insertvalue [10 x %Int32] %166, %Int32 8, 8
	%168 = insertvalue [10 x %Int32] %167, %Int32 9, 9
	%169 = zext i8 10 to %Nat32
	store [10 x %Int32] %168, [10 x %Int32]* %159
	%170 = zext i8 3 to %Nat32
	%171 = getelementptr [10 x %Int32], [10 x %Int32]* %159, %Int32 0, %Nat32 %170
	%172 = bitcast %Int32* %171 to [5 x %Int32]*
	%173 = insertvalue [5 x %Int32] zeroinitializer, %Int32 11, 0
	%174 = insertvalue [5 x %Int32] %173, %Int32 22, 1
	%175 = insertvalue [5 x %Int32] %174, %Int32 33, 2
	%176 = insertvalue [5 x %Int32] %175, %Int32 44, 3
	%177 = insertvalue [5 x %Int32] %176, %Int32 55, 4
	%178 = zext i8 5 to %Nat32
	store [5 x %Int32] %177, [5 x %Int32]* %172
	%179 = bitcast [10 x %Int32]* %159 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %179, %Nat32 10)
	ret %Int 0
}


