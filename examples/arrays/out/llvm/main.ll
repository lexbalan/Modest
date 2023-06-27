
@str_0 = private constant [15 x i8] c"array example\0A\00"
@str_1 = private constant [16 x i8] c"array[%d] = %d\0A\00"
@str_2 = private constant [25 x i8] c"array of arrays example\0A\00"
@str_3 = private constant [18 x i8] c"arr[%d][%d] = %d\0A\00"


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
@array = global [10 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9]
define void @arrayExample() {
  %1 = bitcast [15 x i8]* @str_0 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %i = alloca i32
  store i32 0, i32* %i
  br label %again_1
again_1:
  %3 = load i32, i32* %i
  %4 = icmp ult i32 %3, 10
  br i1 %4 , label %body_1, label %break_1
body_1:
  %5 = bitcast [16 x i8]* @str_1 to %ConstCharStr
  %6 = load i32, i32* %i
  %7 = load i32, i32* %i
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* @array, i32 0, i32 %7
  %9 = load i32, i32* %8
  %10 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %5, i32 %6, i32 %9)
  %11 = load i32, i32* %i
  %12 = add i32 %11, 1
  store i32 %12, i32* %i
  br label %again_1
break_1:
  ret void
}
@arrayOfArrays = global [3 x [3 x i32]] [[3 x i32] [i32 1, i32 2, i32 3], [3 x i32] [i32 4, i32 5, i32 6], [3 x i32] [i32 7, i32 8, i32 9]]
define void @arrayOfArraysExample() {
  %1 = bitcast [25 x i8]* @str_2 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %m = alloca i32
  store i32 0, i32* %m
  br label %again_1
again_1:
  %3 = load i32, i32* %m
  %4 = icmp ult i32 %3, 3
  br i1 %4 , label %body_1, label %break_1
body_1:
  %n = alloca i32
  store i32 0, i32* %n
  br label %again_2
again_2:
  %5 = load i32, i32* %n
  %6 = icmp ult i32 %5, 3
  br i1 %6 , label %body_2, label %break_2
body_2:
  %7 = bitcast [18 x i8]* @str_3 to %ConstCharStr
  %8 = load i32, i32* %m
  %9 = load i32, i32* %n
  %10 = load i32, i32* %m
  %11 = getelementptr inbounds [3 x [3 x i32]], [3 x [3 x i32]]* @arrayOfArrays, i32 0, i32 %10
  %12 = load i32, i32* %n
  %13 = getelementptr inbounds [3 x i32], [3 x i32]* %11, i32 0, i32 %12
  %14 = load i32, i32* %13
  %15 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %7, i32 %8, i32 %9, i32 %14)
  %16 = load i32, i32* %n
  %17 = add i32 %16, 1
  store i32 %17, i32* %n
  br label %again_2
break_2:
  %18 = load i32, i32* %m
  %19 = add i32 %18, 1
  store i32 %19, i32* %m
  br label %again_1
break_1:
  ret void
}

define i32 @main() {
  call void() @arrayExample ()
  call void() @arrayOfArraysExample ()
  ret i32 0
}


