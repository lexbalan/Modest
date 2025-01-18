
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
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
%__VA_List = type i8*
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
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
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
; from included math
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
@str3 = private constant [13 x i8] [i8 121, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str4 = private constant [18 x i8] [i8 97, i8 49, i8 48, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [21 x i8] [i8 97, i8 51, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [17 x i8] [i8 97, i8 51, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [21 x i8] [i8 97, i8 51, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [21 x i8] [i8 112, i8 48, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str9 = private constant [9 x i8] [i8 101, i8 109, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str10 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str12 = private constant [21 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str14 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str15 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str16 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str17 = private constant [11 x i8] [i8 97, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str18 = private constant [11 x i8] [i8 97, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str19 = private constant [11 x i8] [i8 97, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str20 = private constant [11 x i8] [i8 98, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str21 = private constant [11 x i8] [i8 98, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str22 = private constant [11 x i8] [i8 98, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str23 = private constant [8 x i8] [i8 97, i8 32, i8 61, i8 61, i8 32, i8 98, i8 10, i8 0]
@str24 = private constant [8 x i8] [i8 97, i8 32, i8 33, i8 61, i8 32, i8 98, i8 10, i8 0]
@str25 = private constant [11 x i8] [i8 100, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str26 = private constant [11 x i8] [i8 100, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str27 = private constant [11 x i8] [i8 100, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str28 = private constant [11 x i8] [i8 100, i8 91, i8 51, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str29 = private constant [11 x i8] [i8 100, i8 91, i8 52, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str30 = private constant [11 x i8] [i8 100, i8 91, i8 53, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str31 = private constant [12 x i8] [i8 42, i8 112, i8 97, i8 32, i8 61, i8 61, i8 32, i8 42, i8 112, i8 98, i8 10, i8 0]
@str32 = private constant [12 x i8] [i8 42, i8 112, i8 97, i8 32, i8 33, i8 61, i8 32, i8 42, i8 112, i8 98, i8 10, i8 0]
@str33 = private constant [11 x i8] [i8 101, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str34 = private constant [11 x i8] [i8 101, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str35 = private constant [11 x i8] [i8 101, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str36 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str37 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str38 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str39 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 49, i8 48, i8 41, i8 10, i8 0]
@str40 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 50, i8 48, i8 41, i8 10, i8 0]
@str41 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 51, i8 48, i8 41, i8 10, i8 0]
@str42 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 52, i8 48, i8 41, i8 10, i8 0]
@str43 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str44 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str45 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str46 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --

;@attribute("c_no_print")
;import "misc/minmax"
;$pragma c_include "./minmax.h"
@constantArray = constant [10 x i8] [
	i8 1,
	i8 2,
	i8 3,
	i8 4,
	i8 5,
	i8 6,
	i8 7,
	i8 8,
	i8 9,
	i8 10
]
@globalArray = internal global [10 x %Int32] [
	%Int32 1,
	%Int32 2,
	%Int32 3,
	%Int32 4,
	%Int32 5,
	%Int32 6,
	%Int32 7,
	%Int32 8,
	%Int32 9,
	%Int32 10
]
@arrayFromString = internal global [3 x %Char8] [
	%Char8 97,
	%Char8 98,
	%Char8 99
]


;var arrayOfChars = [Char8 "a", 'b', 'c']
define internal void @f0([30 x %Char8]* %0, [20 x %Char8] %__x) {
	%x = alloca [20 x %Char8]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%2 = zext i8 20 to %Int32
	; -- end vol eval --
	store [20 x %Char8] %__x, [20 x %Char8]* %x
	%3 = mul i8 20, 1  ; calc VLA item size
	%4 = alloca [20 x %Char8], align 1
	%5 = load [20 x %Char8], [20 x %Char8]* %x
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%6 = zext i8 20 to %Int32
	; -- end vol eval --
	store [20 x %Char8] %5, [20 x %Char8]* %4
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), [20 x %Char8]* %4)

	; truncate array
	%8 = mul i8 6, 1  ; calc VLA item size
	%9 = alloca [6 x %Char8], align 1
; -- cons_composite_from_composite_by_adr --
	%10 = bitcast [20 x %Char8]* %x to [6 x %Char8]*
	%11 = load [6 x %Char8], [6 x %Char8]* %10
; -- end cons_composite_from_composite_by_adr --
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%12 = zext i8 6 to %Int32
	; -- end vol eval --
	store [6 x %Char8] %11, [6 x %Char8]* %9
	%13 = getelementptr [6 x %Char8], [6 x %Char8]* %9, %Int32 0, %Int32 5
	store %Char8 0, %Char8* %13
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), [6 x %Char8]* %9)

	; extend array
	%15 = mul i8 30, 1  ; calc VLA item size
	%16 = alloca [30 x %Char8], align 1
; -- cons_composite_from_composite_by_adr --
	%17 = bitcast [20 x %Char8]* %x to [30 x %Char8]*
	%18 = load [30 x %Char8], [30 x %Char8]* %17
; -- end cons_composite_from_composite_by_adr --
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%19 = zext i8 30 to %Int32
	; -- end vol eval --
	store [30 x %Char8] %18, [30 x %Char8]* %16
	%20 = getelementptr [30 x %Char8], [30 x %Char8]* %16, %Int32 0, %Int32 6
	store %Char8 77, %Char8* %20
	%21 = getelementptr [30 x %Char8], [30 x %Char8]* %16, %Int32 0, %Int32 7
	store %Char8 111, %Char8* %21
	%22 = getelementptr [30 x %Char8], [30 x %Char8]* %16, %Int32 0, %Int32 8
	store %Char8 100, %Char8* %22
	%23 = getelementptr [30 x %Char8], [30 x %Char8]* %16, %Int32 0, %Int32 9
	store %Char8 101, %Char8* %23
	%24 = getelementptr [30 x %Char8], [30 x %Char8]* %16, %Int32 0, %Int32 10
	store %Char8 115, %Char8* %24
	%25 = getelementptr [30 x %Char8], [30 x %Char8]* %16, %Int32 0, %Int32 11
	store %Char8 116, %Char8* %25
	%26 = getelementptr [30 x %Char8], [30 x %Char8]* %16, %Int32 0, %Int32 12
	store %Char8 33, %Char8* %26
	%27 = getelementptr [30 x %Char8], [30 x %Char8]* %16, %Int32 0, %Int32 13
	store %Char8 0, %Char8* %27
	%28 = load [30 x %Char8], [30 x %Char8]* %16
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%29 = zext i8 30 to %Int32
	; -- end vol eval --
	store [30 x %Char8] %28, [30 x %Char8]* %0
	ret void
}

@startSequence = constant [3 x i8] [
	i8 170,
	i8 85,
	i8 2
]
@stopSequence = constant [1 x i8] [
	i8 22
]
define internal void @test() {
	; тестируем работу с локальным generic массивом
	%1 = mul i8 6, 1  ; calc VLA item size
	%2 = alloca [6 x %Int32], align 1
	%3 = insertvalue [6 x %Int32] zeroinitializer, %Int32 170, 0
	%4 = insertvalue [6 x %Int32] %3, %Int32 85, 1
	%5 = insertvalue [6 x %Int32] %4, %Int32 2, 2
	%6 = insertvalue [6 x %Int32] %5, %Int32 22, 5
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%7 = zext i8 6 to %Int32
	; -- end vol eval --
	store [6 x %Int32] %6, [6 x %Int32]* %2
	%8 = alloca %Int32, align 4
	store %Int32 0, %Int32* %8
	br label %again_1
again_1:
	%9 = load %Int32, %Int32* %8
	%10 = icmp slt %Int32 %9, 6
	br %Bool %10 , label %body_1, label %break_1
body_1:
	%11 = load %Int32, %Int32* %8
	%12 = getelementptr [6 x %Int32], [6 x %Int32]* %2, %Int32 0, %Int32 %11
	%13 = load %Int32, %Int32* %12
	%14 = load %Int32, %Int32* %8
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), %Int32 %14, %Int32 %13)
	%16 = load %Int32, %Int32* %8
	%17 = add %Int32 %16, 1
	store %Int32 %17, %Int32* %8
	br label %again_1
break_1:
	ret void
}

@a0 = internal global [2 x [2 x [5 x %Int32]]] [
	[2 x [5 x %Int32]] [
		[5 x %Int32] [
			%Int32 0,
			%Int32 1,
			%Int32 2,
			%Int32 3,
			%Int32 4
		],
		[5 x %Int32] [
			%Int32 5,
			%Int32 6,
			%Int32 7,
			%Int32 8,
			%Int32 9
		]
	],
	[2 x [5 x %Int32]] [
		[5 x %Int32] [
			%Int32 10,
			%Int32 11,
			%Int32 12,
			%Int32 13,
			%Int32 14
		],
		[5 x %Int32] [
			%Int32 15,
			%Int32 16,
			%Int32 17,
			%Int32 18,
			%Int32 19
		]
	]
]
@a1 = internal global [5 x %Int32] [
	%Int32 0,
	%Int32 1,
	%Int32 2,
	%Int32 3,
	%Int32 4
]
@a2 = internal global [5 x %Int32] [
	%Int32 5,
	%Int32 6,
	%Int32 7,
	%Int32 8,
	%Int32 9
]
@a3 = internal global [2 x [5 x %Int32]*] [
	[5 x %Int32]* @a1,
	[5 x %Int32]* @a2
]
@a4 = internal global [2 x [2 x [5 x %Int32]*]*] [
	[2 x [5 x %Int32]*]* @a3,
	[2 x [5 x %Int32]*]* @a3
]
@p0 = internal global [2 x [2 x [5 x %Int32]*]*]* @a4
@a10 = internal global [10 x [10 x %Int32]] [
	[10 x %Int32] [
		%Int32 1,
		%Int32 2,
		%Int32 3,
		%Int32 4,
		%Int32 5,
		%Int32 6,
		%Int32 7,
		%Int32 8,
		%Int32 9,
		%Int32 10
	],
	[10 x %Int32] [
		%Int32 11,
		%Int32 12,
		%Int32 13,
		%Int32 14,
		%Int32 15,
		%Int32 16,
		%Int32 17,
		%Int32 18,
		%Int32 19,
		%Int32 20
	],
	[10 x %Int32] [
		%Int32 21,
		%Int32 22,
		%Int32 23,
		%Int32 24,
		%Int32 25,
		%Int32 26,
		%Int32 27,
		%Int32 28,
		%Int32 29,
		%Int32 30
	],
	[10 x %Int32] [
		%Int32 31,
		%Int32 32,
		%Int32 33,
		%Int32 34,
		%Int32 35,
		%Int32 36,
		%Int32 37,
		%Int32 38,
		%Int32 39,
		%Int32 40
	],
	[10 x %Int32] [
		%Int32 41,
		%Int32 42,
		%Int32 43,
		%Int32 44,
		%Int32 45,
		%Int32 46,
		%Int32 47,
		%Int32 48,
		%Int32 49,
		%Int32 50
	],
	[10 x %Int32] [
		%Int32 51,
		%Int32 52,
		%Int32 53,
		%Int32 54,
		%Int32 55,
		%Int32 56,
		%Int32 57,
		%Int32 58,
		%Int32 59,
		%Int32 60
	],
	[10 x %Int32] [
		%Int32 61,
		%Int32 62,
		%Int32 63,
		%Int32 64,
		%Int32 65,
		%Int32 66,
		%Int32 67,
		%Int32 68,
		%Int32 69,
		%Int32 70
	],
	[10 x %Int32] [
		%Int32 71,
		%Int32 72,
		%Int32 73,
		%Int32 74,
		%Int32 75,
		%Int32 76,
		%Int32 77,
		%Int32 78,
		%Int32 79,
		%Int32 80
	],
	[10 x %Int32] [
		%Int32 81,
		%Int32 82,
		%Int32 83,
		%Int32 84,
		%Int32 85,
		%Int32 86,
		%Int32 87,
		%Int32 88,
		%Int32 89,
		%Int32 90
	],
	[10 x %Int32] [
		%Int32 91,
		%Int32 92,
		%Int32 93,
		%Int32 94,
		%Int32 95,
		%Int32 96,
		%Int32 97,
		%Int32 98,
		%Int32 99,
		%Int32 100
	]
]
define internal void @test_arrays() {
	%1 = alloca %Int32, align 4
	%2 = alloca %Int32, align 4
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%4 = load %Int32, %Int32* %1
	%5 = icmp slt %Int32 %4, 10
	br %Bool %5 , label %body_1, label %break_1
body_1:
	store %Int32 0, %Int32* %2
	br label %again_2
again_2:
	%6 = load %Int32, %Int32* %2
	%7 = icmp slt %Int32 %6, 10
	br %Bool %7 , label %body_2, label %break_2
body_2:
	%8 = load %Int32, %Int32* %2
	%9 = load %Int32, %Int32* %1
	%10 = getelementptr [10 x [10 x %Int32]], [10 x [10 x %Int32]]* @a10, %Int32 0, %Int32 %9, %Int32 %8
	%11 = load %Int32, %Int32* %2
	%12 = load %Int32, %Int32* %1
	%13 = getelementptr [10 x [10 x %Int32]], [10 x [10 x %Int32]]* @a10, %Int32 0, %Int32 %12, %Int32 %11
	%14 = load %Int32, %Int32* %13
	%15 = mul %Int32 %14, 2
	store %Int32 %15, %Int32* %10
	%16 = load %Int32, %Int32* %2
	%17 = add %Int32 %16, 1
	store %Int32 %17, %Int32* %2
	br label %again_2
break_2:
	%18 = load %Int32, %Int32* %1
	%19 = add %Int32 %18, 1
	store %Int32 %19, %Int32* %1
	br label %again_1
break_1:
	store %Int32 0, %Int32* %1
	br label %again_3
again_3:
	%20 = load %Int32, %Int32* %1
	%21 = icmp slt %Int32 %20, 10
	br %Bool %21 , label %body_3, label %break_3
body_3:
	store %Int32 0, %Int32* %2
	br label %again_4
again_4:
	%22 = load %Int32, %Int32* %2
	%23 = icmp slt %Int32 %22, 10
	br %Bool %23 , label %body_4, label %break_4
body_4:
	%24 = load %Int32, %Int32* %1
	%25 = load %Int32, %Int32* %2
	%26 = load %Int32, %Int32* %2
	%27 = load %Int32, %Int32* %1
	%28 = getelementptr [10 x [10 x %Int32]], [10 x [10 x %Int32]]* @a10, %Int32 0, %Int32 %27, %Int32 %26
	%29 = load %Int32, %Int32* %28
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str4 to [0 x i8]*), %Int32 %24, %Int32 %25, %Int32 %29)
	%31 = load %Int32, %Int32* %2
	%32 = add %Int32 %31, 1
	store %Int32 %32, %Int32* %2
	br label %again_4
break_4:
	%33 = load %Int32, %Int32* %1
	%34 = add %Int32 %33, 1
	store %Int32 %34, %Int32* %1
	br label %again_3
break_3:
	store %Int32 0, %Int32* %1
	br label %again_5
again_5:
	%35 = load %Int32, %Int32* %1
	%36 = icmp slt %Int32 %35, 2
	br %Bool %36 , label %body_5, label %break_5
body_5:
	store %Int32 0, %Int32* %2
	br label %again_6
again_6:
	%37 = load %Int32, %Int32* %2
	%38 = icmp slt %Int32 %37, 2
	br %Bool %38 , label %body_6, label %break_6
body_6:
	store %Int32 0, %Int32* %3
	br label %again_7
again_7:
	%39 = load %Int32, %Int32* %3
	%40 = icmp slt %Int32 %39, 5
	br %Bool %40 , label %body_7, label %break_7
body_7:
	%41 = load %Int32, %Int32* %1
	%42 = load %Int32, %Int32* %2
	%43 = load %Int32, %Int32* %3
	%44 = load %Int32, %Int32* %3
	%45 = load %Int32, %Int32* %2
	%46 = load %Int32, %Int32* %1
	%47 = getelementptr [2 x [2 x [5 x %Int32]]], [2 x [2 x [5 x %Int32]]]* @a0, %Int32 0, %Int32 %46, %Int32 %45, %Int32 %44
	%48 = load %Int32, %Int32* %47
	%49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*), %Int32 %41, %Int32 %42, %Int32 %43, %Int32 %48)
	%50 = load %Int32, %Int32* %3
	%51 = add %Int32 %50, 1
	store %Int32 %51, %Int32* %3
	br label %again_7
break_7:
	%52 = load %Int32, %Int32* %2
	%53 = add %Int32 %52, 1
	store %Int32 %53, %Int32* %2
	br label %again_6
break_6:
	%54 = load %Int32, %Int32* %1
	%55 = add %Int32 %54, 1
	store %Int32 %55, %Int32* %1
	br label %again_5
break_5:
	;
	;
	store %Int32 0, %Int32* %1
	br label %again_8
again_8:
	%56 = load %Int32, %Int32* %1
	%57 = icmp slt %Int32 %56, 2
	br %Bool %57 , label %body_8, label %break_8
body_8:
	store %Int32 0, %Int32* %2
	br label %again_9
again_9:
	%58 = load %Int32, %Int32* %2
	%59 = icmp slt %Int32 %58, 5
	br %Bool %59 , label %body_9, label %break_9
body_9:
	%60 = load %Int32, %Int32* %1
	%61 = load %Int32, %Int32* %2
	%62 = load %Int32, %Int32* %2
	%63 = load %Int32, %Int32* %1
	%64 = getelementptr [2 x [5 x %Int32]*], [2 x [5 x %Int32]*]* @a3, %Int32 0, %Int32 %63
	%65 = load [5 x %Int32]*, [5 x %Int32]** %64
	%66 = getelementptr [5 x %Int32], [5 x %Int32]* %65, %Int32 0, %Int32 %62
	%67 = load %Int32, %Int32* %66
	%68 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str6 to [0 x i8]*), %Int32 %60, %Int32 %61, %Int32 %67)
	%69 = load %Int32, %Int32* %2
	%70 = add %Int32 %69, 1
	store %Int32 %70, %Int32* %2
	br label %again_9
break_9:
	%71 = load %Int32, %Int32* %1
	%72 = add %Int32 %71, 1
	store %Int32 %72, %Int32* %1
	br label %again_8
break_8:
	;
	;
	store %Int32 0, %Int32* %1
	br label %again_10
again_10:
	%73 = load %Int32, %Int32* %1
	%74 = icmp slt %Int32 %73, 2
	br %Bool %74 , label %body_10, label %break_10
body_10:
	store %Int32 0, %Int32* %2
	br label %again_11
again_11:
	%75 = load %Int32, %Int32* %2
	%76 = icmp slt %Int32 %75, 2
	br %Bool %76 , label %body_11, label %break_11
body_11:
	store %Int32 0, %Int32* %3
	br label %again_12
again_12:
	%77 = load %Int32, %Int32* %3
	%78 = icmp slt %Int32 %77, 5
	br %Bool %78 , label %body_12, label %break_12
body_12:
	%79 = load %Int32, %Int32* %1
	%80 = load %Int32, %Int32* %2
	%81 = load %Int32, %Int32* %3
	%82 = load %Int32, %Int32* %3
	%83 = load %Int32, %Int32* %2
	%84 = load %Int32, %Int32* %1
	%85 = getelementptr [2 x [2 x [5 x %Int32]*]*], [2 x [2 x [5 x %Int32]*]*]* @a4, %Int32 0, %Int32 %84
	%86 = load [2 x [5 x %Int32]*]*, [2 x [5 x %Int32]*]** %85
	%87 = getelementptr [2 x [5 x %Int32]*], [2 x [5 x %Int32]*]* %86, %Int32 0, %Int32 %83
	%88 = load [5 x %Int32]*, [5 x %Int32]** %87
	%89 = getelementptr [5 x %Int32], [5 x %Int32]* %88, %Int32 0, %Int32 %82
	%90 = load %Int32, %Int32* %89
	%91 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str7 to [0 x i8]*), %Int32 %79, %Int32 %80, %Int32 %81, %Int32 %90)
	%92 = load %Int32, %Int32* %3
	%93 = add %Int32 %92, 1
	store %Int32 %93, %Int32* %3
	br label %again_12
break_12:
	%94 = load %Int32, %Int32* %2
	%95 = add %Int32 %94, 1
	store %Int32 %95, %Int32* %2
	br label %again_11
break_11:
	%96 = load %Int32, %Int32* %1
	%97 = add %Int32 %96, 1
	store %Int32 %97, %Int32* %1
	br label %again_10
break_10:
	store %Int32 0, %Int32* %1
	br label %again_13
again_13:
	%98 = load %Int32, %Int32* %1
	%99 = icmp slt %Int32 %98, 2
	br %Bool %99 , label %body_13, label %break_13
body_13:
	store %Int32 0, %Int32* %2
	br label %again_14
again_14:
	%100 = load %Int32, %Int32* %2
	%101 = icmp slt %Int32 %100, 2
	br %Bool %101 , label %body_14, label %break_14
body_14:
	store %Int32 0, %Int32* %3
	br label %again_15
again_15:
	%102 = load %Int32, %Int32* %3
	%103 = icmp slt %Int32 %102, 5
	br %Bool %103 , label %body_15, label %break_15
body_15:
	%104 = load %Int32, %Int32* %1
	%105 = load %Int32, %Int32* %2
	%106 = load %Int32, %Int32* %3
	%107 = load %Int32, %Int32* %3
	%108 = load %Int32, %Int32* %2
	%109 = load %Int32, %Int32* %1
	%110 = load [2 x [2 x [5 x %Int32]*]*]*, [2 x [2 x [5 x %Int32]*]*]** @p0
	%111 = getelementptr [2 x [2 x [5 x %Int32]*]*], [2 x [2 x [5 x %Int32]*]*]* %110, %Int32 0, %Int32 %109
	%112 = load [2 x [5 x %Int32]*]*, [2 x [5 x %Int32]*]** %111
	%113 = getelementptr [2 x [5 x %Int32]*], [2 x [5 x %Int32]*]* %112, %Int32 0, %Int32 %108
	%114 = load [5 x %Int32]*, [5 x %Int32]** %113
	%115 = getelementptr [5 x %Int32], [5 x %Int32]* %114, %Int32 0, %Int32 %107
	%116 = load %Int32, %Int32* %115
	%117 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str8 to [0 x i8]*), %Int32 %104, %Int32 %105, %Int32 %106, %Int32 %116)
	%118 = load %Int32, %Int32* %3
	%119 = add %Int32 %118, 1
	store %Int32 %119, %Int32* %3
	br label %again_15
break_15:
	%120 = load %Int32, %Int32* %2
	%121 = add %Int32 %120, 1
	store %Int32 %121, %Int32* %2
	br label %again_14
break_14:
	%122 = load %Int32, %Int32* %1
	%123 = add %Int32 %122, 1
	store %Int32 %123, %Int32* %1
	br label %again_13
break_13:
	ret void
}

define %Int @main() {
	; generic array [4]Char8 will be implicit casted to [10]Char8
	%1 = mul i8 30, 1  ; calc VLA item size
	%2 = alloca [30 x %Char8], align 1
	%3 = insertvalue [20 x %Char8] zeroinitializer, %Char8 72, 0
	%4 = insertvalue [20 x %Char8] %3, %Char8 101, 1
	%5 = insertvalue [20 x %Char8] %4, %Char8 108, 2
	%6 = insertvalue [20 x %Char8] %5, %Char8 108, 3
	%7 = insertvalue [20 x %Char8] %6, %Char8 111, 4
	%8 = insertvalue [20 x %Char8] %7, %Char8 32, 5
	%9 = insertvalue [20 x %Char8] %8, %Char8 87, 6
	%10 = insertvalue [20 x %Char8] %9, %Char8 111, 7
	%11 = insertvalue [20 x %Char8] %10, %Char8 114, 8
	%12 = insertvalue [20 x %Char8] %11, %Char8 108, 9
	%13 = insertvalue [20 x %Char8] %12, %Char8 100, 10
	%14 = insertvalue [20 x %Char8] %13, %Char8 33, 11; alloca memory for return value
	%15 = alloca [30 x %Char8]
	call void @f0([30 x %Char8]* %15, [20 x %Char8] %14)
	%16 = load [30 x %Char8], [30 x %Char8]* %15
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%17 = zext i8 30 to %Int32
	; -- end vol eval --
	store [30 x %Char8] %16, [30 x %Char8]* %2
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str9 to [0 x i8]*), [30 x %Char8]* %2)
	%19 = alloca %Int32, align 4
	store %Int32 0, %Int32* %19
	br label %again_1
again_1:
	%20 = load %Int32, %Int32* %19
	%21 = icmp slt %Int32 %20, 10
	br %Bool %21 , label %body_1, label %break_1
body_1:
	%22 = load %Int32, %Int32* %19
	%23 = getelementptr [10 x %Int32], [10 x %Int32]* @globalArray, %Int32 0, %Int32 %22
	%24 = load %Int32, %Int32* %23
	%25 = load %Int32, %Int32* %19
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str10 to [0 x i8]*), %Int32 %25, %Int32 %24)
	%27 = load %Int32, %Int32* %19
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %19
	br label %again_1
