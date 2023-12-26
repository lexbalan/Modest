
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*); -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/sha256.hm



declare void @sha256_doHash([0 x i8]*, i32, [0 x i8]*)

; -- SOURCE: src/main.cm

@str1 = private constant [5 x i8] [i8 39, i8 37, i8 115, i8 39, i8 0]
@str2 = private constant [5 x i8] [i8 32, i8 45, i8 62, i8 32, i8 0]
@str3 = private constant [5 x i8] [i8 37, i8 48, i8 50, i8 88, i8 0]
@str4 = private constant [2 x i8] [i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 83, i8 72, i8 65, i8 50, i8 53, i8 54, i8 10, i8 0]
@str6 = private constant [17 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 100, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str7 = private constant [17 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 100, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]



%TestInputString = type [32 x i8]
%SHA256_TestData = type {
	%TestInputString,
	i32,
	[32 x i8]
}


@test0 = global %SHA256_TestData {
    %TestInputString [
        i8 97,
        i8 98,
        i8 99,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer
    ],
    i32 3,
    [32 x i8] [
        i8 186,
        i8 120,
        i8 22,
        i8 191,
        i8 143,
        i8 1,
        i8 207,
        i8 234,
        i8 65,
        i8 65,
        i8 64,
        i8 222,
        i8 93,
        i8 174,
        i8 34,
        i8 35,
        i8 176,
        i8 3,
        i8 97,
        i8 163,
        i8 150,
        i8 23,
        i8 122,
        i8 156,
        i8 180,
        i8 16,
        i8 255,
        i8 97,
        i8 242,
        i8 0,
        i8 21,
        i8 173
    ]
}
@test1 = global %SHA256_TestData {
    %TestInputString [
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
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer,
        i8 zeroinitializer
    ],
    i32 12,
    [32 x i8] [
        i8 127,
        i8 131,
        i8 177,
        i8 101,
        i8 127,
        i8 241,
        i8 252,
        i8 83,
        i8 185,
        i8 45,
        i8 193,
        i8 129,
        i8 72,
        i8 161,
        i8 214,
        i8 93,
        i8 252,
        i8 45,
        i8 75,
        i8 31,
        i8 163,
        i8 214,
        i8 119,
        i8 40,
        i8 74,
        i8 221,
        i8 210,
        i8 0,
        i8 18,
        i8 109,
        i8 144,
        i8 105
    ]
}


@sha256_tests = global [2 x %SHA256_TestData*] [
    %SHA256_TestData* @test0,
    %SHA256_TestData* @test1
]

define i1 @sha256_doTest(%SHA256_TestData* %test) {
    %test_hash = alloca [32 x i8]
    %1 = getelementptr inbounds %SHA256_TestData, %SHA256_TestData* %test, i32 0, i32 0
    %2 = bitcast %TestInputString* %1 to [0 x i8]*
    %3 = getelementptr inbounds %SHA256_TestData, %SHA256_TestData* %test, i32 0, i32 1
    %4 = load i32, i32* %3
    %5 = bitcast [32 x i8]* %test_hash to [0 x i8]*
    call void([0 x i8]*, i32, [0 x i8]*) @sha256_doHash ([0 x i8]* %2, i32 %4, [0 x i8]* %5)
    %6 = getelementptr inbounds %SHA256_TestData, %SHA256_TestData* %test, i32 0, i32 0
    %7 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([5 x i8]* @str1 to [0 x i8]*), %TestInputString* %6)
    %8 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([5 x i8]* @str2 to [0 x i8]*))
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %9 = load i32, i32* %i
    %10 = icmp slt i32 %9, 32
    br i1 %10 , label %body_1, label %break_1
body_1:
    %11 = load i32, i32* %i
    %12 = getelementptr inbounds [32 x i8], [32 x i8]* %test_hash, i32 0, i32 %11
    %13 = load i8, i8* %12
    %14 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([5 x i8]* @str3 to [0 x i8]*), i8 %13)
    %15 = load i32, i32* %i
    %16 = add i32 %15, 1
    store i32 %16, i32* %i
    br label %again_1
break_1:
    %17 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
    %18 = getelementptr inbounds %SHA256_TestData, %SHA256_TestData* %test, i32 0, i32 2
    %19 = bitcast [32 x i8]* %18 to i8*
    %20 = bitcast [32 x i8]* %test_hash to i8*
    %21 = call i32(i8*, i8*, i64) @memcmp (i8* %19, i8* %20, i64 32)
    %22 = icmp eq i32 %21, 0
    ret i1 %22
}

define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*))
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %2 = load i32, i32* %i
    %3 = icmp slt i32 %2, 2
    br i1 %3 , label %body_1, label %break_1
body_1:
    %4 = load i32, i32* %i
    %5 = getelementptr inbounds [2 x %SHA256_TestData*], [2 x %SHA256_TestData*]* @sha256_tests, i32 0, i32 %4
    %6 = load %SHA256_TestData*, %SHA256_TestData** %5
    %7 = bitcast %SHA256_TestData* %6 to %SHA256_TestData*
    %8 = call i1(%SHA256_TestData*) @sha256_doTest (%SHA256_TestData* %7)
    br i1 %8 , label %then_0, label %else_0
then_0:
    %9 = load i32, i32* %i
    %10 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str6 to [0 x i8]*), i32 %9)
    br label %endif_0
else_0:
    %11 = load i32, i32* %i
    %12 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str7 to [0 x i8]*), i32 %11)
    br label %endif_0
endif_0:
    %13 = load i32, i32* %i
    %14 = add i32 %13, 1
    store i32 %14, i32* %i
    br label %again_1
break_1:
    ret i32 0
}


