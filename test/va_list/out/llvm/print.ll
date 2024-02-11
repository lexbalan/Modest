
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Float32 = type float
%Float64 = type double
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%VA_List = type i8*
declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare %Int @setvbuf(%FILE* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%FILE* %stream, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/fastfood/print.cm

@str1 = private constant [2 x i8] [i8 37, i8 0]



define void @_put_char8(i8 %c) {
    %1 = sext i8 %c to %Int
    %2 = call %Int (%Int) @putchar(%Int %1)
    ret void
}

define void @put_str8(%Str8* %s) {
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = load i32, i32* %1
    %3 = getelementptr inbounds %Str8, %Str8* %s, i32 0, i32 %2
    %4 = load i8, i8* %3
    %5 = icmp eq i8 %4, 0
    br i1 %5 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    call void (i8) @_put_char8(i8 %4)
    %7 = load i32, i32* %1
    %8 = add i32 %7, 1
    store i32 %8, i32* %1
    br label %again_1
break_1:
    ret void
}

define void @ff_printf(%Str8* %str, ...) {
    %1 = alloca i8*
    %2 = bitcast i8** %1 to i8*
    call void @llvm.va_start(i8* %2)
    %3 = alloca i32
    store i32 0, i32* %3
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %4 = load i32, i32* %3
    %5 = getelementptr inbounds %Str8, %Str8* %str, i32 0, i32 %4
    %6 = load i8, i8* %5
    %7 = alloca i8
    store i8 %6, i8* %7
    %8 = load i8, i8* %7
    %9 = icmp eq i8 %8, 0
    br i1 %9 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %11 = load i8, i8* %7
    %12 = icmp eq i8 %11, 37
    br i1 %12 , label %then_1, label %else_1
then_1:
    %13 = load i32, i32* %3
    %14 = add i32 %13, 1
    store i32 %14, i32* %3
    %15 = load i32, i32* %3
    %16 = getelementptr inbounds %Str8, %Str8* %str, i32 0, i32 %15
    %17 = load i8, i8* %16
    store i8 %17, i8* %7
    ; буффер для печати всего, кроме строк
    %18 = alloca [11 x i8]
    %19 = alloca [0 x i8]*
    %20 = bitcast [11 x i8]* %18 to [0 x i8]*
    store [0 x i8]* %20, [0 x i8]** %19
    %21 = load [0 x i8]*, [0 x i8]** %19
    %22 = getelementptr inbounds [0 x i8], [0 x i8]* %21, i32 0, i32 0
    store i8 0, i8* %22
    %23 = load i8, i8* %7
    %24 = icmp eq i8 %23, 105
    %25 = load i8, i8* %7
    %26 = icmp eq i8 %25, 100
    %27 = or i1 %24, %26
    br i1 %27 , label %then_2, label %else_2
then_2:
    ; %i & %d for signed integer (Int)
    %28 = va_arg %VA_List* %1, i32
    %29 = load [0 x i8]*, [0 x i8]** %19
    call void ([0 x i8]*, i32) @sprintf_dec_int32([0 x i8]* %29, i32 %28)
    br label %endif_2
else_2:
    %30 = load i8, i8* %7
    %31 = icmp eq i8 %30, 110
    br i1 %31 , label %then_3, label %else_3
then_3:
    ; %n for unsigned integer (Nat)
    %32 = va_arg %VA_List* %1, i32
    %33 = load [0 x i8]*, [0 x i8]** %19
    call void ([0 x i8]*, i32) @sprintf_dec_nat32([0 x i8]* %33, i32 %32)
    br label %endif_3
else_3:
    %34 = load i8, i8* %7
    %35 = icmp eq i8 %34, 120
    %36 = load i8, i8* %7
    %37 = icmp eq i8 %36, 112
    %38 = or i1 %35, %37
    br i1 %38 , label %then_4, label %else_4
then_4:
    ; %x for unsigned integer (Nat)
    ; %p for pointers
    %39 = va_arg %VA_List* %1, i32
    %40 = load [0 x i8]*, [0 x i8]** %19
    call void ([0 x i8]*, i32) @sprintf_hex_nat32([0 x i8]* %40, i32 %39)
    br label %endif_4
else_4:
    %41 = load i8, i8* %7
    %42 = icmp eq i8 %41, 115
    br i1 %42 , label %then_5, label %else_5
then_5:
    ; %s pointer to string
    %43 = va_arg %VA_List* %1, %Str8*
    store %Str8* %43, [0 x i8]** %19
    br label %endif_5
else_5:
    %44 = load i8, i8* %7
    %45 = icmp eq i8 %44, 99
    br i1 %45 , label %then_6, label %else_6
then_6:
    ; %c for char
    %46 = va_arg %VA_List* %1, i8
    %47 = load [0 x i8]*, [0 x i8]** %19
    %48 = getelementptr inbounds [0 x i8], [0 x i8]* %47, i32 0, i32 0
    store i8 %46, i8* %48
    %49 = load [0 x i8]*, [0 x i8]** %19
    %50 = getelementptr inbounds [0 x i8], [0 x i8]* %49, i32 0, i32 1
    store i8 0, i8* %50
    br label %endif_6
else_6:
    %51 = load i8, i8* %7
    %52 = icmp eq i8 %51, 37
    br i1 %52 , label %then_7, label %endif_7
then_7:
    ; %% for PERCENT_SYMBOL
    store [0 x i8]* bitcast ([2 x i8]* @str1 to [0 x i8]*), [0 x i8]** %19
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
    %53 = load [0 x i8]*, [0 x i8]** %19
    call void (%Str8*) @put_str8([0 x i8]* %53)
    br label %endif_1
else_1:
    %54 = load i8, i8* %7
    call void (i8) @_put_char8(i8 %54)
    br label %endif_1
endif_1:
    %55 = load i32, i32* %3
    %56 = add i32 %55, 1
    store i32 %56, i32* %3
    br label %again_1
break_1:
    %57 = bitcast %VA_List* %1 to i8*
    call void @llvm.va_end(i8* %57)
    ret void
}

define i8 @n_to_sym(i8 %n) {
    %1 = alloca i8
    %2 = icmp ule i8 %n, 9
    br i1 %2 , label %then_0, label %else_0
then_0:
    %3 = add i8 48, %n
    %4 = bitcast i8 %3 to i8
    store i8 %4, i8* %1
    br label %endif_0
else_0:
    %5 = sub i8 %n, 10
    %6 = add i8 65, %5
    %7 = bitcast i8 %6 to i8
    store i8 %7, i8* %1
    br label %endif_0
endif_0:
    %8 = load i8, i8* %1
    ret i8 %8
}

define void @sprintf_hex_nat32([0 x i8]* %buf, i32 %x) {
    %1 = alloca [8 x i8]
    %2 = alloca i32
    store i32 %x, i32* %2
    %3 = alloca i32
    store i32 0, i32* %3
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %4 = load i32, i32* %2
    %5 = urem i32 %4, 16
    %6 = load i32, i32* %2
    %7 = udiv i32 %6, 16
    store i32 %7, i32* %2
    %8 = trunc i32 %5 to i8
    %9 = call i8 (i8) @n_to_sym(i8 %8)
    %10 = load i32, i32* %3
    %11 = getelementptr inbounds [8 x i8], [8 x i8]* %1, i32 0, i32 %10
    store i8 %9, i8* %11
    %12 = load i32, i32* %3
    %13 = add i32 %12, 1
    store i32 %13, i32* %3
    %14 = load i32, i32* %2
    %15 = icmp eq i32 %14, 0
    br i1 %15 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    br label %again_1
break_1:
    ; mirroring into buffer
    %17 = alloca i32
    store i32 0, i32* %17
    br label %again_2
again_2:
    %18 = load i32, i32* %3
    %19 = icmp sgt i32 %18, 0
    br i1 %19 , label %body_2, label %break_2
body_2:
    %20 = load i32, i32* %3
    %21 = sub i32 %20, 1
    store i32 %21, i32* %3
    %22 = load i32, i32* %3
    %23 = getelementptr inbounds [8 x i8], [8 x i8]* %1, i32 0, i32 %22
    %24 = load i8, i8* %23
    %25 = load i32, i32* %17
    %26 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %25
    store i8 %24, i8* %26
    %27 = load i32, i32* %17
    %28 = add i32 %27, 1
    store i32 %28, i32* %17
    br label %again_2
break_2:
    %29 = load i32, i32* %17
    %30 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %29
    store i8 0, i8* %30
    ;return buf
    ret void
}

define void @sprintf_dec_int32([0 x i8]* %buf, i32 %x) {
    %1 = alloca [11 x i8]
    %2 = alloca i32
    store i32 %x, i32* %2
    %3 = load i32, i32* %2
    %4 = icmp slt i32 %3, 0
    br i1 %4 , label %then_0, label %endif_0
then_0:
    %5 = load i32, i32* %2
    %6 = sub i32 0, %5
    store i32 %6, i32* %2
    br label %endif_0
endif_0:
    %7 = alloca i32
    store i32 0, i32* %7
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %8 = load i32, i32* %2
    %9 = srem i32 %8, 10
    %10 = load i32, i32* %2
    %11 = sdiv i32 %10, 10
    store i32 %11, i32* %2
    %12 = trunc i32 %9 to i8
    %13 = call i8 (i8) @n_to_sym(i8 %12)
    %14 = load i32, i32* %7
    %15 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %14
    store i8 %13, i8* %15
    %16 = load i32, i32* %7
    %17 = add i32 %16, 1
    store i32 %17, i32* %7
    %18 = load i32, i32* %2
    %19 = icmp eq i32 %18, 0
    br i1 %19 , label %then_1, label %endif_1
then_1:
    br label %break_1
    br label %endif_1
endif_1:
    br label %again_1
break_1:
    %21 = alloca i32
    store i32 0, i32* %21
    br i1 %4 , label %then_2, label %endif_2
then_2:
    %22 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 0
    store i8 45, i8* %22
    %23 = load i32, i32* %21
    %24 = add i32 %23, 1
    store i32 %24, i32* %21
    br label %endif_2
endif_2:
    br label %again_2
again_2:
    %25 = load i32, i32* %7
    %26 = icmp sgt i32 %25, 0
    br i1 %26 , label %body_2, label %break_2
body_2:
    %27 = load i32, i32* %7
    %28 = sub i32 %27, 1
    store i32 %28, i32* %7
    %29 = load i32, i32* %7
    %30 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %29
    %31 = load i8, i8* %30
    %32 = load i32, i32* %21
    %33 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %32
    store i8 %31, i8* %33
    %34 = load i32, i32* %21
    %35 = add i32 %34, 1
    store i32 %35, i32* %21
    br label %again_2
break_2:
    %36 = load i32, i32* %21
    %37 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %36
    store i8 0, i8* %37
    ;return buf
    ret void
}

define void @sprintf_dec_nat32([0 x i8]* %buf, i32 %x) {
    %1 = alloca [11 x i8]
    %2 = alloca i32
    store i32 %x, i32* %2
    %3 = alloca i32
    store i32 0, i32* %3
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %4 = load i32, i32* %2
    %5 = urem i32 %4, 10
    %6 = load i32, i32* %2
    %7 = udiv i32 %6, 10
    store i32 %7, i32* %2
    %8 = trunc i32 %5 to i8
    %9 = call i8 (i8) @n_to_sym(i8 %8)
    %10 = load i32, i32* %3
    %11 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %10
    store i8 %9, i8* %11
    %12 = load i32, i32* %3
    %13 = add i32 %12, 1
    store i32 %13, i32* %3
    %14 = load i32, i32* %2
    %15 = icmp eq i32 %14, 0
    br i1 %15 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    br label %again_1
break_1:
    %17 = alloca i32
    store i32 0, i32* %17
    br label %again_2
again_2:
    %18 = load i32, i32* %3
    %19 = icmp sgt i32 %18, 0
    br i1 %19 , label %body_2, label %break_2
body_2:
    %20 = load i32, i32* %3
    %21 = sub i32 %20, 1
    store i32 %21, i32* %3
    %22 = load i32, i32* %3
    %23 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %22
    %24 = load i8, i8* %23
    %25 = load i32, i32* %17
    %26 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %25
    store i8 %24, i8* %26
    %27 = load i32, i32* %17
    %28 = add i32 %27, 1
    store i32 %28, i32* %17
    br label %again_2
break_2:
    %29 = load i32, i32* %17
    %30 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %29
    store i8 0, i8* %30
    ;return buf
    ret void
}