break_1:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str11 to [0 x i8]*))
	%30 = mul i8 3, 1  ; calc VLA item size
	%31 = alloca [3 x %Int32], align 1
	%32 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%33 = insertvalue [3 x %Int32] %32, %Int32 5, 1
	%34 = insertvalue [3 x %Int32] %33, %Int32 6, 2
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%35 = zext i8 3 to %Int32
	; -- end vol eval --
	store [3 x %Int32] %34, [3 x %Int32]* %31
	store %Int32 0, %Int32* %19
	br label %again_2
again_2:
	%36 = load %Int32, %Int32* %19
	%37 = icmp slt %Int32 %36, 3
	br %Bool %37 , label %body_2, label %break_2
body_2:
	%38 = load %Int32, %Int32* %19
	%39 = getelementptr [3 x %Int32], [3 x %Int32]* %31, %Int32 0, %Int32 %38
	%40 = load %Int32, %Int32* %39
	%41 = load %Int32, %Int32* %19
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str12 to [0 x i8]*), %Int32 %41, %Int32 %40)
	%43 = load %Int32, %Int32* %19
	%44 = add %Int32 %43, 1
	store %Int32 %44, %Int32* %19
	br label %again_2
break_2:
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str13 to [0 x i8]*))
	%46 = alloca [0 x %Int32]*, align 8
	store [0 x %Int32]* bitcast ([10 x %Int32]* @globalArray to [0 x %Int32]*), [0 x %Int32]** %46
	store %Int32 0, %Int32* %19
	br label %again_3
