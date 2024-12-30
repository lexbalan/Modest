
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
@str4 = private constant [9 x i8] [i8 101, i8 109, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str5 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str6 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str7 = private constant [21 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str8 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str9 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str10 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str11 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str12 = private constant [11 x i8] [i8 97, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [11 x i8] [i8 97, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str14 = private constant [11 x i8] [i8 97, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str15 = private constant [11 x i8] [i8 98, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str16 = private constant [11 x i8] [i8 98, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str17 = private constant [11 x i8] [i8 98, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str18 = private constant [8 x i8] [i8 97, i8 32, i8 61, i8 61, i8 32, i8 98, i8 10, i8 0]
@str19 = private constant [8 x i8] [i8 97, i8 32, i8 33, i8 61, i8 32, i8 98, i8 10, i8 0]
@str20 = private constant [11 x i8] [i8 100, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str21 = private constant [11 x i8] [i8 100, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str22 = private constant [11 x i8] [i8 100, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str23 = private constant [11 x i8] [i8 100, i8 91, i8 51, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str24 = private constant [11 x i8] [i8 100, i8 91, i8 52, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str25 = private constant [11 x i8] [i8 100, i8 91, i8 53, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str26 = private constant [12 x i8] [i8 42, i8 112, i8 97, i8 32, i8 61, i8 61, i8 32, i8 42, i8 112, i8 98, i8 10, i8 0]
@str27 = private constant [12 x i8] [i8 42, i8 112, i8 97, i8 32, i8 33, i8 61, i8 32, i8 42, i8 112, i8 98, i8 10, i8 0]
@str28 = private constant [11 x i8] [i8 101, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str29 = private constant [11 x i8] [i8 101, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str30 = private constant [11 x i8] [i8 101, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str31 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str32 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str33 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str34 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 49, i8 48, i8 41, i8 10, i8 0]
@str35 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 50, i8 48, i8 41, i8 10, i8 0]
@str36 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 51, i8 48, i8 41, i8 10, i8 0]
@str37 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 52, i8 48, i8 41, i8 10, i8 0]
@str38 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str39 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str40 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str41 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
;@attribute("c_no_print")
;import "misc/minmax"
;$pragma c_include "./minmax.h"

@constantArray = constant [10 x %Int8] [
	%Int8 1,
	%Int8 2,
	%Int8 3,
	%Int8 4,
	%Int8 5,
	%Int8 6,
	%Int8 7,
	%Int8 8,
	%Int8 9,
	%Int8 10
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
	store [20 x %Char8] %__x, [20 x %Char8]* %x
	%2 = alloca [20 x %Char8], align 1
	%3 = load [20 x %Char8], [20 x %Char8]* %x
	store [20 x %Char8] %3, [20 x %Char8]* %2
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), [20 x %Char8]* %2)
	; truncate array
	%5 = alloca [6 x %Char8], align 1
; -- cons_composite_from_composite_by_adr --
	%6 = bitcast [20 x %Char8]* %x to [6 x %Char8]*
	%7 = load [6 x %Char8], [6 x %Char8]* %6
; -- end cons_composite_from_composite_by_adr --
	store [6 x %Char8] %7, [6 x %Char8]* %5
	%8 = getelementptr inbounds [6 x %Char8], [6 x %Char8]* %5, %Int32 0, %Int32 5
	store %Char8 0, %Char8* %8
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), [6 x %Char8]* %5)
	; extend array
	%10 = alloca [30 x %Char8], align 1
; -- cons_composite_from_composite_by_adr --
	%11 = bitcast [20 x %Char8]* %x to [30 x %Char8]*
	%12 = load [30 x %Char8], [30 x %Char8]* %11
; -- end cons_composite_from_composite_by_adr --
	store [30 x %Char8] %12, [30 x %Char8]* %10
	%13 = getelementptr inbounds [30 x %Char8], [30 x %Char8]* %10, %Int32 0, %Int32 6
	store %Char8 77, %Char8* %13
	%14 = getelementptr inbounds [30 x %Char8], [30 x %Char8]* %10, %Int32 0, %Int32 7
	store %Char8 111, %Char8* %14
	%15 = getelementptr inbounds [30 x %Char8], [30 x %Char8]* %10, %Int32 0, %Int32 8
	store %Char8 100, %Char8* %15
	%16 = getelementptr inbounds [30 x %Char8], [30 x %Char8]* %10, %Int32 0, %Int32 9
	store %Char8 101, %Char8* %16
	%17 = getelementptr inbounds [30 x %Char8], [30 x %Char8]* %10, %Int32 0, %Int32 10
	store %Char8 115, %Char8* %17
	%18 = getelementptr inbounds [30 x %Char8], [30 x %Char8]* %10, %Int32 0, %Int32 11
	store %Char8 116, %Char8* %18
	%19 = getelementptr inbounds [30 x %Char8], [30 x %Char8]* %10, %Int32 0, %Int32 12
	store %Char8 33, %Char8* %19
	%20 = getelementptr inbounds [30 x %Char8], [30 x %Char8]* %10, %Int32 0, %Int32 13
	store %Char8 0, %Char8* %20
	%21 = load [30 x %Char8], [30 x %Char8]* %10
	store [30 x %Char8] %21, [30 x %Char8]* %0
	ret void
}


@startSequence = constant [3 x %Int8] [
	%Int8 170,
	%Int8 85,
	%Int8 2
]
@stopSequence = constant [1 x %Int8] [
	%Int8 22
]

define internal void @test() {
	; тестируем работу с локальным generic массивом
	%1 = alloca [6 x %Int32], align 4
	%2 = insertvalue [6 x %Int32] zeroinitializer, %Int32 170, 0
	%3 = insertvalue [6 x %Int32] %2, %Int32 85, 1
	%4 = insertvalue [6 x %Int32] %3, %Int32 2, 2
	%5 = insertvalue [6 x %Int32] %4, %Int32 22, 5
	store [6 x %Int32] %5, [6 x %Int32]* %1
	%6 = alloca %Int32, align 4
	store %Int32 0, %Int32* %6
	br label %again_1
again_1:
	%7 = load %Int32, %Int32* %6
	%8 = icmp slt %Int32 %7, 6
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = load %Int32, %Int32* %6
	%10 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %1, %Int32 0, %Int32 %9
	%11 = load %Int32, %Int32* %10
	%12 = load %Int32, %Int32* %6
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), %Int32 %12, %Int32 %11)
	%14 = load %Int32, %Int32* %6
	%15 = add %Int32 %14, 1
	store %Int32 %15, %Int32* %6
	br label %again_1
break_1:
	ret void
}

define %Int @main() {
	; generic array [4]Char8 will be implicit casted to [10]Char8
	%1 = alloca [30 x %Char8], align 1
	%2 = insertvalue [20 x %Char8] zeroinitializer, %Char8 72, 0
	%3 = insertvalue [20 x %Char8] %2, %Char8 101, 1
	%4 = insertvalue [20 x %Char8] %3, %Char8 108, 2
	%5 = insertvalue [20 x %Char8] %4, %Char8 108, 3
	%6 = insertvalue [20 x %Char8] %5, %Char8 111, 4
	%7 = insertvalue [20 x %Char8] %6, %Char8 32, 5
	%8 = insertvalue [20 x %Char8] %7, %Char8 87, 6
	%9 = insertvalue [20 x %Char8] %8, %Char8 111, 7
	%10 = insertvalue [20 x %Char8] %9, %Char8 114, 8
	%11 = insertvalue [20 x %Char8] %10, %Char8 108, 9
	%12 = insertvalue [20 x %Char8] %11, %Char8 100, 10
	%13 = insertvalue [20 x %Char8] %12, %Char8 33, 11; alloca memory for return value
	%14 = alloca [30 x %Char8]
	call void @f0([30 x %Char8]* %14, [20 x %Char8] %13)
	%15 = load [30 x %Char8], [30 x %Char8]* %14
	store [30 x %Char8] %15, [30 x %Char8]* %1
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str4 to [0 x i8]*), [30 x %Char8]* %1)
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_1
again_1:
	%18 = load %Int32, %Int32* %17
	%19 = icmp slt %Int32 %18, 10
	br %Bool %19 , label %body_1, label %break_1
body_1:
	%20 = load %Int32, %Int32* %17
	%21 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* @globalArray, %Int32 0, %Int32 %20
	%22 = load %Int32, %Int32* %21
	%23 = load %Int32, %Int32* %17
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str5 to [0 x i8]*), %Int32 %23, %Int32 %22)
	%25 = load %Int32, %Int32* %17
	%26 = add %Int32 %25, 1
	store %Int32 %26, %Int32* %17
	br label %again_1
break_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str6 to [0 x i8]*))
	%28 = alloca [3 x %Int32], align 4
	%29 = insertvalue [3 x %Int32] zeroinitializer, %Int32 4, 0
	%30 = insertvalue [3 x %Int32] %29, %Int32 5, 1
	%31 = insertvalue [3 x %Int32] %30, %Int32 6, 2
	store [3 x %Int32] %31, [3 x %Int32]* %28
	store %Int32 0, %Int32* %17
	br label %again_2
again_2:
	%32 = load %Int32, %Int32* %17
	%33 = icmp slt %Int32 %32, 3
	br %Bool %33 , label %body_2, label %break_2
body_2:
	%34 = load %Int32, %Int32* %17
	%35 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %28, %Int32 0, %Int32 %34
	%36 = load %Int32, %Int32* %35
	%37 = load %Int32, %Int32* %17
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str7 to [0 x i8]*), %Int32 %37, %Int32 %36)
	%39 = load %Int32, %Int32* %17
	%40 = add %Int32 %39, 1
	store %Int32 %40, %Int32* %17
	br label %again_2
