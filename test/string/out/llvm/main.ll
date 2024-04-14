
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/utf.hm


declare i8 @utf32_to_utf8(i32 %c, [4 x i8]* %buf)
declare i8 @utf16_to_utf32([0 x i16]* %c, i32* %result)
declare void @utf8_putchar(i8 %c)
declare void @utf16_putchar(i16 %c)
declare void @utf32_putchar(i32 %c)
declare void @utf8_puts(%Str8* %s)
declare void @utf16_puts(%Str16* %s)
declare void @utf32_puts(%Str32* %s)


; -- SOURCE: src/main.cm

@str1 = private constant [13 x i8] [i8 83, i8 45, i8 116, i8 45, i8 114, i8 45, i8 105, i8 45, i8 110, i8 45, i8 103, i8 0, i8 0]
@str2 = private constant [15 x i16] [i16 83, i16 45, i16 116, i16 45, i16 114, i16 45, i16 105, i16 45, i16 110, i16 45, i16 103, i16 45, i16 937, i16 0, i16 0]
@str3 = private constant [19 x i32] [i32 83, i32 45, i32 116, i32 45, i32 114, i32 45, i32 105, i32 45, i32 110, i32 45, i32 103, i32 45, i32 937, i32 32, i32 128000, i32 127881, i32 129412, i32 0, i32 0]
@str4 = private constant [4 x i8] [i8 37, i8 99, i8 0, i8 0]
@str5 = private constant [4 x i8] [i8 37, i8 99, i8 0, i8 0]
@str6 = private constant [3 x i8] [i8 10, i8 0, i8 0]
@str7 = private constant [3 x i8] [i8 10, i8 0, i8 0]
@str8 = private constant [4 x i8] [i8 10, i8 10, i8 0, i8 0]
@str9 = private constant [3 x i8] [i8 10, i8 0, i8 0]
@str10 = private constant [3 x i8] [i8 10, i8 0, i8 0]
@str11 = private constant [4 x i8] [i8 10, i8 10, i8 0, i8 0]
@str12 = private constant [3 x i8] [i8 10, i8 0, i8 0]
@str13 = private constant [3 x i8] [i8 10, i8 0, i8 0]
@str14 = private constant [3 x i8] [i8 10, i8 0, i8 0]



@hello = constant [5 x i8] [
    i8 72,
    i8 101,
    i8 108,
    i8 108,
    i8 111
]
@world = constant [8 x i8] [
    i8 32,
    i8 119,
    i8 111,
    i8 114,
    i8 108,
    i8 100,
    i8 33,
    i8 10
]
@hello_world = constant [13 x i8] [
    i8 72,
    i8 101,
    i8 108,
    i8 108,
    i8 111,
    i8 32,
    i8 119,
    i8 111,
    i8 114,
    i8 108,
    i8 100,
    i8 33,
    i8 10
]

@string8 = global [11 x i8] [
    i8 83,
    i8 45,
    i8 116,
    i8 45,
    i8 114,
    i8 45,
    i8 105,
    i8 45,
    i8 110,
    i8 45,
    i8 103
]
@string16 = global [13 x i16] [
    i16 83,
    i16 45,
    i16 116,
    i16 45,
    i16 114,
    i16 45,
    i16 105,
    i16 45,
    i16 110,
    i16 45,
    i16 103,
    i16 45,
    i16 937
]
@string32 = global [17 x i32] [
    i32 83,
    i32 45,
    i32 116,
    i32 45,
    i32 114,
    i32 45,
    i32 105,
    i32 45,
    i32 110,
    i32 45,
    i32 103,
    i32 45,
    i32 937,
    i32 32,
    i32 128000,
    i32 127881,
    i32 129412
]
@ptr_to_string8 = global [0 x i8]* bitcast ([13 x i8]* @str1 to [0 x i8]*)
@ptr_to_string16 = global [0 x i16]* bitcast ([15 x i16]* @str2 to [0 x i16]*)
@ptr_to_string32 = global [0 x i32]* bitcast ([19 x i32]* @str3 to [0 x i32]*)

define void @putc8(i8 %c) {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str4 to [0 x i8]*), i8 %c)
    ret void
}

define void @putc16(i16 %c) {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str5 to [0 x i8]*), i16 %c)
    ret void
}

define %Int @main() {
    call void (i8) @utf8_putchar(i8 65)
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str6 to [0 x i8]*))
    call void (i16) @utf16_putchar(i16 937)
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str7 to [0 x i8]*))
    call void (i32) @utf32_putchar(i32 129412)
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str8 to [0 x i8]*))
    %4 = bitcast [11 x i8]* @string8 to %Str8*
    call void (%Str8*) @utf8_puts(%Str8* %4)
    %5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str9 to [0 x i8]*))
    %6 = bitcast [13 x i16]* @string16 to %Str16*
    call void (%Str16*) @utf16_puts(%Str16* %6)
    %7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str10 to [0 x i8]*))
    %8 = bitcast [17 x i32]* @string32 to %Str32*
    call void (%Str32*) @utf32_puts(%Str32* %8)
    %9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str11 to [0 x i8]*))
    %10 = load [0 x i8]*, [0 x i8]** @ptr_to_string8
    call void (%Str8*) @utf8_puts([0 x i8]* %10)
    %11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str12 to [0 x i8]*))
    %12 = load [0 x i16]*, [0 x i16]** @ptr_to_string16
    call void (%Str16*) @utf16_puts([0 x i16]* %12)
    %13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str13 to [0 x i8]*))
    %14 = load [0 x i32]*, [0 x i32]** @ptr_to_string32
    call void (%Str32*) @utf32_puts([0 x i32]* %14)
    %15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str14 to [0 x i8]*))
    ret %Int 0
}


