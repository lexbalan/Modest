
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


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr*, %ConstCharStr*)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr*, %ConstCharStr*, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr*)
declare i32 @rename(%ConstCharStr*, %ConstCharStr*)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr*)


declare i32 @setvbuf(%FILE*, %CharStr*, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr*)
declare i32 @printf(%ConstCharStr*, ...)
declare i32 @scanf(%ConstCharStr*, ...)
declare i32 @fprintf(%FILE*, %Str*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr*, ...)
declare i32 @sscanf(%ConstCharStr*, %ConstCharStr*, ...)
declare i32 @sprintf(%CharStr*, %ConstCharStr*, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr* @fgets(%CharStr*, i32, %FILE*)
declare i32 @fputs(%ConstCharStr*, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr*)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr*)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr*)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/utf.cm




define void @utf32_to_utf8(i32 %c, [5 x i8]* %buf) {
    %1 = bitcast i32 %c to i32
    %2 = icmp ule i32 %1, 127
    br i1 %2 , label %then_0, label %else_0
then_0:
    %3 = trunc i32 %1 to i8
    %4 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %3, i8* %4
    %5 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 0, i8* %5
    br label %endif_0
else_0:
    %6 = icmp ule i32 %1, 2047
    br i1 %6 , label %then_1, label %else_1
then_1:
    %7 = lshr i32 %1, 6
    %8 = and i32 %7, 31
    %9 = lshr i32 %1, 0
    %10 = and i32 %9, 63
    %11 = trunc i32 %8 to i8
    %12 = or i8 192, %11
    %13 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %12, i8* %13
    %14 = trunc i32 %10 to i8
    %15 = or i8 128, %14
    %16 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %15, i8* %16
    %17 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 0, i8* %17
    br label %endif_1
else_1:
    %18 = icmp ule i32 %1, 65535
    br i1 %18 , label %then_2, label %else_2
then_2:
    %19 = lshr i32 %1, 12
    %20 = and i32 %19, 15
    %21 = lshr i32 %1, 6
    %22 = and i32 %21, 63
    %23 = lshr i32 %1, 0
    %24 = and i32 %23, 63
    %25 = trunc i32 %20 to i8
    %26 = or i8 224, %25
    %27 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %26, i8* %27
    %28 = trunc i32 %22 to i8
    %29 = or i8 128, %28
    %30 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %29, i8* %30
    %31 = trunc i32 %24 to i8
    %32 = or i8 128, %31
    %33 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 %32, i8* %33
    %34 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 3
    store i8 0, i8* %34
    br label %endif_2
else_2:
    %35 = icmp ule i32 %1, 1114111
    br i1 %35 , label %then_3, label %endif_3
then_3:
    %36 = lshr i32 %1, 18
    %37 = and i32 %36, 7
    %38 = lshr i32 %1, 12
    %39 = and i32 %38, 63
    %40 = lshr i32 %1, 6
    %41 = and i32 %40, 63
    %42 = lshr i32 %1, 0
    %43 = and i32 %42, 63
    %44 = trunc i32 %37 to i8
    %45 = or i8 240, %44
    %46 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %45, i8* %46
    %47 = trunc i32 %39 to i8
    %48 = or i8 128, %47
    %49 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %48, i8* %49
    %50 = trunc i32 %41 to i8
    %51 = or i8 128, %50
    %52 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 %51, i8* %52
    %53 = trunc i32 %43 to i8
    %54 = or i8 128, %53
    %55 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 3
    store i8 %54, i8* %55
    %56 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 4
    store i8 0, i8* %56
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
    %5 = bitcast i32 %4 to i32
    %6 = icmp eq i32 %5, 0
    br i1 %6 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    call void(i32) @utf32_putchar (i32 %4)
    %8 = load i32, i32* %i
    %9 = add i32 %8, 1
    store i32 %9, i32* %i
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
    %5 = bitcast i16 %4 to i16
    %6 = icmp eq i16 %5, 0
    br i1 %6 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %8 = zext i16 %4 to i32
    call void(i32) @utf32_putchar (i32 %8)
    %9 = load i32, i32* %i
    %10 = add i32 %9, 1
    store i32 %10, i32* %i
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
    %5 = bitcast i8 %4 to i8
    %6 = icmp eq i8 %5, 0
    br i1 %6 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %8 = sext i8 %4 to i32
    %9 = call i32(i32) @putchar (i32 %8)
    %10 = load i32, i32* %i
    %11 = add i32 %10, 1
    store i32 %11, i32* %i
    br label %again_1
break_1:
    ret void
}