break_2:
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str8 to [0 x i8]*))
	%42 = alloca [0 x %Int32]*, align 8
	store [0 x %Int32]* bitcast ([10 x %Int32]* @globalArray to [0 x %Int32]*), [0 x %Int32]** %42
	store %Int32 0, %Int32* %17
	br label %again_3
again_3:
	%43 = load %Int32, %Int32* %17
	%44 = icmp slt %Int32 %43, 3
	br %Bool %44 , label %body_3, label %break_3
body_3:
	%45 = load %Int32, %Int32* %17
	%46 = load [0 x %Int32]*, [0 x %Int32]** %42
	%47 = getelementptr inbounds [0 x %Int32], [0 x %Int32]* %46, %Int32 0, %Int32 %45
	%48 = load %Int32, %Int32* %47
	%49 = load %Int32, %Int32* %17
	%50 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str9 to [0 x i8]*), %Int32 %49, %Int32 %48)
	%51 = load %Int32, %Int32* %17
	%52 = add %Int32 %51, 1
	store %Int32 %52, %Int32* %17
	br label %again_3
break_3:
	%53 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str10 to [0 x i8]*))
	%54 = alloca [0 x %Int32]*, align 8
	%55 = bitcast [3 x %Int32]* %28 to [0 x %Int32]*
	store [0 x %Int32]* %55, [0 x %Int32]** %54
	store %Int32 0, %Int32* %17
	br label %again_4