again_3:
	%47 = load %Int32, %Int32* %19
	%48 = icmp slt %Int32 %47, 3
	br %Bool %48 , label %body_3, label %break_3
body_3:
	%49 = load %Int32, %Int32* %19
	%50 = load [0 x %Int32]*, [0 x %Int32]** %46
	%51 = getelementptr [0 x %Int32], [0 x %Int32]* %50, %Int32 0, %Int32 %49
	%52 = load %Int32, %Int32* %51
	%53 = load %Int32, %Int32* %19
	%54 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str14 to [0 x i8]*), %Int32 %53, %Int32 %52)
	%55 = load %Int32, %Int32* %19
	%56 = add %Int32 %55, 1
	store %Int32 %56, %Int32* %19
	br label %again_3
break_3:
	%57 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str15 to [0 x i8]*))
	%58 = alloca [0 x %Int32]*, align 8
	%59 = bitcast [3 x %Int32]* %31 to [0 x %Int32]*
	store [0 x %Int32]* %59, [0 x %Int32]** %58
	store %Int32 0, %Int32* %19
	br label %again_4
again_4:
	%60 = load %Int32, %Int32* %19
	%61 = icmp slt %Int32 %60, 3
	br %Bool %61 , label %body_4, label %break_4
body_4:
	%62 = load %Int32, %Int32* %19
	%63 = load [0 x %Int32]*, [0 x %Int32]** %58
	%64 = getelementptr [0 x %Int32], [0 x %Int32]* %63, %Int32 0, %Int32 %62
	%65 = load %Int32, %Int32* %64
	%66 = load %Int32, %Int32* %19
	%67 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str16 to [0 x i8]*), %Int32 %66, %Int32 %65)
	%68 = load %Int32, %Int32* %19
	%69 = add %Int32 %68, 1
	store %Int32 %69, %Int32* %19
	br label %again_4
