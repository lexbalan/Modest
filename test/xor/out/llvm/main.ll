
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


declare i32 @fclose(%FILE* %f)
declare i32 @feof(%FILE* %f)
declare i32 @ferror(%FILE* %f)
declare i32 @fflush(%FILE* %f)
declare i32 @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare i32 @fseek(%FILE* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%FILE* %f, %FposT* %pos)
declare i64 @ftell(%FILE* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare i32 @setvbuf(%FILE* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%FILE* %stream, %Str* %format, ...)
declare i32 @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare i32 @fgetc(%FILE* %f)
declare i32 @fputc(i32 %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %FILE* %f)
declare i32 @fputs(%ConstCharStr* %str, %FILE* %f)
declare i32 @getc(%FILE* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %FILE* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%OffT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(i64 %size)
declare i8* @memset(i8* %mem, i32 %c, i64 %n)
declare i8* @memcpy(i8* %dst, i8* %src, i64 %len)
declare i32 @memcmp(i8* %ptr1, i8* %ptr2, i64 %num)
declare void @free(i8* %ptr)
declare i32 @strncmp([0 x i8]* %s1, [0 x i8]* %s2, i64 %n)
declare i32 @strcmp([0 x i8]* %s1, [0 x i8]* %s2)
declare [0 x i8]* @strcpy([0 x i8]* %dst, [0 x i8]* %src)
declare i64 @strlen([0 x i8]* %s)


declare i32 @ftruncate(i32 %fd, i32 %size)
















declare i32 @creat(%Str* %path, i32 %mode)
declare i32 @open(%Str* %path, i32 %oflags)
declare i32 @read(i32 %fd, i8* %buf, i32 %len)
declare i32 @write(i32 %fd, i8* %buf, i32 %len)
declare i32 @lseek(i32 %fd, i32 %offset, i32 %whence)
declare i32 @close(i32 %fd)
declare void @exit(i32 %rc)


declare %DIR* @opendir(%Str* %name)
declare i32 @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, i64 %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, i64 %n)


declare void @bcopy(i8* %src, i8* %dst, i64 %n)

; -- SOURCE: src/main.cm

@str1 = private constant [8 x i8] [i8 48, i8 120, i8 37, i8 48, i8 50, i8 88, i8 32, i8 0]
@str2 = private constant [2 x i8] [i8 10, i8 0]
@str3 = private constant [21 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 120, i8 111, i8 114, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 105, i8 110, i8 103, i8 10, i8 0]
@str4 = private constant [27 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]
@str5 = private constant [26 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 100, i8 101, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]



define void @xor_encrypter([0 x i8]* %buf, i32 %buflen, [0 x i8]* %key, i32 %keylen) {
    %1 = alloca i32
    store i32 0, i32* %1
    %2 = alloca i32
    store i32 0, i32* %2
    br label %again_1
again_1:
    %3 = load i32, i32* %1
    %4 = icmp ult i32 %3, %buflen
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = load i32, i32* %1
    %6 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %5
    %7 = load i8, i8* %6
    %8 = load i32, i32* %2
    %9 = getelementptr inbounds [0 x i8], [0 x i8]* %key, i32 0, i32 %8
    %10 = load i8, i8* %9
    %11 = xor i8 %7, %10
    %12 = load i32, i32* %1
    %13 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %12
    store i8 %11, i8* %13
    %14 = load i32, i32* %1
    %15 = add i32 %14, 1
    store i32 %15, i32* %1
    %16 = load i32, i32* %2
    %17 = sub i32 %keylen, 1
    %18 = icmp ult i32 %16, %17
    br i1 %18 , label %then_0, label %else_0
then_0:
    %19 = load i32, i32* %2
    %20 = add i32 %19, 1
    store i32 %20, i32* %2
    br label %endif_0
else_0:
    store i32 0, i32* %2
    br label %endif_0
endif_0:
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
    store i32 0, i32* %1
    br label %again_1
again_1:
    %2 = load i32, i32* %1
    %3 = icmp ult i32 %2, %len
    br i1 %3 , label %body_1, label %break_1
body_1:
    %4 = load i32, i32* %1
    %5 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %4
    %6 = load i8, i8* %5
    %7 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str1 to [0 x i8]*), i8 %6)
    %8 = load i32, i32* %1
    %9 = add i32 %8, 1
    store i32 %9, i32* %1
    br label %again_1
break_1:
    %10 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
    ret void
}

define i32 @main() {
    %1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*))
    %2 = bitcast [13 x i8]* @test_msg to [0 x i8]*
    %3 = bitcast [4 x i8]* @test_key to [0 x i8]*
    %4 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
    call void ([0 x i8]*, i32) @print_bytes([0 x i8]* %2, i32 12)
    ; encrypt test data
    call void ([0 x i8]*, i32, [0 x i8]*, i32) @xor_encrypter([0 x i8]* %2, i32 12, [0 x i8]* %3, i32 3)
    %5 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str5 to [0 x i8]*))
    call void ([0 x i8]*, i32) @print_bytes([0 x i8]* %2, i32 12)
    ; decrypt test data
    call void ([0 x i8]*, i32, [0 x i8]*, i32) @xor_encrypter([0 x i8]* %2, i32 12, [0 x i8]* %3, i32 3)
    %6 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
    call void ([0 x i8]*, i32) @print_bytes([0 x i8]* %2, i32 12)
    ret i32 0
}


