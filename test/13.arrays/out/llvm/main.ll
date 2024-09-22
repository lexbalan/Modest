
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


declare %Double @acos(%Double %x)
declare %Double @asin(%Double %x)
declare %Double @atan(%Double %x)
declare %Double @atan2(%Double %a, %Double %b)
declare %Double @cos(%Double %x)
declare %Double @sin(%Double %x)
declare %Double @tan(%Double %x)
declare %Double @cosh(%Double %x)
declare %Double @sinh(%Double %x)
declare %Double @tanh(%Double %x)
declare %Double @exp(%Double %x)
declare %Double @frexp(%Double %a, %Int* %i)
declare %Double @ldexp(%Double %a, %Int %i)
declare %Double @log(%Double %x)
declare %Double @log10(%Double %x)
declare %Double @modf(%Double %a, %Double* %b)
declare %Double @pow(%Double %a, %Double %b)
declare %Double @sqrt(%Double %x)
declare %Double @ceil(%Double %x)
declare %Double @fabs(%Double %x)
declare %Double @floor(%Double %x)
declare %Double @fmod(%Double %a, %Double %b)
declare %LongDouble @acosl(%LongDouble %x)
declare %LongDouble @asinl(%LongDouble %x)
declare %LongDouble @atanl(%LongDouble %x)
declare %LongDouble @atan2l(%LongDouble %a, %LongDouble %b)
declare %LongDouble @cosl(%LongDouble %x)
declare %LongDouble @sinl(%LongDouble %x)
declare %LongDouble @tanl(%LongDouble %x)
declare %LongDouble @acoshl(%LongDouble %x)
declare %LongDouble @asinhl(%LongDouble %x)
declare %LongDouble @atanhl(%LongDouble %x)
declare %LongDouble @coshl(%LongDouble %x)
declare %LongDouble @sinhl(%LongDouble %x)
declare %LongDouble @tanhl(%LongDouble %x)
declare %LongDouble @expl(%LongDouble %x)
declare %LongDouble @exp2l(%LongDouble %x)
declare %LongDouble @expm1l(%LongDouble %x)
declare %LongDouble @frexpl(%LongDouble %a, %Int* %i)
declare %Int @ilogbl(%LongDouble %x)
declare %LongDouble @ldexpl(%LongDouble %a, %Int %i)
declare %LongDouble @logl(%LongDouble %x)
declare %LongDouble @log10l(%LongDouble %x)
declare %LongDouble @log1pl(%LongDouble %x)
declare %LongDouble @log2l(%LongDouble %x)
declare %LongDouble @logbl(%LongDouble %x)
declare %LongDouble @modfl(%LongDouble %a, %LongDouble* %b)
declare %LongDouble @scalbnl(%LongDouble %a, %Int %i)
declare %LongDouble @scalblnl(%LongDouble %a, %LongInt %i)
declare %LongDouble @cbrtl(%LongDouble %x)
declare %LongDouble @fabsl(%LongDouble %x)
declare %LongDouble @hypotl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @powl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @sqrtl(%LongDouble %x)
declare %LongDouble @erfl(%LongDouble %x)
declare %LongDouble @erfcl(%LongDouble %x)
declare %LongDouble @lgammal(%LongDouble %x)
declare %LongDouble @tgammal(%LongDouble %x)
declare %LongDouble @ceill(%LongDouble %x)
declare %LongDouble @floorl(%LongDouble %x)
declare %LongDouble @nearbyintl(%LongDouble %x)
declare %LongDouble @rintl(%LongDouble %x)
declare %LongInt @lrintl(%LongDouble %x)
declare %LongLongInt @llrintl(%LongDouble %x)
declare %LongDouble @roundl(%LongDouble %x)
declare %LongInt @lroundl(%LongDouble %x)
declare %LongLongInt @llroundl(%LongDouble %x)
declare %LongDouble @truncl(%LongDouble %x)
declare %LongDouble @fmodl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @remainderl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @remquol(%LongDouble %a, %LongDouble %b, %Int* %i)
declare %LongDouble @copysignl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @nanl(%ConstChar* %x)
declare %LongDouble @nextafterl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @nexttowardl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fdiml(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fmaxl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fminl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fmal(%LongDouble %a, %LongDouble %b, %LongDouble %c)
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
@str1 = private constant [10 x i8] [i8 102, i8 48, i8 40, i8 34, i8 37, i8 115, i8 34, i8 41, i8 10, i8 0]
@str2 = private constant [15 x i8] [i8 102, i8 48, i8 32, i8 109, i8 105, i8 99, i8 32, i8 61, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@str3 = private constant [9 x i8] [i8 101, i8 109, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str4 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str5 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str6 = private constant [21 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str8 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str10 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [11 x i8] [i8 97, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str12 = private constant [11 x i8] [i8 97, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [11 x i8] [i8 97, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str14 = private constant [11 x i8] [i8 98, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str15 = private constant [11 x i8] [i8 98, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str16 = private constant [11 x i8] [i8 98, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str17 = private constant [8 x i8] [i8 97, i8 32, i8 61, i8 61, i8 32, i8 98, i8 10, i8 0]
@str18 = private constant [8 x i8] [i8 97, i8 32, i8 33, i8 61, i8 32, i8 98, i8 10, i8 0]
@str19 = private constant [11 x i8] [i8 100, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str20 = private constant [11 x i8] [i8 100, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str21 = private constant [11 x i8] [i8 100, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str22 = private constant [11 x i8] [i8 100, i8 91, i8 51, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str23 = private constant [11 x i8] [i8 100, i8 91, i8 52, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str24 = private constant [11 x i8] [i8 100, i8 91, i8 53, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str25 = private constant [12 x i8] [i8 42, i8 112, i8 97, i8 32, i8 61, i8 61, i8 32, i8 42, i8 112, i8 98, i8 10, i8 0]
@str26 = private constant [12 x i8] [i8 42, i8 112, i8 97, i8 32, i8 33, i8 61, i8 32, i8 42, i8 112, i8 98, i8 10, i8 0]
@str27 = private constant [11 x i8] [i8 101, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str28 = private constant [11 x i8] [i8 101, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str29 = private constant [11 x i8] [i8 101, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str30 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str31 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str32 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str33 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 49, i8 48, i8 41, i8 10, i8 0]
@str34 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 50, i8 48, i8 41, i8 10, i8 0]
@str35 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 51, i8 48, i8 41, i8 10, i8 0]
@str36 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 52, i8 48, i8 41, i8 10, i8 0]
@str37 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str38 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str39 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str40 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]

@constantArray = constant [10 x i4] [
	i4 1,
	i4 2,
	i4 3,
	i4 4,
	i4 5,
	i4 6,
	i4 7,
	i4 8,
	i4 9,
	i4 10
]

@globalArray = global [10 x i32] [
	i32 1,
	i32 2,
	i32 3,
	i32 4,
	i32 5,
	i32 6,
	i32 7,
	i32 8,
	i32 9,
	i32 10
]
@arrayFromString = global [3 x i8] [
	i8 97,
	i8 98,
	i8 99
]

@startSequence = constant [3 x i8] [
	i8 170,
	i8 85,
	i8 2
]
@stopSequence = constant [1 x i5] [
	i5 22
]

define void @f0([30 x i8]* noalias sret([30 x i8]) %0, [20 x i8] %x) {
	%2 = alloca [20 x i8], align 1
	store [20 x i8] %x, [20 x i8]* %2
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), [20 x i8]* %2)
	; truncate array
	%4 = alloca [6 x i8], align 1
	; cast_composite_to_composite
	; trunk
	%5 = alloca [20 x i8]
	store [20 x i8] %x, [20 x i8]* %5
	%6 = bitcast [20 x i8]* %5 to [6 x i8]*
	%7 = load [6 x i8], [6 x i8]* %6
	store [6 x i8] %7, [6 x i8]* %4
	%8 = getelementptr inbounds [6 x i8], [6 x i8]* %4, i32 0, i32 5
	store i8 0, i8* %8
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), [6 x i8]* %4)
	; extend array
	%10 = alloca [30 x i8], align 1
	; cast_composite_to_composite
	; extend
	%11 = alloca [30 x i8]
	%12 = bitcast [30 x i8]* %11 to [20 x i8]*
	store [20 x i8] %x, [20 x i8]* %12
	%13 = load [30 x i8], [30 x i8]* %11
	store [30 x i8] %13, [30 x i8]* %10
	%14 = getelementptr inbounds [30 x i8], [30 x i8]* %10, i32 0, i32 6
	store i8 77, i8* %14
	%15 = getelementptr inbounds [30 x i8], [30 x i8]* %10, i32 0, i32 7
	store i8 111, i8* %15
	%16 = getelementptr inbounds [30 x i8], [30 x i8]* %10, i32 0, i32 8
	store i8 100, i8* %16
	%17 = getelementptr inbounds [30 x i8], [30 x i8]* %10, i32 0, i32 9
	store i8 101, i8* %17
	%18 = getelementptr inbounds [30 x i8], [30 x i8]* %10, i32 0, i32 10
	store i8 115, i8* %18
	%19 = getelementptr inbounds [30 x i8], [30 x i8]* %10, i32 0, i32 11
	store i8 116, i8* %19
	%20 = getelementptr inbounds [30 x i8], [30 x i8]* %10, i32 0, i32 12
	store i8 33, i8* %20
	%21 = getelementptr inbounds [30 x i8], [30 x i8]* %10, i32 0, i32 13
	store i8 0, i8* %21
	%22 = load [30 x i8], [30 x i8]* %10
	store [30 x i8] %22, [30 x i8]* %0
	ret void
}

define void @test() {
	; тестируем работу с локальным generic массивом
	%1 = alloca [6 x i8], align 1
	%2 = insertvalue [6 x i8] zeroinitializer, i8 170, 0
	%3 = insertvalue [6 x i8] %2, i8 85, 1
	%4 = insertvalue [6 x i8] %3, i8 2, 2
	%5 = insertvalue [6 x i8] %4, i8 0, 3
	%6 = insertvalue [6 x i8] %5, i8 0, 4
	%7 = insertvalue [6 x i8] %6, i8 22, 5
	store [6 x i8] %7, [6 x i8]* %1
	%8 = alloca i32, align 4
	store i32 0, i32* %8
	br label %again_1
again_1:
	%9 = load i32, i32* %8
	%10 = icmp slt i32 %9, 6
	br i1 %10 , label %body_1, label %break_1
body_1:
	%11 = load i32, i32* %8
	%12 = getelementptr inbounds [6 x i8], [6 x i8]* %1, i32 0, i32 %11
	%13 = load i8, i8* %12
	%14 = load i32, i32* %8
	%15 = add i32 %14, 1
	store i32 %15, i32* %8
	br label %again_1
break_1:
	ret void
}

define %Int @main() {
	; generic array [4]Char8 will be implicit casted to [10]Char8
	%1 = alloca [30 x i8], align 1
	%2 = insertvalue [20 x i8] zeroinitializer, i8 72, 0
	%3 = insertvalue [20 x i8] %2, i8 101, 1
	%4 = insertvalue [20 x i8] %3, i8 108, 2
	%5 = insertvalue [20 x i8] %4, i8 108, 3
	%6 = insertvalue [20 x i8] %5, i8 111, 4
	%7 = insertvalue [20 x i8] %6, i8 32, 5
	%8 = insertvalue [20 x i8] %7, i8 87, 6
	%9 = insertvalue [20 x i8] %8, i8 111, 7
	%10 = insertvalue [20 x i8] %9, i8 114, 8
	%11 = insertvalue [20 x i8] %10, i8 108, 9
	%12 = insertvalue [20 x i8] %11, i8 100, 10
	%13 = insertvalue [20 x i8] %12, i8 33, 11
	%14 = insertvalue [20 x i8] %13, i8 0, 12
	%15 = insertvalue [20 x i8] %14, i8 0, 13
	%16 = insertvalue [20 x i8] %15, i8 0, 14
	%17 = insertvalue [20 x i8] %16, i8 0, 15
	%18 = insertvalue [20 x i8] %17, i8 0, 16
	%19 = insertvalue [20 x i8] %18, i8 0, 17
	%20 = insertvalue [20 x i8] %19, i8 0, 18
	%21 = insertvalue [20 x i8] %20, i8 0, 19; alloca memory for return value
	%22 = alloca [30 x i8]
	call void @f0([30 x i8]* %22, [20 x i8] %21)
	%23 = load [30 x i8], [30 x i8]* %22
	store [30 x i8] %23, [30 x i8]* %1
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str3 to [0 x i8]*), [30 x i8]* %1)
	%25 = alloca i32, align 4
	store i32 0, i32* %25
	br label %again_1
again_1:
	%26 = load i32, i32* %25
	%27 = icmp slt i32 %26, 10
	br i1 %27 , label %body_1, label %break_1
body_1:
	%28 = load i32, i32* %25
	%29 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 %28
	%30 = load i32, i32* %29
	%31 = load i32, i32* %25
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str4 to [0 x i8]*), i32 %31, i32 %30)
	%33 = load i32, i32* %25
	%34 = add i32 %33, 1
	store i32 %34, i32* %25
	br label %again_1
break_1:
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str5 to [0 x i8]*))
	%36 = alloca [3 x i32], align 4
	%37 = insertvalue [3 x i32] zeroinitializer, i32 4, 0
	%38 = insertvalue [3 x i32] %37, i32 5, 1
	%39 = insertvalue [3 x i32] %38, i32 6, 2
	store [3 x i32] %39, [3 x i32]* %36
	store i32 0, i32* %25
	br label %again_2
again_2:
	%40 = load i32, i32* %25
	%41 = icmp slt i32 %40, 3
	br i1 %41 , label %body_2, label %break_2
body_2:
	%42 = load i32, i32* %25
	%43 = getelementptr inbounds [3 x i32], [3 x i32]* %36, i32 0, i32 %42
	%44 = load i32, i32* %43
	%45 = load i32, i32* %25
	%46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str6 to [0 x i8]*), i32 %45, i32 %44)
	%47 = load i32, i32* %25
	%48 = add i32 %47, 1
	store i32 %48, i32* %25
	br label %again_2
break_2:
	%49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str7 to [0 x i8]*))
	%50 = alloca [0 x i32]*, align 8
	%51 = bitcast [10 x i32]* @globalArray to [0 x i32]*
	store [0 x i32]* %51, [0 x i32]** %50
	store i32 0, i32* %25
	br label %again_3
again_3:
	%52 = load i32, i32* %25
	%53 = icmp slt i32 %52, 3
	br i1 %53 , label %body_3, label %break_3
body_3:
	%54 = load i32, i32* %25
	%55 = load [0 x i32]*, [0 x i32]** %50
	%56 = getelementptr inbounds [0 x i32], [0 x i32]* %55, i32 0, i32 %54
	%57 = load i32, i32* %56
	%58 = load i32, i32* %25
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str8 to [0 x i8]*), i32 %58, i32 %57)
	%60 = load i32, i32* %25
	%61 = add i32 %60, 1
	store i32 %61, i32* %25
	br label %again_3
