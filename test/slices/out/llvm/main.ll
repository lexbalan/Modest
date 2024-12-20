
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
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
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
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
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
; -- print imports --
; -- end print imports --
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
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp slt %Int32 %2, %len
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Int32, %Int32* %1
	%5 = load %Int32, %Int32* %1
	%6 = getelementptr inbounds [0 x %Int32], [0 x %Int32]* %pa, %Int32 0, %Int32 %5
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
	%2 = alloca [10 x %Int32], align 4
	%3 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%4 = insertvalue [10 x %Int32] %3, %Int32 2, 2
	%5 = insertvalue [10 x %Int32] %4, %Int32 3, 3
	%6 = insertvalue [10 x %Int32] %5, %Int32 4, 4
	%7 = insertvalue [10 x %Int32] %6, %Int32 5, 5
	%8 = insertvalue [10 x %Int32] %7, %Int32 6, 6
	%9 = insertvalue [10 x %Int32] %8, %Int32 7, 7
	%10 = insertvalue [10 x %Int32] %9, %Int32 8, 8
	%11 = insertvalue [10 x %Int32] %10, %Int32 9, 9
	store [10 x %Int32] %11, [10 x %Int32]* %2
	%12 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %2, %Int32 0, i1 1
	%13 = bitcast %Int32* %12 to [1 x %Int32]*
	%14 = load [1 x %Int32], [1 x %Int32]* %13
	%15 = alloca [1 x %Int32]
	store [1 x %Int32] %14, [1 x %Int32]* %15
	%16 = alloca %Int32, align 4
	store %Int32 0, %Int32* %16
	br label %again_1
again_1:
	%17 = load %Int32, %Int32* %16
	%18 = icmp slt %Int32 %17, 1
	br %Bool %18 , label %body_1, label %break_1
body_1:
	%19 = load %Int32, %Int32* %16
	%20 = load %Int32, %Int32* %16
	%21 = getelementptr inbounds [1 x %Int32], [1 x %Int32]* %15, %Int32 0, %Int32 %20
	%22 = load %Int32, %Int32* %21
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), %Int32 %19, %Int32 %22)
	%24 = load %Int32, %Int32* %16
	%25 = add %Int32 %24, 1
	store %Int32 %25, %Int32* %16
	br label %again_1
break_1:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str4 to [0 x i8]*))
	;
	; by ptr
	;
	%27 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %2, %Int32 0, i3 5
;
	%28 = bitcast %Int32* %27 to [3 x %Int32]*
	%29 = load [3 x %Int32], [3 x %Int32]* %28
	%30 = alloca [3 x %Int32]
	store [3 x %Int32] %29, [3 x %Int32]* %30
	store %Int32 0, %Int32* %16
	br label %again_2
again_2:
	%31 = load %Int32, %Int32* %16
	%32 = icmp slt %Int32 %31, 3
	br %Bool %32 , label %body_2, label %break_2
body_2:
	%33 = load %Int32, %Int32* %16
	%34 = load %Int32, %Int32* %16
	%35 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %30, %Int32 0, %Int32 %34
	%36 = load %Int32, %Int32* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), %Int32 %33, %Int32 %36)
	%38 = load %Int32, %Int32* %16
	%39 = add %Int32 %38, 1
	store %Int32 %39, %Int32* %16
	br label %again_2
break_2:
	%40 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str6 to [0 x i8]*))
	%41 = alloca [1 x %Int32], align 4
	%42 = load [1 x %Int32], [1 x %Int32]* %15
	store [1 x %Int32] %42, [1 x %Int32]* %41
	%43 = alloca [3 x %Int32], align 4
	%44 = load [3 x %Int32], [3 x %Int32]* %30
	store [3 x %Int32] %44, [3 x %Int32]* %43
	; -- STMT ASSIGN ARRAY --
	%45 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %2, %Int32 0, i2 2
	%46 = bitcast %Int32* %45 to [4 x %Int32]*
	; -- start vol eval --
	%47 = zext i3 4 to %Int32
	; -- end vol eval --
	%48 = insertvalue [4 x %Int32] zeroinitializer, %Int32 10, 0
	%49 = insertvalue [4 x %Int32] %48, %Int32 20, 1
	%50 = insertvalue [4 x %Int32] %49, %Int32 30, 2
	%51 = insertvalue [4 x %Int32] %50, %Int32 40, 3
	store [4 x %Int32] %51, [4 x %Int32]* %46
	store %Int32 0, %Int32* %16
	br label %again_3
