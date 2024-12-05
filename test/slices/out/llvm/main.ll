
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
	%3 = insertvalue [10 x %Int32] zeroinitializer, %Int32 0, 0
	%4 = insertvalue [10 x %Int32] %3, %Int32 1, 1
	%5 = insertvalue [10 x %Int32] %4, %Int32 2, 2
	%6 = insertvalue [10 x %Int32] %5, %Int32 3, 3
	%7 = insertvalue [10 x %Int32] %6, %Int32 4, 4
	%8 = insertvalue [10 x %Int32] %7, %Int32 5, 5
	%9 = insertvalue [10 x %Int32] %8, %Int32 6, 6
	%10 = insertvalue [10 x %Int32] %9, %Int32 7, 7
	%11 = insertvalue [10 x %Int32] %10, %Int32 8, 8
	%12 = insertvalue [10 x %Int32] %11, %Int32 9, 9
	store [10 x %Int32] %12, [10 x %Int32]* %2
	%13 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %2, %Int32 0, i1 1
	%14 = bitcast %Int32* %13 to [1 x %Int32]*
	%15 = load [1 x %Int32], [1 x %Int32]* %14
	%16 = alloca [1 x %Int32]
	store [1 x %Int32] %15, [1 x %Int32]* %16
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_1
again_1:
	%18 = load %Int32, %Int32* %17
	%19 = icmp slt %Int32 %18, 1
	br %Bool %19 , label %body_1, label %break_1
body_1:
	%20 = load %Int32, %Int32* %17
	%21 = load %Int32, %Int32* %17
	%22 = getelementptr inbounds [1 x %Int32], [1 x %Int32]* %16, %Int32 0, %Int32 %21
	%23 = load %Int32, %Int32* %22
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), %Int32 %20, %Int32 %23)
	%25 = load %Int32, %Int32* %17
	%26 = add %Int32 %25, 1
	store %Int32 %26, %Int32* %17
	br label %again_1
break_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str4 to [0 x i8]*))
	;
	; by ptr
	;
	%28 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %2, %Int32 0, i3 5
;
	%29 = bitcast %Int32* %28 to [3 x %Int32]*
	%30 = load [3 x %Int32], [3 x %Int32]* %29
	%31 = alloca [3 x %Int32]
	store [3 x %Int32] %30, [3 x %Int32]* %31
	store %Int32 0, %Int32* %17
	br label %again_2
again_2:
	%32 = load %Int32, %Int32* %17
	%33 = icmp slt %Int32 %32, 3
	br %Bool %33 , label %body_2, label %break_2
body_2:
	%34 = load %Int32, %Int32* %17
	%35 = load %Int32, %Int32* %17
	%36 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %31, %Int32 0, %Int32 %35
	%37 = load %Int32, %Int32* %36
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), %Int32 %34, %Int32 %37)
	%39 = load %Int32, %Int32* %17
	%40 = add %Int32 %39, 1
	store %Int32 %40, %Int32* %17
	br label %again_2
break_2:
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str6 to [0 x i8]*))
	%42 = alloca [1 x %Int32], align 4
	%43 = load [1 x %Int32], [1 x %Int32]* %16
	store [1 x %Int32] %43, [1 x %Int32]* %42
	%44 = alloca [3 x %Int32], align 4
	%45 = load [3 x %Int32], [3 x %Int32]* %31
	store [3 x %Int32] %45, [3 x %Int32]* %44
	; -- STMT ASSIGN ARRAY --
	%46 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %2, %Int32 0, i2 2
	%47 = bitcast %Int32* %46 to [4 x %Int32]*
	; -- start vol eval --
	%48 = zext i3 4 to %Int32
	; -- end vol eval --
	%49 = insertvalue [4 x %Int32] zeroinitializer, %Int32 10, 0
	%50 = insertvalue [4 x %Int32] %49, %Int32 20, 1
	%51 = insertvalue [4 x %Int32] %50, %Int32 30, 2
	%52 = insertvalue [4 x %Int32] %51, %Int32 40, 3
	store [4 x %Int32] %52, [4 x %Int32]* %47
	store %Int32 0, %Int32* %17
	br label %again_3
