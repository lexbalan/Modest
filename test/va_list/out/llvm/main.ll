
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*); -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

; -- SOURCE: src/main.cm

@str1 = private constant [3 x i8] [i8 37, i8 99, i8 0]
@str2 = private constant [2 x i8] [i8 37, i8 0]
@str3 = private constant [14 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 10, i8 0]
@str4 = private constant [4 x i8] [i8 72, i8 105, i8 33, i8 0]
@str5 = private constant [11 x i8] [i8 37, i8 37, i8 32, i8 61, i8 32, i8 39, i8 37, i8 37, i8 39, i8 10, i8 0]
@str6 = private constant [10 x i8] [i8 99, i8 32, i8 61, i8 32, i8 39, i8 37, i8 99, i8 39, i8 10, i8 0]
@str7 = private constant [10 x i8] [i8 115, i8 32, i8 61, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@str8 = private constant [9 x i8] [i8 105, i8 32, i8 58, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [8 x i8] [i8 110, i8 32, i8 61, i8 32, i8 37, i8 110, i8 10, i8 0]
@str10 = private constant [10 x i8] [i8 120, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]



define void @_putchar(i8 %c) {
    ;var cc := c
    ;write(0, &cc, 1)
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([3 x i8]* @str1 to [0 x i8]*), i8 %c)
    ret void
}

define void @put_str8([0 x i8]* %s) {
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %1 = load i32, i32* %i
    %2 = getelementptr inbounds [0 x i8], [0 x i8]* %s, i32 0, i32 %1
    %3 = load i8, i8* %2
    %4 = icmp eq i8 %3, 0
    br i1 %4 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    call void(i8) @_putchar (i8 %3)
    %6 = load i32, i32* %i
    %7 = add i32 %6, 1
    store i32 %7, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @ff_printf([0 x i8]* %str, ...) {
    %va_list = alloca i8*
    %1 = bitcast i8** %va_list to i8*
    call void @llvm.va_start(i8* %1)
    ;var a_list: va_list
    ;va_start(a_list, str)
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %i
    %3 = getelementptr inbounds [0 x i8], [0 x i8]* %str, i32 0, i32 %2
    %4 = load i8, i8* %3
    %c = alloca i8
    store i8 %4, i8* %c
    %5 = load i8, i8* %c
    %6 = icmp eq i8 %5, 0
    br i1 %6 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %8 = load i8, i8* %c
    %9 = icmp eq i8 %8, 37
    br i1 %9 , label %then_1, label %else_1
then_1:
    %10 = load i32, i32* %i
    %11 = add i32 %10, 1
    store i32 %11, i32* %i
    %12 = load i32, i32* %i
    %13 = getelementptr inbounds [0 x i8], [0 x i8]* %str, i32 0, i32 %12
    %14 = load i8, i8* %13
    store i8 %14, i8* %c
    ; буффер для печати всего, кроме строк
    %buf = alloca [11 x i8]
    ;buf := []
    %sptr = alloca [0 x i8]*
    %15 = bitcast [11 x i8]* %buf to [0 x i8]*
    store [0 x i8]* %15, [0 x i8]** %sptr
    %16 = load [0 x i8]*, [0 x i8]** %sptr
    %17 = getelementptr inbounds [0 x i8], [0 x i8]* %16, i32 0, i32 0
    store i8 0, i8* %17
    %18 = load i8, i8* %c
    %19 = icmp eq i8 %18, 105
    %20 = load i8, i8* %c
    %21 = icmp eq i8 %20, 100
    %22 = or i1 %19, %21
    br i1 %22 , label %then_2, label %else_2
then_2:
    ; %i & %d for signed integer (Int)
    %23 = va_arg i8** %va_list, i32
    %24 = load [0 x i8]*, [0 x i8]** %sptr
    call void([0 x i8]*, i32) @sprintf_dec_int32 ([0 x i8]* %24, i32 %23)
    br label %endif_2
else_2:
    %25 = load i8, i8* %c
    %26 = icmp eq i8 %25, 110
    br i1 %26 , label %then_3, label %else_3
then_3:
    ; %n for unsigned integer (Nat)
    %27 = va_arg i8** %va_list, i32
    %28 = load [0 x i8]*, [0 x i8]** %sptr
    call void([0 x i8]*, i32) @sprintf_dec_nat32 ([0 x i8]* %28, i32 %27)
    br label %endif_3
else_3:
    %29 = load i8, i8* %c
    %30 = icmp eq i8 %29, 120
    %31 = load i8, i8* %c
    %32 = icmp eq i8 %31, 112
    %33 = or i1 %30, %32
    br i1 %33 , label %then_4, label %else_4
then_4:
    ; %x for unsigned integer (Nat)
    ; %p for pointers
    %34 = va_arg i8** %va_list, i32
    %35 = load [0 x i8]*, [0 x i8]** %sptr
    call void([0 x i8]*, i32) @sprintf_hex_nat32 ([0 x i8]* %35, i32 %34)
    br label %endif_4
else_4:
    %36 = load i8, i8* %c
    %37 = icmp eq i8 %36, 115
    br i1 %37 , label %then_5, label %else_5
then_5:
    ; %s pointer to string
    %38 = va_arg i8** %va_list, [0 x i8]*
    store [0 x i8]* %38, [0 x i8]** %sptr
    br label %endif_5
else_5:
    %39 = load i8, i8* %c
    %40 = icmp eq i8 %39, 99
    br i1 %40 , label %then_6, label %else_6
then_6:
    ; %c for char
    %41 = va_arg i8** %va_list, i8
    %42 = load [0 x i8]*, [0 x i8]** %sptr
    %43 = getelementptr inbounds [0 x i8], [0 x i8]* %42, i32 0, i32 0
    store i8 %41, i8* %43
    %44 = load [0 x i8]*, [0 x i8]** %sptr
    %45 = getelementptr inbounds [0 x i8], [0 x i8]* %44, i32 0, i32 1
    store i8 0, i8* %45
    br label %endif_6
else_6:
    %46 = load i8, i8* %c
    %47 = icmp eq i8 %46, 37
    br i1 %47 , label %then_7, label %endif_7
then_7:
    ; %% for PERCENT_SYMBOL
    store [0 x i8]* bitcast ([2 x i8]* @str2 to [0 x i8]*), [0 x i8]** %sptr
    br label %endif_7
endif_7:
    br label %endif_6
endif_6:
    br label %endif_5
endif_5:
    br label %endif_4
endif_4:
    br label %endif_3
endif_3:
    br label %endif_2
endif_2:
    %48 = load [0 x i8]*, [0 x i8]** %sptr
    call void([0 x i8]*) @put_str8 ([0 x i8]* %48)
    br label %endif_1
else_1:
    %49 = load i8, i8* %c
    call void(i8) @_putchar (i8 %49)
    br label %endif_1
endif_1:
    %50 = load i32, i32* %i
    %51 = add i32 %50, 1
    store i32 %51, i32* %i
    br label %again_1
break_1:
    ;va_end(a_list)
    %52 = bitcast i8** %va_list to i8*
    call void @llvm.va_end(i8* %52)
    ret void
}

define i8 @n_to_sym(i8 %n) {
    %c = alloca i8
    %1 = icmp ule i8 %n, 9
    br i1 %1 , label %then_0, label %else_0
then_0:
    %2 = add i8 48, %n
    %3 = bitcast i8 %2 to i8
    store i8 %3, i8* %c
    br label %endif_0
else_0:
    %4 = sub i8 %n, 10
    %5 = add i8 65, %4
    %6 = bitcast i8 %5 to i8
    store i8 %6, i8* %c
    br label %endif_0
endif_0:
    %7 = load i8, i8* %c
    ret i8 %7
}

define void @sprintf_hex_nat32([0 x i8]* %buf, i32 %x) {
    %cc = alloca [8 x i8]
    ;cc := []
    %d = alloca i32
    store i32 %x, i32* %d
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %1 = load i32, i32* %d
    %2 = urem i32 %1, 16
    %3 = load i32, i32* %d
    %4 = udiv i32 %3, 16
    store i32 %4, i32* %d
    %5 = trunc i32 %2 to i8
    %6 = call i8(i8) @n_to_sym (i8 %5)
    %7 = load i32, i32* %i
    %8 = getelementptr inbounds [8 x i8], [8 x i8]* %cc, i32 0, i32 %7
    store i8 %6, i8* %8
    %9 = load i32, i32* %i
    %10 = add i32 %9, 1
    store i32 %10, i32* %i
    %11 = load i32, i32* %d
    %12 = icmp eq i32 %11, 0
    br i1 %12 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    br label %again_1
break_1:
    ; mirroring into buffer
    %j = alloca i32
    store i32 0, i32* %j
    br label %again_2
again_2:
    %14 = load i32, i32* %i
    %15 = icmp sgt i32 %14, 0
    br i1 %15 , label %body_2, label %break_2
body_2:
    %16 = load i32, i32* %i
    %17 = sub i32 %16, 1
    store i32 %17, i32* %i
    %18 = load i32, i32* %i
    %19 = getelementptr inbounds [8 x i8], [8 x i8]* %cc, i32 0, i32 %18
    %20 = load i8, i8* %19
    %21 = load i32, i32* %j
    %22 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %21
    store i8 %20, i8* %22
    %23 = load i32, i32* %j
    %24 = add i32 %23, 1
    store i32 %24, i32* %j
    br label %again_2
break_2:
    %25 = load i32, i32* %j
    %26 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %25
    store i8 0, i8* %26
    ;return buf
    ret void
}

define void @sprintf_dec_int32([0 x i8]* %buf, i32 %x) {
    %cc = alloca [11 x i8]
    ;cc := []
    %d = alloca i32
    store i32 %x, i32* %d
    %1 = load i32, i32* %d
    %2 = icmp slt i32 %1, 0
    br i1 %2 , label %then_0, label %endif_0
then_0:
    %3 = load i32, i32* %d
    %4 = sub i32 0, %3
    store i32 %4, i32* %d
    br label %endif_0
endif_0:
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %5 = load i32, i32* %d
    %6 = srem i32 %5, 10
    %7 = load i32, i32* %d
    %8 = sdiv i32 %7, 10
    store i32 %8, i32* %d
    %9 = trunc i32 %6 to i8
    %10 = call i8(i8) @n_to_sym (i8 %9)
    %11 = load i32, i32* %i
    %12 = getelementptr inbounds [11 x i8], [11 x i8]* %cc, i32 0, i32 %11
    store i8 %10, i8* %12
    %13 = load i32, i32* %i
    %14 = add i32 %13, 1
    store i32 %14, i32* %i
    %15 = load i32, i32* %d
    %16 = icmp eq i32 %15, 0
    br i1 %16 , label %then_1, label %endif_1
then_1:
    br label %break_1
    br label %endif_1
endif_1:
    br label %again_1
break_1:
    %j = alloca i32
    store i32 0, i32* %j
    br i1 %2 , label %then_2, label %endif_2
then_2:
    %18 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 0
    store i8 45, i8* %18
    %19 = load i32, i32* %j
    %20 = add i32 %19, 1
    store i32 %20, i32* %j
    br label %endif_2
endif_2:
    br label %again_2
again_2:
    %21 = load i32, i32* %i
    %22 = icmp sgt i32 %21, 0
    br i1 %22 , label %body_2, label %break_2
body_2:
    %23 = load i32, i32* %i
    %24 = sub i32 %23, 1
    store i32 %24, i32* %i
    %25 = load i32, i32* %i
    %26 = getelementptr inbounds [11 x i8], [11 x i8]* %cc, i32 0, i32 %25
    %27 = load i8, i8* %26
    %28 = load i32, i32* %j
    %29 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %28
    store i8 %27, i8* %29
    %30 = load i32, i32* %j
    %31 = add i32 %30, 1
    store i32 %31, i32* %j
    br label %again_2
break_2:
    %32 = load i32, i32* %j
    %33 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %32
    store i8 0, i8* %33
    ;return buf
    ret void
}

define void @sprintf_dec_nat32([0 x i8]* %buf, i32 %x) {
    %cc = alloca [11 x i8]
    ;cc := []
    %d = alloca i32
    store i32 %x, i32* %d
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %1 = load i32, i32* %d
    %2 = urem i32 %1, 10
    %3 = load i32, i32* %d
    %4 = udiv i32 %3, 10
    store i32 %4, i32* %d
    %5 = trunc i32 %2 to i8
    %6 = call i8(i8) @n_to_sym (i8 %5)
    %7 = load i32, i32* %i
    %8 = getelementptr inbounds [11 x i8], [11 x i8]* %cc, i32 0, i32 %7
    store i8 %6, i8* %8
    %9 = load i32, i32* %i
    %10 = add i32 %9, 1
    store i32 %10, i32* %i
    %11 = load i32, i32* %d
    %12 = icmp eq i32 %11, 0
    br i1 %12 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    br label %again_1
break_1:
    %j = alloca i32
    store i32 0, i32* %j
    br label %again_2
again_2:
    %14 = load i32, i32* %i
    %15 = icmp sgt i32 %14, 0
    br i1 %15 , label %body_2, label %break_2
body_2:
    %16 = load i32, i32* %i
    %17 = sub i32 %16, 1
    store i32 %17, i32* %i
    %18 = load i32, i32* %i
    %19 = getelementptr inbounds [11 x i8], [11 x i8]* %cc, i32 0, i32 %18
    %20 = load i8, i8* %19
    %21 = load i32, i32* %j
    %22 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %21
    store i8 %20, i8* %22
    %23 = load i32, i32* %j
    %24 = add i32 %23, 1
    store i32 %24, i32* %j
    br label %again_2
break_2:
    %25 = load i32, i32* %j
    %26 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %25
    store i8 0, i8* %26
    ;return buf
    ret void
}

define i32 @main() {
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([14 x i8]* @str3 to [0 x i8]*))
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([11 x i8]* @str5 to [0 x i8]*))
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([10 x i8]* @str6 to [0 x i8]*), i8 36)
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([10 x i8]* @str7 to [0 x i8]*), [0 x i8]* bitcast ([4 x i8]* @str4 to [0 x i8]*))
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([9 x i8]* @str8 to [0 x i8]*), i32 -1)
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([8 x i8]* @str9 to [0 x i8]*), i32 123)
    call void([0 x i8]*, ...) @ff_printf ([0 x i8]* bitcast ([10 x i8]* @str10 to [0 x i8]*), i32 305419903)
    ret i32 0
}