again_4:
	%56 = load %Int32, %Int32* %17
	%57 = icmp slt %Int32 %56, 3
	br %Bool %57 , label %body_4, label %break_4
body_4:
	%58 = load %Int32, %Int32* %17
	%59 = load [0 x %Int32]*, [0 x %Int32]** %54
	%60 = getelementptr inbounds [0 x %Int32], [0 x %Int32]* %59, %Int32 0, %Int32 %58
	%61 = load %Int32, %Int32* %60
	%62 = load %Int32, %Int32* %17
	%63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str11 to [0 x i8]*), %Int32 %62, %Int32 %61)
	%64 = load %Int32, %Int32* %17
	%65 = add %Int32 %64, 1
	store %Int32 %65, %Int32* %17
	br label %again_4
break_4:
	; assign array to array 1
	; (with equal types)
	%66 = alloca [3 x %Int32], align 4
	%67 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%68 = insertvalue [3 x %Int32] %67, %Int32 2, 1
	%69 = insertvalue [3 x %Int32] %68, %Int32 3, 2
	store [3 x %Int32] %69, [3 x %Int32]* %66
	%70 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %66, %Int32 0, %Int32 0
	%71 = load %Int32, %Int32* %70
	%72 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str12 to [0 x i8]*), %Int32 %71)
	%73 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %66, %Int32 0, %Int32 1
	%74 = load %Int32, %Int32* %73
	%75 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str13 to [0 x i8]*), %Int32 %74)
	%76 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %66, %Int32 0, %Int32 2
	%77 = load %Int32, %Int32* %76
	%78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str14 to [0 x i8]*), %Int32 %77)
	; create (and initialize) new variable b
	; (with type [3]Int32)
	; this variable are copy of array a
	%79 = alloca [3 x %Int32], align 4
	%80 = load [3 x %Int32], [3 x %Int32]* %66
	store [3 x %Int32] %80, [3 x %Int32]* %79
	%81 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %79, %Int32 0, %Int32 0
	%82 = load %Int32, %Int32* %81
	%83 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str15 to [0 x i8]*), %Int32 %82)
	%84 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %79, %Int32 0, %Int32 1
	%85 = load %Int32, %Int32* %84
	%86 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str16 to [0 x i8]*), %Int32 %85)
	%87 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %79, %Int32 0, %Int32 2
	%88 = load %Int32, %Int32* %87
	%89 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str17 to [0 x i8]*), %Int32 %88)
	; check equality between two arrays (by value)
	%90 = bitcast [3 x %Int32]* %66 to i8*
	%91 = bitcast [3 x %Int32]* %79 to i8*
	%92 = call i1 (i8*, i8*, i64) @memeq(i8* %90, i8* %91, %Int64 12)
	%93 = icmp ne %Bool %92, 0
	br %Bool %93 , label %then_0, label %else_0
