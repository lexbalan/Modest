
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

; -- SOURCE: src/main.cm

@str1.c8 = private constant [13 x i8] [i8 102, i8 48, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2.c8 = private constant [13 x i8] [i8 102, i8 49, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3.c8 = private constant [13 x i8] [i8 102, i8 50, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4.c8 = private constant [13 x i8] [i8 102, i8 51, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5.c8 = private constant [14 x i8] [i8 102, i8 48, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6.c8 = private constant [14 x i8] [i8 102, i8 49, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7.c8 = private constant [14 x i8] [i8 102, i8 50, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8.c8 = private constant [14 x i8] [i8 102, i8 51, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]



%Type1 = type {
	i32
}

%Type2 = type {
	i32
}

%Type3 = type {
	i32
}


define void @f0_val(%Type1 %x) {
    %1 = extractvalue %Type1 %x, 0
    %2 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str1.c8 to [0 x i8]*), i32 %1)
    ret void
}

define void @f1_val(%Type2 %x) {
    %1 = extractvalue %Type2 %x, 0
    %2 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str2.c8 to [0 x i8]*), i32 %1)
    ret void
}

define void @f2_val(%Type3 %x) {
    %1 = extractvalue %Type3 %x, 0
    %2 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str3.c8 to [0 x i8]*), i32 %1)
    ret void
}

define void @f3_val({
	i32
} %x) {
    %1 = extractvalue {
	i32
} %x, 0
    %2 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str4.c8 to [0 x i8]*), i32 %1)
    ret void
}

define void @f0_ptr(%Type1* %x) {
    %1 = getelementptr inbounds %Type1, %Type1* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str5.c8 to [0 x i8]*), i32 %2)
    ret void
}

define void @f1_ptr(%Type2* %x) {
    %1 = getelementptr inbounds %Type2, %Type2* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str6.c8 to [0 x i8]*), i32 %2)
    ret void
}

define void @f2_ptr(%Type3* %x) {
    %1 = getelementptr inbounds %Type3, %Type3* %x, i32 0, i32 0
    %2 = load i32, i32* %1
    %3 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str7.c8 to [0 x i8]*), i32 %2)
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
    %3 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str8.c8 to [0 x i8]*), i32 %2)
    ret void
}


@a = global %Type1 {
  i32 1
}
@b = global %Type2 {
  i32 2
}
@c = global %Type3 {
  i32 3
}

define void @test_by_value() {
    %1 = load %Type1, %Type1* @a
    call void(%Type1) @f0_val (%Type1 %1)
    %2 = load %Type1, %Type1* @a
    %3 = alloca %Type1

; -- record assign
    %4 = getelementptr inbounds %Type1, %Type1* %3, i32 0, i32 0
    %5 = extractvalue %Type1 %2, 0
    store i32 %5, i32* %4
; -- end record assign

    %6 = bitcast %Type1* %3 to %Type2*
    %7 = load %Type2, %Type2* %6
    call void(%Type2) @f1_val (%Type2 %7)
    %8 = load %Type1, %Type1* @a
    %9 = alloca %Type1

; -- record assign
    %10 = getelementptr inbounds %Type1, %Type1* %9, i32 0, i32 0
    %11 = extractvalue %Type1 %8, 0
    store i32 %11, i32* %10
; -- end record assign

    %12 = bitcast %Type1* %9 to %Type3*
    %13 = load %Type3, %Type3* %12
    call void(%Type3) @f2_val (%Type3 %13)
;f3_val(a)
    %14 = load %Type2, %Type2* @b
    %15 = alloca %Type2

; -- record assign
    %16 = getelementptr inbounds %Type2, %Type2* %15, i32 0, i32 0
    %17 = extractvalue %Type2 %14, 0
    store i32 %17, i32* %16
; -- end record assign

    %18 = bitcast %Type2* %15 to %Type1*
    %19 = load %Type1, %Type1* %18
    call void(%Type1) @f0_val (%Type1 %19)
    %20 = load %Type2, %Type2* @b
    call void(%Type2) @f1_val (%Type2 %20)
    %21 = load %Type2, %Type2* @b
    %22 = alloca %Type2

; -- record assign
    %23 = getelementptr inbounds %Type2, %Type2* %22, i32 0, i32 0
    %24 = extractvalue %Type2 %21, 0
    store i32 %24, i32* %23
; -- end record assign

    %25 = bitcast %Type2* %22 to %Type3*
    %26 = load %Type3, %Type3* %25
    call void(%Type3) @f2_val (%Type3 %26)
;f3_val(b)
    %27 = load %Type3, %Type3* @c
    %28 = alloca %Type3

; -- record assign
    %29 = getelementptr inbounds %Type3, %Type3* %28, i32 0, i32 0
    %30 = extractvalue %Type3 %27, 0
    store i32 %30, i32* %29
; -- end record assign

    %31 = bitcast %Type3* %28 to %Type1*
    %32 = load %Type1, %Type1* %31
    call void(%Type1) @f0_val (%Type1 %32)
    %33 = load %Type3, %Type3* @c
    %34 = alloca %Type3

; -- record assign
    %35 = getelementptr inbounds %Type3, %Type3* %34, i32 0, i32 0
    %36 = extractvalue %Type3 %33, 0
    store i32 %36, i32* %35
; -- end record assign

    %37 = bitcast %Type3* %34 to %Type2*
    %38 = load %Type2, %Type2* %37
    call void(%Type2) @f1_val (%Type2 %38)
    %39 = load %Type3, %Type3* @c
    call void(%Type3) @f2_val (%Type3 %39)
;f3_val(c)
    ret void
}

define void @test_by_pointer() {
    %1 = bitcast %Type1* @a to %Type1*
    call void(%Type1*) @f0_ptr (%Type1* %1)
    %2 = bitcast %Type1* @a to %Type2*
    call void(%Type2*) @f1_ptr (%Type2* %2)
    %3 = bitcast %Type1* @a to %Type3*
    call void(%Type3*) @f2_ptr (%Type3* %3)
;f3_ptr(&a)
    %4 = bitcast %Type2* @b to %Type1*
    call void(%Type1*) @f0_ptr (%Type1* %4)
    %5 = bitcast %Type2* @b to %Type2*
    call void(%Type2*) @f1_ptr (%Type2* %5)
    %6 = bitcast %Type2* @b to %Type3*
    call void(%Type3*) @f2_ptr (%Type3* %6)
;f3_ptr(&b)
    %7 = bitcast %Type3* @c to %Type1*
    call void(%Type1*) @f0_ptr (%Type1* %7)
    %8 = bitcast %Type3* @c to %Type2*
    call void(%Type2*) @f1_ptr (%Type2* %8)
    %9 = bitcast %Type3* @c to %Type3*
    call void(%Type3*) @f2_ptr (%Type3* %9)
;f3_ptr(&c)
    ret void
}

define i32 @main() {
    call void() @test_by_value ()
    call void() @test_by_pointer ()
    ret i32 0
}


