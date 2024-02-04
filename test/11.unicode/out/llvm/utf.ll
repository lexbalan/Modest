
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm



; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes32.hm


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



define i8 @utf16_to_utf32([0 x i16]* %c, i32* %result) {
    %1 = getelementptr inbounds [0 x i16], [0 x i16]* %c, i32 0, i32 0
    %2 = load i16, i16* %1
    %3 = zext i16 %2 to i32
    %4 = icmp ult i32 %3, 55296
    %5 = icmp ugt i32 %3, 57343
    %6 = or i1 %4, %5
    br i1 %6 , label %then_0, label %else_0
then_0:
    %7 = bitcast i32 %3 to i32
    store i32 %7, i32* %result
    ret i8 1
    br label %endif_0
else_0:
    %9 = icmp uge i32 %3, 56320
    br i1 %9 , label %then_1, label %else_1
then_1:
    ;error("Недопустимая кодовая последовательность.")
    br label %endif_1
else_1:
    %10 = alloca i32
    %11 = and i32 %3, 1023
    %12 = shl i32 %11, 10
    store i32 %12, i32* %10
    %13 = getelementptr inbounds [0 x i16], [0 x i16]* %c, i32 0, i32 1
    %14 = load i16, i16* %13
    %15 = zext i16 %14 to i32
    %16 = icmp ult i32 %15, 56320
    %17 = icmp ugt i32 %15, 57343
    %18 = or i1 %16, %17
    br i1 %18 , label %then_2, label %else_2
then_2:
    ;error("Недопустимая кодовая последовательность.")
    br label %endif_2
else_2:
    %19 = load i32, i32* %10
    %20 = and i32 %15, 1023
    %21 = or i32 %19, %20
    store i32 %21, i32* %10
    %22 = load i32, i32* %10
    %23 = add i32 %22, 65536
    %24 = bitcast i32 %23 to i32
    store i32 %24, i32* %result
    ret i8 2
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret i8 0
}

define void @utf32_putchar(i32 %c) {
    %1 = alloca [5 x i8]
    %2 = call i8 (i32, [5 x i8]*) @utf32_to_utf8(i32 %c, [5 x i8]* %1)
    %3 = sext i8 %2 to i32
    %4 = alloca i32
    store i32 0, i32* %4
    br label %again_1
again_1:
    %5 = load i32, i32* %4
    %6 = icmp slt i32 %5, %3
    br i1 %6 , label %body_1, label %break_1
body_1:
    %7 = load i32, i32* %4
    %8 = getelementptr inbounds [5 x i8], [5 x i8]* %1, i32 0, i32 %7
    %9 = load i8, i8* %8
    %10 = bitcast i8 %9 to i8
    %11 = icmp eq i8 %10, 0
    br i1 %11 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %13 = sext i8 %9 to i32
    %14 = call i32 (i32) @putchar(i32 %13)
    %15 = load i32, i32* %4
    %16 = add i32 %15, 1
    store i32 %16, i32* %4
    br label %again_1
break_1:
    ret void
}

define void @utf32_puts([0 x i32]* %s) {
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %1
    %3 = getelementptr inbounds [0 x i32], [0 x i32]* %s, i32 0, i32 %2
    %4 = load i32, i32* %3
    %5 = bitcast i32 %4 to i32
    %6 = icmp eq i32 %5, 0
    br i1 %6 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    call void (i32) @utf32_putchar(i32 %4)
    %8 = load i32, i32* %1
    %9 = add i32 %8, 1
    store i32 %9, i32* %1
    br label %again_1
break_1:
    ret void
}

define void @utf16_puts([0 x i16]* %s) {
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %1
    %3 = getelementptr inbounds [0 x i16], [0 x i16]* %s, i32 0, i32 %2
    %4 = load i16, i16* %3
    %5 = bitcast i16 %4 to i16
    %6 = icmp eq i16 %5, 0
    br i1 %6 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %8 = alloca i32
    %9 = load i32, i32* %1
    %10 = getelementptr inbounds [0 x i16], [0 x i16]* %s, i32 0, i32 %9
    %11 = bitcast i16* %10 to [0 x i16]*
    %12 = call i8 ([0 x i16]*, i32*) @utf16_to_utf32([0 x i16]* %11, i32* %8)
    %13 = icmp eq i8 %12, 0
    br i1 %13 , label %then_1, label %endif_1
then_1:
    br label %break_1
    br label %endif_1
endif_1:
    %15 = load i32, i32* %8
    call void (i32) @utf32_putchar(i32 %15)
    %16 = load i32, i32* %1
    %17 = sext i8 %12 to i32
    %18 = add i32 %16, %17
    store i32 %18, i32* %1
    br label %again_1
break_1:
    ret void
}

define void @utf8_puts([0 x i8]* %s) {
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %1
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
    %9 = call i32 (i32) @putchar(i32 %8)
    %10 = load i32, i32* %1
    %11 = add i32 %10, 1
    store i32 %11, i32* %1
    br label %again_1
break_1:
    ret void
}


