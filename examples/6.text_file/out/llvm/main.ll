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

@str_1 = private constant [9 x i8] c"file.txt\00"
@str_2 = private constant [19 x i8] c"run write_example\0A\00"
@str_3 = private constant [2 x i8] c"w\00"
@str_4 = private constant [31 x i8] c"error: cannot create file \27%s\27\00"
@str_5 = private constant [12 x i8] c"some text.\0A\00"
@str_6 = private constant [18 x i8] c"run read_example\0A\00"
@str_7 = private constant [2 x i8] c"r\00"
@str_8 = private constant [29 x i8] c"error: cannot open file \27%s\27\00"
@str_9 = private constant [21 x i8] c"file \27%s\27 contains: \00"
@str_10 = private constant [19 x i8] c"text_file example\0A\00"



define void @write_example() {
  %1 = bitcast [19 x i8]* @str_2 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %3 = bitcast [9 x i8]* @str_1 to %ConstCharStr
  %4 = bitcast [2 x i8]* @str_3 to %ConstCharStr
  %5 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr %3, %ConstCharStr %4)
  %6 = icmp eq %FILE* %5, null
  br i1 %6 , label %then_0, label %endif_0
then_0:
  %7 = bitcast [31 x i8]* @str_4 to %ConstCharStr
  %8 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %7, [9 x i8]* @str_1)
  ret void
  br label %endif_0
endif_0:
  %10 = bitcast [12 x i8]* @str_5 to [0 x i8]*
  %11 = call i32(%FILE*, [0 x i8]*, ...) @fprintf (%FILE* %5, [0 x i8]* %10)
  %12 = call i32(%FILE*) @fclose (%FILE* %5)
  ret void
}

define void @read_example() {
  %1 = bitcast [18 x i8]* @str_6 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %3 = bitcast [9 x i8]* @str_1 to %ConstCharStr
  %4 = bitcast [2 x i8]* @str_7 to %ConstCharStr
  %5 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr %3, %ConstCharStr %4)
  %6 = icmp eq %FILE* %5, null
  br i1 %6 , label %then_0, label %endif_0
then_0:
  %7 = bitcast [29 x i8]* @str_8 to %ConstCharStr
  %8 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %7, [9 x i8]* @str_1)
  ret void
  br label %endif_0
endif_0:
  %10 = bitcast [21 x i8]* @str_9 to %ConstCharStr
  %11 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %10, [9 x i8]* @str_1)
  br label %again_1
again_1:
  br i1 1 , label %body_1, label %break_1
body_1:
  %12 = call i32(%FILE*) @fgetc (%FILE* %5)
  %13 = icmp eq i32 %12, -1
  br i1 %13 , label %then_1, label %endif_1
then_1:
  br label %break_1
  br label %endif_1
endif_1:
  %15 = call i32(i32) @putchar (i32 %12)
  br label %again_1
break_1:
  %16 = call i32(%FILE*) @fclose (%FILE* %5)
  ret void
}

define i32 @main() {
  %1 = bitcast [19 x i8]* @str_10 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  call void() @write_example ()
  call void() @read_example ()
  ret i32 0
}


