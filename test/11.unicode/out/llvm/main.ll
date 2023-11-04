
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

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


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr*, %ConstCharStr*)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr*, %ConstCharStr*, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr*)
declare i32 @rename(%ConstCharStr*, %ConstCharStr*)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr*)


declare i32 @setvbuf(%FILE*, %CharStr*, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr*)
declare i32 @printf(%ConstCharStr*, ...)
declare i32 @scanf(%ConstCharStr*, ...)
declare i32 @fprintf(%FILE*, %Str*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr*, ...)
declare i32 @sscanf(%ConstCharStr*, %ConstCharStr*, ...)
declare i32 @sprintf(%CharStr*, %ConstCharStr*, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr* @fgets(%CharStr*, i32, %FILE*)
declare i32 @fputs(%ConstCharStr*, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr*)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr*)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr*)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/utf.hm


declare void @utf32_to_utf8(i32, [5 x i8]*)
declare void @utf8_puts([0 x i8]*)
declare void @utf16_puts([0 x i16]*)
declare void @utf32_puts([0 x i32]*)
declare void @utf32_putchar(i32)

; -- SOURCE: src/main.cm

@str1 = private constant [12 x i8] [i8 83, i8 45, i8 116, i8 45, i8 114, i8 45, i8 105, i8 45, i8 110, i8 45, i8 103, i8 0]
@str2 = private constant [12 x i16] [i16 83, i16 45, i16 116, i16 45, i16 114, i16 45, i16 105, i16 45, i16 110, i16 45, i16 103, i16 0]
@str3 = private constant [12 x i32] [i32 83, i32 45, i32 116, i32 45, i32 114, i32 45, i32 105, i32 45, i32 110, i32 45, i32 103, i32 0]
@str4 = private constant [10 x i16] [i16 72, i16 101, i16 108, i16 108, i16 111, i16 32, i16 937, i16 33, i16 10, i16 0]
@str5 = private constant [10 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 32, i32 937, i32 33, i32 10, i32 0]
@str6 = private constant [10 x i32] [i32 72, i32 101, i32 108, i32 108, i32 111, i32 32, i32 128000, i32 33, i32 10, i32 0]
@str7 = private constant [2 x i8] [i8 10, i8 0]
@str8 = private constant [2 x i8] [i8 10, i8 0]
@str9 = private constant [2 x i8] [i8 10, i8 0]




@arr_utf8 = global [8 x i8] [
  i8 72,
  i8 105,
  i8 33,
  i8 10,
  i8 zeroinitializer,
  i8 zeroinitializer,
  i8 zeroinitializer,
  i8 zeroinitializer
]
@arr_utf16 = global [8 x i16] [
  i16 72,
  i16 101,
  i16 108,
  i16 108,
  i16 111,
  i16 33,
  i16 10,
  i16 zeroinitializer
]
@arr_utf32 = global [8 x i32] [
  i32 72,
  i32 101,
  i32 108,
  i32 108,
  i32 111,
  i32 33,
  i32 10,
  i32 zeroinitializer
]


define i32 @main() {
; indexing of GenericString returns #i symbol code
; the symbols have GenericInteger type
;    let omegaCharCode = "Hello Ω!\n"[6]
;    let ratCharCode = "Hello 🐀!\n"[6]
; you can assign omegaCharCode (937) to Nat32,
; but you can't assign ratCharCode (128000) to Nat16 (!)
;    var omegaCode : Nat16 := omegaCharCode to Nat16
;    var ratCode : Nat32 := ratCharCode to Nat32
;    printf("omegaCode = %d\n", omegaCode)
;    printf("ratCode = %d\n", ratCode)
    call void([0 x i16]*) @utf16_puts ([0 x i16]* bitcast ([10 x i16]* @str4 to [0 x i16]*))
    call void([0 x i32]*) @utf32_puts ([0 x i32]* bitcast ([10 x i32]* @str5 to [0 x i32]*))
    call void([0 x i32]*) @utf32_puts ([0 x i32]* bitcast ([10 x i32]* @str6 to [0 x i32]*))
    %str8 = alloca [0 x i8]*
    store [0 x i8]* bitcast ([12 x i8]* @str1 to [0 x i8]*), [0 x i8]** %str8
    %str16 = alloca [0 x i16]*
    store [0 x i16]* bitcast ([12 x i16]* @str2 to [0 x i16]*), [0 x i16]** %str16
    %str32 = alloca [0 x i32]*
    store [0 x i32]* bitcast ([12 x i32]* @str3 to [0 x i32]*), [0 x i32]** %str32
    %1 = load [0 x i8]*, [0 x i8]** %str8
    call void([0 x i8]*) @utf8_puts ([0 x i8]* %1)
    call void([0 x i8]*) @utf8_puts ([0 x i8]* bitcast ([2 x i8]* @str7 to [0 x i8]*))
    %2 = load [0 x i16]*, [0 x i16]** %str16
    call void([0 x i16]*) @utf16_puts ([0 x i16]* %2)
    call void([0 x i8]*) @utf8_puts ([0 x i8]* bitcast ([2 x i8]* @str8 to [0 x i8]*))
    %3 = load [0 x i32]*, [0 x i32]** %str32
    call void([0 x i32]*) @utf32_puts ([0 x i32]* %3)
    call void([0 x i8]*) @utf8_puts ([0 x i8]* bitcast ([2 x i8]* @str9 to [0 x i8]*))
    ret i32 0
}