break_3:
	%62 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str9 to [0 x i8]*))
	%63 = alloca [0 x i32]*, align 8
	%64 = bitcast [3 x i32]* %36 to [0 x i32]*
	store [0 x i32]* %64, [0 x i32]** %63
	store i32 0, i32* %25
	br label %again_4
again_4:
	%65 = load i32, i32* %25
	%66 = icmp slt i32 %65, 3
	br i1 %66 , label %body_4, label %break_4
body_4:
	%67 = load i32, i32* %25
	%68 = load [0 x i32]*, [0 x i32]** %63
	%69 = getelementptr inbounds [0 x i32], [0 x i32]* %68, i32 0, i32 %67
	%70 = load i32, i32* %69
	%71 = load i32, i32* %25
	%72 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str10 to [0 x i8]*), i32 %71, i32 %70)
	%73 = load i32, i32* %25
	%74 = add i32 %73, 1
	store i32 %74, i32* %25
	br label %again_4
break_4:
	; assign array to array 1
	; (with equal types)
	%75 = alloca [3 x i32], align 4
	%76 = insertvalue [3 x i32] zeroinitializer, i32 1, 0
	%77 = insertvalue [3 x i32] %76, i32 2, 1
	%78 = insertvalue [3 x i32] %77, i32 3, 2
	store [3 x i32] %78, [3 x i32]* %75
	%79 = getelementptr inbounds [3 x i32], [3 x i32]* %75, i32 0, i32 0
	%80 = load i32, i32* %79
	%81 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str11 to [0 x i8]*), i32 %80)
	%82 = getelementptr inbounds [3 x i32], [3 x i32]* %75, i32 0, i32 1
	%83 = load i32, i32* %82
	%84 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str12 to [0 x i8]*), i32 %83)
	%85 = getelementptr inbounds [3 x i32], [3 x i32]* %75, i32 0, i32 2
	%86 = load i32, i32* %85
	%87 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str13 to [0 x i8]*), i32 %86)
	; create (and initialize) new variable b
	; (with type [3]Int32)
	; this variable are copy of array a
	%88 = alloca [3 x i32], align 4
	%89 = load [3 x i32], [3 x i32]* %75
	store [3 x i32] %89, [3 x i32]* %88
	%90 = getelementptr inbounds [3 x i32], [3 x i32]* %88, i32 0, i32 0
	%91 = load i32, i32* %90
	%92 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str14 to [0 x i8]*), i32 %91)
	%93 = getelementptr inbounds [3 x i32], [3 x i32]* %88, i32 0, i32 1
	%94 = load i32, i32* %93
	%95 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str15 to [0 x i8]*), i32 %94)
	%96 = getelementptr inbounds [3 x i32], [3 x i32]* %88, i32 0, i32 2
	%97 = load i32, i32* %96
	%98 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str16 to [0 x i8]*), i32 %97)
	; check equality between two arrays (by value)
	%99 = bitcast [3 x i32]* %75 to i8*
	%100 = bitcast [3 x i32]* %88 to i8*
	
	%101 = call i1 (i8*, i8*, i64) @memeq( i8* %99, i8* %100, i64 12)
	%102 = icmp ne i1 %101, 0
	br i1 %102 , label %then_0, label %else_0
