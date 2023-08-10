; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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
%SizeT = type i64
%SSizeT = type i64

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*

declare %Int @fclose(%FILE*)
declare %Int @feof(%FILE*)
declare %Int @ferror(%FILE*)
declare %Int @fflush(%FILE*)
declare %Int @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare %SizeT @fread(i8*, %SizeT, %SizeT, %FILE*)
declare %SizeT @fwrite(i8*, %SizeT, %SizeT, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare %Int @fseek(%FILE*, %LongInt, %Int)
declare %Int @fsetpos(%FILE*, %FposT*)
declare %LongInt @ftell(%FILE*)
declare %Int @remove(%ConstCharStr)
declare %Int @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)


declare %Int @setvbuf(%FILE*, %CharStr, %Int, %SizeT)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare %Int @printf(%ConstCharStr, ...)
declare %Int @scanf(%ConstCharStr, ...)
declare %Int @fprintf(%FILE*, [0 x i8]*, ...)
declare %Int @fscanf(%FILE*, %ConstCharStr, ...)
declare %Int @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare %Int @sprintf(%CharStr, %ConstCharStr, ...)


declare %Int @fgetc(%FILE*)
declare %Int @fputc(%Int, %FILE*)
declare %CharStr @fgets(%CharStr, %Int, %FILE*)
declare %Int @fputs(%ConstCharStr, %FILE*)
declare %Int @getc(%FILE*)
declare %Int @getchar()
declare %CharStr @gets(%CharStr)
declare %Int @putc(%Int, %FILE*)
declare %Int @putchar(%Int)
declare %Int @puts(%ConstCharStr)
declare %Int @ungetc(%Int, %FILE*)
declare void @perror(%ConstCharStr)

; -- MODULE: /Users/alexbalan/p/Modest/examples/2.if-else/src/main.cm

@str_1 = private constant [17 x i8] c"if-else example\0A\00"
@str_2 = private constant [10 x i8] c"enter a: \00"
@str_3 = private constant [3 x i8] c"%d\00"
@str_4 = private constant [10 x i8] c"enter b: \00"
@str_5 = private constant [3 x i8] c"%d\00"
@str_6 = private constant [7 x i8] c"a > b\0A\00"
@str_7 = private constant [7 x i8] c"a < b\0A\00"
@str_8 = private constant [8 x i8] c"a == b\0A\00"



define %Int @main() {
  %1 = bitcast [17 x i8]* @str_1 to %ConstCharStr
  %2 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %a = alloca i32
  %b = alloca i32
  %3 = bitcast [10 x i8]* @str_2 to %ConstCharStr
  %4 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %3)
  %5 = bitcast [3 x i8]* @str_3 to %ConstCharStr
  %6 = call %Int(%ConstCharStr, ...) @scanf (%ConstCharStr %5, i32* %a)
  %7 = bitcast [10 x i8]* @str_4 to %ConstCharStr
  %8 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %7)
  %9 = bitcast [3 x i8]* @str_5 to %ConstCharStr
  %10 = call %Int(%ConstCharStr, ...) @scanf (%ConstCharStr %9, i32* %b)
  %11 = load i32, i32* %a
  %12 = load i32, i32* %b
  %13 = icmp sgt i32 %11, %12
  br i1 %13 , label %then_0, label %else_0
then_0:
  %14 = bitcast [7 x i8]* @str_6 to %ConstCharStr
  %15 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %14)
  br label %endif_0
else_0:
  %16 = load i32, i32* %a
  %17 = load i32, i32* %b
  %18 = icmp slt i32 %16, %17
  br i1 %18 , label %then_1, label %else_1
then_1:
  %19 = bitcast [7 x i8]* @str_7 to %ConstCharStr
  %20 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %19)
  br label %endif_1
else_1:
  %21 = bitcast [8 x i8]* @str_8 to %ConstCharStr
  %22 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %21)
  br label %endif_1
endif_1:
  br label %endif_0
endif_0:
  ret %Int 0
}


