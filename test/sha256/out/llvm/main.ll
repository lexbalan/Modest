
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

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)



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

; MODULE: main

; -- print includes --

%Str = type %Str8;
%Char = type i8;
%ConstChar = type %Char;
%SignedChar = type i8;
%UnsignedChar = type i8;
%Short = type i16;
%UnsignedShort = type i16;
%Int = type i32;
%UnsignedInt = type i32;
%LongInt = type i64;
%UnsignedLongInt = type i64;
%Long = type i64;
%UnsignedLong = type i64;
%LongLong = type i64;
%UnsignedLongLong = type i64;
%LongLongInt = type i64;
%UnsignedLongLongInt = type i64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SocklenT = type i32;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;

%File = type i8;
%FposT = type i8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;


declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports --

declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)

%Context = type {
	[64 x %Byte], 
	i32, 
	i64, 
	[8 x i32]
};


@initalState = constant [8 x i32] [
	i32 1779033703,
	i32 3144134277,
	i32 1013904242,
	i32 2773480762,
	i32 1359893119,
	i32 2600822924,
	i32 528734635,
	i32 1541459225
]
@k = constant [64 x i32] [
	i32 1116352408,
	i32 1899447441,
	i32 3049323471,
	i32 3921009573,
	i32 961987163,
	i32 1508970993,
	i32 2453635748,
	i32 2870763221,
	i32 3624381080,
	i32 310598401,
	i32 607225278,
	i32 1426881987,
	i32 1925078388,
	i32 2162078206,
	i32 2614888103,
	i32 3248222580,
	i32 3835390401,
	i32 4022224774,
	i32 264347078,
	i32 604807628,
	i32 770255983,
	i32 1249150122,
	i32 1555081692,
	i32 1996064986,
	i32 2554220882,
	i32 2821834349,
	i32 2952996808,
	i32 3210313671,
	i32 3336571891,
	i32 3584528711,
	i32 113926993,
	i32 338241895,
	i32 666307205,
	i32 773529912,
	i32 1294757372,
	i32 1396182291,
	i32 1695183700,
	i32 1986661051,
	i32 2177026350,
	i32 2456956037,
	i32 2730485921,
	i32 2820302411,
	i32 3259730800,
	i32 3345764771,
	i32 3516065817,
	i32 3600352804,
	i32 4094571909,
	i32 275423344,
	i32 430227734,
	i32 506948616,
	i32 659060556,
	i32 883997877,
	i32 958139571,
	i32 1322822218,
	i32 1537002063,
	i32 1747873779,
	i32 1955562222,
	i32 2024104815,
	i32 2227730452,
	i32 2361852424,
	i32 2428436474,
	i32 2756734187,
	i32 3204031479,
	i32 3329325298
]

declare i32 @rotleft(i32 %a, i32 %b)
declare i32 @rotright(i32 %a, i32 %b)
declare i32 @ch(i32 %x, i32 %y, i32 %z)
declare i32 @maj(i32 %x, i32 %y, i32 %z)
declare i32 @ep0(i32 %x)
declare i32 @ep1(i32 %x)
declare i32 @sig0(i32 %x)
declare i32 @sig1(i32 %x)
declare void @contextInit(%Context* %ctx)
declare void @transform(%Context* %ctx, [0 x %Byte]* %data)
declare void @update(%Context* %ctx, [0 x %Byte]* %msg, i32 %msgLen)
declare void @final(%Context* %ctx, %Hash* %outHash)


%Hash = type [32 x %Byte];

