
target triple = "arm64-apple-darwin21.6.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]*
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

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr)
declare i32 @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)


declare i32 @setvbuf(%FILE*, %CharStr, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare i32 @printf(%ConstCharStr, ...)
declare i32 @scanf(%ConstCharStr, ...)
declare i32 @fprintf(%FILE*, %Str, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr, ...)
declare i32 @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare i32 @sprintf(%CharStr, %ConstCharStr, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr @fgets(%CharStr, i32, %FILE*)
declare i32 @fputs(%ConstCharStr, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr @gets(%CharStr)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/utf.hm


declare void @utf32_to_utf8(i32, [5 x i8]*)
declare void @utf8_puts([0 x i8]*)
declare void @utf16_puts([0 x i16]*)
declare void @utf32_puts([0 x i32]*)
declare void @utf32_putchar(i32)

; -- SOURCE: src/main.cm

@str1.c8 = private constant [12 x i8] c"S-t-r-i-n-g\00"
@str1.c16 = private constant [12 x i16] [i16 83, i16 45, i16 116, i16 45, i16 114, i16 45, i16 105, i16 45, i16 110, i16 45, i16 103, i16 0]
@str1.c32 = private constant [12 x i32] [i32 83, i32 45, i32 116, i32 45, i32 114, i32 45, i32 105, i32 45, i32 110, i32 45, i32 103, i32 0]
@str2.c8 = private constant [12 x i8] c"S-t-r-i-n-g\00"
@str2.c16 = private constant [12 x i16] [i16 83, i16 45, i16 116, i16 45, i16 114, i16 45, i16 105, i16 45, i16 110, i16 45, i16 103, i16 0]
@str2.c32 = private constant [12 x i32] [i32 83, i32 45, i32 116, i32 45, i32 114, i32 45, i32 105, i32 45, i32 110, i32 45, i32 103, i32 0]
@str3.c8 = private constant [12 x i8] c"S-t-r-i-n-g\00"
@str3.c16 = private constant [12 x i16] [i16 83, i16 45, i16 116, i16 45, i16 114, i16 45, i16 105, i16 45, i16 110, i16 45, i16 103, i16 0]
@str3.c32 = private constant [12 x i32] [i32 83, i32 45, i32 116, i32 45, i32 114, i32 45, i32 105, i32 45, i32 110, i32 45, i32 103, i32 0]
@str4.c8 = private constant [16 x i8] c"omegaCode = %d\0A\00"
@str5.c8 = private constant [14 x i8] c"ratCode = %d\0A\00"
@str6.c16 = private constant [10 x i16] [i16 72, i16 101, i16 108, i16 108, i16 111, i16 32, i16 937, i16 33, i16 10, i16 0]
@str7.c32 = private constant [10 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 32, i32 937, i32 33, i32 10, i32 0]
@str8.c32 = private constant [10 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 32, i32 128000, i32 33, i32 10, i32 0]
@str9.c8 = private constant [2 x i8] c"\0A\00"
@str10.c8 = private constant [2 x i8] c"\0A\00"
@str11.c8 = private constant [2 x i8] c"\0A\00"




@arr_utf8 = global [8 x i8] [
  i8 72,
  i8 105,
  i8 33,
  i8 10,
  i8 0,
  i8 0,
  i8 0,
  i8 0
]
@arr_utf16 = global [8 x i16] [
  i16 72,
  i16 101,
  i16 108,
  i16 108,
  i16 111,
  i16 33,
  i16 10,
  i16 0
]
@arr_utf32 = global [8 x i32] [
  i32 72,
  i32 101,
  i32 108,
  i32 108,
  i32 111,
  i32 33,
  i32 10,
  i32 0
]


define i32 @main() {
; indexing of GenericString returns #i symbol code
; the symbols have GenericInteger type
; you can assign omegaCharCode (937) to Nat32,
; but you can't assign ratCharCode (128000) to Nat16 (!)
    %omegaCode = alloca i16
    store i16 937, i16* %omegaCode
    %ratCode = alloca i32
    store i32 128000, i32* %ratCode
    %1 = load i16, i16* %omegaCode
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str4.c8, i16 %1)
    %3 = load i32, i32* %ratCode
    %4 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str5.c8, i32 %3)
    call void([0 x i16]*) @utf16_puts ([0 x i16]* @str6.c16)
    call void([0 x i32]*) @utf32_puts ([0 x i32]* @str7.c32)
    call void([0 x i32]*) @utf32_puts ([0 x i32]* @str8.c32)
    %str8 = alloca [0 x i8]*
    store [0 x i8]* @str3.c8, [0 x i8]** %str8
    %str16 = alloca [0 x i16]*
    store [0 x i16]* @str3.c16, [0 x i16]** %str16
    %str32 = alloca [0 x i32]*
    store [0 x i32]* @str3.c32, [0 x i32]** %str32
    %5 = load [0 x i8]*, [0 x i8]** %str8
    call void([0 x i8]*) @utf8_puts ([0 x i8]* %5)
    call void([0 x i8]*) @utf8_puts ([0 x i8]* @str9.c8)
    %6 = load [0 x i16]*, [0 x i16]** %str16
    call void([0 x i16]*) @utf16_puts ([0 x i16]* %6)
    call void([0 x i8]*) @utf8_puts ([0 x i8]* @str10.c8)
    %7 = load [0 x i32]*, [0 x i32]** %str32
    call void([0 x i32]*) @utf32_puts ([0 x i32]* %7)
    call void([0 x i8]*) @utf8_puts ([0 x i8]* @str11.c8)
    ret i32 0
}


