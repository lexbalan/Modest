
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

; from import "mem"
declare void @memory_zero(i8* %mem, %Nat64 %len)
declare void @memory_copy(i8* %dst, i8* %src, %Nat64 %len)
declare %Bool @memory_eq(i8* %mem0, i8* %mem1, %Nat64 %len)

; end from import "mem"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [14 x i8] [i8 109, i8 101, i8 109, i8 99, i8 111, i8 112, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str2 = private constant [11 x i8] [i8 76, i8 69, i8 78, i8 32, i8 61, i8 32, i8 37, i8 122, i8 117, i8 10, i8 0]
@.str3 = private constant [18 x i8] [i8 102, i8 105, i8 114, i8 115, i8 116, i8 110, i8 97, i8 109, i8 101, i8 32, i8 61, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@.str4 = private constant [17 x i8] [i8 108, i8 97, i8 115, i8 116, i8 110, i8 97, i8 109, i8 101, i8 32, i8 61, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@.str5 = private constant [10 x i8] [i8 97, i8 103, i8 101, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --
%Object = type {
	[32 x %Char8],
	[32 x %Char8],
	%Int32
};

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str1 to [0 x i8]*))
	%2 = alloca %Object, align 4
	%3 = alloca %Object, align 4
	%4 = insertvalue [32 x %Char8] zeroinitializer, %Char8 74, 0
	%5 = insertvalue [32 x %Char8] %4, %Char8 111, 1
	%6 = insertvalue [32 x %Char8] %5, %Char8 104, 2
	%7 = insertvalue [32 x %Char8] %6, %Char8 110, 3
	%8 = insertvalue %Object zeroinitializer, [32 x %Char8] %7, 0
	%9 = insertvalue [32 x %Char8] zeroinitializer, %Char8 68, 0
	%10 = insertvalue [32 x %Char8] %9, %Char8 111, 1
	%11 = insertvalue [32 x %Char8] %10, %Char8 101, 2
	%12 = insertvalue %Object %8, [32 x %Char8] %11, 1
	%13 = insertvalue %Object %12, %Int32 30, 2
	store %Object %13, %Object* %2
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @.str2 to [0 x i8]*), %Size 128)
	%15 = bitcast %Object* %3 to i8*
	%16 = bitcast %Object* %2 to i8*
	call void @memory_copy(i8* %15, i8* %16, %Size 128)
	%17 = getelementptr %Object, %Object* %3, %Int32 0, %Int32 0
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str3 to [0 x i8]*), [32 x %Char8]* %17)
	%19 = getelementptr %Object, %Object* %3, %Int32 0, %Int32 1
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str4 to [0 x i8]*), [32 x %Char8]* %19)
	%21 = getelementptr %Object, %Object* %3, %Int32 0, %Int32 2
	%22 = load %Int32, %Int32* %21
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str5 to [0 x i8]*), %Int32 %22)
	ret %Int 0
}


