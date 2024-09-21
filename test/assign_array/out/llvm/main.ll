
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

; MODULE: main

; print includes

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


%SocklenT = type i32;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;


%File = type i8;
%FposT = type i8;
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
; end print includes
; -- strings --
@str1 = private constant [19 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 95, i8 97, i8 114, i8 114, i8 97, i8 121, i8 10, i8 0]
@str2 = private constant [23 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 49, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str4 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str5 = private constant [22 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 49, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str7 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]


@globalArray0 = global [10 x i32] [
	i32 0,
	i32 1,
	i32 2,
	i32 3,
	i32 4,
	i32 5,
	i32 6,
	i32 7,
	i32 8,
	i32 9
]
@globalArray1 = global [10 x i32] [
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0
]

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*))
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%2 = zext i4 10 to i32
	; -- end vol eval --
	%3 = load [10 x i32], [10 x i32]* @globalArray0
	store [10 x i32] %3, [10 x i32]* @globalArray1
	%4 = alloca i32, align 4
	store i32 0, i32* %4
	br label %again_1
again_1:
	%5 = load i32, i32* %4
	%6 = icmp slt i32 %5, 10
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i32, i32* %4
	%8 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray1, i32 0, i32 %7
	%9 = load i32, i32* %8
	%10 = load i32, i32* %4
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str2 to [0 x i8]*), i32 %10, i32 %9)
	%12 = load i32, i32* %4
	%13 = add i32 %12, 1
	store i32 %13, i32* %4
	br label %again_1
break_1:
	%14 = bitcast [10 x i32]* @globalArray0 to i8*
	%15 = bitcast [10 x i32]* @globalArray1 to i8*
	
	%16 = call i1 (i8*, i8*, i64) @memeq( i8* %14, i8* %15, i64 40)
	%17 = icmp ne i1 %16, 0
	br i1 %17 , label %then_0, label %else_0
then_0:
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
else_0:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str4 to [0 x i8]*))
	br label %endif_0
endif_0:
	; local
	%20 = alloca [10 x i32], align 4
	%21 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%22 = insertvalue [10 x i32] %21, i32 1, 1
	%23 = insertvalue [10 x i32] %22, i32 2, 2
	%24 = insertvalue [10 x i32] %23, i32 3, 3
	%25 = insertvalue [10 x i32] %24, i32 4, 4
	%26 = insertvalue [10 x i32] %25, i32 5, 5
	%27 = insertvalue [10 x i32] %26, i32 6, 6
	%28 = insertvalue [10 x i32] %27, i32 7, 7
	%29 = insertvalue [10 x i32] %28, i32 8, 8
	%30 = insertvalue [10 x i32] %29, i32 9, 9
	store [10 x i32] %30, [10 x i32]* %20
	%31 = alloca [10 x i32], align 4
	%32 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%33 = insertvalue [10 x i32] %32, i32 0, 1
	%34 = insertvalue [10 x i32] %33, i32 0, 2
	%35 = insertvalue [10 x i32] %34, i32 0, 3
	%36 = insertvalue [10 x i32] %35, i32 0, 4
	%37 = insertvalue [10 x i32] %36, i32 0, 5
	%38 = insertvalue [10 x i32] %37, i32 0, 6
	%39 = insertvalue [10 x i32] %38, i32 0, 7
	%40 = insertvalue [10 x i32] %39, i32 0, 8
	%41 = insertvalue [10 x i32] %40, i32 0, 9
	store [10 x i32] %41, [10 x i32]* %31
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%42 = zext i4 10 to i32
	; -- end vol eval --
	%43 = load [10 x i32], [10 x i32]* %20
	store [10 x i32] %43, [10 x i32]* %31
	store i32 0, i32* %4
	br label %again_2
again_2:
	%44 = load i32, i32* %4
	%45 = icmp slt i32 %44, 10
	br i1 %45 , label %body_2, label %break_2
body_2:
	%46 = load i32, i32* %4
	%47 = getelementptr inbounds [10 x i32], [10 x i32]* %31, i32 0, i32 %46
	%48 = load i32, i32* %47
	%49 = load i32, i32* %4
	%50 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str5 to [0 x i8]*), i32 %49, i32 %48)
	%51 = load i32, i32* %4
	%52 = add i32 %51, 1
	store i32 %52, i32* %4
	br label %again_2
break_2:
	%53 = bitcast [10 x i32]* %20 to i8*
	%54 = bitcast [10 x i32]* %31 to i8*
	
	%55 = call i1 (i8*, i8*, i64) @memeq( i8* %53, i8* %54, i64 40)
	%56 = icmp ne i1 %55, 0
	br i1 %56 , label %then_1, label %else_1
then_1:
	%57 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str6 to [0 x i8]*))
	br label %endif_1
else_1:
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str7 to [0 x i8]*))
	br label %endif_1
endif_1:
	ret %Int 0
}