then_0:
	%103 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str17 to [0 x i8]*))
	br label %endif_0
else_0:
	%104 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str18 to [0 x i8]*))
	br label %endif_0
endif_0:
	; assign array to array 2
	; (with array extending)
	%105 = alloca [3 x i32], align 4
	%106 = insertvalue [3 x i32] zeroinitializer, i32 10, 0
	%107 = insertvalue [3 x i32] %106, i32 20, 1
	%108 = insertvalue [3 x i32] %107, i32 30, 2
	store [3 x i32] %108, [3 x i32]* %105
	%109 = alloca [6 x i32], align 4
	; cast_composite_to_composite
	; JUST
	; as ptr
	%110 = bitcast [3 x i32]* %105 to [6 x i32]*
	%111 = load [6 x i32], [6 x i32]* %110
	store [6 x i32] %111, [6 x i32]* %109
	%112 = getelementptr inbounds [6 x i32], [6 x i32]* %109, i32 0, i32 0
	%113 = load i32, i32* %112
	%114 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str19 to [0 x i8]*), i32 %113)
	%115 = getelementptr inbounds [6 x i32], [6 x i32]* %109, i32 0, i32 1
	%116 = load i32, i32* %115
	%117 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str20 to [0 x i8]*), i32 %116)
	%118 = getelementptr inbounds [6 x i32], [6 x i32]* %109, i32 0, i32 2
	%119 = load i32, i32* %118
	%120 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str21 to [0 x i8]*), i32 %119)
	%121 = getelementptr inbounds [6 x i32], [6 x i32]* %109, i32 0, i32 3
	%122 = load i32, i32* %121
	%123 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str22 to [0 x i8]*), i32 %122)
	%124 = getelementptr inbounds [6 x i32], [6 x i32]* %109, i32 0, i32 4
	%125 = load i32, i32* %124
	%126 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str23 to [0 x i8]*), i32 %125)
	%127 = getelementptr inbounds [6 x i32], [6 x i32]* %109, i32 0, i32 5
	%128 = load i32, i32* %127
	%129 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str24 to [0 x i8]*), i32 %128)
	; check equality between two arrays (by pointer)
	%130 = bitcast [3 x i32]* %75 to i8*
	%131 = bitcast [3 x i32]* %88 to i8*
	
	%132 = call i1 (i8*, i8*, i64) @memeq( i8* %130, i8* %131, i64 12)
	%133 = icmp ne i1 %132, 0
	br i1 %133 , label %then_1, label %else_1