again_3:
	%52 = load %Int32, %Int32* %16
	%53 = icmp slt %Int32 %52, 10
	br %Bool %53 , label %body_3, label %break_3
body_3:
	%54 = load %Int32, %Int32* %16
	%55 = load %Int32, %Int32* %16
	%56 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Int32 %55
	%57 = load %Int32, %Int32* %56
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str7 to [0 x i8]*), %Int32 %54, %Int32 %57)
	%59 = load %Int32, %Int32* %16
	%60 = add %Int32 %59, 1
	store %Int32 %60, %Int32* %16
	br label %again_3
break_3:
	%61 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str8 to [0 x i8]*))
	%62 = alloca [10 x %Int32], align 4
	%63 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 0
	%64 = insertvalue [10 x %Int32] %63, %Int32 20, 1
	%65 = insertvalue [10 x %Int32] %64, %Int32 30, 2
	%66 = insertvalue [10 x %Int32] %65, %Int32 40, 3
	%67 = insertvalue [10 x %Int32] %66, %Int32 50, 4
	%68 = insertvalue [10 x %Int32] %67, %Int32 60, 5
	%69 = insertvalue [10 x %Int32] %68, %Int32 70, 6
	%70 = insertvalue [10 x %Int32] %69, %Int32 80, 7
	%71 = insertvalue [10 x %Int32] %70, %Int32 90, 8
	%72 = insertvalue [10 x %Int32] %71, %Int32 100, 9
	store [10 x %Int32] %72, [10 x %Int32]* %62
	; -- STMT ASSIGN ARRAY --
	%73 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %62, %Int32 0, i2 2
	%74 = bitcast %Int32* %73 to [3 x %Int32]*
	; -- start vol eval --
	%75 = zext i2 3 to %Int32
	; -- end vol eval --
	; -- zero fill rest of array
	%76 = mul %Int32 %75, 4
	%77 = bitcast [3 x %Int32]* %74 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %77, i8 0, %Int32 %76, i1 0)
	store %Int32 0, %Int32* %16
	br label %again_4
again_4:
	%78 = load %Int32, %Int32* %16
	%79 = icmp slt %Int32 %78, 10
	br %Bool %79 , label %body_4, label %break_4
body_4:
	%80 = load %Int32, %Int32* %16
	%81 = load %Int32, %Int32* %16
	%82 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %62, %Int32 0, %Int32 %81
	%83 = load %Int32, %Int32* %82
	%84 = bitcast %Int32 %83 to %Int32
	%85 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str9 to [0 x i8]*), %Int32 %80, %Int32 %84)
	%86 = load %Int32, %Int32* %16
	%87 = add %Int32 %86, 1
	store %Int32 %87, %Int32* %16
	br label %again_4
