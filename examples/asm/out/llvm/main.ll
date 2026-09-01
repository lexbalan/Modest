
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
%Float16 = type half
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
@.str1 = private constant [21 x i8] [i8 115, i8 117, i8 109, i8 115, i8 117, i8 98, i8 54, i8 52, i8 32, i8 115, i8 117, i8 109, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@.str2 = private constant [21 x i8] [i8 115, i8 117, i8 109, i8 115, i8 117, i8 98, i8 54, i8 52, i8 32, i8 115, i8 117, i8 98, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@.str3 = private constant [17 x i8] [i8 105, i8 110, i8 108, i8 105, i8 110, i8 101, i8 32, i8 97, i8 115, i8 109, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str4 = private constant [24 x i8] [i8 115, i8 117, i8 109, i8 40, i8 37, i8 108, i8 108, i8 100, i8 44, i8 32, i8 37, i8 108, i8 108, i8 100, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@.str5 = private constant [24 x i8] [i8 115, i8 117, i8 98, i8 40, i8 37, i8 108, i8 108, i8 100, i8 44, i8 32, i8 37, i8 108, i8 108, i8 100, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
; -- endstrings --
define internal void @memoryBarrier() {
	call void asm sideeffect "", "~{memory}" ()
	ret void
}

define internal %Int64 @sum64(%Int64 %a, %Int64 %b) {
	%1 = alloca %Int64, align 8
	%2 = call %Int64 asm sideeffect "add $0, $1, $2", "=r,r,r,~{cc}" (%Int64 %a, %Int64 %b)
	store %Int64 %2, %Int64* %1
	%3 = load %Int64, %Int64* %1
	ret %Int64 %3
}

define internal %Int64 @sub64(%Int64 %a, %Int64 %b) {
	%1 = alloca %Int64, align 8
	%2 = call %Int64 asm sideeffect "sub $0, $1, $2", "=r,r,r,~{cc}" (%Int64 %a, %Int64 %b)
	store %Int64 %2, %Int64* %1
	%3 = load %Int64, %Int64* %1
	ret %Int64 %3
}

define internal void @sumsub64(%Int64 %a, %Int64 %b) {
	%1 = alloca %Int64, align 8
	%2 = alloca %Int64, align 8
	%3 = call {%Int64,%Int64} asm sideeffect "add $0, $2, $3\0Asub $1, $2, $3\0A", "=&r,=&r,r,r,~{cc}" (%Int64 %a, %Int64 %b)
	%4 = extractvalue {%Int64,%Int64} %3, 0
	store %Int64 %4, %Int64* %1
	%5 = extractvalue {%Int64,%Int64} %3, 1
	store %Int64 %5, %Int64* %2
	%6 = load %Int64, %Int64* %1
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str1 to [0 x i8]*), %Int64 %6)
	%8 = load %Int64, %Int64* %2
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str2 to [0 x i8]*), %Int64 %8)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str3 to [0 x i8]*))
	call void asm sideeffect "nop", "" ()
	%2 = alloca %Int64, align 8
	store %Int64 10, %Int64* %2
	%3 = alloca %Int64, align 8
	store %Int64 20, %Int64* %3
	%4 = load %Int64, %Int64* %2
	%5 = load %Int64, %Int64* %3
	%6 = call %Int64 @sum64(%Int64 %4, %Int64 %5)
	%7 = load %Int64, %Int64* %2
	%8 = load %Int64, %Int64* %3
	%9 = call %Int64 @sub64(%Int64 %7, %Int64 %8)
	%10 = load %Int64, %Int64* %2
	%11 = load %Int64, %Int64* %3
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str4 to [0 x i8]*), %Int64 %10, %Int64 %11, %Int64 %6)
	%13 = load %Int64, %Int64* %2
	%14 = load %Int64, %Int64* %3
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str5 to [0 x i8]*), %Int64 %13, %Int64 %14, %Int64 %9)
	%16 = load %Int64, %Int64* %2
	%17 = load %Int64, %Int64* %3
	call void @sumsub64(%Int64 %16, %Int64 %17)
	ret %Int 0
}


