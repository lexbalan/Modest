
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
declare i8* @malloc(i64)
declare i8* @memset(i8*, i32, i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @memcmp(i8*, i8*, i64)
declare void @free(i8*)
declare i32 @strncmp([0 x i8]*, [0 x i8]*, i64)
declare i32 @strcmp([0 x i8]*, [0 x i8]*)
declare [0 x i8]* @strcpy([0 x i8]*, [0 x i8]*)
declare i64 @strlen([0 x i8]*)


declare i32 @ftruncate(i32, i32)
















declare i32 @creat(%Str*, i32)
declare i32 @open(%Str*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir(%Str*)
declare i32 @closedir(%DIR*)


declare %Str* @getcwd(%Str*, i64)
declare %Str* @getenv(%Str*)


declare void @bzero(i8*, i64)


declare void @bcopy(i8*, i8*, i64)

; -- SOURCE: src/main.cm

@str1 = private constant [8 x i8] [i8 48, i8 120, i8 37, i8 48, i8 50, i8 88, i8 32, i8 0]
@str2 = private constant [2 x i8] [i8 10, i8 0]
@str3 = private constant [21 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 120, i8 111, i8 114, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 105, i8 110, i8 103, i8 10, i8 0]
@str4 = private constant [27 x i8] [i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]
@str5 = private constant [26 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 101, i8 110, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 97, i8 102, i8 116, i8 101, i8 114, i8 32, i8 100, i8 101, i8 99, i8 114, i8 121, i8 112, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 95, i8 109, i8 115, i8 103, i8 58, i8 32, i8 10, i8 0]



define void @xor_encrypter([0 x i8]* %buf, i32 %buflen, [0 x i8]* %key, i32 %keylen) {
    %i = alloca i32
    store i32 0, i32* %i
    %j = alloca i32
    store i32 0, i32* %j
    br label %again_1
again_1:
    %1 = load i32, i32* %i
    %2 = icmp ult i32 %1, %buflen
    br i1 %2 , label %body_1, label %break_1
body_1:
    %3 = load i32, i32* %i
    %4 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %3
    %5 = load i8, i8* %4
    %6 = load i32, i32* %j
    %7 = getelementptr inbounds [0 x i8], [0 x i8]* %key, i32 0, i32 %6
    %8 = load i8, i8* %7
    %9 = xor i8 %5, %8
    %10 = load i32, i32* %i
    %11 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %10
    store i8 %9, i8* %11
    %12 = load i32, i32* %i
    %13 = add i32 %12, 1
    store i32 %13, i32* %i
    %14 = load i32, i32* %j
    %15 = sub i32 %keylen, 1
    %16 = icmp ult i32 %14, %15
    br i1 %16 , label %then_0, label %else_0
then_0:
    %17 = load i32, i32* %j
    %18 = add i32 %17, 1
    store i32 %18, i32* %j
    br label %endif_0
else_0:
    store i32 0, i32* %j
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
    i8 zeroinitializer
]
@test_key = global [4 x i8] [
    i8 97,
    i8 98,
    i8 99,
    i8 zeroinitializer
]

define void @print_bytes([0 x i8]* %buf, i32 %len) {
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %1 = load i32, i32* %i
    %2 = icmp ult i32 %1, %len
    br i1 %2 , label %body_1, label %break_1
body_1:
    %3 = load i32, i32* %i
    %4 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %3
    %5 = load i8, i8* %4
    %6 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([8 x i8]* @str1 to [0 x i8]*), i8 %5)
    %7 = load i32, i32* %i
    %8 = add i32 %7, 1
    store i32 %8, i32* %i
    br label %again_1
break_1:
    %9 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
    ret void
}

define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*))
    %2 = bitcast [13 x i8]* @test_msg to [0 x i8]*
    %3 = bitcast [4 x i8]* @test_key to [0 x i8]*
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
    call void([0 x i8]*, i32) @print_bytes ([0 x i8]* %2, i32 12)
    ; encrypt test data
    call void([0 x i8]*, i32, [0 x i8]*, i32) @xor_encrypter ([0 x i8]* %2, i32 12, [0 x i8]* %3, i32 3)
    %5 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([26 x i8]* @str5 to [0 x i8]*))
    call void([0 x i8]*, i32) @print_bytes ([0 x i8]* %2, i32 12)
    ; decrypt test data
    call void([0 x i8]*, i32, [0 x i8]*, i32) @xor_encrypter ([0 x i8]* %2, i32 12, [0 x i8]* %3, i32 3)
    %6 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
    call void([0 x i8]*, i32) @print_bytes ([0 x i8]* %2, i32 12)
    ret i32 0
}