then_1:
	%134 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str25 to [0 x i8]*))
	br label %endif_1
else_1:
	%135 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str26 to [0 x i8]*))
	br label %endif_1
endif_1:
	;
	; Check assination local literal array
	;
	;let aa = [111] + [222] + [333]
	; cons literal array from var items
	%136 = alloca %Int, align 4
	store %Int 100, %Int* %136
	%137 = alloca %Int, align 4
	store %Int 200, %Int* %137
	%138 = alloca %Int, align 4
	store %Int 300, %Int* %138
	; immutable, non immediate value (array)
	%139 = load %Int, %Int* %136
	%140 = load %Int, %Int* %137
	%141 = load %Int, %Int* %138
	%142 = insertvalue [3 x %Int] zeroinitializer, %Int %139, 0
	%143 = insertvalue [3 x %Int] %142, %Int %140, 1
	%144 = insertvalue [3 x %Int] %143, %Int %141, 2
	%145 = alloca [3 x %Int]
	store [3 x %Int] %144, [3 x %Int]* %145
	; check local literal array assignation to local array
	%146 = alloca [4 x i32], align 4
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%147 = zext i3 4 to i32
	; -- end vol eval --
	; cast_composite_to_composite
	; JUST
	; as ptr
	%148 = bitcast [3 x %Int]* %145 to [4 x i32]*
	%149 = load [4 x i32], [4 x i32]* %148
	store [4 x i32] %149, [4 x i32]* %146
	%150 = getelementptr inbounds [4 x i32], [4 x i32]* %146, i32 0, i32 0
	%151 = load i32, i32* %150
	%152 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str27 to [0 x i8]*), i32 %151)
	%153 = getelementptr inbounds [4 x i32], [4 x i32]* %146, i32 0, i32 1
	%154 = load i32, i32* %153
	%155 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str28 to [0 x i8]*), i32 %154)
	%156 = getelementptr inbounds [4 x i32], [4 x i32]* %146, i32 0, i32 2
	%157 = load i32, i32* %156
	%158 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str29 to [0 x i8]*), i32 %157)
	; check local literal array assignation to global array
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%159 = zext i4 10 to i32
	; -- end vol eval --
	; cast_composite_to_composite
	; JUST
	; as ptr
	%160 = bitcast [3 x %Int]* %145 to [10 x i32]*
	%161 = load [10 x i32], [10 x i32]* %160
	store [10 x i32] %161, [10 x i32]* @globalArray
	%162 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 0
	%163 = load i32, i32* %162
	%164 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str30 to [0 x i8]*), i32 0, i32 %163)
	%165 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 1
	%166 = load i32, i32* %165
	%167 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str31 to [0 x i8]*), i32 1, i32 %166)
	%168 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 2
	%169 = load i32, i32* %168
	%170 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str32 to [0 x i8]*), i32 2, i32 %169)
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%171 = zext i4 10 to i32
	; -- end vol eval --
	; -- ZERO
	%172 = mul i32 %171, 4
	%173 = bitcast [10 x i32]* @globalArray to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %173, i8 0, i32 %172, i1 0)
	; проверка того как локальная константа-массив
	; "замораживает" свои элементы
	%174 = alloca i32, align 4
	store i32 10, i32* %174
	%175 = alloca i32, align 4
	store i32 20, i32* %175
	%176 = alloca i32, align 4
	store i32 30, i32* %176
	%177 = load i32, i32* %174
	%178 = load i32, i32* %175
	%179 = load i32, i32* %176
	%180 = insertvalue [4 x i32] zeroinitializer, i32 %177, 0
	%181 = insertvalue [4 x i32] %180, i32 %178, 1
	%182 = insertvalue [4 x i32] %181, i32 %179, 2
	%183 = insertvalue [4 x i32] %182, i32 40, 3
	%184 = alloca [4 x i32]
	store [4 x i32] %183, [4 x i32]* %184
	store i32 111, i32* %174
	store i32 222, i32* %175
	store i32 333, i32* %176
	%185 = getelementptr inbounds [4 x i32], [4 x i32]* %184, i32 0, i32 0
	%186 = load i32, i32* %185
	%187 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str33 to [0 x i8]*), i32 0, i32 %186)
	%188 = getelementptr inbounds [4 x i32], [4 x i32]* %184, i32 0, i32 1
	%189 = load i32, i32* %188
	%190 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str34 to [0 x i8]*), i32 1, i32 %189)
	%191 = getelementptr inbounds [4 x i32], [4 x i32]* %184, i32 0, i32 2
	%192 = load i32, i32* %191
	%193 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str35 to [0 x i8]*), i32 2, i32 %192)
	%194 = getelementptr inbounds [4 x i32], [4 x i32]* %184, i32 0, i32 3
	%195 = load i32, i32* %194
	%196 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str36 to [0 x i8]*), i32 3, i32 %195)
	%197 = insertvalue [4 x i32] zeroinitializer, i32 10, 0
	%198 = insertvalue [4 x i32] %197, i32 20, 1
	%199 = insertvalue [4 x i32] %198, i32 30, 2
	%200 = insertvalue [4 x i32] %199, i32 40, 3
	%201 = alloca [4 x i32]
	store [4 x i32] %200, [4 x i32]* %201
	%202 = bitcast [4 x i32]* %184 to i8*
	%203 = bitcast [4 x i32]* %201 to i8*
	
	%204 = call i1 (i8*, i8*, i64) @memeq( i8* %202, i8* %203, i64 16)
	%205 = icmp ne i1 %204, 0
	br i1 %205 , label %then_2, label %else_2
