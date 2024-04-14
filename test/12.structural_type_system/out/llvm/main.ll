
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


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


; -- SOURCE: src/main.cm

@str1 = private constant [14 x i8] [i8 102, i8 48, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0, i8 0]
@str2 = private constant [14 x i8] [i8 102, i8 49, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0, i8 0]
@str3 = private constant [14 x i8] [i8 102, i8 50, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0, i8 0]
@str4 = private constant [14 x i8] [i8 102, i8 51, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0, i8 0]
@str5 = private constant [15 x i8] [i8 102, i8 48, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0, i8 0]
@str6 = private constant [15 x i8] [i8 102, i8 49, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0, i8 0]
@str7 = private constant [15 x i8] [i8 102, i8 50, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0, i8 0]
@str8 = private constant [15 x i8] [i8 102, i8 51, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0, i8 0]



%Type1 = type {
	i32
}

%Type2 = type {
	i32
}


define void @f0_val(%Type1 %x) {
    %1 = extractvalue %Type1 %x, 0
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str1 to [0 x i8]*), i32 %1)
    ret void
}

define void @f1_val(%Type2 %x) {
    %1 = extractvalue %Type2 %x, 0
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str2 to [0 x i8]*), i32 %1)
    ret void
}

define void @f2_val(%Type1 %x) {
    %1 = extractvalue %Type1 %x, 0
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str3 to [0 x i8]*), i32 %1)
    ret void
}

define void @f3_val({ i32} %x) {
    %1 = extractvalue { i32} %x, 0
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str4 to [0 x i8]*), i32 %1)
    ret void
}

define void @f0_ptr(%Type1* %x) {
    %1 = getelementptr inbounds %Type1, %Type1* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str5 to [0 x i8]*), i32 %2)
    ret void
}

define void @f1_ptr(%Type2* %x) {
    %1 = getelementptr inbounds %Type2, %Type2* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), i32 %2)
    ret void
}

define void @f2_ptr(%Type1* %x) {
    %1 = getelementptr inbounds %Type1, %Type1* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i32 %2)
    ret void
}

define void @f3_ptr({ i32}* %x) {
    %1 = getelementptr inbounds { i32}, { i32}* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str8 to [0 x i8]*), i32 %2)
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
    %7 = load %Type1, %Type1* @a
    %8 = alloca %Type1
    store %Type1 %7, %Type1* %8
    %9 = bitcast %Type1* %8 to { i32}*
    %10 = load { i32}, { i32}* %9
    call void ({ i32}) @f3_val({ i32} %10)
    %11 = load %Type2, %Type2* @b
    %12 = alloca %Type2
    store %Type2 %11, %Type2* %12
    %13 = bitcast %Type2* %12 to %Type1*
    %14 = load %Type1, %Type1* %13
    call void (%Type1) @f0_val(%Type1 %14)
    %15 = load %Type2, %Type2* @b
    call void (%Type2) @f1_val(%Type2 %15)
    %16 = load %Type2, %Type2* @b
    %17 = alloca %Type2
    store %Type2 %16, %Type2* %17
    %18 = bitcast %Type2* %17 to %Type1*
    %19 = load %Type1, %Type1* %18
    call void (%Type1) @f2_val(%Type1 %19)
    %20 = load %Type2, %Type2* @b
    %21 = alloca %Type2
    store %Type2 %20, %Type2* %21
    %22 = bitcast %Type2* %21 to { i32}*
    %23 = load { i32}, { i32}* %22
    call void ({ i32}) @f3_val({ i32} %23)
    %24 = load %Type1, %Type1* @c
    call void (%Type1) @f0_val(%Type1 %24)
    %25 = load %Type1, %Type1* @c
    %26 = alloca %Type1
    store %Type1 %25, %Type1* %26
    %27 = bitcast %Type1* %26 to %Type2*
    %28 = load %Type2, %Type2* %27
    call void (%Type2) @f1_val(%Type2 %28)
    %29 = load %Type1, %Type1* @c
    call void (%Type1) @f2_val(%Type1 %29)
    %30 = load %Type1, %Type1* @c
    %31 = alloca %Type1
    store %Type1 %30, %Type1* %31
    %32 = bitcast %Type1* %31 to { i32}*
    %33 = load { i32}, { i32}* %32
    call void ({ i32}) @f3_val({ i32} %33)
    ret void
}

define void @test_by_pointer() {
    call void (%Type1*) @f0_ptr(%Type1* @a)
    %1 = bitcast %Type1* @a to %Type2*
    call void (%Type2*) @f1_ptr(%Type2* %1)
    call void (%Type1*) @f2_ptr(%Type1* @a)
    %2 = bitcast %Type1* @a to { i32}*
    call void ({ i32}*) @f3_ptr({ i32}* %2)
    %3 = bitcast %Type2* @b to %Type1*
    call void (%Type1*) @f0_ptr(%Type1* %3)
    call void (%Type2*) @f1_ptr(%Type2* @b)
    %4 = bitcast %Type2* @b to %Type1*
    call void (%Type1*) @f2_ptr(%Type1* %4)
    %5 = bitcast %Type2* @b to { i32}*
    call void ({ i32}*) @f3_ptr({ i32}* %5)
    call void (%Type1*) @f0_ptr(%Type1* @c)
    %6 = bitcast %Type1* @c to %Type2*
    call void (%Type2*) @f1_ptr(%Type2* %6)
    call void (%Type1*) @f2_ptr(%Type1* @c)
    %7 = bitcast %Type1* @c to { i32}*
    call void ({ i32}*) @f3_ptr({ i32}* %7)
    ret void
}

define %Int @main() {
    call void () @test_by_value()
    call void () @test_by_pointer()
    ret %Int 0
}