break_4:

	; assign array to array 1
	; (with equal types)
	%70 = mul i8 3, 1  ; calc VLA item size
	%71 = alloca [3 x %Int32], align 1
	%72 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%73 = insertvalue [3 x %Int32] %72, %Int32 2, 1
	%74 = insertvalue [3 x %Int32] %73, %Int32 3, 2
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%75 = zext i8 3 to %Int32
	; -- end vol eval --
	store [3 x %Int32] %74, [3 x %Int32]* %71
	%76 = getelementptr [3 x %Int32], [3 x %Int32]* %71, %Int32 0, %Int32 0
	%77 = load %Int32, %Int32* %76
	%78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str17 to [0 x i8]*), %Int32 %77)
	%79 = getelementptr [3 x %Int32], [3 x %Int32]* %71, %Int32 0, %Int32 1
	%80 = load %Int32, %Int32* %79
	%81 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str18 to [0 x i8]*), %Int32 %80)
	%82 = getelementptr [3 x %Int32], [3 x %Int32]* %71, %Int32 0, %Int32 2
	%83 = load %Int32, %Int32* %82
	%84 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str19 to [0 x i8]*), %Int32 %83)

	; create (and initialize) new variable b
	; (with type [3]Int32)
	; this variable are copy of array a
	%85 = mul i8 3, 1  ; calc VLA item size
	%86 = alloca [3 x %Int32], align 1
	%87 = load [3 x %Int32], [3 x %Int32]* %71
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%88 = zext i8 3 to %Int32
	; -- end vol eval --
	store [3 x %Int32] %87, [3 x %Int32]* %86
	%89 = getelementptr [3 x %Int32], [3 x %Int32]* %86, %Int32 0, %Int32 0
	%90 = load %Int32, %Int32* %89
	%91 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str20 to [0 x i8]*), %Int32 %90)
	%92 = getelementptr [3 x %Int32], [3 x %Int32]* %86, %Int32 0, %Int32 1
	%93 = load %Int32, %Int32* %92
	%94 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str21 to [0 x i8]*), %Int32 %93)
	%95 = getelementptr [3 x %Int32], [3 x %Int32]* %86, %Int32 0, %Int32 2
	%96 = load %Int32, %Int32* %95
	%97 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str22 to [0 x i8]*), %Int32 %96)

	; check equality between two arrays (by value)
	%98 = bitcast [3 x %Int32]* %71 to i8*
	%99 = bitcast [3 x %Int32]* %86 to i8*
	%100 = call i1 (i8*, i8*, i64) @memeq(i8* %98, i8* %99, %Int64 12)
	%101 = icmp ne %Bool %100, 0
	br %Bool %101 , label %then_0, label %else_0
