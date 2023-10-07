
target triple = "arm64-apple-darwin21.6.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

; -- SOURCE: src/main.cm

@str1.c8 = private constant [13 x i8] c"f0 x.x = %d\0A\00"
@str2.c8 = private constant [13 x i8] c"f1 x.x = %d\0A\00"
@str3.c8 = private constant [13 x i8] c"f2 x.x = %d\0A\00"
@str4.c8 = private constant [13 x i8] c"f3 x.x = %d\0A\00"
@str5.c8 = private constant [14 x i8] c"f0p x.x = %d\0A\00"
@str6.c8 = private constant [14 x i8] c"f1p x.x = %d\0A\00"
@str7.c8 = private constant [14 x i8] c"f2p x.x = %d\0A\00"
@str8.c8 = private constant [14 x i8] c"f3p x.x = %d\0A\00"



%Type1 = type {
	i32
}

%Type2 = type {
	i32
}

%Type3 = type {
	i32
}


define void @f0(%Type1 %x) {
    %1 = extractvalue %Type1 %x, 0
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str1.c8, i32 %1)
    ret void
}

define void @f1(%Type2 %x) {
    %1 = extractvalue %Type2 %x, 0
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str2.c8, i32 %1)
    ret void
}

define void @f2(%Type3 %x) {
    %1 = extractvalue %Type3 %x, 0
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str3.c8, i32 %1)
    ret void
}

define void @f3({
	i32
} %x) {
    %1 = extractvalue {
	i32
} %x, 0
    %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str4.c8, i32 %1)
    ret void
}

define void @f0p(%Type1* %x) {
    %1 = getelementptr inbounds %Type1, %Type1* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str5.c8, i32 %2)
    ret void
}

define void @f1p(%Type2* %x) {
    %1 = getelementptr inbounds %Type2, %Type2* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str6.c8, i32 %2)
    ret void
}

define void @f2p(%Type3* %x) {
    %1 = getelementptr inbounds %Type3, %Type3* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str7.c8, i32 %2)
    ret void
}

define void @f3p({
	i32
}* %x) {
    %1 = getelementptr inbounds {
	i32
}, {
	i32
}* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str8.c8, i32 %2)
    ret void
}


@a = global %Type1 {
  i32 1
}
@b = global %Type2 {
  i32 2
}
@c = global %Type3 {
  i32 3
}

define void @test_by_value() {
    %1 = load %Type1, %Type1* @a
    call void(%Type1) @f0 (%Type1 %1)
    %2 = load %Type1, %Type1* @a
    call void(%Type2) @f1 (%Type2 %2)
    %3 = load %Type1, %Type1* @a
    call void(%Type3) @f2 (%Type3 %3)
;f3(a)
    %4 = load %Type2, %Type2* @b
    call void(%Type1) @f0 (%Type1 %4)
    %5 = load %Type2, %Type2* @b
    call void(%Type2) @f1 (%Type2 %5)
    %6 = load %Type2, %Type2* @b
    call void(%Type3) @f2 (%Type3 %6)
;f3(b)
    %7 = load %Type3, %Type3* @c
    call void(%Type1) @f0 (%Type1 %7)
    %8 = load %Type3, %Type3* @c
    call void(%Type2) @f1 (%Type2 %8)
    %9 = load %Type3, %Type3* @c
    call void(%Type3) @f2 (%Type3 %9)
;f3(c)
    ret void
}

define void @test_by_pointer() {
    call void(%Type1*) @f0p (%Type1* @a)
    call void(%Type2*) @f1p (%Type2* @a)
    call void(%Type3*) @f2p (%Type3* @a)
;f3p(&a)
    call void(%Type1*) @f0p (%Type1* @b)
    call void(%Type2*) @f1p (%Type2* @b)
    call void(%Type3*) @f2p (%Type3* @b)
;f3p(&b)
    call void(%Type1*) @f0p (%Type1* @c)
    call void(%Type2*) @f1p (%Type2* @c)
    call void(%Type3*) @f2p (%Type3* @c)
;f3p(&c)
    ret void
}

define i32 @main() {
    call void() @test_by_value ()
    call void() @test_by_pointer ()
    ret i32 0
}


