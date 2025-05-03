
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
%File = type %Nat8;
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
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
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
@str21 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
; -- endstrings --
define internal void @array_print([0 x %Int32]* %pa, %Int32 %len) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp slt %Int32 %2, %len
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Int32, %Int32* %1
	%5 = load %Int32, %Int32* %1
	%6 = getelementptr [0 x %Int32], [0 x %Int32]* %pa, %Int32 0, %Int32 %5
	%7 = load %Int32, %Int32* %6
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*), %Int32 %4, %Int32 %7)
	%9 = load %Int32, %Int32* %1
	%10 = add %Int32 %9, 1
	store %Int32 %10, %Int32* %1
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
	%19 = alloca %Int32, align 4
	store %Int32 0, %Int32* %19
; while_1
	br label %again_1
again_1:
	%20 = load %Int32, %Int32* %19
	%21 = icmp slt %Int32 %20, 1
	br %Bool %21 , label %body_1, label %break_1
body_1:
	%22 = load %Int32, %Int32* %19
	%23 = load %Int32, %Int32* %19
	%24 = getelementptr [1 x %Int32], [1 x %Int32]* %17, %Int32 0, %Int32 %23
	%25 = load %Int32, %Int32* %24
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), %Int32 %22, %Int32 %25)
	%27 = load %Int32, %Int32* %19
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %19
	br label %again_1
break_1:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str4 to [0 x i8]*))

	;
	; by ptr
	;
	%30 = zext i8 5 to %Nat32
	%31 = getelementptr [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Nat32 %30
;
	%32 = bitcast %Int32* %31 to [3 x %Int32]*
	%33 = load [3 x %Int32], [3 x %Int32]* %32
	%34 = alloca [3 x %Int32]
	%35 = zext i8 3 to %Nat32
	store [3 x %Int32] %33, [3 x %Int32]* %34
	store %Int32 0, %Int32* %19
; while_2
	br label %again_2
again_2:
	%36 = load %Int32, %Int32* %19
	%37 = icmp slt %Int32 %36, 3
	br %Bool %37 , label %body_2, label %break_2
body_2:
	%38 = load %Int32, %Int32* %19
	%39 = load %Int32, %Int32* %19
	%40 = getelementptr [3 x %Int32], [3 x %Int32]* %34, %Int32 0, %Int32 %39
	%41 = load %Int32, %Int32* %40
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), %Int32 %38, %Int32 %41)
	%43 = load %Int32, %Int32* %19
	%44 = add %Int32 %43, 1
	store %Int32 %44, %Int32* %19
	br label %again_2
break_2:
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str6 to [0 x i8]*))
	%46 = alloca [1 x %Int32], align 1
	%47 = load [1 x %Int32], [1 x %Int32]* %17
	%48 = zext i8 1 to %Nat32
	store [1 x %Int32] %47, [1 x %Int32]* %46
	%49 = alloca [3 x %Int32], align 1
	%50 = load [3 x %Int32], [3 x %Int32]* %34
	%51 = zext i8 3 to %Nat32
	store [3 x %Int32] %50, [3 x %Int32]* %49
	%52 = zext i8 2 to %Nat32
	%53 = getelementptr [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Nat32 %52
	%54 = bitcast %Int32* %53 to [4 x %Int32]*
	%55 = insertvalue [4 x %Int32] zeroinitializer, %Int32 10, 0
	%56 = insertvalue [4 x %Int32] %55, %Int32 20, 1
	%57 = insertvalue [4 x %Int32] %56, %Int32 30, 2
	%58 = insertvalue [4 x %Int32] %57, %Int32 40, 3
	%59 = zext i8 4 to %Nat32
	store [4 x %Int32] %58, [4 x %Int32]* %54
	store %Int32 0, %Int32* %19
; while_3
	br label %again_3
again_3:
	%60 = load %Int32, %Int32* %19
	%61 = icmp slt %Int32 %60, 10
	br %Bool %61 , label %body_3, label %break_3
body_3:
	%62 = load %Int32, %Int32* %19
	%63 = load %Int32, %Int32* %19
	%64 = getelementptr [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Int32 %63
	%65 = load %Int32, %Int32* %64
	%66 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str7 to [0 x i8]*), %Int32 %62, %Int32 %65)
	%67 = load %Int32, %Int32* %19
	%68 = add %Int32 %67, 1
	store %Int32 %68, %Int32* %19
	br label %again_3