again_3:
	%53 = load %Int32, %Int32* %17
	%54 = icmp slt %Int32 %53, 10
	br %Bool %54 , label %body_3, label %break_3
body_3:
	%55 = load %Int32, %Int32* %17
	%56 = load %Int32, %Int32* %17
	%57 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %2, %Int32 0, %Int32 %56
	%58 = load %Int32, %Int32* %57
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str7 to [0 x i8]*), %Int32 %55, %Int32 %58)
	%60 = load %Int32, %Int32* %17
	%61 = add %Int32 %60, 1
	store %Int32 %61, %Int32* %17
	br label %again_3
break_3:
	%62 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str8 to [0 x i8]*))
	%63 = alloca [10 x %Int32], align 4
	%64 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 0
	%65 = insertvalue [10 x %Int32] %64, %Int32 20, 1
	%66 = insertvalue [10 x %Int32] %65, %Int32 30, 2
	%67 = insertvalue [10 x %Int32] %66, %Int32 40, 3
	%68 = insertvalue [10 x %Int32] %67, %Int32 50, 4
	%69 = insertvalue [10 x %Int32] %68, %Int32 60, 5
	%70 = insertvalue [10 x %Int32] %69, %Int32 70, 6
	%71 = insertvalue [10 x %Int32] %70, %Int32 80, 7
	%72 = insertvalue [10 x %Int32] %71, %Int32 90, 8
	%73 = insertvalue [10 x %Int32] %72, %Int32 100, 9
	store [10 x %Int32] %73, [10 x %Int32]* %63
	; -- STMT ASSIGN ARRAY --
	%74 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %63, %Int32 0, i2 2
	%75 = bitcast %Int32* %74 to [3 x %Int32]*
	; -- start vol eval --
	%76 = zext i2 3 to %Int32
	; -- end vol eval --
	; -- ZERO
	%77 = mul %Int32 %76, 4
	%78 = bitcast [3 x %Int32]* %75 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %78, i8 0, %Int32 %77, i1 0)
	store %Int32 0, %Int32* %17
	br label %again_4
again_4:
	%79 = load %Int32, %Int32* %17
	%80 = icmp slt %Int32 %79, 10
	br %Bool %80 , label %body_4, label %break_4
body_4:
	%81 = load %Int32, %Int32* %17
	%82 = load %Int32, %Int32* %17
	%83 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %63, %Int32 0, %Int32 %82
	%84 = load %Int32, %Int32* %83
	%85 = bitcast %Int32 %84 to %Int32
	%86 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str9 to [0 x i8]*), %Int32 %81, %Int32 %85)
	%87 = load %Int32, %Int32* %17
	%88 = add %Int32 %87, 1
	store %Int32 %88, %Int32* %17
	br label %again_4
break_4:
	%89 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str10 to [0 x i8]*))
	%90 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str11 to [0 x i8]*))
	%91 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %63, %Int32 0, i2 2
	%92 = bitcast %Int32* %91 to [6 x %Int32]*
	%93 = bitcast [6 x %Int32]* %92 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %93, %Int32 6)
	%94 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str12 to [0 x i8]*))
	%95 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %92, %Int32 0, %Int32 0
	store %Int32 123, %Int32* %95
	%96 = bitcast [6 x %Int32]* %92 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %96, %Int32 6)
	%97 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str13 to [0 x i8]*))
	%98 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @str14 to [0 x i8]*))
	; за каким то хером это работает, то что мне сейчас нужно
	; но тут еще куча работы впереди
	%99 = alloca [0 x %Int32]*, align 8
	%100 = bitcast [10 x %Int32]* %63 to [0 x %Int32]*
	store [0 x %Int32]* %100, [0 x %Int32]** %99
	%101 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str15 to [0 x i8]*))
	%102 = load [0 x %Int32]*, [0 x %Int32]** %99
	call void @array_print([0 x %Int32]* %102, %Int32 10)
	%103 = alloca %Int32, align 4
	store %Int32 1, %Int32* %103
	%104 = load [0 x %Int32]*, [0 x %Int32]** %99
	%105 = load %Int32, %Int32* %103
	%106 = getelementptr inbounds [0 x %Int32], [0 x %Int32]* %104, %Int32 0, %Int32 %105
