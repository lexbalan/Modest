
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
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
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
@str1 = private constant [9 x i8] [i8 102, i8 105, i8 108, i8 101, i8 46, i8 98, i8 105, i8 110, i8 0]
@str2 = private constant [19 x i8] [i8 114, i8 117, i8 110, i8 32, i8 119, i8 114, i8 105, i8 116, i8 101, i8 95, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str3 = private constant [3 x i8] [i8 119, i8 98, i8 0]
@str4 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str5 = private constant [3 x i8] [i8 105, i8 100, i8 0]
@str6 = private constant [5 x i8] [i8 100, i8 97, i8 116, i8 97, i8 0]
@str7 = private constant [18 x i8] [i8 114, i8 117, i8 110, i8 32, i8 114, i8 101, i8 97, i8 100, i8 95, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str8 = private constant [3 x i8] [i8 114, i8 98, i8 0]
@str9 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str10 = private constant [21 x i8] [i8 102, i8 105, i8 108, i8 101, i8 32, i8 34, i8 37, i8 115, i8 34, i8 32, i8 99, i8 111, i8 110, i8 116, i8 97, i8 105, i8 110, i8 115, i8 58, i8 10, i8 0]
@str11 = private constant [16 x i8] [i8 99, i8 104, i8 117, i8 110, i8 107, i8 46, i8 105, i8 100, i8 58, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@str12 = private constant [18 x i8] [i8 99, i8 104, i8 117, i8 110, i8 107, i8 46, i8 100, i8 97, i8 116, i8 97, i8 58, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@str13 = private constant [21 x i8] [i8 98, i8 105, i8 110, i8 97, i8 114, i8 121, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
; -- endstrings --
; FIXIT: not worked LLVM result (!)

; chunk of data for read/write operations in file

%Chunk = type {
	[100 x %Char],
	[1024 x %Char]
};


define internal void @write_example() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*))
	%2 = call %File* @fopen(%Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*))
	%3 = icmp eq %File* %2, bitcast (i8* null to %File*)
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @str4 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*))
	ret void
	br label %endif_0
endif_0:
	%6 = alloca %Chunk, align 1
	; pointers casting requires -funsafe translator option
	; (see Makefile)
	%7 = getelementptr [100 x %Char], %Chunk* %6, %Int32 0
	%8 = bitcast [100 x %Char]* %7 to [0 x %Char]*
	%9 = call [0 x %Char]* @strcpy([0 x %Char]* %8, [0 x %Char]* bitcast ([3 x i8]* @str5 to [0 x i8]*))
	%10 = getelementptr [1024 x %Char], %Chunk* %6, %Int32 1
	%11 = bitcast [1024 x %Char]* %10 to [0 x %Char]*
	%12 = call [0 x %Char]* @strcpy([0 x %Char]* %11, [0 x %Char]* bitcast ([5 x i8]* @str6 to [0 x i8]*))
	; write chunk to file
	%13 = bitcast %Chunk* %6 to i8*
	%14 = call %SizeT @fwrite(i8* %13, %SizeT 1124, %SizeT 1, %File* %2)
	%15 = call %Int @fclose(%File* %2)
	ret void
}

define internal void @read_example() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str7 to [0 x i8]*))
	%2 = call %File* @fopen(%Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([3 x i8]* @str8 to [0 x i8]*))
	%3 = icmp eq %File* %2, bitcast (i8* null to %File*)
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str9 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*))
	ret void
	br label %endif_0
endif_0:
	%6 = alloca %Chunk, align 1
	%7 = bitcast %Chunk* %6 to i8*
	%8 = call %SizeT @fread(i8* %7, %SizeT 1124, %SizeT 1, %File* %2)
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*))
	%10 = getelementptr [100 x %Char], %Chunk* %6, %Int32 0
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), [100 x %Char]* %10)
	%12 = getelementptr [1024 x %Char], %Chunk* %6, %Int32 1
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str12 to [0 x i8]*), [1024 x %Char]* %12)
	%14 = call %Int @fclose(%File* %2)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str13 to [0 x i8]*))
	call void @write_example()
	call void @read_example()
	ret %Int 0
}