break_3:
	%69 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str8 to [0 x i8]*))
	%70 = alloca [10 x %Int32], align 1
	%71 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 0
	%72 = insertvalue [10 x %Int32] %71, %Int32 20, 1
	%73 = insertvalue [10 x %Int32] %72, %Int32 30, 2
	%74 = insertvalue [10 x %Int32] %73, %Int32 40, 3
	%75 = insertvalue [10 x %Int32] %74, %Int32 50, 4
	%76 = insertvalue [10 x %Int32] %75, %Int32 60, 5
	%77 = insertvalue [10 x %Int32] %76, %Int32 70, 6
	%78 = insertvalue [10 x %Int32] %77, %Int32 80, 7
	%79 = insertvalue [10 x %Int32] %78, %Int32 90, 8
	%80 = insertvalue [10 x %Int32] %79, %Int32 100, 9
	%81 = zext i8 10 to %Nat32
	store [10 x %Int32] %80, [10 x %Int32]* %70
	%82 = zext i8 2 to %Nat32
	%83 = getelementptr [10 x %Int32], [10 x %Int32]* %70, %Int32 0, %Nat32 %82
	%84 = bitcast %Int32* %83 to [3 x %Int32]*
	%85 = zext i8 3 to %Nat32
	%86 = mul %Nat32 %85, 4
	%87 = bitcast [3 x %Int32]* %84 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %87, i8 0, %Nat32 %86, i1 0)
	store %Int32 0, %Int32* %19
; while_4
	br label %again_4
again_4:
	%88 = load %Int32, %Int32* %19
	%89 = icmp slt %Int32 %88, 10
	br %Bool %89 , label %body_4, label %break_4
body_4:
	%90 = load %Int32, %Int32* %19
	%91 = load %Int32, %Int32* %19
	%92 = getelementptr [10 x %Int32], [10 x %Int32]* %70, %Int32 0, %Int32 %91
	%93 = load %Int32, %Int32* %92
	%94 = bitcast %Int32 %93 to %Nat32
	%95 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str9 to [0 x i8]*), %Int32 %90, %Nat32 %94)
	%96 = load %Int32, %Int32* %19
	%97 = add %Int32 %96, 1
	store %Int32 %97, %Int32* %19
	br label %again_4
break_4:
	%98 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str10 to [0 x i8]*))
	%99 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str11 to [0 x i8]*))
	%100 = zext i8 2 to %Nat32
	%101 = getelementptr [10 x %Int32], [10 x %Int32]* %70, %Int32 0, %Nat32 %100
	%102 = bitcast %Int32* %101 to [6 x %Int32]*
	%103 = bitcast [6 x %Int32]* %102 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %103, %Int32 6)
	%104 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str12 to [0 x i8]*))
	%105 = getelementptr [6 x %Int32], [6 x %Int32]* %102, %Int32 0, %Int32 0
	store %Int32 123, %Int32* %105
	%106 = bitcast [6 x %Int32]* %102 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %106, %Int32 6)
	%107 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str13 to [0 x i8]*))
	%108 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @str14 to [0 x i8]*))

	; за каким то хером это работает, то что мне сейчас нужно
	; но тут еще куча работы впереди
	%109 = alloca [0 x %Int32]*, align 8
	%110 = bitcast [10 x %Int32]* %70 to [0 x %Int32]*
	store [0 x %Int32]* %110, [0 x %Int32]** %109
	%111 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str15 to [0 x i8]*))
	%112 = load [0 x %Int32]*, [0 x %Int32]** %109
	call void @array_print([0 x %Int32]* %112, %Int32 10)
	%113 = alloca %Int32, align 4
	store %Int32 1, %Int32* %113
	%114 = load [0 x %Int32]*, [0 x %Int32]** %109
	%115 = load %Int32, %Int32* %113
	%116 = getelementptr [0 x %Int32], [0 x %Int32]* %114, %Int32 0, %Int32 %115