then_0:
	%102 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str23 to [0 x i8]*))
	br label %endif_0
else_0:
	%103 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str24 to [0 x i8]*))
	br label %endif_0
endif_0:

	; assign array to array 2
	; (with array extending)
	%104 = mul i8 3, 1  ; calc VLA item size
	%105 = alloca [3 x %Int32], align 1
	%106 = insertvalue [3 x %Int32] zeroinitializer, %Int32 10, 0
	%107 = insertvalue [3 x %Int32] %106, %Int32 20, 1
	%108 = insertvalue [3 x %Int32] %107, %Int32 30, 2
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%109 = zext i8 3 to %Int32
	; -- end vol eval --
	store [3 x %Int32] %108, [3 x %Int32]* %105
	%110 = mul i8 6, 1  ; calc VLA item size
	%111 = alloca [6 x %Int32], align 1
; -- cons_composite_from_composite_by_adr --
	%112 = bitcast [3 x %Int32]* %105 to [6 x %Int32]*
	%113 = load [6 x %Int32], [6 x %Int32]* %112
; -- end cons_composite_from_composite_by_adr --
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%114 = zext i8 6 to %Int32
	; -- end vol eval --
	store [6 x %Int32] %113, [6 x %Int32]* %111
	%115 = getelementptr [6 x %Int32], [6 x %Int32]* %111, %Int32 0, %Int32 0
	%116 = load %Int32, %Int32* %115
	%117 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str25 to [0 x i8]*), %Int32 %116)
	%118 = getelementptr [6 x %Int32], [6 x %Int32]* %111, %Int32 0, %Int32 1
	%119 = load %Int32, %Int32* %118
	%120 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str26 to [0 x i8]*), %Int32 %119)
	%121 = getelementptr [6 x %Int32], [6 x %Int32]* %111, %Int32 0, %Int32 2
	%122 = load %Int32, %Int32* %121
	%123 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str27 to [0 x i8]*), %Int32 %122)
	%124 = getelementptr [6 x %Int32], [6 x %Int32]* %111, %Int32 0, %Int32 3
	%125 = load %Int32, %Int32* %124
	%126 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str28 to [0 x i8]*), %Int32 %125)
	%127 = getelementptr [6 x %Int32], [6 x %Int32]* %111, %Int32 0, %Int32 4
	%128 = load %Int32, %Int32* %127
	%129 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str29 to [0 x i8]*), %Int32 %128)
	%130 = getelementptr [6 x %Int32], [6 x %Int32]* %111, %Int32 0, %Int32 5
	%131 = load %Int32, %Int32* %130
	%132 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str30 to [0 x i8]*), %Int32 %131)


	; check equality between two arrays (by pointer)
	%133 = mul i8 3, 1  ; calc VLA item size
	%134 = mul i8 3, 1  ; calc VLA item size
	%135 = bitcast [3 x %Int32]* %71 to i8*
	%136 = bitcast [3 x %Int32]* %86 to i8*
	%137 = call i1 (i8*, i8*, i64) @memeq(i8* %135, i8* %136, %Int64 12)
	%138 = icmp ne %Bool %137, 0
	br %Bool %138 , label %then_1, label %else_1
