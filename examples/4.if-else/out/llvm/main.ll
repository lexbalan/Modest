
@str_0 = private constant [17 x i8] c"if-else example\0A\00"
@str_1 = private constant [10 x i8] c"enter a: \00"
@str_2 = private constant [3 x i8] c"%d\00"
@str_3 = private constant [10 x i8] c"enter b: \00"
@str_4 = private constant [3 x i8] c"%d\00"
@str_5 = private constant [7 x i8] c"a > b\0A\00"
@str_6 = private constant [7 x i8] c"a < b\0A\00"
@str_7 = private constant [8 x i8] c"a == b\0A\00"


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
declare i32 @fprintf(%FILE*, [0 x i8]*, ...)
declare i32 @printf(%ConstCharStr, ...)
declare i32 @scanf(%ConstCharStr, ...)
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

define i32 @main() {
  %1 = bitcast [17 x i8]* @str_0 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %a = alloca i32
  %b = alloca i32
  %3 = bitcast [10 x i8]* @str_1 to %ConstCharStr
  %4 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %3)
  %5 = bitcast [3 x i8]* @str_2 to %ConstCharStr
  %6 = call i32(%ConstCharStr, ...) @scanf (%ConstCharStr %5, i32* %a)
  %7 = bitcast [10 x i8]* @str_3 to %ConstCharStr
  %8 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %7)
  %9 = bitcast [3 x i8]* @str_4 to %ConstCharStr
  %10 = call i32(%ConstCharStr, ...) @scanf (%ConstCharStr %9, i32* %b)
  %11 = load i32, i32* %a
  %12 = load i32, i32* %b
  %13 = icmp sgt i32 %11, %12
  br i1 %13 , label %then_0, label %else_0
then_0:
  %14 = bitcast [7 x i8]* @str_5 to %ConstCharStr
  %15 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %14)
  br label %endif_0
else_0:
  %16 = load i32, i32* %a
  %17 = load i32, i32* %b
  %18 = icmp slt i32 %16, %17
  br i1 %18 , label %then_1, label %else_1
then_1:
  %19 = bitcast [7 x i8]* @str_6 to %ConstCharStr
  %20 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %19)
  br label %endif_1
else_1:
  %21 = bitcast [8 x i8]* @str_7 to %ConstCharStr
  %22 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %21)
  br label %endif_1
endif_1:
  br label %endif_0
endif_0:
  ret i32 0
}