;
	%117 = bitcast %Int32* %116 to [0 x %Int32]*
	store [0 x %Int32]* %117, [0 x %Int32]** %109
	%118 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str16 to [0 x i8]*))
	%119 = load [0 x %Int32]*, [0 x %Int32]** %109
	call void @array_print([0 x %Int32]* %119, %Int32 10)
	%120 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str17 to [0 x i8]*))
	%121 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str18 to [0 x i8]*))
	; NOT WORKED NOW
	%122 = alloca [10 x %Int32], align 1
	%123 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%124 = insertvalue [10 x %Int32] %123, %Int32 2, 2
	%125 = insertvalue [10 x %Int32] %124, %Int32 3, 3
	%126 = insertvalue [10 x %Int32] %125, %Int32 4, 4
	%127 = insertvalue [10 x %Int32] %126, %Int32 5, 5
	%128 = insertvalue [10 x %Int32] %127, %Int32 6, 6
	%129 = insertvalue [10 x %Int32] %128, %Int32 7, 7
	%130 = insertvalue [10 x %Int32] %129, %Int32 8, 8
	%131 = insertvalue [10 x %Int32] %130, %Int32 9, 9
	%132 = zext i8 10 to %Nat32
	store [10 x %Int32] %131, [10 x %Int32]* %122
	%133 = alloca %Int32, align 4
	store %Int32 4, %Int32* %133
	%134 = alloca %Int32, align 4
	store %Int32 7, %Int32* %134
	%135 = load %Int32, %Int32* %133
	%136 = getelementptr [10 x %Int32], [10 x %Int32]* %122, %Int32 0, %Int32 %135
	%137 = bitcast %Int32* %136 to [0 x %Int32]*
	%138 = load %Int32, %Int32* %134
	%139 = load %Int32, %Int32* %133
	%140 = sub %Int32 %138, %139
	%141 = mul %Int32 %140, 4
	%142 = bitcast [0 x %Int32]* %137 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %142, i8 0, %Int32 %141, i1 0)
	%143 = bitcast [10 x %Int32]* %122 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %143, %Int32 10)
	%144 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str19 to [0 x i8]*))
	%145 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str20 to [0 x i8]*))
	%146 = alloca [5 x %Int32], align 1
	%147 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%148 = insertvalue [5 x %Int32] %147, %Int32 20, 1
	%149 = insertvalue [5 x %Int32] %148, %Int32 30, 2
	%150 = insertvalue [5 x %Int32] %149, %Int32 40, 3
	%151 = insertvalue [5 x %Int32] %150, %Int32 50, 4
	%152 = zext i8 5 to %Nat32
	store [5 x %Int32] %151, [5 x %Int32]* %146
	%153 = alloca [10 x %Int32], align 1
	%154 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%155 = insertvalue [10 x %Int32] %154, %Int32 2, 2
	%156 = insertvalue [10 x %Int32] %155, %Int32 3, 3
	%157 = insertvalue [10 x %Int32] %156, %Int32 4, 4
	%158 = insertvalue [10 x %Int32] %157, %Int32 5, 5
	%159 = insertvalue [10 x %Int32] %158, %Int32 6, 6
	%160 = insertvalue [10 x %Int32] %159, %Int32 7, 7
	%161 = insertvalue [10 x %Int32] %160, %Int32 8, 8
	%162 = insertvalue [10 x %Int32] %161, %Int32 9, 9
	%163 = zext i8 10 to %Nat32
	store [10 x %Int32] %162, [10 x %Int32]* %153

	; test with let
	%164 = zext i8 3 to %Nat32
	%165 = getelementptr [10 x %Int32], [10 x %Int32]* %153, %Int32 0, %Nat32 %164
	%166 = bitcast %Int32* %165 to [5 x %Int32]*
	%167 = insertvalue [5 x %Int32] zeroinitializer, %Int32 11, 0
	%168 = insertvalue [5 x %Int32] %167, %Int32 22, 1
	%169 = insertvalue [5 x %Int32] %168, %Int32 33, 2
	%170 = insertvalue [5 x %Int32] %169, %Int32 44, 3
	%171 = insertvalue [5 x %Int32] %170, %Int32 55, 4
	%172 = zext i8 5 to %Nat32
	store [5 x %Int32] %171, [5 x %Int32]* %166
	%173 = bitcast [10 x %Int32]* %153 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %173, %Int32 10)
	%174 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str21 to [0 x i8]*))
	%175 = alloca [10 x %Int32], align 1
	%176 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 1
	%177 = insertvalue [10 x %Int32] %176, %Int32 20, 2
	%178 = insertvalue [10 x %Int32] %177, %Int32 30, 3
	%179 = insertvalue [10 x %Int32] %178, %Int32 40, 4
	%180 = insertvalue [10 x %Int32] %179, %Int32 50, 5
	%181 = insertvalue [10 x %Int32] %180, %Int32 60, 6
	%182 = insertvalue [10 x %Int32] %181, %Int32 70, 7
	%183 = insertvalue [10 x %Int32] %182, %Int32 80, 8
	%184 = insertvalue [10 x %Int32] %183, %Int32 90, 9
	%185 = zext i8 10 to %Nat32
	store [10 x %Int32] %184, [10 x %Int32]* %175
	%186 = alloca %Nat8, align 1
	store %Nat8 111, %Nat8* %186
	%187 = alloca %Nat8, align 1
	store %Nat8 222, %Nat8* %187

	; test with var
	%188 = alloca %Int32, align 4
	store %Int32 3, %Int32* %188
	%189 = alloca %Int32, align 4
	store %Int32 5, %Int32* %189
	%190 = load %Int32, %Int32* %188
	%191 = getelementptr [10 x %Int32], [10 x %Int32]* %175, %Int32 0, %Int32 %190
	%192 = bitcast %Int32* %191 to [0 x %Int32]*
	%193 = load %Nat8, %Nat8* %186
	%194 = sext %Nat8 %193 to %Int32
	%195 = load %Nat8, %Nat8* %187
	%196 = sext %Nat8 %195 to %Int32
	%197 = load %Nat8, %Nat8* %186
	%198 = sext %Nat8 %197 to %Int32
	%199 = insertvalue [2 x %Int32] zeroinitializer, %Int32 %198, 0
	%200 = load %Nat8, %Nat8* %187
	%201 = sext %Nat8 %200 to %Int32
	%202 = insertvalue [2 x %Int32] %199, %Int32 %201, 1
; -- cons_composite_from_composite_by_value --
	%203 = alloca [2 x %Int32]
	%204 = zext i8 2 to %Nat32
	store [2 x %Int32] %202, [2 x %Int32]* %203
	%205 = bitcast [2 x %Int32]* %203 to [0 x %Int32]*
; -- end cons_composite_from_composite_by_value --
	%206 = load [0 x %Int32], [0 x %Int32]* %205
	%207 = load %Int32, %Int32* %189
	%208 = load %Int32, %Int32* %188
	%209 = sub %Int32 %207, %208
	store [0 x %Int32] %206, [0 x %Int32]* %192
	%210 = bitcast [10 x %Int32]* %175 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %210, %Int32 10)
	ret %Int 0
}