then_1:
	%139 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str31 to [0 x i8]*))
	br label %endif_1
else_1:
	%140 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str32 to [0 x i8]*))
	br label %endif_1
endif_1:


	;
	; Check assination local literal array
	;


	;let aa = [111] + [222] + [333]
	; cons literal array from var items
	%141 = alloca %Int, align 4
	store %Int 100, %Int* %141
	%142 = alloca %Int, align 4
	store %Int 200, %Int* %142
	%143 = alloca %Int, align 4
	store %Int 300, %Int* %143
	; immutable, non immediate value (array)
	%144 = load %Int, %Int* %141
	%145 = load %Int, %Int* %142
	%146 = load %Int, %Int* %143
	%147 = load %Int, %Int* %141
	%148 = insertvalue [3 x %Int] zeroinitializer, %Int %147, 0
	%149 = load %Int, %Int* %142
	%150 = insertvalue [3 x %Int] %148, %Int %149, 1
	%151 = load %Int, %Int* %143
	%152 = insertvalue [3 x %Int] %150, %Int %151, 2
	%153 = mul i8 3, 1  ; calc VLA item size
	%154 = alloca [3 x %Int]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%155 = zext i8 3 to %Int32
	; -- end vol eval --
	store [3 x %Int] %152, [3 x %Int]* %154

	; check local literal array assignation to local array
	%156 = mul i8 4, 1  ; calc VLA item size
	%157 = alloca [4 x %Int32], align 1
