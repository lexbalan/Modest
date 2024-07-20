
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8;
%Char = type i8;
%ConstChar = type i8;
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%SocklenT = type i32;
%SizeT = type i64;
%SSizeT = type i64;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str;
%ConstCharStr = type %CharStr;


declare i32 @fclose(%File* %f)
declare i32 @feof(%File* %f)
declare i32 @ferror(%File* %f)
declare i32 @fflush(%File* %f)
declare i32 @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %File* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare i32 @fseek(%File* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%File* %f, %FposT* %pos)
declare i64 @ftell(%File* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare i32 @setvbuf(%File* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%File* %stream, %Str* %format, ...)
declare i32 @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare i32 @vprintf(%ConstCharStr* %format, i8* %args)
declare i32 @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare i32 @vsnprintf(%CharStr* %str, i64 %n, %ConstCharStr* %format, i8* %args)
declare i32 @__vsnprintf_chk(%CharStr* %dest, i64 %len, i32 %flags, i64 %dstlen, %ConstCharStr* %format, i8* %arg)
declare i32 @fgetc(%File* %f)
declare i32 @fputc(i32 %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %File* %f)
declare i32 @fputs(%ConstCharStr* %str, %File* %f)
declare i32 @getc(%File* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %File* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %File* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/math.hm






declare double @acos(double %x)
declare double @asin(double %x)
declare double @atan(double %x)
declare double @atan2(double %a, double %b)
declare double @cos(double %x)
declare double @sin(double %x)
declare double @tan(double %x)
declare double @cosh(double %x)
declare double @sinh(double %x)
declare double @tanh(double %x)
declare double @exp(double %x)
declare double @frexp(double %a, i32* %i)
declare double @ldexp(double %a, i32 %i)
declare double @log(double %x)
declare double @log10(double %x)
declare double @modf(double %a, double* %b)
declare double @pow(double %a, double %b)
declare double @sqrt(double %x)
declare double @ceil(double %x)
declare double @fabs(double %x)
declare double @floor(double %x)
declare double @fmod(double %a, double %b)


declare double @acosl(double %x)
declare double @asinl(double %x)
declare double @atanl(double %x)
declare double @atan2l(double %a, double %b)
declare double @cosl(double %x)
declare double @sinl(double %x)
declare double @tanl(double %x)
declare double @acoshl(double %x)
declare double @asinhl(double %x)
declare double @atanhl(double %x)
declare double @coshl(double %x)
declare double @sinhl(double %x)
declare double @tanhl(double %x)
declare double @expl(double %x)
declare double @exp2l(double %x)
declare double @expm1l(double %x)
declare double @frexpl(double %a, i32* %i)
declare i32 @ilogbl(double %x)
declare double @ldexpl(double %a, i32 %i)
declare double @logl(double %x)
declare double @log10l(double %x)
declare double @log1pl(double %x)
declare double @log2l(double %x)
declare double @logbl(double %x)
declare double @modfl(double %a, double* %b)
declare double @scalbnl(double %a, i32 %i)
declare double @scalblnl(double %a, i64 %i)
declare double @cbrtl(double %x)
declare double @fabsl(double %x)
declare double @hypotl(double %a, double %b)
declare double @powl(double %a, double %b)
declare double @sqrtl(double %x)
declare double @erfl(double %x)
declare double @erfcl(double %x)
declare double @lgammal(double %x)
declare double @tgammal(double %x)
declare double @ceill(double %x)
declare double @floorl(double %x)
declare double @nearbyintl(double %x)
declare double @rintl(double %x)
declare i64 @lrintl(double %x)
declare i64 @llrintl(double %x)
declare double @roundl(double %x)
declare i64 @lroundl(double %x)
declare i64 @llroundl(double %x)
declare double @truncl(double %x)
declare double @fmodl(double %a, double %b)
declare double @remainderl(double %a, double %b)
declare double @remquol(double %a, double %b, i32* %i)
declare double @copysignl(double %a, double %b)
declare double @nanl(i8* %x)
declare double @nextafterl(double %a, double %b)
declare double @nexttowardl(double %a, double %b)
declare double @fdiml(double %a, double %b)
declare double @fmaxl(double %a, double %b)
declare double @fminl(double %a, double %b)
declare double @fmal(double %a, double %b, double %c)


; -- SOURCE: src/main.cm

@str1 = private constant [12 x i8] [i8 102, i8 108, i8 111, i8 97, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [8 x i8] [i8 115, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str3 = private constant [8 x i8] [i8 107, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]




define double @squareOfCircle(double %radius) {
	%1 = call double @pow(double %radius, double 2.0000000000000000)
	%2 = fmul double %1, 3.1415926535897931
	ret double %2
}

define i32 @main() {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*))
	%2 = call double @squareOfCircle(double 10.0000000000000000)
	%3 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str2 to [0 x i8]*), double %2)
	%4 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str3 to [0 x i8]*), double 0.1250000000000000)
	ret i32 0
}