break_4:
	%88 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str10 to [0 x i8]*))
	%89 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str11 to [0 x i8]*))
	%90 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %62, %Int32 0, i2 2
	%91 = bitcast %Int32* %90 to [6 x %Int32]*
	%92 = bitcast [6 x %Int32]* %91 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %92, %Int32 6)
	%93 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str12 to [0 x i8]*))
	%94 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %91, %Int32 0, %Int32 0
	store %Int32 123, %Int32* %94
	%95 = bitcast [6 x %Int32]* %91 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %95, %Int32 6)
	%96 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str13 to [0 x i8]*))
	%97 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @str14 to [0 x i8]*))
	; за каким то хером это работает, то что мне сейчас нужно
	; но тут еще куча работы впереди
	%98 = alloca [0 x %Int32]*, align 8
	%99 = bitcast [10 x %Int32]* %62 to [0 x %Int32]*
	store [0 x %Int32]* %99, [0 x %Int32]** %98
	%100 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str15 to [0 x i8]*))
	%101 = load [0 x %Int32]*, [0 x %Int32]** %98
	call void @array_print([0 x %Int32]* %101, %Int32 10)
	%102 = alloca %Int32, align 4
	store %Int32 1, %Int32* %102
	%103 = load [0 x %Int32]*, [0 x %Int32]** %98
	%104 = load %Int32, %Int32* %102
	%105 = getelementptr inbounds [0 x %Int32], [0 x %Int32]* %103, %Int32 0, %Int32 %104
