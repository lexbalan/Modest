
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
; -- endstrings --; tests/slices/src/main.m
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
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*), %Nat32 %4, %Int32 %8)
	%10 = load %Nat32, %Nat32* %1
	%11 = add %Nat32 %10, 1
	store %Nat32 %11, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*))

	;
	; by value
	;
	%2 = alloca [10 x %Int32], align 1
	%3 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%4 = insertvalue [10 x %Int32] %3, %Int32 2, 2
	%5 = insertvalue [10 x %Int32] %4, %Int32 3, 3
	%6 = insertvalue [10 x %Int32] %5, %Int32 4, 4
	%7 = insertvalue [10 x %Int32] %6, %Int32 5, 5
	%8 = insertvalue [10 x %Int32] %7, %Int32 6, 6
	%9 = insertvalue [10 x %Int32] %8, %Int32 7, 7
	%10 = insertvalue [10 x %Int32] %9, %Int32 8, 8
	%11 = insertvalue [10 x %Int32] %10, %Int32 9, 9
	%12 = zext i8 10 to %Nat32
	store [10 x %Int32] %11, [10 x %Int32]* %2
	%13 = zext i8 1 to %Nat32
	%14 = getelementptr [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Nat32 %13
	%15 = bitcast %Int32* %14 to [1 x %Int32]*
	%16 = load [1 x %Int32], [1 x %Int32]* %15
	%17 = alloca [1 x %Int32]
	%18 = zext i8 1 to %Nat32
	store [1 x %Int32] %16, [1 x %Int32]* %17
	%19 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %19
; while_1
	br label %again_1
again_1:
	%20 = load %Nat32, %Nat32* %19
	%21 = icmp ult %Nat32 %20, 1
	br %Bool %21 , label %body_1, label %break_1
body_1:
	%22 = load %Nat32, %Nat32* %19
	%23 = load %Nat32, %Nat32* %19
	%24 = bitcast %Nat32 %23 to %Nat32
	%25 = getelementptr [1 x %Int32], [1 x %Int32]* %17, %Int32 0, %Nat32 %24
	%26 = load %Int32, %Int32* %25
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), %Nat32 %22, %Int32 %26)
	%28 = load %Nat32, %Nat32* %19
	%29 = add %Nat32 %28, 1
	store %Nat32 %29, %Nat32* %19
	br label %again_1
break_1:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str4 to [0 x i8]*))

	;
	; by ptr
	;
	%31 = zext i8 5 to %Nat32
	%32 = getelementptr [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Nat32 %31
;
	%33 = bitcast %Int32* %32 to [3 x %Int32]*
	%34 = load [3 x %Int32], [3 x %Int32]* %33
	%35 = alloca [3 x %Int32]
	%36 = zext i8 3 to %Nat32
	store [3 x %Int32] %34, [3 x %Int32]* %35
	store %Nat32 0, %Nat32* %19
; while_2
	br label %again_2
again_2:
	%37 = load %Nat32, %Nat32* %19
	%38 = icmp ult %Nat32 %37, 3
	br %Bool %38 , label %body_2, label %break_2
body_2:
	%39 = load %Nat32, %Nat32* %19
	%40 = load %Nat32, %Nat32* %19
	%41 = bitcast %Nat32 %40 to %Nat32
	%42 = getelementptr [3 x %Int32], [3 x %Int32]* %35, %Int32 0, %Nat32 %41
	%43 = load %Int32, %Int32* %42
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), %Nat32 %39, %Int32 %43)
	%45 = load %Nat32, %Nat32* %19
	%46 = add %Nat32 %45, 1
	store %Nat32 %46, %Nat32* %19
	br label %again_2
break_2:
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str6 to [0 x i8]*))
	%48 = alloca [1 x %Int32], align 1
	%49 = load [1 x %Int32], [1 x %Int32]* %17
	%50 = zext i8 1 to %Nat32
	store [1 x %Int32] %49, [1 x %Int32]* %48
	%51 = alloca [3 x %Int32], align 1
	%52 = load [3 x %Int32], [3 x %Int32]* %35
	%53 = zext i8 3 to %Nat32
	store [3 x %Int32] %52, [3 x %Int32]* %51
	%54 = zext i8 2 to %Nat32
	%55 = getelementptr [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Nat32 %54
	%56 = bitcast %Int32* %55 to [4 x %Int32]*
	%57 = insertvalue [4 x %Int32] zeroinitializer, %Int32 10, 0
	%58 = insertvalue [4 x %Int32] %57, %Int32 20, 1
	%59 = insertvalue [4 x %Int32] %58, %Int32 30, 2
	%60 = insertvalue [4 x %Int32] %59, %Int32 40, 3
	%61 = zext i8 4 to %Nat32
	store [4 x %Int32] %60, [4 x %Int32]* %56
	store %Nat32 0, %Nat32* %19
; while_3
	br label %again_3
again_3:
	%62 = load %Nat32, %Nat32* %19
	%63 = icmp ult %Nat32 %62, 10
	br %Bool %63 , label %body_3, label %break_3
body_3:
	%64 = load %Nat32, %Nat32* %19
	%65 = load %Nat32, %Nat32* %19
	%66 = bitcast %Nat32 %65 to %Nat32
	%67 = getelementptr [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Nat32 %66
	%68 = load %Int32, %Int32* %67
	%69 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str7 to [0 x i8]*), %Nat32 %64, %Int32 %68)
	%70 = load %Nat32, %Nat32* %19
	%71 = add %Nat32 %70, 1
	store %Nat32 %71, %Nat32* %19
	br label %again_3
