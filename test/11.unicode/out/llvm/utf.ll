
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




define i8 @utf32_to_utf8(i32 %c, [5 x i8]* %buf) {
    %1 = bitcast i32 %c to i32
    %2 = icmp ule i32 %1, 127
    br i1 %2 , label %then_0, label %else_0
then_0:
    %3 = trunc i32 %1 to i8
    %4 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %3, i8* %4
    %5 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 0, i8* %5
    ret i8 2
    br label %endif_0
else_0:
    %7 = icmp ule i32 %1, 2047
    br i1 %7 , label %then_1, label %else_1
then_1:
    %8 = lshr i32 %1, 6
    %9 = and i32 %8, 31
    %10 = lshr i32 %1, 0
    %11 = and i32 %10, 63
    %12 = or i32 192, %9
    %13 = trunc i32 %12 to i8
    %14 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %13, i8* %14
    %15 = or i32 128, %11
    %16 = trunc i32 %15 to i8
    %17 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %16, i8* %17
    %18 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 0, i8* %18
    ret i8 3
    br label %endif_1
else_1:
    %20 = icmp ule i32 %1, 65535
    br i1 %20 , label %then_2, label %else_2
then_2:
    %21 = lshr i32 %1, 12
    %22 = and i32 %21, 15
    %23 = lshr i32 %1, 6
    %24 = and i32 %23, 63
    %25 = lshr i32 %1, 0
    %26 = and i32 %25, 63
    %27 = or i32 224, %22
    %28 = trunc i32 %27 to i8
    %29 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %28, i8* %29
    %30 = or i32 128, %24
    %31 = trunc i32 %30 to i8
    %32 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %31, i8* %32
    %33 = or i32 128, %26
    %34 = trunc i32 %33 to i8
    %35 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 %34, i8* %35
    %36 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 3
    store i8 0, i8* %36
    ret i8 4
    br label %endif_2
else_2:
    %38 = icmp ule i32 %1, 1114111
    br i1 %38 , label %then_3, label %endif_3
then_3:
    %39 = lshr i32 %1, 18
    %40 = and i32 %39, 7
    %41 = lshr i32 %1, 12
    %42 = and i32 %41, 63
    %43 = lshr i32 %1, 6
    %44 = and i32 %43, 63
    %45 = lshr i32 %1, 0
    %46 = and i32 %45, 63
    %47 = or i32 240, %40
    %48 = trunc i32 %47 to i8
    %49 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 0
    store i8 %48, i8* %49
    %50 = or i32 128, %42
    %51 = trunc i32 %50 to i8
    %52 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 1
    store i8 %51, i8* %52
    %53 = or i32 128, %44
    %54 = trunc i32 %53 to i8
    %55 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 2
    store i8 %54, i8* %55
    %56 = or i32 128, %46
    %57 = trunc i32 %56 to i8
    %58 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 3
    store i8 %57, i8* %58
    %59 = getelementptr inbounds [5 x i8], [5 x i8]* %buf, i32 0, i32 4
    store i8 0, i8* %59
    ret i8 5
    br label %endif_3
endif_3:
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret i8 0
}

define void @utf32_putchar(i32 %c) {
    %decoded_buf = alloca [5 x i8]
    %1 = call i8(i32, [5 x i8]*) @utf32_to_utf8 (i32 %c, [5 x i8]* %decoded_buf)
    %2 = sext i8 %1 to i32
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %3 = load i32, i32* %i
    %4 = icmp slt i32 %3, %2
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = load i32, i32* %i
    %6 = getelementptr inbounds [5 x i8], [5 x i8]* %decoded_buf, i32 0, i32 %5
    %7 = load i8, i8* %6
    %8 = bitcast i8 %7 to i8
    %9 = icmp eq i8 %8, 0
    br i1 %9 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %11 = sext i8 %7 to i32
    %12 = call i32(i32) @putchar (i32 %11)
    %13 = load i32, i32* %i
    %14 = add i32 %13, 1
    store i32 %14, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @utf32_puts([0 x i32]* %s) {
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %1 = load i32, i32* %i
    %2 = getelementptr inbounds [0 x i32], [0 x i32]* %s, i32 0, i32 %1
    %3 = load i32, i32* %2
    %4 = bitcast i32 %3 to i32
    %5 = icmp eq i32 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    call void(i32) @utf32_putchar (i32 %3)
    %7 = load i32, i32* %i
    %8 = add i32 %7, 1
    store i32 %8, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @utf16_puts([0 x i16]* %s) {
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %1 = load i32, i32* %i
    %2 = getelementptr inbounds [0 x i16], [0 x i16]* %s, i32 0, i32 %1
    %3 = load i16, i16* %2
    %4 = bitcast i16 %3 to i16
    %5 = icmp eq i16 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %7 = zext i16 %3 to i32
    call void(i32) @utf32_putchar (i32 %7)
    %8 = load i32, i32* %i
    %9 = add i32 %8, 1
    store i32 %9, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @utf8_puts([0 x i8]* %s) {
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %1 = load i32, i32* %i
    %2 = getelementptr inbounds [0 x i8], [0 x i8]* %s, i32 0, i32 %1
    %3 = load i8, i8* %2
    %4 = bitcast i8 %3 to i8
    %5 = icmp eq i8 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %7 = sext i8 %3 to i32
    %8 = call i32(i32) @putchar (i32 %7)
    %9 = load i32, i32* %i
    %10 = add i32 %9, 1
    store i32 %10, i32* %i
    br label %again_1
break_1:
    ret void
}


