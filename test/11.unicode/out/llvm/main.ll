
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

@str1 = private constant [28 x i8] [i8 83, i8 45, i8 116, i8 45, i8 114, i8 45, i8 105, i8 45, i8 110, i8 45, i8 103, i8 45, i8 206, i8 169, i8 32, i8 240, i8 159, i8 144, i8 128, i8 240, i8 159, i8 142, i8 137, i8 240, i8 159, i8 166, i8 132, i8 0]
@str2 = private constant [21 x i16] [i16 83, i16 45, i16 116, i16 45, i16 114, i16 45, i16 105, i16 45, i16 110, i16 45, i16 103, i16 45, i16 937, i16 32, i16 55357, i16 56320, i16 55356, i16 57225, i16 55358, i16 56708, i16 0]
@str3 = private constant [18 x i32] [i32 83, i32 45, i32 116, i32 45, i32 114, i32 45, i32 105, i32 45, i32 110, i32 45, i32 103, i32 45, i32 937, i32 32, i32 128000, i32 127881, i32 129412, i32 0]
@str4 = private constant [15 x i8] [i8 91, i8 37, i8 100, i8 93, i8 85, i8 49, i8 54, i8 58, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str5 = private constant [2 x i8] [i8 10, i8 0]
@str6 = private constant [2 x i8] [i8 10, i8 0]
@str7 = private constant [2 x i8] [i8 10, i8 0]



@ratSymbolUTF8 = constant [4 x i8] [
    i8 240,
    i8 159,
    i8 144,
    i8 128
]
@ratSymbolUTF16 = constant [2 x i16] [
    i16 55357,
    i16 56320
]

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


define %Int @main() {
    ; indexing of GenericString returns #i symbol code
    ; the symbols have GenericInteger type
    ;	let omegaCharCode = "Hello Ω!\n"[6]
    ;	let ratCharCode = "Hello 🐀!\n"[6]
    ; you can assign omegaCharCode (937) to Nat32,
    ; but you can't assign ratCharCode (128000) to Nat16 (!)
    ;	var omegaCode: Nat16 = Nat16 omegaCharCode
    ;	var ratCode: Nat32 = Nat32 ratCharCode
    ;	printf("omegaCode = %d\n", omegaCode)
    ;	printf("ratCode = %d\n", ratCode)
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %1
    %3 = getelementptr inbounds %Str16, %Str16* bitcast ([21 x i16]* @str2 to [0 x i16]*), i32 0, i32 %2
    %4 = load i16, i16* %3
    %5 = icmp eq i16 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %7 = load i32, i32* %1
    %8 = zext i16 %4 to i32
    %9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str4 to [0 x i8]*), i32 %7, i32 %8)
    %10 = load i32, i32* %1
    %11 = add i32 %10, 1
    store i32 %11, i32* %1
    br label %again_1
break_1:
    %12 = alloca %Str8*
    store %Str8* bitcast ([28 x i8]* @str1 to [0 x i8]*), %Str8** %12
    %13 = alloca %Str16*
    store %Str16* bitcast ([21 x i16]* @str2 to [0 x i16]*), %Str16** %13
    %14 = alloca %Str32*
    store %Str32* bitcast ([18 x i32]* @str3 to [0 x i32]*), %Str32** %14
    %15 = load %Str8*, %Str8** %12
    call void (%Str8*) @utf8_puts(%Str8* %15)
    call void (%Str8*) @utf8_puts(%Str8* bitcast ([2 x i8]* @str5 to [0 x i8]*))
    %16 = load %Str16*, %Str16** %13
    call void (%Str16*) @utf16_puts(%Str16* %16)
    call void (%Str8*) @utf8_puts(%Str8* bitcast ([2 x i8]* @str6 to [0 x i8]*))
    %17 = load %Str32*, %Str32** %14
    call void (%Str32*) @utf32_puts(%Str32* %17)
    call void (%Str8*) @utf8_puts(%Str8* bitcast ([2 x i8]* @str7 to [0 x i8]*))
    ret %Int 0
}


