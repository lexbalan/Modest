
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8
%Char = type i8
%ConstChar = type %Char
%SignedChar = type i8
%UnsignedChar = type i8
%Short = type i16
%UnsignedShort = type i16
%Int = type i32
%UnsignedInt = type i32
%LongInt = type i64
%UnsignedLongInt = type i64
%Long = type i64
%UnsignedLong = type i64
%LongLong = type i64
%UnsignedLongLong = type i64
%LongLongInt = type i64
%UnsignedLongLongInt = type i64
%Float = type double
%Double = type double
%LongDouble = type double


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FILE = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare %Int @setvbuf(%FILE* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%FILE* %stream, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: src/main.cm

@str1 = private constant [21 x i8] [i8 115, i8 117, i8 109, i8 115, i8 117, i8 98, i8 54, i8 52, i8 32, i8 115, i8 117, i8 109, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@str2 = private constant [21 x i8] [i8 115, i8 117, i8 109, i8 115, i8 117, i8 98, i8 54, i8 52, i8 32, i8 115, i8 117, i8 98, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@str3 = private constant [17 x i8] [i8 105, i8 110, i8 108, i8 105, i8 110, i8 101, i8 32, i8 97, i8 115, i8 109, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str4 = private constant [24 x i8] [i8 115, i8 117, i8 109, i8 40, i8 37, i8 108, i8 108, i8 100, i8 44, i8 32, i8 37, i8 108, i8 108, i8 100, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@str5 = private constant [24 x i8] [i8 115, i8 117, i8 98, i8 40, i8 37, i8 108, i8 108, i8 100, i8 44, i8 32, i8 37, i8 108, i8 108, i8 100, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]



define i64 @sum64(i64 %a, i64 %b) {
	%1 = alloca i64
	%2 = call i64 asm sideeffect "add $0, $1, $2", "=r,r,r,~{cc}" (i64 %a, i64 %b)
	store i64 %2, i64* %1
	%3 = load i64, i64* %1
	ret i64 %3
}

define i64 @sub64(i64 %a, i64 %b) {
	%1 = alloca i64
	%2 = call i64 asm sideeffect "sub $0, $1, $2", "=r,r,r,~{cc}" (i64 %a, i64 %b)
	store i64 %2, i64* %1
	%3 = load i64, i64* %1
	ret i64 %3
}

define void @sumsub64(i64 %a, i64 %b) {
	%1 = alloca i64
	%2 = alloca i64
	;let s = 1 + 2
	%3 = call {i64, i64} asm sideeffect "add $0, $2, $3\0Asub $1, $2, $3\0A", "=&r,=&r,r,r,~{cc}" (i64 %a, i64 %b)
	%4 = extractvalue {i64, i64} %3, 0
	store i64 %4, i64* %1
	%5 = extractvalue {i64, i64} %3, 1
	store i64 %5, i64* %2
	%6 = load i64, i64* %1
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*), i64 %6)
	%8 = load i64, i64* %2
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str2 to [0 x i8]*), i64 %8)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str3 to [0 x i8]*))
	%2 = alloca i64
	store i64 10, i64* %2
	%3 = alloca i64
	store i64 20, i64* %3
	%4 = load i64, i64* %2
	%5 = load i64, i64* %3
	%6 = call i64 (i64, i64) @sum64(i64 %4, i64 %5)
	%7 = load i64, i64* %2
	%8 = load i64, i64* %3
	%9 = call i64 (i64, i64) @sub64(i64 %7, i64 %8)
	%10 = load i64, i64* %2
	%11 = load i64, i64* %3
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str4 to [0 x i8]*), i64 %10, i64 %11, i64 %6)
	%13 = load i64, i64* %2
	%14 = load i64, i64* %3
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str5 to [0 x i8]*), i64 %13, i64 %14, i64 %9)
	%16 = load i64, i64* %2
	%17 = load i64, i64* %3
	call void (i64, i64) @sumsub64(i64 %16, i64 %17)
	ret %Int 0
}


