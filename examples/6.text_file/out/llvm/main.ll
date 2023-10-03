
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

; -- MODULE: /Users/alexbalan/p/Modest/examples/6.text_file/src/main.cm

@str1.c8 = private constant [9 x i8] c"file.txt\00"
@str2.c8 = private constant [19 x i8] c"run write_example\0A\00"
@str3.c8 = private constant [2 x i8] c"w\00"
@str4.c8 = private constant [31 x i8] c"error: cannot create file \27%s\27\00"
@str5.c8 = private constant [12 x i8] c"some text.\0A\00"
@str6.c8 = private constant [18 x i8] c"run read_example\0A\00"
@str7.c8 = private constant [2 x i8] c"r\00"
@str8.c8 = private constant [29 x i8] c"error: cannot open file \27%s\27\00"
@str9.c8 = private constant [21 x i8] c"file \27%s\27 contains: \00"
@str10.c8 = private constant [19 x i8] c"text_file example\0A\00"




define void @write_example() {
    %1 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str2.c8)
    %2 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr @str1.c8, %ConstCharStr @str3.c8)
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str4.c8, [0 x i8]* @str1.c8)
    ret void
    br label %endif_0
endif_0:
    %6 = call i32(%FILE*, [0 x i8]*, ...) @fprintf (%FILE* %2, [0 x i8]* @str5.c8)
    %7 = call i32(%FILE*) @fclose (%FILE* %2)
    ret void
}

define void @read_example() {
    %1 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str6.c8)
    %2 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr @str1.c8, %ConstCharStr @str7.c8)
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str8.c8, [0 x i8]* @str1.c8)
    ret void
    br label %endif_0
endif_0:
    %6 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str9.c8, [0 x i8]* @str1.c8)
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %7 = call i32(%FILE*) @fgetc (%FILE* %2)
    %8 = icmp eq i32 %7, -1
    br i1 %8 , label %then_1, label %endif_1
then_1:
    br label %break_1
    br label %endif_1
endif_1:
    %10 = call i32(i32) @putchar (i32 %7)
    br label %again_1
break_1:
    %11 = call i32(%FILE*) @fclose (%FILE* %2)
    ret void
}

define i32 @main() {
    %1 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr @str10.c8)
    call void() @write_example ()
    call void() @read_example ()
    ret i32 0
}