; -- cons_composite_from_composite_by_adr --
	%158 = bitcast [3 x %Int]* %154 to [4 x %Int32]*
	%159 = load [4 x %Int32], [4 x %Int32]* %158
; -- end cons_composite_from_composite_by_adr --
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%160 = zext i8 4 to %Int32
	; -- end vol eval --
	store [4 x %Int32] %159, [4 x %Int32]* %157
	%161 = getelementptr [4 x %Int32], [4 x %Int32]* %157, %Int32 0, %Int32 0
	%162 = load %Int32, %Int32* %161
	%163 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str33 to [0 x i8]*), %Int32 %162)
	%164 = getelementptr [4 x %Int32], [4 x %Int32]* %157, %Int32 0, %Int32 1
	%165 = load %Int32, %Int32* %164
	%166 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str34 to [0 x i8]*), %Int32 %165)
	%167 = getelementptr [4 x %Int32], [4 x %Int32]* %157, %Int32 0, %Int32 2
	%168 = load %Int32, %Int32* %167
	%169 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str35 to [0 x i8]*), %Int32 %168)

	; check local literal array assignation to global array
; -- cons_composite_from_composite_by_adr --
	%170 = bitcast [3 x %Int]* %154 to [10 x %Int32]*
	%171 = load [10 x %Int32], [10 x %Int32]* %170