break_3:
	%72 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str8 to [0 x i8]*))
	%73 = alloca [10 x %Int32], align 1
	%74 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 0
	%75 = insertvalue [10 x %Int32] %74, %Int32 20, 1
	%76 = insertvalue [10 x %Int32] %75, %Int32 30, 2
	%77 = insertvalue [10 x %Int32] %76, %Int32 40, 3
	%78 = insertvalue [10 x %Int32] %77, %Int32 50, 4
	%79 = insertvalue [10 x %Int32] %78, %Int32 60, 5
	%80 = insertvalue [10 x %Int32] %79, %Int32 70, 6
	%81 = insertvalue [10 x %Int32] %80, %Int32 80, 7
	%82 = insertvalue [10 x %Int32] %81, %Int32 90, 8
	%83 = insertvalue [10 x %Int32] %82, %Int32 100, 9
	%84 = zext i8 10 to %Nat32
	store [10 x %Int32] %83, [10 x %Int32]* %73
	%85 = zext i8 2 to %Nat32
	%86 = getelementptr [10 x %Int32], [10 x %Int32]* %73, %Int32 0, %Nat32 %85
	%87 = bitcast %Int32* %86 to [3 x %Int32]*
	%88 = zext i8 3 to %Nat32
	%89 = mul %Nat32 %88, 4
	%90 = bitcast [3 x %Int32]* %87 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %90, i8 0, %Nat32 %89, i1 0)
	store %Nat32 0, %Nat32* %19
; while_4
	br label %again_4
again_4:
	%91 = load %Nat32, %Nat32* %19
	%92 = icmp ult %Nat32 %91, 10
	br %Bool %92 , label %body_4, label %break_4
body_4:
	%93 = load %Nat32, %Nat32* %19
	%94 = load %Nat32, %Nat32* %19
	%95 = bitcast %Nat32 %94 to %Nat32
	%96 = getelementptr [10 x %Int32], [10 x %Int32]* %73, %Int32 0, %Nat32 %95
	%97 = load %Int32, %Int32* %96
	%98 = bitcast %Int32 %97 to %Nat32
	%99 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str9 to [0 x i8]*), %Nat32 %93, %Nat32 %98)
	%100 = load %Nat32, %Nat32* %19
	%101 = add %Nat32 %100, 1
	store %Nat32 %101, %Nat32* %19
	br label %again_4
break_4:
	%102 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str10 to [0 x i8]*))
	%103 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str11 to [0 x i8]*))
	%104 = zext i8 2 to %Nat32
	%105 = getelementptr [10 x %Int32], [10 x %Int32]* %73, %Int32 0, %Nat32 %104
	%106 = bitcast %Int32* %105 to [6 x %Int32]*
	%107 = bitcast [6 x %Int32]* %106 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %107, %Nat32 6)
	%108 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str12 to [0 x i8]*))
	%109 = getelementptr [6 x %Int32], [6 x %Int32]* %106, %Int32 0, %Int32 0
	store %Int32 123, %Int32* %109
	%110 = bitcast [6 x %Int32]* %106 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %110, %Nat32 6)
	%111 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str13 to [0 x i8]*))
	%112 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @str14 to [0 x i8]*))

	; за каким то хером это работает, то что мне сейчас нужно
	; но тут еще куча работы впереди
	%113 = alloca [0 x %Int32]*, align 8
	%114 = bitcast [10 x %Int32]* %73 to [0 x %Int32]*
	store [0 x %Int32]* %114, [0 x %Int32]** %113
	%115 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str15 to [0 x i8]*))
	%116 = load [0 x %Int32]*, [0 x %Int32]** %113
	call void @array_print([0 x %Int32]* %116, %Nat32 10)
	%117 = alloca %Int32, align 4
	store %Int32 1, %Int32* %117
	%118 = load [0 x %Int32]*, [0 x %Int32]** %113
	%119 = load %Int32, %Int32* %117
	%120 = getelementptr [0 x %Int32], [0 x %Int32]* %118, %Int32 0, %Int32 %119
