
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


; -- SOURCE: src/main.cm

@str1 = private constant [13 x i8] [i8 102, i8 48, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 102, i8 49, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [13 x i8] [i8 102, i8 50, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [13 x i8] [i8 102, i8 51, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 102, i8 48, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 102, i8 49, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 102, i8 50, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [14 x i8] [i8 102, i8 51, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]



%Type1 = type {
	i32
}

%Type2 = type {
	i32
}


define void @f0_val(%Type1 %x) {
    %1 = extractvalue %Type1 %x, 0
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*), i32 %1)
    ret void
}

define void @f1_val(%Type2 %x) {
    %1 = extractvalue %Type2 %x, 0
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), i32 %1)
    ret void
}

define void @f2_val(%Type1 %x) {
    %1 = extractvalue %Type1 %x, 0
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), i32 %1)
    ret void
}

define void @f3_val({
	i32
} %x) {
    %1 = extractvalue {
	i32
} %x, 0
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str4 to [0 x i8]*), i32 %1)
    ret void
}

define void @f0_ptr(%Type1* %x) {
    %1 = getelementptr inbounds %Type1, %Type1* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*), i32 %2)
    ret void
}

define void @f1_ptr(%Type2* %x) {
    %1 = getelementptr inbounds %Type2, %Type2* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), i32 %2)
    ret void
}

define void @f2_ptr(%Type1* %x) {
    %1 = getelementptr inbounds %Type1, %Type1* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*), i32 %2)
    ret void
}

define void @f3_ptr({
	i32
}* %x) {
    %1 = getelementptr inbounds {
	i32
}, {
	i32
}* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*), i32 %2)
    ret void
}


@a = global %Type1 {
    i32 1
}
@b = global %Type2 {
    i32 2
}
@c = global %Type1 {
    i32 3
}

define void @test_by_value() {
    %1 = load %Type1, %Type1* @a
    call void (%Type1) @f0_val(%Type1 %1)
    %2 = load %Type1, %Type1* @a
    %3 = alloca %Type1
    store %Type1 %2, %Type1* %3
    %4 = bitcast %Type1* %3 to %Type2*
    %5 = load %Type2, %Type2* %4
    call void (%Type2) @f1_val(%Type2 %5)
    %6 = load %Type1, %Type1* @a
    call void (%Type1) @f2_val(%Type1 %6)
    ;f3_val(a)
    %7 = load %Type2, %Type2* @b
    %8 = alloca %Type2
    store %Type2 %7, %Type2* %8
    %9 = bitcast %Type2* %8 to %Type1*
    %10 = load %Type1, %Type1* %9
    call void (%Type1) @f0_val(%Type1 %10)
    %11 = load %Type2, %Type2* @b
    call void (%Type2) @f1_val(%Type2 %11)
    %12 = load %Type2, %Type2* @b
    %13 = alloca %Type2
    store %Type2 %12, %Type2* %13
    %14 = bitcast %Type2* %13 to %Type1*
    %15 = load %Type1, %Type1* %14
    call void (%Type1) @f2_val(%Type1 %15)
    ;f3_val(b)
    %16 = load %Type1, %Type1* @c
    call void (%Type1) @f0_val(%Type1 %16)
    %17 = load %Type1, %Type1* @c
    %18 = alloca %Type1
    store %Type1 %17, %Type1* %18
    %19 = bitcast %Type1* %18 to %Type2*
    %20 = load %Type2, %Type2* %19
    call void (%Type2) @f1_val(%Type2 %20)
    %21 = load %Type1, %Type1* @c
    call void (%Type1) @f2_val(%Type1 %21)
    ;f3_val(c)
    ret void
}

define void @test_by_pointer() {
    call void (%Type1*) @f0_ptr(%Type1* @a)
    %1 = bitcast %Type1* @a to %Type2*
    call void (%Type2*) @f1_ptr(%Type2* %1)
    call void (%Type1*) @f2_ptr(%Type1* @a)
    ;f3_ptr(&a)
    %2 = bitcast %Type2* @b to %Type1*
    call void (%Type1*) @f0_ptr(%Type1* %2)
    call void (%Type2*) @f1_ptr(%Type2* @b)
    %3 = bitcast %Type2* @b to %Type1*
    call void (%Type1*) @f2_ptr(%Type1* %3)
    ;f3_ptr(&b)
    call void (%Type1*) @f0_ptr(%Type1* @c)
    %4 = bitcast %Type1* @c to %Type2*
    call void (%Type2*) @f1_ptr(%Type2* %4)
    call void (%Type1*) @f2_ptr(%Type1* @c)
    ;f3_ptr(&c)
    ret void
}

define %Int @main() {
    call void () @test_by_value()
    call void () @test_by_pointer()
    ret %Int 0
}