;
	%106 = bitcast %Int32* %105 to [0 x %Int32]*
	store [0 x %Int32]* %106, [0 x %Int32]** %98
	%107 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str16 to [0 x i8]*))
	%108 = load [0 x %Int32]*, [0 x %Int32]** %98
	call void @array_print([0 x %Int32]* %108, %Int32 10)
	%109 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str17 to [0 x i8]*))
	%110 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str18 to [0 x i8]*))
	; NOT WORKED NOW
	%111 = alloca [10 x %Int32], align 4
	%112 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%113 = insertvalue [10 x %Int32] %112, %Int32 2, 2
	%114 = insertvalue [10 x %Int32] %113, %Int32 3, 3
	%115 = insertvalue [10 x %Int32] %114, %Int32 4, 4
	%116 = insertvalue [10 x %Int32] %115, %Int32 5, 5
	%117 = insertvalue [10 x %Int32] %116, %Int32 6, 6
	%118 = insertvalue [10 x %Int32] %117, %Int32 7, 7
	%119 = insertvalue [10 x %Int32] %118, %Int32 8, 8
	%120 = insertvalue [10 x %Int32] %119, %Int32 9, 9
	store [10 x %Int32] %120, [10 x %Int32]* %111
	%121 = alloca %Int32, align 4
	store %Int32 4, %Int32* %121
	%122 = alloca %Int32, align 4
	store %Int32 7, %Int32* %122
	; -- STMT ASSIGN ARRAY --
	%123 = load %Int32, %Int32* %121
	%124 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %111, %Int32 0, %Int32 %123
	%125 = bitcast %Int32* %124 to [0 x %Int32]*
	; -- start vol eval --
	%126 = load %Int32, %Int32* %122
	%127 = load %Int32, %Int32* %121
	%128 = sub %Int32 %126, %127
	; -- end vol eval --
	; -- zero fill rest of array
	%129 = mul %Int32 %128, 4
	%130 = bitcast [0 x %Int32]* %125 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %130, i8 0, %Int32 %129, i1 0)
	%131 = bitcast [10 x %Int32]* %111 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %131, %Int32 10)
	%132 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str19 to [0 x i8]*))
	%133 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str20 to [0 x i8]*))
	%134 = alloca [5 x %Int32], align 4
	%135 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%136 = insertvalue [5 x %Int32] %135, %Int32 20, 1
	%137 = insertvalue [5 x %Int32] %136, %Int32 30, 2
	%138 = insertvalue [5 x %Int32] %137, %Int32 40, 3
	%139 = insertvalue [5 x %Int32] %138, %Int32 50, 4
	store [5 x %Int32] %139, [5 x %Int32]* %134
	%140 = alloca [10 x %Int32], align 4
	%141 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%142 = insertvalue [10 x %Int32] %141, %Int32 2, 2
	%143 = insertvalue [10 x %Int32] %142, %Int32 3, 3
	%144 = insertvalue [10 x %Int32] %143, %Int32 4, 4
	%145 = insertvalue [10 x %Int32] %144, %Int32 5, 5
	%146 = insertvalue [10 x %Int32] %145, %Int32 6, 6
	%147 = insertvalue [10 x %Int32] %146, %Int32 7, 7
	%148 = insertvalue [10 x %Int32] %147, %Int32 8, 8
	%149 = insertvalue [10 x %Int32] %148, %Int32 9, 9
	store [10 x %Int32] %149, [10 x %Int32]* %140
	; test with let
	; -- STMT ASSIGN ARRAY --
	%150 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %140, %Int32 0, i2 3
	%151 = bitcast %Int32* %150 to [5 x %Int32]*
	; -- start vol eval --
	%152 = zext i3 5 to %Int32
	; -- end vol eval --
	%153 = insertvalue [5 x %Int32] zeroinitializer, %Int32 11, 0
	%154 = insertvalue [5 x %Int32] %153, %Int32 22, 1
	%155 = insertvalue [5 x %Int32] %154, %Int32 33, 2
	%156 = insertvalue [5 x %Int32] %155, %Int32 44, 3
	%157 = insertvalue [5 x %Int32] %156, %Int32 55, 4
	store [5 x %Int32] %157, [5 x %Int32]* %151
	%158 = bitcast [10 x %Int32]* %140 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %158, %Int32 10)
	%159 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str21 to [0 x i8]*))
	%160 = alloca [10 x %Int32], align 4
	%161 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 1
	%162 = insertvalue [10 x %Int32] %161, %Int32 20, 2
	%163 = insertvalue [10 x %Int32] %162, %Int32 30, 3
	%164 = insertvalue [10 x %Int32] %163, %Int32 40, 4
	%165 = insertvalue [10 x %Int32] %164, %Int32 50, 5
	%166 = insertvalue [10 x %Int32] %165, %Int32 60, 6
	%167 = insertvalue [10 x %Int32] %166, %Int32 70, 7
	%168 = insertvalue [10 x %Int32] %167, %Int32 80, 8
	%169 = insertvalue [10 x %Int32] %168, %Int32 90, 9
	store [10 x %Int32] %169, [10 x %Int32]* %160
	%170 = alloca %Int8, align 1
	store %Int8 111, %Int8* %170
	%171 = alloca %Int8, align 1
	store %Int8 222, %Int8* %171
	; test with var
	%172 = alloca %Int32, align 4
	store %Int32 3, %Int32* %172
	%173 = alloca %Int32, align 4
	store %Int32 5, %Int32* %173
	; -- STMT ASSIGN ARRAY --
	%174 = load %Int32, %Int32* %172
	%175 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %160, %Int32 0, %Int32 %174
	%176 = bitcast %Int32* %175 to [0 x %Int32]*
	; -- start vol eval --
	%177 = load %Int32, %Int32* %173
	%178 = load %Int32, %Int32* %172
	%179 = sub %Int32 %177, %178
	; -- end vol eval --
	%180 = load %Int8, %Int8* %170
	%181 = sext %Int8 %180 to %Int32
	%182 = load %Int8, %Int8* %171
	%183 = sext %Int8 %182 to %Int32
	%184 = load %Int8, %Int8* %170
	%185 = sext %Int8 %184 to %Int32
	%186 = insertvalue [2 x %Int32] zeroinitializer, %Int32 %185, 0
	%187 = load %Int8, %Int8* %171
	%188 = sext %Int8 %187 to %Int32
	%189 = insertvalue [2 x %Int32] %186, %Int32 %188, 1
; -- cons_composite_from_composite --
	%190 = alloca [2 x %Int32]
	store [2 x %Int32] %189, [2 x %Int32]* %190
	%191 = bitcast [2 x %Int32]* %190 to [0 x %Int32]*
; -- end cons_composite_from_composite --
	%192 = load [0 x %Int32], [0 x %Int32]* %191
	store [0 x %Int32] %192, [0 x %Int32]* %176
	%193 = bitcast [10 x %Int32]* %160 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %193, %Int32 10)
	ret %Int 0
}