declare void @sha256_hash([0 x %Byte]* %msg, i32 %msgLen, %Hash* %outHash)
; -- end print imports --
; -- strings --
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
	%Hash
};


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
	%Hash [
		%Byte 186,
		%Byte 120,
		%Byte 22,
		%Byte 191,
		%Byte 143,
		%Byte 1,
		%Byte 207,
		%Byte 234,
		%Byte 65,
		%Byte 65,
		%Byte 64,
		%Byte 222,
		%Byte 93,
		%Byte 174,
		%Byte 34,
		%Byte 35,
		%Byte 176,
		%Byte 3,
		%Byte 97,
		%Byte 163,
		%Byte 150,
		%Byte 23,
		%Byte 122,
		%Byte 156,
		%Byte 180,
		%Byte 16,
		%Byte 255,
		%Byte 97,
		%Byte 242,
		%Byte 0,
		%Byte 21,
		%Byte 173
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
	%Hash [
		%Byte 127,
		%Byte 131,
		%Byte 177,
		%Byte 101,
		%Byte 127,
		%Byte 241,
		%Byte 252,
		%Byte 83,
		%Byte 185,
		%Byte 45,
		%Byte 193,
		%Byte 129,
		%Byte 72,
		%Byte 161,
		%Byte 214,
		%Byte 93,
		%Byte 252,
		%Byte 45,
		%Byte 75,
		%Byte 31,
		%Byte 163,
		%Byte 214,
		%Byte 119,
		%Byte 40,
		%Byte 74,
		%Byte 221,
		%Byte 210,
		%Byte 0,
		%Byte 18,
		%Byte 109,
		%Byte 144,
		%Byte 105
	]
}
@tests = global [2 x %SHA256_TestCase*] 
	; cast_composite_to_composite[
	%SHA256_TestCase* @test0,
	%SHA256_TestCase* @test1
]

define i1 @doTest(%SHA256_TestCase* %test) {
	%1 = alloca %Hash, align 1
	%2 = getelementptr inbounds %SHA256_TestCase, %SHA256_TestCase* %test, i32 0, i32 0
	%3 = bitcast [32 x i8]* %2 to [0 x %Byte]*
	%4 = getelementptr inbounds %SHA256_TestCase, %SHA256_TestCase* %test, i32 0, i32 1
	%5 = load i32, i32* %4
	call void @sha256_hash([0 x %Byte]* %3, i32 %5, %Hash* %1)
	%6 = getelementptr inbounds %SHA256_TestCase, %SHA256_TestCase* %test, i32 0, i32 0
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str1 to [0 x i8]*), [32 x i8]* %6)
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str2 to [0 x i8]*))
	%9 = alloca i32, align 4
	store i32 0, i32* %9
	br label %again_1
again_1:
	%10 = load i32, i32* %9
	%11 = sext i6 32 to i32
	%12 = icmp slt i32 %10, %11
	br i1 %12 , label %body_1, label %break_1
body_1:
	%13 = load i32, i32* %9
	%14 = getelementptr inbounds %Hash, %Hash* %1, i32 0, i32 %13
	%15 = load %Byte, %Byte* %14
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str3 to [0 x i8]*), %Byte %15)
	%17 = load i32, i32* %9
	%18 = add i32 %17, 1
	store i32 %18, i32* %9
	br label %again_1
break_1:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
	%20 = getelementptr inbounds %SHA256_TestCase, %SHA256_TestCase* %test, i32 0, i32 2
	%21 = bitcast %Hash* %1 to i8*
	%22 = bitcast %Hash* %20 to i8*
	
	%23 = call i1 (i8*, i8*, i64) @memeq( i8* %21, i8* %22, i64 32)
	%24 = icmp ne i1 %23, 0
	ret i1 %24
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*))
	%2 = alloca i32, align 4
	store i32 0, i32* %2
	br label %again_1
again_1:
	%3 = load i32, i32* %2
	%4 = icmp slt i32 %3, 16
	br i1 %4 , label %body_1, label %break_1
body_1:
	%5 = load i32, i32* %2
	%6 = getelementptr inbounds [2 x %SHA256_TestCase*], [2 x %SHA256_TestCase*]* @tests, i32 0, i32 %5
	%7 = load %SHA256_TestCase*, %SHA256_TestCase** %6
	%8 = bitcast %SHA256_TestCase* %7 to %SHA256_TestCase*
	%9 = call i1 @doTest(%SHA256_TestCase* %8)
	%10 = alloca %Str8*, align 8
	store %Str8* bitcast ([7 x i8]* @str6 to [0 x i8]*), %Str8** %10
	br i1 %9 , label %then_0, label %endif_0
then_0:
	store %Str8* bitcast ([7 x i8]* @str7 to [0 x i8]*), %Str8** %10
	br label %endif_0
endif_0:
	%11 = load i32, i32* %2
	%12 = load %Str8*, %Str8** %10
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*), i32 %11, %Str8* %12)
	%14 = load i32, i32* %2
	%15 = add i32 %14, 1
	store i32 %15, i32* %2
	br label %again_1
break_1:
	ret %Int 0
}


