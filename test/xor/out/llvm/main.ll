
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

; -- print includes --
; from included ctypes64
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
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type i64;
%PtrDiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PIDT = type i32;
%UIDT = type i32;
%GIDT = type i32;
; from included stdio
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
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
@str1 = private constant [8 x i8] [i8 48, i8 120, i8 37, i8 48, i8 50, i8 88, i8 32, i8 0]
@str2 = private constant [2 x i8] [i8 10, i8 0]
@str3 = private constant [21 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 120, i8 111, i8 114, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 105, i8 110, i8 103, i8 10, i8 0]
@str4 = private constant [27 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]
@str5 = private constant [26 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 100, i8 101, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]


@test_msg = global [13 x i8] [
	i8 72,
	i8 101,
	i8 108,
	i8 108,
	i8 111,
	i8 32,
	i8 87,
	i8 111,
	i8 114,
	i8 108,
	i8 100,
	i8 33,
	i8 0
]
@test_key = global [4 x i8] [
	i8 97,
	i8 98,
	i8 99,
	i8 0
]

define internal void @xor_encrypter([0 x i8]* %buf, i32 %buflen, [0 x i8]* %key, i32 %keylen) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	%2 = alloca i32, align 4
	store i32 0, i32* %2
	br label %again_1
again_1:
	%3 = load i32, i32* %1
	%4 = icmp ult i32 %3, %buflen
	br i1 %4 , label %body_1, label %break_1
body_1:
	%5 = load i32, i32* %1
	%6 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %5
	%7 = load i32, i32* %1
	%8 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %7
	%9 = load i8, i8* %8
	%10 = load i32, i32* %2
	%11 = getelementptr inbounds [0 x i8], [0 x i8]* %key, i32 0, i32 %10
	%12 = load i8, i8* %11
	%13 = xor i8 %9, %12
	store i8 %13, i8* %6
	%14 = load i32, i32* %2
	%15 = sub i32 %keylen, 1
	%16 = icmp ult i32 %14, %15
	br i1 %16 , label %then_0, label %else_0
then_0:
	%17 = load i32, i32* %2
	%18 = add i32 %17, 1
	store i32 %18, i32* %2
	br label %endif_0
else_0:
	store i32 0, i32* %2
	br label %endif_0
endif_0:
	%19 = load i32, i32* %1
	%20 = add i32 %19, 1
	store i32 %20, i32* %1
	br label %again_1
break_1:
	ret void
}

define internal void @print_bytes([0 x i8]* %buf, i32 %len) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	%2 = load i32, i32* %1
	%3 = icmp ult i32 %2, %len
	br i1 %3 , label %body_1, label %break_1
body_1:
	%4 = load i32, i32* %1
	%5 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %4
	%6 = load i8, i8* %5
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str1 to [0 x i8]*), i8 %6)
	%8 = load i32, i32* %1
	%9 = add i32 %8, 1
	store i32 %9, i32* %1
	br label %again_1
break_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
	ret void
}


define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*))
	%2 = bitcast [13 x i8]* @test_msg to [0 x i8]*
	%3 = bitcast [4 x i8]* @test_key to [0 x i8]*
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
	call void @print_bytes([0 x i8]* %2, i32 12)
	; encrypt test data
	call void @xor_encrypter([0 x i8]* %2, i32 12, [0 x i8]* %3, i32 3)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str5 to [0 x i8]*))
	call void @print_bytes([0 x i8]* %2, i32 12)
	; decrypt test data
	call void @xor_encrypter([0 x i8]* %2, i32 12, [0 x i8]* %3, i32 3)
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	call void @print_bytes([0 x i8]* %2, i32 12)
	ret %Int 0
}


