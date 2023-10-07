
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/utf.cm




define void @utf32_to_utf8(i32 %x, [5 x i8]* %buf) {
    %1 = icmp ule i32 %x, 127
    br i1 %1 , label %then_0, label %else_0
then_0:
    %2 = trunc i32 %x to i8
    %3 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %2, i8* %3
    %4 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 0, i8* %4
    br label %endif_0
else_0:
    %5 = icmp ule i32 %x, 2047
    br i1 %5 , label %then_1, label %else_1
then_1:
    %6 = lshr i32 %x, 6
    %7 = and i32 %6, 31
    %8 = lshr i32 %x, 0
    %9 = and i32 %8, 63
    %10 = trunc i32 %7 to i8
    %11 = or i8 192, %10
    %12 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %11, i8* %12
    %13 = trunc i32 %9 to i8
    %14 = or i8 128, %13
    %15 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %14, i8* %15
    %16 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 0, i8* %16
    br label %endif_1
else_1:
    %17 = icmp ule i32 %x, 65535
    br i1 %17 , label %then_2, label %else_2
then_2:
    %18 = lshr i32 %x, 12
    %19 = and i32 %18, 15
    %20 = lshr i32 %x, 6
    %21 = and i32 %20, 63
    %22 = lshr i32 %x, 0
    %23 = and i32 %22, 63
    %24 = trunc i32 %19 to i8
    %25 = or i8 224, %24
    %26 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %25, i8* %26
    %27 = trunc i32 %21 to i8
    %28 = or i8 128, %27
    %29 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %28, i8* %29
    %30 = trunc i32 %23 to i8
    %31 = or i8 128, %30
    %32 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 %31, i8* %32
    %33 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 3
    store i8 0, i8* %33
    br label %endif_2
else_2:
    %34 = icmp ule i32 %x, 1114111
    br i1 %34 , label %then_3, label %endif_3
then_3:
    %35 = lshr i32 %x, 18
    %36 = and i32 %35, 7
    %37 = lshr i32 %x, 12
    %38 = and i32 %37, 63
    %39 = lshr i32 %x, 6
    %40 = and i32 %39, 63
    %41 = lshr i32 %x, 0
    %42 = and i32 %41, 63
    %43 = trunc i32 %36 to i8
    %44 = or i8 240, %43
    %45 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %44, i8* %45
    %46 = trunc i32 %38 to i8
    %47 = or i8 128, %46
    %48 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %47, i8* %48
    %49 = trunc i32 %40 to i8
    %50 = or i8 128, %49
    %51 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 %50, i8* %51
    %52 = trunc i32 %42 to i8
    %53 = or i8 128, %52
    %54 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 3
    store i8 %53, i8* %54
    %55 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 4
    store i8 0, i8* %55
    br label %endif_3
endif_3:
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret void
}

define void @utf32_putchar(i32 %c) {
    %decoded_buf = alloca [5 x i8]
    call void(i32, [5 x i8]*) @utf32_to_utf8 (i32 %c, [5 x i8]* %decoded_buf)
    %1 = sext i1 0 to i32
    %i = alloca i32
    store i32 %1, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %i
    %3 = getelementptr inbounds [5 x i8], [5 x i8]* %decoded_buf, i32 0, i32 %2
    %4 = load i8, i8* %3
    %5 = icmp eq i8 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %7 = sext i8 %4 to i32
    %8 = call i32(i32) @putchar (i32 %7)
    %9 = load i32, i32* %i
    %10 = add i32 %9, 1
    store i32 %10, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @utf32_puts([0 x i32]* %s) {
    %1 = sext i1 0 to i32
    %i = alloca i32
    store i32 %1, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %i
    %3 = getelementptr inbounds [0 x i32], [0 x i32]* %s, i32 0, i32 %2
    %4 = load i32, i32* %3
    %5 = icmp eq i32 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    call void(i32) @utf32_putchar (i32 %4)
    %7 = load i32, i32* %i
    %8 = add i32 %7, 1
    store i32 %8, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @utf16_puts([0 x i16]* %s) {
    %1 = sext i1 0 to i32
    %i = alloca i32
    store i32 %1, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %i
    %3 = getelementptr inbounds [0 x i16], [0 x i16]* %s, i32 0, i32 %2
    %4 = load i16, i16* %3
    %5 = icmp eq i16 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %7 = zext i16 %4 to i32
    call void(i32) @utf32_putchar (i32 %7)
    %8 = load i32, i32* %i
    %9 = add i32 %8, 1
    store i32 %9, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @utf8_puts([0 x i8]* %s) {
    %1 = sext i1 0 to i32
    %i = alloca i32
    store i32 %1, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %i
    %3 = getelementptr inbounds [0 x i8], [0 x i8]* %s, i32 0, i32 %2
    %4 = load i8, i8* %3
    %5 = icmp eq i8 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %7 = sext i8 %4 to i32
    %8 = call i32(i32) @putchar (i32 %7)
    %9 = load i32, i32* %i
    %10 = add i32 %9, 1
    store i32 %10, i32* %i
    br label %again_1
break_1:
    ret void
}


