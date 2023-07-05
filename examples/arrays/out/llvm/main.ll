
@str_0 = private constant [15 x i8] c"array example\0A\00"
@str_1 = private constant [16 x i8] c"array[%d] = %d\0A\00"
@str_2 = private constant [25 x i8] c"array of arrays example\0A\00"
@str_3 = private constant [18 x i8] c"arr[%d][%d] = %d\0A\00"
@str_4 = private constant [11 x i8] c"arr[%d] = \00"
@str_5 = private constant [3 x i8] c"%d\00"

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
@array = global [10 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9]
define void @arrayExample() {
  %1 = bitcast [15 x i8]* @str_0 to %ConstCharStr
  %2 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %1)
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
  %10 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %5, i32 %6, i32 %9)
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
  %2 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %1)
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
  %15 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %7, i32 %8, i32 %9, i32 %14)
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

define void @fillArray() {
  %i = alloca %Int
  store %Int 0, %Int* %i
  br label %again_1
again_1:
  %1 = load %Int, %Int* %i
  %2 = icmp slt %Int %1, 10
  br i1 %2 , label %body_1, label %break_1
body_1:
  %3 = bitcast [11 x i8]* @str_4 to %ConstCharStr
  %4 = load %Int, %Int* %i
  %5 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %3, %Int %4)
  %6 = bitcast [3 x i8]* @str_5 to %ConstCharStr
  %7 = load %Int, %Int* %i
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* @array, i32 0, %Int %7
  %9 = call %Int(%ConstCharStr, ...) @scanf (%ConstCharStr %6, i32* %8)
  %10 = load %Int, %Int* %i
  %11 = add %Int %10, 1
  store %Int %11, %Int* %i
  br label %again_1
break_1:
  ret void
}

define %Int @main() {
  call void() @fillArray ()
  %1 = bitcast [10 x i32]* @array to [0 x i32]*
  call void([0 x i32]*, i32) @sortBubble ([0 x i32]* %1, i32 10)
  call void() @arrayExample ()
  ret %Int 0
}

define void @sortBubble([0 x i32]* %arr, i32 %len) {
  %end = alloca i1
  store i1 0, i1* %end
  br label %again_1
again_1:
  %1 = load i1, i1* %end
  %2 = xor  i1 %1, -1
  br i1 %2 , label %body_1, label %break_1
body_1:
  store i1 1, i1* %end
  %i = alloca i32
  store i32 0, i32* %i
  br label %again_2
again_2:
  %3 = load i32, i32* %i
  %4 = sub i32 %len, 1
  %5 = icmp ult i32 %3, %4
  br i1 %5 , label %body_2, label %break_2
body_2:
  %6 = load i32, i32* %i
  %7 = getelementptr inbounds [0 x i32], [0 x i32]* %arr, i32 0, i32 %6
  %8 = load i32, i32* %7
  %9 = load i32, i32* %i
  %10 = add i32 %9, 1
  %11 = getelementptr inbounds [0 x i32], [0 x i32]* %arr, i32 0, i32 %10
  %12 = load i32, i32* %11
  %13 = icmp ugt i32 %8, %12
  br i1 %13 , label %then_0, label %endif_0
then_0:
  %14 = load i32, i32* %i
  %15 = getelementptr inbounds [0 x i32], [0 x i32]* %arr, i32 0, i32 %14
  store i32 %12, i32* %15
  %16 = load i32, i32* %i
  %17 = add i32 %16, 1
  %18 = getelementptr inbounds [0 x i32], [0 x i32]* %arr, i32 0, i32 %17
  store i32 %8, i32* %18
  store i1 0, i1* %end
  br label %endif_0
endif_0:
  %19 = load i32, i32* %i
  %20 = add i32 %19, 1
  store i32 %20, i32* %i
  br label %again_2
break_2:
  br label %again_1
break_1:
  ret void
}


