
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

@str1 = private constant [13 x i8] [i8 98, i8 111, i8 111, i8 108, i8 32, i8 99, i8 104, i8 101, i8 99, i8 107, i8 10, i8 109, i8 0]
@str2 = private constant [8 x i8] [i8 120, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str3 = private constant [16 x i8] [i8 120, i8 32, i8 116, i8 111, i8 32, i8 66, i8 111, i8 111, i8 108, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str4 = private constant [8 x i8] [i8 120, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str5 = private constant [16 x i8] [i8 120, i8 32, i8 116, i8 111, i8 32, i8 66, i8 111, i8 111, i8 108, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str6 = private constant [8 x i8] [i8 120, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str7 = private constant [16 x i8] [i8 120, i8 32, i8 116, i8 111, i8 32, i8 66, i8 111, i8 111, i8 108, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]



define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*))
	%2 = alloca i8
	%3 = alloca i1
	store i8 1, i8* %2
	%4 = load i8, i8* %2
	%5 = icmp ne i8 %4, 0
	store i1 %5, i1* %3
	%6 = load i8, i8* %2
	%7 = zext i8 %6 to i32
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str2 to [0 x i8]*), i32 %7)
	%9 = load i1, i1* %3
	%10 = zext i1 %9 to i32
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str3 to [0 x i8]*), i32 %10)
	store i8 2, i8* %2
	%12 = load i8, i8* %2
	%13 = icmp ne i8 %12, 0
	store i1 %13, i1* %3
	%14 = load i8, i8* %2
	%15 = zext i8 %14 to i32
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), i32 %15)
	%17 = load i1, i1* %3
	%18 = zext i1 %17 to i32
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), i32 %18)
	store i8 3, i8* %2
	%20 = load i8, i8* %2
	%21 = icmp ne i8 %20, 0
	store i1 %21, i1* %3
	%22 = load i8, i8* %2
	%23 = zext i8 %22 to i32
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str6 to [0 x i8]*), i32 %23)
	%25 = load i1, i1* %3
	%26 = zext i1 %25 to i32
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str7 to [0 x i8]*), i32 %26)
	ret %Int 0
}


