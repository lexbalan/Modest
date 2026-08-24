
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
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare [0 x %Char]* @strncpy([0 x %Char]* %dst, [0 x %ConstChar]* %src, %SizeT %n)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
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
@.str1 = private constant [9 x i8] [i8 102, i8 105, i8 108, i8 101, i8 46, i8 98, i8 105, i8 110, i8 0]
@.str2 = private constant [20 x i8] [i8 114, i8 117, i8 110, i8 32, i8 119, i8 114, i8 105, i8 116, i8 101, i8 69, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 40, i8 41, i8 10, i8 0]
@.str3 = private constant [3 x i8] [i8 119, i8 98, i8 0]
@.str4 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@.str5 = private constant [19 x i8] [i8 114, i8 117, i8 110, i8 32, i8 114, i8 101, i8 97, i8 100, i8 69, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 40, i8 41, i8 10, i8 0]
@.str6 = private constant [3 x i8] [i8 114, i8 98, i8 0]
@.str7 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@.str8 = private constant [21 x i8] [i8 102, i8 105, i8 108, i8 101, i8 32, i8 34, i8 37, i8 115, i8 34, i8 32, i8 99, i8 111, i8 110, i8 116, i8 97, i8 105, i8 110, i8 115, i8 58, i8 10, i8 0]
@.str9 = private constant [16 x i8] [i8 99, i8 104, i8 117, i8 110, i8 107, i8 46, i8 105, i8 100, i8 58, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@.str10 = private constant [18 x i8] [i8 99, i8 104, i8 117, i8 110, i8 107, i8 46, i8 100, i8 97, i8 116, i8 97, i8 58, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@.str11 = private constant [21 x i8] [i8 98, i8 105, i8 110, i8 97, i8 114, i8 121, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
; -- endstrings --
%Chunk = type {
	[100 x %Char],
	[1024 x %Char]
};

define internal void @writeExample() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str2 to [0 x i8]*))
	%2 = call i8* @fopen(%Str8* bitcast ([9 x i8]* @.str1 to [0 x i8]*), %ConstCharStr* bitcast ([3 x i8]* @.str3 to [0 x i8]*))
; if_0
	%3 = icmp eq i8* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @.str4 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @.str1 to [0 x i8]*))
	ret void
	br label %endif_0
endif_0:
	%6 = alloca %Chunk, align 1
	%7 = insertvalue [100 x %Char] zeroinitializer, %Char 105, 0
	%8 = insertvalue [100 x %Char] %7, %Char 100, 1
	%9 = insertvalue %Chunk zeroinitializer, [100 x %Char] %8, 0
	%10 = insertvalue [1024 x %Char] zeroinitializer, %Char 100, 0
	%11 = insertvalue [1024 x %Char] %10, %Char 97, 1
	%12 = insertvalue [1024 x %Char] %11, %Char 116, 2
	%13 = insertvalue [1024 x %Char] %12, %Char 97, 3
	%14 = insertvalue %Chunk %9, [1024 x %Char] %13, 1
	store %Chunk %14, %Chunk* %6
	%15 = bitcast %Chunk* %6 to i8*
	%16 = call %SizeT @fwrite(i8* %15, %SizeT 2048, %SizeT 1, i8* %2)
	%17 = call %Int @fclose(i8* %2)
	ret void
}

define internal void @readExample() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @.str5 to [0 x i8]*))
	%2 = call i8* @fopen(%Str8* bitcast ([9 x i8]* @.str1 to [0 x i8]*), %ConstCharStr* bitcast ([3 x i8]* @.str6 to [0 x i8]*))
; if_0
	%3 = icmp eq i8* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @.str7 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @.str1 to [0 x i8]*))
	ret void
	br label %endif_0
endif_0:
	%6 = alloca %Chunk, align 1
	%7 = bitcast %Chunk* %6 to i8*
	%8 = call %SizeT @fread(i8* %7, %SizeT 2048, %SizeT 1, i8* %2)
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str8 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @.str1 to [0 x i8]*))
	%10 = getelementptr %Chunk, %Chunk* %6, %Int32 0, %Int32 0
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str9 to [0 x i8]*), [100 x %Char]* %10)
	%12 = getelementptr %Chunk, %Chunk* %6, %Int32 0, %Int32 1
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str10 to [0 x i8]*), [1024 x %Char]* %12)
	%14 = call %Int @fclose(i8* %2)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str11 to [0 x i8]*))
	call void @writeExample()
	call void @readExample()
	ret %Int 0
}


