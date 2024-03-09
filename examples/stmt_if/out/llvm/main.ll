
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

@str1 = private constant [22 x i8] [i8 105, i8 102, i8 32, i8 115, i8 116, i8 97, i8 116, i8 101, i8 109, i8 101, i8 110, i8 116, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 97, i8 58, i8 32, i8 0]
@str3 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str4 = private constant [10 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 98, i8 58, i8 32, i8 0]
@str5 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str6 = private constant [7 x i8] [i8 97, i8 32, i8 62, i8 32, i8 98, i8 10, i8 0]
@str7 = private constant [7 x i8] [i8 97, i8 32, i8 60, i8 32, i8 98, i8 10, i8 0]
@str8 = private constant [8 x i8] [i8 97, i8 32, i8 61, i8 61, i8 32, i8 98, i8 10, i8 0]



define %Int @main() {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str1 to [0 x i8]*))
    %2 = alloca i32
    %3 = alloca i32
    %4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*))
    %5 = call %Int (%ConstCharStr*, ...) @scanf(%ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*), i32* %2)
    %6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str4 to [0 x i8]*))
    %7 = call %Int (%ConstCharStr*, ...) @scanf(%ConstCharStr* bitcast ([3 x i8]* @str5 to [0 x i8]*), i32* %3)
    %8 = load i32, i32* %2
    %9 = load i32, i32* %3
    %10 = icmp sgt i32 %8, %9
    br i1 %10 , label %then_0, label %else_0
then_0:
    %11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str6 to [0 x i8]*))
    br label %endif_0
else_0:
    %12 = load i32, i32* %2
    %13 = load i32, i32* %3
    %14 = icmp slt i32 %12, %13
    br i1 %14 , label %then_1, label %else_1
then_1:
    %15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str7 to [0 x i8]*))
    br label %endif_1
else_1:
    %16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str8 to [0 x i8]*))
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret %Int 0
}


