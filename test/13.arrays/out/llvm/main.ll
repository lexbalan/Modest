
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





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/math.hm






declare double @acos(double)
declare double @asin(double)
declare double @atan(double)
declare double @atan2(double, double)
declare double @cos(double)
declare double @sin(double)
declare double @tan(double)
declare double @cosh(double)
declare double @sinh(double)
declare double @tanh(double)
declare double @exp(double)
declare double @frexp(double, i32*)
declare double @ldexp(double, i32)
declare double @log(double)
declare double @log10(double)
declare double @modf(double, double*)
declare double @pow(double, double)
declare double @sqrt(double)
declare double @ceil(double)
declare double @fabs(double)
declare double @floor(double)
declare double @fmod(double, double)


declare double @acosl(double)
declare double @asinl(double)
declare double @atanl(double)
declare double @atan2l(double, double)
declare double @cosl(double)
declare double @sinl(double)
declare double @tanl(double)
declare double @acoshl(double)
declare double @asinhl(double)
declare double @atanhl(double)
declare double @coshl(double)
declare double @sinhl(double)
declare double @tanhl(double)
declare double @expl(double)
declare double @exp2l(double)
declare double @expm1l(double)
declare double @frexpl(double, i32*)
declare i32 @ilogbl(double)
declare double @ldexpl(double, i32)
declare double @logl(double)
declare double @log10l(double)
declare double @log1pl(double)
declare double @log2l(double)
declare double @logbl(double)
declare double @modfl(double, double*)
declare double @scalbnl(double, i32)
declare double @scalblnl(double, i64)
declare double @cbrtl(double)
declare double @fabsl(double)
declare double @hypotl(double, double)
declare double @powl(double, double)
declare double @sqrtl(double)
declare double @erfl(double)
declare double @erfcl(double)
declare double @lgammal(double)
declare double @tgammal(double)
declare double @ceill(double)
declare double @floorl(double)
declare double @nearbyintl(double)
declare double @rintl(double)
declare i64 @lrintl(double)
declare i64 @llrintl(double)
declare double @roundl(double)
declare i64 @lroundl(double)
declare i64 @llroundl(double)
declare double @truncl(double)
declare double @fmodl(double, double)
declare double @remainderl(double, double)
declare double @remquol(double, double, i32*)
declare double @copysignl(double, double)
declare double @nanl(i8*)
declare double @nextafterl(double, double)
declare double @nexttowardl(double, double)
declare double @fdiml(double, double)
declare double @fmaxl(double, double)
declare double @fminl(double, double)
declare double @fmal(double, double, double)

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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/minmax.hm


declare i32 @min_int32(i32, i32)
declare i32 @max_int32(i32, i32)
declare i64 @min_int64(i64, i64)
declare i64 @max_int64(i64, i64)
declare i32 @min_nat32(i32, i32)
declare i32 @max_nat32(i32, i32)
declare i64 @min_nat64(i64, i64)
declare i64 @max_nat64(i64, i64)
declare float @min_float32(float, float)
declare float @max_float32(float, float)
declare double @min_float64(double, double)
declare double @max_float64(double, double)

; -- SOURCE: src/main.cm

@str1 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str3 = private constant [21 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str5 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str7 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]



@globalArray = global [3 x i32] [
  i32 1,
  i32 2,
  i32 3
]

define i32 @main() {
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %1 = load i32, i32* %i
    %2 = icmp slt i32 %1, 3
    br i1 %2 , label %body_1, label %break_1
body_1:
    %3 = load i32, i32* %i
    %4 = getelementptr inbounds [3 x i32], [3 x i32]* @globalArray, i32 0, i32 %3
    %5 = load i32, i32* %4
    %6 = load i32, i32* %i
    %7 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str1 to [0 x i8]*), i32 %6, i32 %5)
    %8 = load i32, i32* %i
    %9 = add i32 %8, 1
    store i32 %9, i32* %i
    br label %again_1
break_1:
    %10 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([38 x i8]* @str2 to [0 x i8]*))
    %11 = insertvalue [3 x i32] zeroinitializer, i32 4, 0
    %12 = insertvalue [3 x i32] %11, i32 5, 1
    %13 = insertvalue [3 x i32] %12, i32 6, 2
    %localArray = alloca [3 x i32]
    store [3 x i32] %13, [3 x i32]* %localArray
    store i32 0, i32* %i
    br label %again_2
again_2:
    %14 = load i32, i32* %i
    %15 = icmp slt i32 %14, 3
    br i1 %15 , label %body_2, label %break_2
body_2:
    %16 = load i32, i32* %i
    %17 = getelementptr inbounds [3 x i32], [3 x i32]* %localArray, i32 0, i32 %16
    %18 = load i32, i32* %17
    %19 = load i32, i32* %i
    %20 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*), i32 %19, i32 %18)
    %21 = load i32, i32* %i
    %22 = add i32 %21, 1
    store i32 %22, i32* %i
    br label %again_2
break_2:
    %23 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([38 x i8]* @str4 to [0 x i8]*))
    %globalArrayPtr = alloca [0 x i32]*
    %24 = bitcast [3 x i32]* @globalArray to [0 x i32]*
    store [0 x i32]* %24, [0 x i32]** %globalArrayPtr
    store i32 0, i32* %i
    br label %again_3
again_3:
    %25 = load i32, i32* %i
    %26 = icmp slt i32 %25, 3
    br i1 %26 , label %body_3, label %break_3
body_3:
    %27 = load [0 x i32]*, [0 x i32]** %globalArrayPtr
    %28 = load i32, i32* %i
    %29 = getelementptr inbounds [0 x i32], [0 x i32]* %27, i32 0, i32 %28
    %30 = load i32, i32* %29
    %31 = load i32, i32* %i
    %32 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([25 x i8]* @str5 to [0 x i8]*), i32 %31, i32 %30)
    %33 = load i32, i32* %i
    %34 = add i32 %33, 1
    store i32 %34, i32* %i
    br label %again_3
break_3:
    %35 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([38 x i8]* @str6 to [0 x i8]*))
    %localArrayPtr = alloca [0 x i32]*
    %36 = bitcast [3 x i32]* %localArray to [0 x i32]*
    store [0 x i32]* %36, [0 x i32]** %localArrayPtr
    store i32 0, i32* %i
    br label %again_4
again_4:
    %37 = load i32, i32* %i
    %38 = icmp slt i32 %37, 3
    br i1 %38 , label %body_4, label %break_4
body_4:
    %39 = load [0 x i32]*, [0 x i32]** %localArrayPtr
    %40 = load i32, i32* %i
    %41 = getelementptr inbounds [0 x i32], [0 x i32]* %39, i32 0, i32 %40
    %42 = load i32, i32* %41
    %43 = load i32, i32* %i
    %44 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([24 x i8]* @str7 to [0 x i8]*), i32 %43, i32 %42)
    %45 = load i32, i32* %i
    %46 = add i32 %45, 1
    store i32 %46, i32* %i
    br label %again_4
break_4:
    ret i32 0
}