;
	%107 = bitcast %Int32* %106 to [0 x %Int32]*
	store [0 x %Int32]* %107, [0 x %Int32]** %99
	%108 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str16 to [0 x i8]*))
	%109 = load [0 x %Int32]*, [0 x %Int32]** %99
	call void @array_print([0 x %Int32]* %109, %Int32 10)
	%110 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str17 to [0 x i8]*))
	%111 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str18 to [0 x i8]*))
	; NOT WORKED NOW
	%112 = alloca [10 x %Int32], align 4
	%113 = insertvalue [10 x %Int32] zeroinitializer, %Int32 0, 0
	%114 = insertvalue [10 x %Int32] %113, %Int32 1, 1
	%115 = insertvalue [10 x %Int32] %114, %Int32 2, 2
	%116 = insertvalue [10 x %Int32] %115, %Int32 3, 3
	%117 = insertvalue [10 x %Int32] %116, %Int32 4, 4
	%118 = insertvalue [10 x %Int32] %117, %Int32 5, 5
	%119 = insertvalue [10 x %Int32] %118, %Int32 6, 6
	%120 = insertvalue [10 x %Int32] %119, %Int32 7, 7
	%121 = insertvalue [10 x %Int32] %120, %Int32 8, 8
	%122 = insertvalue [10 x %Int32] %121, %Int32 9, 9
	store [10 x %Int32] %122, [10 x %Int32]* %112
	%123 = alloca %Int32, align 4
	store %Int32 4, %Int32* %123
	%124 = alloca %Int32, align 4
	store %Int32 7, %Int32* %124
	; -- STMT ASSIGN ARRAY --
	%125 = load %Int32, %Int32* %123
	%126 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %112, %Int32 0, %Int32 %125
	%127 = bitcast %Int32* %126 to [0 x %Int32]*
	; -- start vol eval --
	%128 = load %Int32, %Int32* %124
	%129 = load %Int32, %Int32* %123
	%130 = sub %Int32 %128, %129
	; -- end vol eval --
	; -- ZERO
	%131 = mul %Int32 %130, 4
	%132 = bitcast [0 x %Int32]* %127 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %132, i8 0, %Int32 %131, i1 0)
	%133 = bitcast [10 x %Int32]* %112 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %133, %Int32 10)
	%134 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str19 to [0 x i8]*))
	%135 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str20 to [0 x i8]*))
	%136 = alloca [5 x %Int32], align 4
	%137 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%138 = insertvalue [5 x %Int32] %137, %Int32 20, 1
	%139 = insertvalue [5 x %Int32] %138, %Int32 30, 2
	%140 = insertvalue [5 x %Int32] %139, %Int32 40, 3
	%141 = insertvalue [5 x %Int32] %140, %Int32 50, 4
	store [5 x %Int32] %141, [5 x %Int32]* %136
	%142 = alloca [10 x %Int32], align 4
	%143 = insertvalue [10 x %Int32] zeroinitializer, %Int32 0, 0
	%144 = insertvalue [10 x %Int32] %143, %Int32 1, 1
	%145 = insertvalue [10 x %Int32] %144, %Int32 2, 2
	%146 = insertvalue [10 x %Int32] %145, %Int32 3, 3
	%147 = insertvalue [10 x %Int32] %146, %Int32 4, 4
	%148 = insertvalue [10 x %Int32] %147, %Int32 5, 5
	%149 = insertvalue [10 x %Int32] %148, %Int32 6, 6
	%150 = insertvalue [10 x %Int32] %149, %Int32 7, 7
	%151 = insertvalue [10 x %Int32] %150, %Int32 8, 8
	%152 = insertvalue [10 x %Int32] %151, %Int32 9, 9
	store [10 x %Int32] %152, [10 x %Int32]* %142
	; test with let
	; -- STMT ASSIGN ARRAY --
	%153 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %142, %Int32 0, i2 3
	%154 = bitcast %Int32* %153 to [5 x %Int32]*
	; -- start vol eval --
	%155 = zext i3 5 to %Int32
	; -- end vol eval --
	%156 = insertvalue [5 x %Int32] zeroinitializer, %Int32 11, 0
	%157 = insertvalue [5 x %Int32] %156, %Int32 22, 1
	%158 = insertvalue [5 x %Int32] %157, %Int32 33, 2
	%159 = insertvalue [5 x %Int32] %158, %Int32 44, 3
	%160 = insertvalue [5 x %Int32] %159, %Int32 55, 4
	store [5 x %Int32] %160, [5 x %Int32]* %154
	%161 = bitcast [10 x %Int32]* %142 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %161, %Int32 10)
	%162 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str21 to [0 x i8]*))
	%163 = alloca [10 x %Int32], align 4
	%164 = insertvalue [10 x %Int32] zeroinitializer, %Int32 0, 0
	%165 = insertvalue [10 x %Int32] %164, %Int32 10, 1
	%166 = insertvalue [10 x %Int32] %165, %Int32 20, 2
	%167 = insertvalue [10 x %Int32] %166, %Int32 30, 3
	%168 = insertvalue [10 x %Int32] %167, %Int32 40, 4
	%169 = insertvalue [10 x %Int32] %168, %Int32 50, 5
	%170 = insertvalue [10 x %Int32] %169, %Int32 60, 6
	%171 = insertvalue [10 x %Int32] %170, %Int32 70, 7
	%172 = insertvalue [10 x %Int32] %171, %Int32 80, 8
	%173 = insertvalue [10 x %Int32] %172, %Int32 90, 9
	store [10 x %Int32] %173, [10 x %Int32]* %163
	%174 = alloca %Int8, align 1
	store %Int8 111, %Int8* %174
	%175 = alloca %Int8, align 1
	store %Int8 222, %Int8* %175
	; test with var
	%176 = alloca %Int32, align 4
	store %Int32 3, %Int32* %176
	%177 = alloca %Int32, align 4
	store %Int32 5, %Int32* %177
	; -- STMT ASSIGN ARRAY --
	%178 = load %Int32, %Int32* %176
	%179 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* %163, %Int32 0, %Int32 %178
	%180 = bitcast %Int32* %179 to [0 x %Int32]*
	; -- start vol eval --
	%181 = load %Int32, %Int32* %177
	%182 = load %Int32, %Int32* %176
	%183 = sub %Int32 %181, %182
	; -- end vol eval --
	%184 = load %Int8, %Int8* %174
	%185 = sext %Int8 %184 to %Int32
	%186 = load %Int8, %Int8* %175
	%187 = sext %Int8 %186 to %Int32
	%188 = insertvalue [2 x %Int32] zeroinitializer, %Int32 %185, 0
	%189 = insertvalue [2 x %Int32] %188, %Int32 %187, 1
	; trunk
	%190 = alloca [2 x %Int32]
	store [2 x %Int32] %189, [2 x %Int32]* %190
	%191 = bitcast [2 x %Int32]* %190 to [0 x %Int32]*
	%192 = load [0 x %Int32], [0 x %Int32]* %191
	store [0 x %Int32] %192, [0 x %Int32]* %180
	%193 = bitcast [10 x %Int32]* %163 to [0 x %Int32]*
	call void @array_print([0 x %Int32]* %193, %Int32 10)
	ret %Int 0
}


