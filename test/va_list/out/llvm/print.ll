
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

declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

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




%FILE = type opaque
%FposT = type opaque

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
    %4 = alloca i8
    %5 = load i32, i32* %3
    %6 = getelementptr inbounds %Str8, %Str8* %str, i32 0, i32 %5
    %7 = bitcast i8* %4 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %7, i8 0, i32 1, i1 0)
    %8 = bitcast i8* %4 to i8*
    %9 = bitcast i8* %6 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %8, i8* %9, i32 1, i1 0)
    %10 = load i8, i8* %4
    %11 = icmp eq i8 %10, 0
    br i1 %11 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    %13 = load i8, i8* %4
    %14 = icmp eq i8 %13, 37
    br i1 %14 , label %then_1, label %else_1
then_1:
    %15 = load i32, i32* %3
    %16 = add i32 %15, 1
    store i32 %16, i32* %3
    %17 = load i32, i32* %3
    %18 = getelementptr inbounds %Str8, %Str8* %str, i32 0, i32 %17
    %19 = bitcast i8* %4 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %19, i8 0, i32 1, i1 0)
    %20 = bitcast i8* %4 to i8*
    %21 = bitcast i8* %18 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %20, i8* %21, i32 1, i1 0)
    ; буффер для печати всего, кроме строк
    %22 = alloca [11 x i8]
    %23 = alloca [0 x i8]*
    %24 = bitcast [11 x i8]* %22 to [0 x i8]*
    store [0 x i8]* %24, [0 x i8]** %23
    %25 = load [0 x i8]*, [0 x i8]** %23
    %26 = getelementptr inbounds [0 x i8], [0 x i8]* %25, i32 0, i32 0
    store i8 0, i8* %26
    %27 = load i8, i8* %4
    %28 = icmp eq i8 %27, 105
    %29 = load i8, i8* %4
    %30 = icmp eq i8 %29, 100
    %31 = or i1 %28, %30
    br i1 %31 , label %then_2, label %else_2
then_2:
    ; %i & %d for signed integer (Int)
    %32 = va_arg %VA_List* %1, i32
    %33 = load [0 x i8]*, [0 x i8]** %23
    call void ([0 x i8]*, i32) @sprintf_dec_int32([0 x i8]* %33, i32 %32)
    br label %endif_2
else_2:
    %34 = load i8, i8* %4
    %35 = icmp eq i8 %34, 110
    br i1 %35 , label %then_3, label %else_3
then_3:
    ; %n for unsigned integer (Nat)
    %36 = va_arg %VA_List* %1, i32
    %37 = load [0 x i8]*, [0 x i8]** %23
    call void ([0 x i8]*, i32) @sprintf_dec_nat32([0 x i8]* %37, i32 %36)
    br label %endif_3
else_3:
    %38 = load i8, i8* %4
    %39 = icmp eq i8 %38, 120
    %40 = load i8, i8* %4
    %41 = icmp eq i8 %40, 112
    %42 = or i1 %39, %41
    br i1 %42 , label %then_4, label %else_4
then_4:
    ; %x for unsigned integer (Nat)
    ; %p for pointers
    %43 = va_arg %VA_List* %1, i32
    %44 = load [0 x i8]*, [0 x i8]** %23
    call void ([0 x i8]*, i32) @sprintf_hex_nat32([0 x i8]* %44, i32 %43)
    br label %endif_4
else_4:
    %45 = load i8, i8* %4
    %46 = icmp eq i8 %45, 115
    br i1 %46 , label %then_5, label %else_5
then_5:
    ; %s pointer to string
    %47 = va_arg %VA_List* %1, %Str8*
    store %Str8* %47, [0 x i8]** %23
    br label %endif_5
else_5:
    %48 = load i8, i8* %4
    %49 = icmp eq i8 %48, 99
    br i1 %49 , label %then_6, label %else_6
