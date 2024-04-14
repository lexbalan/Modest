
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

@str1 = private constant [21 x i8] [i8 114, i8 101, i8 116, i8 117, i8 114, i8 110, i8 101, i8 100, i8 95, i8 115, i8 116, i8 114, i8 105, i8 110, i8 103, i8 32, i8 61, i8 32, i8 37, i8 115, i8 0]
@str2 = private constant [14 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 32, i8 115, i8 119, i8 97, i8 112, i8 58, i8 10, i8 0]
@str3 = private constant [11 x i8] [i8 97, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str4 = private constant [11 x i8] [i8 97, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 115, i8 119, i8 97, i8 112, i8 58, i8 10, i8 0]
@str6 = private constant [11 x i8] [i8 98, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [11 x i8] [i8 98, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]



define [2 x i32] @swap([2 x i32] %x) {
    %1 = alloca [2 x i32]
    %2 = getelementptr inbounds [2 x i32], [2 x i32]* %1, i32 0, i32 0
    %3 = extractvalue [2 x i32] %x, 1
    store i32 %3, i32* %2
    %4 = getelementptr inbounds [2 x i32], [2 x i32]* %1, i32 0, i32 1
    %5 = extractvalue [2 x i32] %x, 0
    store i32 %5, i32* %4
    %6 = load [2 x i32], [2 x i32]* %1
    ret [2 x i32] %6
}

define [7 x i8] @ret_str() {
    %1 = insertvalue [7 x i8] zeroinitializer, i8 104, 0
    %2 = insertvalue [7 x i8] %1, i8 101, 1
    %3 = insertvalue [7 x i8] %2, i8 108, 2
    %4 = insertvalue [7 x i8] %3, i8 108, 3
    %5 = insertvalue [7 x i8] %4, i8 111, 4
    %6 = insertvalue [7 x i8] %5, i8 33, 5
    %7 = insertvalue [7 x i8] %6, i8 10, 6
    ret [7 x i8] %7
}



@global_array = global [2 x i32] [
    i32 1,
    i32 2
]

%Point = type {
	i32,
	i32
}

%Pod = type {
	[10 x i8]
}


define %Int @main() {
    ; function returns array
    %1 = alloca [7 x i8]
    %2 = call [7 x i8] () @ret_str()
    store [7 x i8] %2, [7 x i8]* %1
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*), [7 x i8]* %1)
    ; function receive array & return array
    %4 = alloca [2 x i32]
    %5 = getelementptr inbounds [2 x i32], [2 x i32]* %4, i32 0, i32 0
    store i32 10, i32* %5
    %6 = getelementptr inbounds [2 x i32], [2 x i32]* %4, i32 0, i32 1
    store i32 20, i32* %6
    %7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str2 to [0 x i8]*))
    %8 = getelementptr inbounds [2 x i32], [2 x i32]* %4, i32 0, i32 0
    %9 = load i32, i32* %8
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str3 to [0 x i8]*), i32 %9)
    %11 = getelementptr inbounds [2 x i32], [2 x i32]* %4, i32 0, i32 1
    %12 = load i32, i32* %11
    %13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str4 to [0 x i8]*), i32 %12)
    %14 = load [2 x i32], [2 x i32]* %4
    %15 = call [2 x i32] ([2 x i32]) @swap([2 x i32] %14)
    %16 = alloca [2 x i32]
    store [2 x i32] %15, [2 x i32]* %16
    %17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*))
    %18 = getelementptr inbounds [2 x i32], [2 x i32]* %16, i32 0, i32 0
    %19 = load i32, i32* %18
    %20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str6 to [0 x i8]*), i32 %19)
    %21 = getelementptr inbounds [2 x i32], [2 x i32]* %16, i32 0, i32 1
    %22 = load i32, i32* %21
    %23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str7 to [0 x i8]*), i32 %22)
    ret %Int 0
}