then_0:
	%94 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str18 to [0 x i8]*))
	br label %endif_0
else_0:
	%95 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str19 to [0 x i8]*))
	br label %endif_0
endif_0:
	; assign array to array 2
	; (with array extending)
	%96 = alloca [3 x %Int32], align 4
	%97 = insertvalue [3 x %Int32] zeroinitializer, %Int32 10, 0
	%98 = insertvalue [3 x %Int32] %97, %Int32 20, 1
	%99 = insertvalue [3 x %Int32] %98, %Int32 30, 2
	store [3 x %Int32] %99, [3 x %Int32]* %96
	%100 = alloca [6 x %Int32], align 4
; -- cons_composite_from_composite_by_adr --
	%101 = bitcast [3 x %Int32]* %96 to [6 x %Int32]*
	%102 = load [6 x %Int32], [6 x %Int32]* %101
; -- end cons_composite_from_composite_by_adr --
	store [6 x %Int32] %102, [6 x %Int32]* %100
	%103 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %100, %Int32 0, %Int32 0
	%104 = load %Int32, %Int32* %103
	%105 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str20 to [0 x i8]*), %Int32 %104)
	%106 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %100, %Int32 0, %Int32 1
	%107 = load %Int32, %Int32* %106
	%108 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str21 to [0 x i8]*), %Int32 %107)
	%109 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %100, %Int32 0, %Int32 2
	%110 = load %Int32, %Int32* %109
	%111 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str22 to [0 x i8]*), %Int32 %110)
	%112 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %100, %Int32 0, %Int32 3
	%113 = load %Int32, %Int32* %112
	%114 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str23 to [0 x i8]*), %Int32 %113)
	%115 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %100, %Int32 0, %Int32 4
	%116 = load %Int32, %Int32* %115
	%117 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str24 to [0 x i8]*), %Int32 %116)
	%118 = getelementptr inbounds [6 x %Int32], [6 x %Int32]* %100, %Int32 0, %Int32 5
	%119 = load %Int32, %Int32* %118
	%120 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str25 to [0 x i8]*), %Int32 %119)
	; check equality between two arrays (by pointer)
	%121 = bitcast [3 x %Int32]* %66 to i8*
	%122 = bitcast [3 x %Int32]* %79 to i8*
	%123 = call i1 (i8*, i8*, i64) @memeq(i8* %121, i8* %122, %Int64 12)
	%124 = icmp ne %Bool %123, 0
	br %Bool %124 , label %then_1, label %else_1
then_1:
	%125 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str26 to [0 x i8]*))
	br label %endif_1
else_1:
	%126 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str27 to [0 x i8]*))
	br label %endif_1
