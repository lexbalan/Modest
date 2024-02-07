
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm



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


declare i32 @fclose(%FILE* %f)
declare i32 @feof(%FILE* %f)
declare i32 @ferror(%FILE* %f)
declare i32 @fflush(%FILE* %f)
declare i32 @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare i32 @fseek(%FILE* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%FILE* %f, %FposT* %pos)
declare i64 @ftell(%FILE* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare i32 @setvbuf(%FILE* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%FILE* %stream, %Str* %format, ...)
declare i32 @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare i32 @fgetc(%FILE* %f)
declare i32 @fputc(i32 %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %FILE* %f)
declare i32 @fputs(%ConstCharStr* %str, %FILE* %f)
declare i32 @getc(%FILE* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %FILE* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/utf.hm


declare void @utf32_to_utf8(i32 %x, [5 x i8]* %buf)
declare i8 @utf16_to_utf32([0 x i16]* %c, i32* %result)
declare void @utf8_puts([0 x i8]* %s)
declare void @utf16_puts([0 x i16]* %s)
declare void @utf32_puts([0 x i32]* %s)
declare void @utf32_putchar(i32 %c)

; -- SOURCE: src/main.cm

@str1 = private constant [28 x i8] [i8 83, i8 45, i8 116, i8 45, i8 114, i8 45, i8 105, i8 45, i8 110, i8 45, i8 103, i8 45, i8 206, i8 169, i8 32, i8 240, i8 159, i8 144, i8 128, i8 240, i8 159, i8 142, i8 137, i8 240, i8 159, i8 166, i8 132, i8 0]
@str2 = private constant [21 x i16] [i16 83, i16 45, i16 116, i16 45, i16 114, i16 45, i16 105, i16 45, i16 110, i16 45, i16 103, i16 45, i16 937, i16 32, i16 55357, i16 56320, i16 55356, i16 57225, i16 55358, i16 56708, i16 0]
@str3 = private constant [18 x i32] [i32 83, i32 45, i32 116, i32 45, i32 114, i32 45, i32 105, i32 45, i32 110, i32 45, i32 103, i32 45, i32 937, i32 32, i32 128000, i32 127881, i32 129412, i32 0]
@str4 = private constant [15 x i8] [i8 91, i8 37, i8 100, i8 93, i8 85, i8 49, i8 54, i8 58, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str5 = private constant [2 x i8] [i8 10, i8 0]
@str6 = private constant [2 x i8] [i8 10, i8 0]
@str7 = private constant [2 x i8] [i8 10, i8 0]




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
    ;    let omegaCharCode = "Hello Ω!\n"[6]
    ;    let ratCharCode = "Hello 🐀!\n"[6]
    ; you can assign omegaCharCode (937) to Nat32,
    ; but you can't assign ratCharCode (128000) to Nat16 (!)
    ;    var omegaCode : Nat16 = omegaCharCode to Nat16
    ;    var ratCode : Nat32 = ratCharCode to Nat32
    ;    printf("omegaCode = %d\n", omegaCode)
    ;    printf("ratCode = %d\n", ratCode)
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %1
    %3 = getelementptr inbounds [0 x i16], [0 x i16]* bitcast ([21 x i16]* @str2 to [0 x i16]*), i32 0, i32 %2
    %4 = load i16, i16* %3
    %5 = icmp eq i16 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %7 = load i32, i32* %1
    %8 = zext i16 %4 to i32
    %9 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str4 to [0 x i8]*), i32 %7, i32 %8)
    %10 = load i32, i32* %1
    %11 = add i32 %10, 1
    store i32 %11, i32* %1
    br label %again_1
break_1:
    %12 = alloca [0 x i8]*
    store [0 x i8]* bitcast ([28 x i8]* @str1 to [0 x i8]*), [0 x i8]** %12
    %13 = alloca [0 x i16]*
    store [0 x i16]* bitcast ([21 x i16]* @str2 to [0 x i16]*), [0 x i16]** %13
    %14 = alloca [0 x i32]*
    store [0 x i32]* bitcast ([18 x i32]* @str3 to [0 x i32]*), [0 x i32]** %14
    %15 = load [0 x i8]*, [0 x i8]** %12
    call void ([0 x i8]*) @utf8_puts([0 x i8]* %15)
    call void ([0 x i8]*) @utf8_puts([0 x i8]* bitcast ([2 x i8]* @str5 to [0 x i8]*))
    %16 = load [0 x i16]*, [0 x i16]** %13
    call void ([0 x i16]*) @utf16_puts([0 x i16]* %16)
    call void ([0 x i8]*) @utf8_puts([0 x i8]* bitcast ([2 x i8]* @str6 to [0 x i8]*))
    %17 = load [0 x i32]*, [0 x i32]** %14
    call void ([0 x i32]*) @utf32_puts([0 x i32]* %17)
    call void ([0 x i8]*) @utf8_puts([0 x i8]* bitcast ([2 x i8]* @str7 to [0 x i8]*))
    ret i32 0
}


