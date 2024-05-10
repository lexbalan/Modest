
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

%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
}


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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/sha256.hm



declare void @sha256_doHash([0 x i8]* %msg, i32 %msgLen, [32 x i8]* %outHash)


; -- SOURCE: src/main.cm

@str1 = private constant [5 x i8] [i8 39, i8 37, i8 115, i8 39, i8 0]
@str2 = private constant [5 x i8] [i8 32, i8 45, i8 62, i8 32, i8 0]
@str3 = private constant [5 x i8] [i8 37, i8 48, i8 50, i8 88, i8 0]
@str4 = private constant [2 x i8] [i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 83, i8 72, i8 65, i8 50, i8 53, i8 54, i8 10, i8 0]
@str6 = private constant [7 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 0]
@str7 = private constant [7 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 0]
@str8 = private constant [14 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 35, i8 37, i8 105, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]




%SHA256_TestCase = type {
	[32 x i8], 
	i32, 
	[32 x i8]
}


@test0 = global %SHA256_TestCase {
	[32 x i8] [
		i8 97,
		i8 98,
		i8 99,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0
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
@test1 = global %SHA256_TestCase {
	[32 x i8] [
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
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0,
		i8 0
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
@sha256_tests = global [2 x %SHA256_TestCase*] [
	%SHA256_TestCase* @test0,
	%SHA256_TestCase* @test1
]

define i1 @sha256_doTest(%SHA256_TestCase* %test) {
	%1 = alloca [32 x i8]
	%2 = getelementptr inbounds %SHA256_TestCase, %SHA256_TestCase* %test, i32 0, i32 0
	%3 = bitcast [32 x i8]* %2 to [0 x i8]*
	%4 = getelementptr inbounds %SHA256_TestCase, %SHA256_TestCase* %test, i32 0, i32 1
	%5 = load i32, i32* %4
	call void ([0 x i8]*, i32, [32 x i8]*) @sha256_doHash([0 x i8]* %3, i32 %5, [32 x i8]* %1)
	%6 = getelementptr inbounds %SHA256_TestCase, %SHA256_TestCase* %test, i32 0, i32 0
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str1 to [0 x i8]*), [32 x i8]* %6)
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str2 to [0 x i8]*))
	%9 = alloca i32
	store i32 0, i32* %9
	br label %again_1
again_1:
	%10 = load i32, i32* %9
	%11 = icmp slt i32 %10, 32
	br i1 %11 , label %body_1, label %break_1
body_1:
	%12 = load i32, i32* %9
	%13 = getelementptr inbounds [32 x i8], [32 x i8]* %1, i32 0, i32 %12
	%14 = load i8, i8* %13
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str3 to [0 x i8]*), i8 %14)
	%16 = load i32, i32* %9
	%17 = add i32 %16, 1
	store i32 %17, i32* %9
	br label %again_1
break_1:
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
	%19 = getelementptr inbounds %SHA256_TestCase, %SHA256_TestCase* %test, i32 0, i32 2
	%20 = bitcast [32 x i8]* %1 to i8*
	%21 = bitcast [32 x i8]* %19 to i8*
	
	%22 = call i1 (i8*, i8*, i64) @memeq( i8* %20, i8* %21, i64 32)
	%23 = icmp ne i1 %22, 0
	ret i1 %23
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*))
	%2 = alloca i32
	store i32 0, i32* %2
	br label %again_1
again_1:
	%3 = load i32, i32* %2
	%4 = icmp slt i32 %3, 2
	br i1 %4 , label %body_1, label %break_1
body_1:
	%5 = load i32, i32* %2
	%6 = getelementptr inbounds [2 x %SHA256_TestCase*], [2 x %SHA256_TestCase*]* @sha256_tests, i32 0, i32 %5
	%7 = load %SHA256_TestCase*, %SHA256_TestCase** %6
	%8 = call i1 (%SHA256_TestCase*) @sha256_doTest(%SHA256_TestCase* %7)
	%9 = alloca %Str8*
	store %Str8* bitcast ([7 x i8]* @str6 to [0 x i8]*), %Str8** %9
	br i1 %8 , label %then_0, label %endif_0
then_0:
	store %Str8* bitcast ([7 x i8]* @str7 to [0 x i8]*), %Str8** %9
	br label %endif_0
endif_0:
	%10 = load i32, i32* %2
	%11 = load %Str8*, %Str8** %9
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*), i32 %10, %Str8* %11)
	%13 = load i32, i32* %2
	%14 = add i32 %13, 1
	store i32 %14, i32* %2
	br label %again_1
break_1:
	ret %Int 0
}


