
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]
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

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


declare i32 @fclose(%FILE* %f)
declare i32 @feof(%FILE* %f)
declare i32 @ferror(%FILE* %f)
declare i32 @fflush(%FILE* %f)
declare i32 @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare i32 @fseek(%FILE* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%FILE* %f, %FposT* %pos)
declare i64 @ftell(%FILE* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare i32 @setvbuf(%FILE* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%FILE* %stream, %Str* %format, ...)
declare i32 @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare i32 @fgetc(%FILE* %f)
declare i32 @fputc(i32 %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %FILE* %f)
declare i32 @fputs(%ConstCharStr* %str, %FILE* %f)
declare i32 @getc(%FILE* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %FILE* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)

; -- SOURCE: src/main.cm

@str1 = private constant [9 x i8] [i8 102, i8 105, i8 108, i8 101, i8 46, i8 116, i8 120, i8 116, i8 0]
@str2 = private constant [19 x i8] [i8 114, i8 117, i8 110, i8 32, i8 119, i8 114, i8 105, i8 116, i8 101, i8 95, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str3 = private constant [2 x i8] [i8 119, i8 0]
@str4 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str5 = private constant [12 x i8] [i8 115, i8 111, i8 109, i8 101, i8 32, i8 116, i8 101, i8 120, i8 116, i8 46, i8 10, i8 0]
@str6 = private constant [18 x i8] [i8 114, i8 117, i8 110, i8 32, i8 114, i8 101, i8 97, i8 100, i8 95, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str7 = private constant [2 x i8] [i8 114, i8 0]
@str8 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str9 = private constant [21 x i8] [i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 32, i8 99, i8 111, i8 110, i8 116, i8 97, i8 105, i8 110, i8 115, i8 58, i8 32, i8 0]
@str10 = private constant [19 x i8] [i8 116, i8 101, i8 120, i8 116, i8 95, i8 102, i8 105, i8 108, i8 101, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]




define void @write_example() {
    %1 = call i32(%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*))
    %2 = call %FILE*(%ConstCharStr*, %ConstCharStr*) @fopen([0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str3 to [0 x i8]*))
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call i32(%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @str4 to [0 x i8]*), [0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*))ret void
    br label %endif_0
endif_0:
    %6 = call i32(%FILE*, %Str*, ...) @fprintf(%FILE* %2, %Str* bitcast ([12 x i8]* @str5 to [0 x i8]*))
    %7 = call i32(%FILE*) @fclose(%FILE* %2)
    ret void
}

define void @read_example() {
    %1 = call i32(%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str6 to [0 x i8]*))
    %2 = call %FILE*(%ConstCharStr*, %ConstCharStr*) @fopen([0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str7 to [0 x i8]*))
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call i32(%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str8 to [0 x i8]*), [0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*))ret void
    br label %endif_0
endif_0:
    %6 = call i32(%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str9 to [0 x i8]*), [0 x i8]* bitcast ([9 x i8]* @str1 to [0 x i8]*))
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %7 = call i32(%FILE*) @fgetc(%FILE* %2)
    %8 = icmp eq i32 %7, -1
    br i1 %8 , label %then_1, label %endif_1
then_1:
    br label %break_1
    br label %endif_1
endif_1:
    %10 = call i32(i32) @putchar(i32 %7)
    br label %again_1
break_1:
    %11 = call i32(%FILE*) @fclose(%FILE* %2)
    ret void
}

define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str10 to [0 x i8]*))
    call void() @write_example()
    call void() @read_example()
    ret i32 0
}