then_6:
    ; %c for char
    %50 = va_arg %VA_List* %1, i8
    %51 = load [0 x i8]*, [0 x i8]** %23
    %52 = getelementptr inbounds [0 x i8], [0 x i8]* %51, i32 0, i32 0
    store i8 %50, i8* %52
    %53 = load [0 x i8]*, [0 x i8]** %23
    %54 = getelementptr inbounds [0 x i8], [0 x i8]* %53, i32 0, i32 1
    store i8 0, i8* %54
    br label %endif_6
else_6:
    %55 = load i8, i8* %4
    %56 = icmp eq i8 %55, 37
    br i1 %56 , label %then_7, label %endif_7
then_7:
    ; %% for PERCENT_SYMBOL
    store [0 x i8]* bitcast ([2 x i8]* @str1 to [0 x i8]*), [0 x i8]** %23
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
    %57 = load [0 x i8]*, [0 x i8]** %23
    call void (%Str8*) @put_str8([0 x i8]* %57)
    br label %endif_1
else_1:
    %58 = load i8, i8* %4
    call void (i8) @_put_char8(i8 %58)
    br label %endif_1
endif_1:
    %59 = load i32, i32* %3
    %60 = add i32 %59, 1
    store i32 %60, i32* %3
    br label %again_1
break_1:
    %61 = bitcast %VA_List* %1 to i8*
    call void @llvm.va_end(i8* %61)
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
    %8 = load i32, i32* %3
    %9 = getelementptr inbounds [8 x i8], [8 x i8]* %1, i32 0, i32 %8
    %10 = trunc i32 %5 to i8
    %11 = call i8 (i8) @n_to_sym(i8 %10)
    store i8 %11, i8* %9
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
    %22 = load i32, i32* %17
    %23 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %22
    %24 = load i32, i32* %3
    %25 = getelementptr inbounds [8 x i8], [8 x i8]* %1, i32 0, i32 %24
    %26 = bitcast i8* %23 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %26, i8 0, i32 1, i1 0)
    %27 = bitcast i8* %23 to i8*
    %28 = bitcast i8* %25 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %27, i8* %28, i32 1, i1 0)
    %29 = load i32, i32* %17
    %30 = add i32 %29, 1
    store i32 %30, i32* %17
    br label %again_2
break_2:
    %31 = load i32, i32* %17
    %32 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %31
    store i8 0, i8* %32
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
    %12 = load i32, i32* %7
    %13 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %12
    %14 = trunc i32 %9 to i8
    %15 = call i8 (i8) @n_to_sym(i8 %14)
    store i8 %15, i8* %13
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
    %29 = load i32, i32* %21
    %30 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %29
    %31 = load i32, i32* %7
    %32 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %31
    %33 = bitcast i8* %30 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %33, i8 0, i32 1, i1 0)
    %34 = bitcast i8* %30 to i8*
    %35 = bitcast i8* %32 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %34, i8* %35, i32 1, i1 0)
    %36 = load i32, i32* %21
    %37 = add i32 %36, 1
    store i32 %37, i32* %21
    br label %again_2
break_2:
    %38 = load i32, i32* %21
    %39 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %38
    store i8 0, i8* %39
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
    %8 = load i32, i32* %3
    %9 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %8
    %10 = trunc i32 %5 to i8
    %11 = call i8 (i8) @n_to_sym(i8 %10)
    store i8 %11, i8* %9
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
    %22 = load i32, i32* %17
    %23 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %22
    %24 = load i32, i32* %3
    %25 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %24
    %26 = bitcast i8* %23 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %26, i8 0, i32 1, i1 0)
    %27 = bitcast i8* %23 to i8*
    %28 = bitcast i8* %25 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %27, i8* %28, i32 1, i1 0)
    %29 = load i32, i32* %17
    %30 = add i32 %29, 1
    store i32 %30, i32* %17
    br label %again_2
break_2:
    %31 = load i32, i32* %17
    %32 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %31
    store i8 0, i8* %32
    ;return buf
    ret void
}


