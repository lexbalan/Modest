
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

@str1 = private constant [15 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 58, i8 10, i8 0]
@str2 = private constant [2 x i8] [i8 10, i8 0]
@str3 = private constant [14 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 97, i8 102, i8 116, i8 101, i8 114, i8 58, i8 10, i8 0]
@str4 = private constant [2 x i8] [i8 10, i8 0]
@str5 = private constant [2 x i8] [i8 10, i8 0]
@str6 = private constant [16 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [6 x i8] [i8 91, i8 37, i8 105, i8 93, i8 32, i8 0]
@str8 = private constant [28 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 97, i8 32, i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 40, i8 37, i8 105, i8 32, i8 46, i8 46, i8 32, i8 37, i8 105, i8 41, i8 58, i8 32, i8 0]
@str9 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str10 = private constant [43 x i8] [i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 103, i8 114, i8 101, i8 97, i8 116, i8 101, i8 114, i8 32, i8 116, i8 104, i8 97, i8 110, i8 32, i8 37, i8 105, i8 44, i8 32, i8 116, i8 114, i8 121, i8 32, i8 97, i8 103, i8 97, i8 105, i8 110, i8 10, i8 0]
@str11 = private constant [40 x i8] [i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 108, i8 101, i8 115, i8 115, i8 32, i8 116, i8 104, i8 97, i8 110, i8 32, i8 37, i8 105, i8 44, i8 32, i8 116, i8 114, i8 121, i8 32, i8 97, i8 103, i8 97, i8 105, i8 110, i8 10, i8 0]




@array = global [21 x i32] [
    i32 -3,
    i32 -5,
    i32 2,
    i32 1,
    i32 -1,
    i32 0,
    i32 -2,
    i32 3,
    i32 -4,
    i32 4,
    i32 11,
    i32 9,
    i32 6,
    i32 -7,
    i32 -8,
    i32 5,
    i32 7,
    i32 10,
    i32 8,
    i32 -6,
    i32 -9
]

define void @bubble_sort32([0 x i32]* %array, i32 %len) {
    %1 = alloca i1
    store i1 1, i1* %1
    br label %again_1
again_1:
    %2 = load i1, i1* %1
    br i1 %2 , label %body_1, label %break_1
body_1:
    store i1 0, i1* %1
    %3 = alloca i32
    store i32 0, i32* %3
    br label %again_2
again_2:
    %4 = sub i32 %len, 1
    %5 = load i32, i32* %3
    %6 = icmp slt i32 %5, %4
    br i1 %6 , label %body_2, label %break_2
body_2:
    %7 = load i32, i32* %3
    %8 = getelementptr inbounds [0 x i32], [0 x i32]* %array, i32 0, i32 %7
    %9 = load i32, i32* %8
    %10 = load i32, i32* %3
    %11 = add i32 %10, 1
    %12 = getelementptr inbounds [0 x i32], [0 x i32]* %array, i32 0, i32 %11
    %13 = load i32, i32* %12
    %14 = icmp sgt i32 %9, %13
    br i1 %14 , label %then_0, label %endif_0
then_0:
    ; swap
    %15 = load i32, i32* %3
    %16 = getelementptr inbounds [0 x i32], [0 x i32]* %array, i32 0, i32 %15
    store i32 %13, i32* %16
    %17 = load i32, i32* %3
    %18 = add i32 %17, 1
    %19 = getelementptr inbounds [0 x i32], [0 x i32]* %array, i32 0, i32 %18
    store i32 %9, i32* %19
    store i1 1, i1* %1
    br label %break_2
    br label %endif_0
endif_0:
    %21 = load i32, i32* %3
    %22 = add i32 %21, 1
    store i32 %22, i32* %3
    br label %again_2
break_2:
    br label %again_1
break_1:
    ret void
}

define i32 @main() {
    ;fill_array(&array, numberOfItems)
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str1 to [0 x i8]*))
    %2 = bitcast [21 x i32]* @array to [0 x i32]*
    call void ([0 x i32]*, i32) @print_array([0 x i32]* %2, i32 21)
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
    %4 = bitcast [21 x i32]* @array to [0 x i32]*
    call void ([0 x i32]*, i32) @bubble_sort32([0 x i32]* %4, i32 21)
    %5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str3 to [0 x i8]*))
    %6 = bitcast [21 x i32]* @array to [0 x i32]*
    call void ([0 x i32]*, i32) @print_array([0 x i32]* %6, i32 21)
    %7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
    ret i32 0
}

define void @print_array([0 x i32]* %array, i32 %len) {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str5 to [0 x i8]*))
    %2 = alloca i32
    store i32 0, i32* %2
    br label %again_1
again_1:
    %3 = load i32, i32* %2
    %4 = icmp slt i32 %3, %len
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = load i32, i32* %2
    %6 = load i32, i32* %2
    %7 = getelementptr inbounds [0 x i32], [0 x i32]* %array, i32 0, i32 %6
    %8 = load i32, i32* %7
    %9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str6 to [0 x i8]*), i32 %5, i32 %8)
    %10 = load i32, i32* %2
    %11 = add i32 %10, 1
    store i32 %11, i32* %2
    br label %again_1
break_1:
    ret void
}

define void @fill_array([0 x i32]* %array, i32 %len) {
    %1 = sub i10 0, 1000
    %2 = alloca i32
    store i32 0, i32* %2
    br label %again_1
again_1:
    %3 = load i32, i32* %2
    %4 = icmp slt i32 %3, %len
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = load i32, i32* %2
    %6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str7 to [0 x i8]*), i32 %5)
    %7 = call i32 (i32, i32) @get_integer(i32 -1000, i32 1000)
    %8 = load i32, i32* %2
    %9 = getelementptr inbounds [0 x i32], [0 x i32]* %array, i32 0, i32 %8
    store i32 %7, i32* %9
    %10 = load i32, i32* %2
    %11 = add i32 %10, 1
    store i32 %11, i32* %2
    br label %again_1
break_1:
    ret void
}

define i32 @get_integer(i32 %min, i32 %max) {
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str8 to [0 x i8]*), i32 %min, i32 %max)
    %3 = call %Int (%ConstCharStr*, ...) @scanf(%ConstCharStr* bitcast ([3 x i8]* @str9 to [0 x i8]*), i32* %1)
    %4 = load i32, i32* %1
    %5 = icmp slt i32 %4, %min
    br i1 %5 , label %then_0, label %else_0
then_0:
    %6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @str10 to [0 x i8]*), i32 %min)
    br label %again_1
    br label %endif_0
else_0:
    %8 = load i32, i32* %1
    %9 = icmp sgt i32 %8, %max
    br i1 %9 , label %then_1, label %else_1
then_1:
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([40 x i8]* @str11 to [0 x i8]*), i32 %max)
    br label %again_1
    br label %endif_1
else_1:
    br label %break_1
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    br label %again_1
break_1:
    %13 = load i32, i32* %1
    ret i32 %13
}


