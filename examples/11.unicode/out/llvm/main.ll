
target triple = "arm64-apple-darwin21.6.0"

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




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
declare i32 @fprintf(%FILE*, [0 x i8]*, ...)
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

; -- MODULE: /Users/alexbalan/p/Modest/lib/misc/utf.hm



declare void @utf8_puts([0 x i8]*)
declare void @utf16_puts([0 x i16]*)
declare void @utf32_puts([0 x i32]*)
declare void @utf32_putchar(i32)
declare void @utf32_to_utf8(i32, [5 x i8]*)

; -- MODULE: /Users/alexbalan/p/Modest/examples/11.unicode/src/main.cm

@str.1 = private constant [7 x i8] c"Helo!\0A\00"
@str.2_utf16 = private constant [8 x i16] [i16 72, i16 101, i16 108, i16 108, i16 111, i16 33, i16 10, i16 0]
@str.3_utf32 = private constant [8 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 33, i32 10, i32 0]
@str.4_utf16 = private constant [10 x i16] [i16 72, i16 101, i16 108, i16 108, i16 111, i16 32, i16 937, i16 33, i16 10, i16 0]
@str.5_utf32 = private constant [10 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 32, i32 937, i32 33, i32 10, i32 0]
@str.6_utf32 = private constant [10 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 32, i32 128000, i32 33, i32 10, i32 0]






@arr_utf8 = global [8 x i8] [
  i8 72,
  i8 101,
  i8 108,
  i8 111,
  i8 33,
  i8 10,
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
;let clocale = setlocale(LC_ALL, nil)
;printf("clocale = %s\n", clocale)
;    utf32_putchar(ratUTF32)
;    utf32_putchar(0xA)
    call void([0 x i16]*) @utf16_puts ([0 x i16]* @str.4_utf16)
    call void([0 x i32]*) @utf32_puts ([0 x i32]* @str.5_utf32)
    call void([0 x i32]*) @utf32_puts ([0 x i32]* @str.6_utf32)
    ret i32 0
}