then_2:
	%206 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str37 to [0 x i8]*))
	br label %endif_2
else_2:
	%207 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str38 to [0 x i8]*))
	br label %endif_2
endif_2:
	%208 = insertvalue [5 x i8] zeroinitializer, i8 76, 0
	%209 = insertvalue [5 x i8] %208, i8 111, 1
	%210 = insertvalue [5 x i8] %209, i8 72, 2
	%211 = insertvalue [5 x i8] %210, i8 105, 3
	%212 = insertvalue [5 x i8] %211, i8 33, 4
	%213 = alloca [5 x i8]
	store [5 x i8] %212, [5 x i8]* %213
	%214 = getelementptr inbounds [5 x i8], [5 x i8]* %213, i32 0, i2 2
	%215 = bitcast i8* %214 to [2 x i8]*
	%216 = insertvalue [2 x i8] zeroinitializer, i8 72, 0
	%217 = insertvalue [2 x i8] %216, i8 105, 1
	%218 = alloca [2 x i8]
	store [2 x i8] %217, [2 x i8]* %218
	%219 = bitcast [2 x i8]* %215 to i8*
	%220 = bitcast [2 x i8]* %218 to i8*
	
	%221 = call i1 (i8*, i8*, i64) @memeq( i8* %219, i8* %220, i64 2)
	%222 = icmp ne i1 %221, 0
	br i1 %222 , label %then_3, label %else_3
then_3:
	%223 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str39 to [0 x i8]*))
	br label %endif_3
else_3:
	%224 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str40 to [0 x i8]*))
	br label %endif_3
endif_3:
	ret %Int 0
}


