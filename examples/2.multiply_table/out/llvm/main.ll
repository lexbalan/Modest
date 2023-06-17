
@str_0 = private constant [14 x i8] c"%d * %d = %d\0A\00"
@str_1 = private constant [23 x i8] c"multiply table for %d\0A\00"


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

define void @mtab(i32 %n) {
  %m = alloca i32
  store i32 1, i32* %m
  br label %again_1
again_1:
  %1 = load i32, i32* %m
  %2 = icmp ult i32 %1, 10
  br i1 %2 , label %body_1, label %break_1
body_1:
  %3 = load i32, i32* %m
  %4 = mul i32 %n, %3
  %5 = bitcast [14 x i8]* @str_0 to %ConstCharStr
  %6 = load i32, i32* %m
  %7 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %5, i32 %n, i32 %6, i32 %4)
  %8 = load i32, i32* %m
  %9 = add i32 %8, 1
  store i32 %9, i32* %m
  br label %again_1
break_1:
  ret void
}
define i32 @main() {
  %1 = bitcast [23 x i8]* @str_1 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1, i64 2)
  call void(i32) @mtab (i32 2)
  ret i32 0
}