;
	%121 = bitcast %Int32* %120 to [0 x %Int32]*
	store [0 x %Int32]* %121, [0 x %Int32]** %113
	%122 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str16 to [0 x i8]*))
	%123 = load [0 x %Int32]*, [0 x %Int32]** %113
	call void @array_print([0 x %Int32]* %123, %Nat32 10)
	%124 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str17 to [0 x i8]*))
	%125 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str18 to [0 x i8]*))
	; NOT WORKED NOW
	%126 = alloca [10 x %Int32], align 1
	%127 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%128 = insertvalue [10 x %Int32] %127, %Int32 2, 2
	%129 = insertvalue [10 x %Int32] %128, %Int32 3, 3
	%130 = insertvalue [10 x %Int32] %129, %Int32 4, 4
	%131 = insertvalue [10 x %Int32] %130, %Int32 5, 5
	%132 = insertvalue [10 x %Int32] %131, %Int32 6, 6
	%133 = insertvalue [10 x %Int32] %132, %Int32 7, 7
	%134 = insertvalue [10 x %Int32] %133, %Int32 8, 8
	%135 = insertvalue [10 x %Int32] %134, %Int32 9, 9
	%136 = zext i8 10 to %Nat32
	store [10 x %Int32] %135, [10 x %Int32]* %126
	%137 = alloca %Int32, align 4
	store %Int32 4, %Int32* %137
	%138 = alloca %Int32, align 4
	store %Int32 7, %Int32* %138
	%139 = load %Int32, %Int32* %137
	%140 = getelementptr [10 x %Int32], [10 x %Int32]* %126, %Int32 0, %Int32 %139
	%141 = bitcast %Int32* %140 to [0 x %Int32]*
	%142 = load %Int32, %Int32* %138
	%143 = load %Int32, %Int32* %137
	%144 = sub %Int32 %142, %143
	%145 = mul %Int32 %144, 4
	%146 = bitcast [0 x %Int32]* %141 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %146, i8 0, %Int32 %145, i1 0)
	%147 = bitcast [10 x %Int32]* %126 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %147, %Nat32 10)
	%148 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str19 to [0 x i8]*))
	%149 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str20 to [0 x i8]*))
	%150 = alloca [5 x %Int32], align 1
	%151 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%152 = insertvalue [5 x %Int32] %151, %Int32 20, 1
	%153 = insertvalue [5 x %Int32] %152, %Int32 30, 2
	%154 = insertvalue [5 x %Int32] %153, %Int32 40, 3
	%155 = insertvalue [5 x %Int32] %154, %Int32 50, 4
	%156 = zext i8 5 to %Nat32
	store [5 x %Int32] %155, [5 x %Int32]* %150
	%157 = alloca [10 x %Int32], align 1
	%158 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%159 = insertvalue [10 x %Int32] %158, %Int32 2, 2
	%160 = insertvalue [10 x %Int32] %159, %Int32 3, 3
	%161 = insertvalue [10 x %Int32] %160, %Int32 4, 4
	%162 = insertvalue [10 x %Int32] %161, %Int32 5, 5
	%163 = insertvalue [10 x %Int32] %162, %Int32 6, 6
	%164 = insertvalue [10 x %Int32] %163, %Int32 7, 7
	%165 = insertvalue [10 x %Int32] %164, %Int32 8, 8
	%166 = insertvalue [10 x %Int32] %165, %Int32 9, 9
	%167 = zext i8 10 to %Nat32
	store [10 x %Int32] %166, [10 x %Int32]* %157

	; test with let
	%168 = zext i8 3 to %Nat32
	%169 = getelementptr [10 x %Int32], [10 x %Int32]* %157, %Int32 0, %Nat32 %168
	%170 = bitcast %Int32* %169 to [5 x %Int32]*
	%171 = insertvalue [5 x %Int32] zeroinitializer, %Int32 11, 0
	%172 = insertvalue [5 x %Int32] %171, %Int32 22, 1
	%173 = insertvalue [5 x %Int32] %172, %Int32 33, 2
	%174 = insertvalue [5 x %Int32] %173, %Int32 44, 3
	%175 = insertvalue [5 x %Int32] %174, %Int32 55, 4
	%176 = zext i8 5 to %Nat32
	store [5 x %Int32] %175, [5 x %Int32]* %170
	%177 = bitcast [10 x %Int32]* %157 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %177, %Nat32 10)

	;	printf("--------------------------------------------\n")
	;
	;	var dst2 = []Int32 [00, 10, 20, 30, 40, 50, 60, 70, 80, 90]
	;
	;	var axx = Nat8 111
	;	var bxx = Nat8 222
	;
	;	// FIXIT: test with var
	;	// ARRCPY не умеет копировать generic массив, исправь это
	;	var i2: Int32 = 3
	;	var j2: Int32 = 5
	;	dst2[i2:j2] = [Int32 axx, Int32 bxx]
	;
	;	array_print(&dst2, 10)
	ret %Int 0
}