endif_1:
	;
	; Check assination local literal array
	;
	;let aa = [111] + [222] + [333]
	; cons literal array from var items
	%127 = alloca %Int, align 4
	store %Int 100, %Int* %127
	%128 = alloca %Int, align 4
	store %Int 200, %Int* %128
	%129 = alloca %Int, align 4
	store %Int 300, %Int* %129
	; immutable, non immediate value (array)
	%130 = load %Int, %Int* %127
	%131 = load %Int, %Int* %128
	%132 = load %Int, %Int* %129
	%133 = load %Int, %Int* %127
	%134 = insertvalue [3 x %Int] zeroinitializer, %Int %133, 0
	%135 = load %Int, %Int* %128
	%136 = insertvalue [3 x %Int] %134, %Int %135, 1
	%137 = load %Int, %Int* %129
	%138 = insertvalue [3 x %Int] %136, %Int %137, 2
	%139 = alloca [3 x %Int]
	store [3 x %Int] %138, [3 x %Int]* %139
	; check local literal array assignation to local array
	%140 = alloca [4 x %Int32], align 4
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%141 = zext %Int8 4 to %Int32
	; -- end vol eval --
; -- cons_composite_from_composite_by_adr --
	%142 = bitcast [3 x %Int]* %139 to [4 x %Int32]*
	%143 = load [4 x %Int32], [4 x %Int32]* %142
; -- end cons_composite_from_composite_by_adr --
	store [4 x %Int32] %143, [4 x %Int32]* %140
	%144 = getelementptr inbounds [4 x %Int32], [4 x %Int32]* %140, %Int32 0, %Int32 0
	%145 = load %Int32, %Int32* %144
	%146 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str28 to [0 x i8]*), %Int32 %145)
	%147 = getelementptr inbounds [4 x %Int32], [4 x %Int32]* %140, %Int32 0, %Int32 1
	%148 = load %Int32, %Int32* %147
	%149 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str29 to [0 x i8]*), %Int32 %148)
	%150 = getelementptr inbounds [4 x %Int32], [4 x %Int32]* %140, %Int32 0, %Int32 2
	%151 = load %Int32, %Int32* %150
	%152 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str30 to [0 x i8]*), %Int32 %151)
	; check local literal array assignation to global array
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%153 = zext %Int8 10 to %Int32
	; -- end vol eval --
; -- cons_composite_from_composite_by_adr --
	%154 = bitcast [3 x %Int]* %139 to [10 x %Int32]*
	%155 = load [10 x %Int32], [10 x %Int32]* %154
