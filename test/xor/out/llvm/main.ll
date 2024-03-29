
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(%SizeT %size)
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare %Int @memcmp(i8* %ptr1, i8* %ptr2, %SizeT %num)
declare void @free(i8* %ptr)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)


declare %Int @ftruncate(%Int %fd, %OffT %size)
















declare %Int @creat(%Str* %path, %ModeT %mode)
declare %Int @open(%Str* %path, %Int %oflags)
declare %Int @read(%Int %fd, i8* %buf, i32 %len)
declare %Int @write(%Int %fd, i8* %buf, i32 %len)
declare %OffT @lseek(%Int %fd, %OffT %offset, %Int %whence)
declare %Int @close(%Int %fd)
declare void @exit(%Int %rc)


declare %DIR* @opendir(%Str* %name)
declare %Int @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, %SizeT %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, %SizeT %n)


declare void @bcopy(i8* %src, i8* %dst, %SizeT %n)


; -- SOURCE: src/main.cm

@str1 = private constant [8 x i8] [i8 48, i8 120, i8 37, i8 48, i8 50, i8 88, i8 32, i8 0]
@str2 = private constant [2 x i8] [i8 10, i8 0]
@str3 = private constant [21 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 120, i8 111, i8 114, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 105, i8 110, i8 103, i8 10, i8 0]
@str4 = private constant [27 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]
@str5 = private constant [26 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 100, i8 101, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]



define void @xor_encrypter([0 x i8]* %buf, i32 %buflen, [0 x i8]* %key, i32 %keylen) {
    %1 = alloca i32
    %2 = zext i8 0 to i32
    store i32 %2, i32* %1
    %3 = alloca i32
    %4 = zext i8 0 to i32
    store i32 %4, i32* %3
    br label %again_1
again_1:
    %5 = load i32, i32* %1
    %6 = icmp ult i32 %5, %buflen
    br i1 %6 , label %body_1, label %break_1
body_1:
    %7 = load i32, i32* %1
    %8 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %7
    %9 = load i32, i32* %1
    %10 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %9
    %11 = load i8, i8* %10
    %12 = load i32, i32* %3
    %13 = getelementptr inbounds [0 x i8], [0 x i8]* %key, i32 0, i32 %12
    %14 = load i8, i8* %13
    %15 = xor i8 %11, %14
    store i8 %15, i8* %8
    %16 = load i32, i32* %3
    %17 = sub i32 %keylen, 1
    %18 = icmp ult i32 %16, %17
    br i1 %18 , label %then_0, label %else_0
then_0:
    %19 = load i32, i32* %3
    %20 = add i32 %19, 1
    store i32 %20, i32* %3
    br label %endif_0
else_0:
    store i32 0, i32* %3
    br label %endif_0
endif_0:
    %21 = load i32, i32* %1
    %22 = add i32 %21, 1
    store i32 %22, i32* %1
    br label %again_1
break_1:
    ret void
}




@test_msg = global [13 x i8] [
    i8 72,
    i8 101,
    i8 108,
    i8 108,
    i8 111,
    i8 32,
    i8 87,
    i8 111,
    i8 114,
    i8 108,
    i8 100,
    i8 33,
    i8 0
]
@test_key = global [4 x i8] [
    i8 97,
    i8 98,
    i8 99,
    i8 0
]

define void @print_bytes([0 x i8]* %buf, i32 %len) {
    %1 = alloca i32
    %2 = zext i8 0 to i32
    store i32 %2, i32* %1
    br label %again_1
again_1:
    %3 = load i32, i32* %1
    %4 = icmp ult i32 %3, %len
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = load i32, i32* %1
    %6 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %5
    %7 = load i8, i8* %6
    %8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str1 to [0 x i8]*), i8 %7)
    %9 = load i32, i32* %1
    %10 = add i32 %9, 1
    store i32 %10, i32* %1
    br label %again_1
break_1:
    %11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
    ret void
}

define %Int @main() {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*))
    %2 = bitcast [13 x i8]* @test_msg to [0 x i8]*
    %3 = bitcast [4 x i8]* @test_key to [0 x i8]*
    %4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
    call void ([0 x i8]*, i32) @print_bytes([0 x i8]* %2, i32 12)
    ; encrypt test data
    call void ([0 x i8]*, i32, [0 x i8]*, i32) @xor_encrypter([0 x i8]* %2, i32 12, [0 x i8]* %3, i32 3)
    %5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str5 to [0 x i8]*))
    call void ([0 x i8]*, i32) @print_bytes([0 x i8]* %2, i32 12)
    ; decrypt test data
    call void ([0 x i8]*, i32, [0 x i8]*, i32) @xor_encrypter([0 x i8]* %2, i32 12, [0 x i8]* %3, i32 3)
    %6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
    call void ([0 x i8]*, i32) @print_bytes([0 x i8]* %2, i32 12)
    ret %Int 0
}