; -- end cons_composite_from_composite_by_adr --
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%172 = zext i8 10 to %Int32
	; -- end vol eval --
	store [10 x %Int32] %171, [10 x %Int32]* @globalArray
	%173 = getelementptr [10 x %Int32], [10 x %Int32]* @globalArray, %Int32 0, %Int32 0
	%174 = load %Int32, %Int32* %173
	%175 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str36 to [0 x i8]*), %Int32 0, %Int32 %174)
	%176 = getelementptr [10 x %Int32], [10 x %Int32]* @globalArray, %Int32 0, %Int32 1
	%177 = load %Int32, %Int32* %176
	%178 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str37 to [0 x i8]*), %Int32 1, %Int32 %177)
	%179 = getelementptr [10 x %Int32], [10 x %Int32]* @globalArray, %Int32 0, %Int32 2
	%180 = load %Int32, %Int32* %179
	%181 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str38 to [0 x i8]*), %Int32 2, %Int32 %180)
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%182 = zext i8 10 to %Int32
	; -- end vol eval --
	; -- zero fill rest of array
	%183 = mul %Int32 %182, 4
	%184 = bitcast [10 x %Int32]* @globalArray to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %184, i8 0, %Int32 %183, i1 0)


	; проверка того как локальная константа-массив
	; "замораживает" свои элементы
	%185 = alloca %Int32, align 4
	store %Int32 10, %Int32* %185
	%186 = alloca %Int32, align 4
	store %Int32 20, %Int32* %186
	%187 = alloca %Int32, align 4
	store %Int32 30, %Int32* %187
	%188 = load %Int32, %Int32* %185
	%189 = load %Int32, %Int32* %186
	%190 = load %Int32, %Int32* %187
	%191 = load %Int32, %Int32* %185
	%192 = insertvalue [4 x %Int32] zeroinitializer, %Int32 %191, 0
	%193 = load %Int32, %Int32* %186
	%194 = insertvalue [4 x %Int32] %192, %Int32 %193, 1
	%195 = load %Int32, %Int32* %187
	%196 = insertvalue [4 x %Int32] %194, %Int32 %195, 2
	%197 = insertvalue [4 x %Int32] %196, %Int32 40, 3
	%198 = mul i8 4, 1  ; calc VLA item size
	%199 = alloca [4 x %Int32]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%200 = zext i8 4 to %Int32
	; -- end vol eval --
	store [4 x %Int32] %197, [4 x %Int32]* %199
	store %Int32 111, %Int32* %185
	store %Int32 222, %Int32* %186
	store %Int32 333, %Int32* %187
	%201 = getelementptr [4 x %Int32], [4 x %Int32]* %199, %Int32 0, %Int32 0
	%202 = load %Int32, %Int32* %201
	%203 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str39 to [0 x i8]*), %Int32 0, %Int32 %202)
	%204 = getelementptr [4 x %Int32], [4 x %Int32]* %199, %Int32 0, %Int32 1
	%205 = load %Int32, %Int32* %204
	%206 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str40 to [0 x i8]*), %Int32 1, %Int32 %205)
	%207 = getelementptr [4 x %Int32], [4 x %Int32]* %199, %Int32 0, %Int32 2
	%208 = load %Int32, %Int32* %207
	%209 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str41 to [0 x i8]*), %Int32 2, %Int32 %208)
	%210 = getelementptr [4 x %Int32], [4 x %Int32]* %199, %Int32 0, %Int32 3
	%211 = load %Int32, %Int32* %210
	%212 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str42 to [0 x i8]*), %Int32 3, %Int32 %211)
	%213 = insertvalue [4 x %Int32] zeroinitializer, %Int32 10, 0
	%214 = insertvalue [4 x %Int32] %213, %Int32 20, 1
	%215 = insertvalue [4 x %Int32] %214, %Int32 30, 2
	%216 = insertvalue [4 x %Int32] %215, %Int32 40, 3
	%217 = alloca [4 x %Int32]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%218 = zext i8 4 to %Int32
	; -- end vol eval --
	store [4 x %Int32] %216, [4 x %Int32]* %217
	%219 = bitcast [4 x %Int32]* %199 to i8*
	%220 = bitcast [4 x %Int32]* %217 to i8*
	%221 = call i1 (i8*, i8*, i64) @memeq(i8* %219, i8* %220, %Int64 16)
	%222 = icmp ne %Bool %221, 0
	br %Bool %222 , label %then_2, label %else_2
then_2:
	%223 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str43 to [0 x i8]*))
	br label %endif_2
else_2:
	%224 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str44 to [0 x i8]*))
	br label %endif_2
endif_2:
	%225 = insertvalue [5 x %Char8] zeroinitializer, %Char8 76, 0
	%226 = insertvalue [5 x %Char8] %225, %Char8 111, 1
	%227 = insertvalue [5 x %Char8] %226, %Char8 72, 2
	%228 = insertvalue [5 x %Char8] %227, %Char8 105, 3
	%229 = insertvalue [5 x %Char8] %228, %Char8 33, 4
	%230 = mul i8 5, 1  ; calc VLA item size
	%231 = alloca [5 x %Char8]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%232 = zext i8 5 to %Int32
	; -- end vol eval --
	store [5 x %Char8] %229, [5 x %Char8]* %231
	%233 = getelementptr [5 x %Char8], [5 x %Char8]* %231, %Int32 0, i8 2
	%234 = bitcast %Char8* %233 to [2 x %Char8]*
	%235 = insertvalue [2 x %Char8] zeroinitializer, %Char8 72, 0
	%236 = insertvalue [2 x %Char8] %235, %Char8 105, 1
	%237 = alloca [2 x %Char8]
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%238 = zext i8 2 to %Int32
	; -- end vol eval --
	store [2 x %Char8] %236, [2 x %Char8]* %237
	%239 = bitcast [2 x %Char8]* %234 to i8*
	%240 = bitcast [2 x %Char8]* %237 to i8*
	%241 = call i1 (i8*, i8*, i64) @memeq(i8* %239, i8* %240, %Int64 2)
	%242 = icmp ne %Bool %241, 0
	br %Bool %242 , label %then_3, label %else_3
then_3:
	%243 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str45 to [0 x i8]*))
	br label %endif_3
else_3:
	%244 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str46 to [0 x i8]*))
	br label %endif_3
endif_3:
	call void @test_arrays()
	ret %Int 0
}