; -- end cons_composite_from_composite_by_adr --
	store [10 x %Int32] %155, [10 x %Int32]* @globalArray
	%156 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* @globalArray, %Int32 0, %Int32 0
	%157 = load %Int32, %Int32* %156
	%158 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str31 to [0 x i8]*), %Int32 0, %Int32 %157)
	%159 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* @globalArray, %Int32 0, %Int32 1
	%160 = load %Int32, %Int32* %159
	%161 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str32 to [0 x i8]*), %Int32 1, %Int32 %160)
	%162 = getelementptr inbounds [10 x %Int32], [10 x %Int32]* @globalArray, %Int32 0, %Int32 2
	%163 = load %Int32, %Int32* %162
	%164 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str33 to [0 x i8]*), %Int32 2, %Int32 %163)
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%165 = zext %Int8 10 to %Int32
	; -- end vol eval --
	; -- zero fill rest of array
	%166 = mul %Int32 %165, 4
	%167 = bitcast [10 x %Int32]* @globalArray to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %167, i8 0, %Int32 %166, i1 0)
	; проверка того как локальная константа-массив
	; "замораживает" свои элементы
	%168 = alloca %Int32, align 4
	store %Int32 10, %Int32* %168
	%169 = alloca %Int32, align 4
	store %Int32 20, %Int32* %169
	%170 = alloca %Int32, align 4
	store %Int32 30, %Int32* %170
	%171 = load %Int32, %Int32* %168
	%172 = load %Int32, %Int32* %169
	%173 = load %Int32, %Int32* %170
	%174 = load %Int32, %Int32* %168
	%175 = insertvalue [4 x %Int32] zeroinitializer, %Int32 %174, 0
	%176 = load %Int32, %Int32* %169
	%177 = insertvalue [4 x %Int32] %175, %Int32 %176, 1
	%178 = load %Int32, %Int32* %170
	%179 = insertvalue [4 x %Int32] %177, %Int32 %178, 2
	%180 = insertvalue [4 x %Int32] %179, %Int32 40, 3
	%181 = alloca [4 x %Int32]
	store [4 x %Int32] %180, [4 x %Int32]* %181
	store %Int32 111, %Int32* %168
	store %Int32 222, %Int32* %169
	store %Int32 333, %Int32* %170
	%182 = getelementptr inbounds [4 x %Int32], [4 x %Int32]* %181, %Int32 0, %Int32 0
	%183 = load %Int32, %Int32* %182
	%184 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str34 to [0 x i8]*), %Int32 0, %Int32 %183)
	%185 = getelementptr inbounds [4 x %Int32], [4 x %Int32]* %181, %Int32 0, %Int32 1
	%186 = load %Int32, %Int32* %185
	%187 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str35 to [0 x i8]*), %Int32 1, %Int32 %186)
	%188 = getelementptr inbounds [4 x %Int32], [4 x %Int32]* %181, %Int32 0, %Int32 2
	%189 = load %Int32, %Int32* %188
	%190 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str36 to [0 x i8]*), %Int32 2, %Int32 %189)
	%191 = getelementptr inbounds [4 x %Int32], [4 x %Int32]* %181, %Int32 0, %Int32 3
	%192 = load %Int32, %Int32* %191
	%193 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str37 to [0 x i8]*), %Int32 3, %Int32 %192)
	%194 = insertvalue [4 x %Int32] zeroinitializer, %Int32 10, 0
	%195 = insertvalue [4 x %Int32] %194, %Int32 20, 1
	%196 = insertvalue [4 x %Int32] %195, %Int32 30, 2
	%197 = insertvalue [4 x %Int32] %196, %Int32 40, 3
	%198 = alloca [4 x %Int32]
	store [4 x %Int32] %197, [4 x %Int32]* %198
	%199 = bitcast [4 x %Int32]* %181 to i8*
	%200 = bitcast [4 x %Int32]* %198 to i8*
	%201 = call i1 (i8*, i8*, i64) @memeq(i8* %199, i8* %200, %Int64 16)
	%202 = icmp ne %Bool %201, 0
	br %Bool %202 , label %then_2, label %else_2
then_2:
	%203 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str38 to [0 x i8]*))
	br label %endif_2
else_2:
	%204 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str39 to [0 x i8]*))
	br label %endif_2
endif_2:
	%205 = insertvalue [5 x %Char8] zeroinitializer, %Char8 76, 0
	%206 = insertvalue [5 x %Char8] %205, %Char8 111, 1
	%207 = insertvalue [5 x %Char8] %206, %Char8 72, 2
	%208 = insertvalue [5 x %Char8] %207, %Char8 105, 3
	%209 = insertvalue [5 x %Char8] %208, %Char8 33, 4
	%210 = alloca [5 x %Char8]
	store [5 x %Char8] %209, [5 x %Char8]* %210
	%211 = getelementptr inbounds [5 x %Char8], [5 x %Char8]* %210, %Int32 0, %Int8 2
	%212 = bitcast %Char8* %211 to [2 x %Char8]*
	%213 = insertvalue [2 x %Char8] zeroinitializer, %Char8 72, 0
	%214 = insertvalue [2 x %Char8] %213, %Char8 105, 1
	%215 = alloca [2 x %Char8]
	store [2 x %Char8] %214, [2 x %Char8]* %215
	%216 = bitcast [2 x %Char8]* %212 to i8*
	%217 = bitcast [2 x %Char8]* %215 to i8*
	%218 = call i1 (i8*, i8*, i64) @memeq(i8* %216, i8* %217, %Int64 2)
	%219 = icmp ne %Bool %218, 0
	br %Bool %219 , label %then_3, label %else_3
then_3:
	%220 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str40 to [0 x i8]*))
	br label %endif_3
else_3:
	%221 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str41 to [0 x i8]*))
	br label %endif_3
endif_3:
	ret %Int 0
}


