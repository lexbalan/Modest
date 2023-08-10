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

; -- MODULE: /Users/alexbalan/p/Modest/examples/1.hello_world/main.cm

@str_1 = private constant [14 x i8] c"Hello World!\0A\00"



define %Int @main() {
  %1 = bitcast [14 x i8]* @str_1 to %ConstCharStr
  %2 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  ret %Int 0
}


