
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
%VA_List = type i8*; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm



; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]
%Char = type i8
%ConstChar = type i8
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
%SizeT = type i64
%SSizeT = type i64

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


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

@str1 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 48, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str2 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 49, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str3 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 50, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str4 = private constant [19 x i8] [i8 98, i8 105, i8 103, i8 51, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str5 = private constant [22 x i8] [i8 98, i8 105, i8 103, i8 95, i8 115, i8 117, i8 109, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 108, i8 108, i8 88, i8 37, i8 108, i8 108, i8 88, i8 10, i8 0]
@str6 = private constant [13 x i8] [i8 115, i8 105, i8 103, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]



@big0 = global i128 1512366075204170947332355369683137040

define i64 @high_128(i128 %x) {
    %1 = lshr i128 %x, 64
    %2 = trunc i128 %1 to i64
    ret i64 %2
}

define i64 @low_128(i128 %x) {
    %1 = and i128 %x, 18446744073709551615
    %2 = trunc i128 %1 to i64
    ret i64 %2
}

define %Int @main() {
    %1 = alloca i128
    store i128 340282366920938463463374607431768211455, i128* %1
    %2 = alloca i128
    store i128 1, i128* %2
    %3 = alloca i32
    store i32 1, i32* %3
    %4 = load i128, i128* %1
    %5 = add i128 340282366920938463463374607431768211455, %4
    %6 = load i32, i32* %3
    %7 = zext i32 %6 to i128
    %8 = add i128 %5, %7
    %9 = alloca i128
    store i128 %8, i128* %9
    %10 = load i128, i128* @big0
    %11 = call i64 (i128) @high_128(i128 %10)
    %12 = load i128, i128* @big0
    %13 = call i64 (i128) @low_128(i128 %12)
    %14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*), i64 %11, i64 %13)
    %15 = call i64 (i128) @high_128(i128 340282366920938463463374607431768211455)
    %16 = call i64 (i128) @low_128(i128 340282366920938463463374607431768211455)
    %17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*), i64 %15, i64 %16)
    %18 = load i128, i128* %1
    %19 = call i64 (i128) @high_128(i128 %18)
    %20 = load i128, i128* %1
    %21 = call i64 (i128) @low_128(i128 %20)
    %22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str3 to [0 x i8]*), i64 %19, i64 %21)
    %23 = load i128, i128* %2
    %24 = call i64 (i128) @high_128(i128 %23)
    %25 = load i128, i128* %2
    %26 = call i64 (i128) @low_128(i128 %25)
    %27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str4 to [0 x i8]*), i64 %24, i64 %26)
    %28 = load i128, i128* %9
    %29 = call i64 (i128) @high_128(i128 %28)
    %30 = load i128, i128* %9
    %31 = call i64 (i128) @low_128(i128 %30)
    %32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str5 to [0 x i8]*), i64 %29, i64 %31)
    ; signed big int test
    %33 = alloca i128
    store i128 -1, i128* %33
    %34 = load i128, i128* %33
    %35 = add i128 %34, 1
    store i128 %35, i128* %33
    %36 = load i128, i128* %33
    %37 = trunc i128 %36 to i64
    %38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str6 to [0 x i8]*), i64 %37)
    ret %Int 0
}


