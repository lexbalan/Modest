
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
declare i32 @strncmp(i8*, i8*, i64)
declare i32 @strcmp(i8*, i8*)
declare i8* @strcpy(i8*, i8*)
declare i64 @strlen(i8*)


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

@str1.c8 = private constant [18 x i8] c"lines_0_len = %f\0A\00"
@str2.c8 = private constant [18 x i8] c"lines_1_len = %f\0A\00"



%Point = type {
	double,
	double
}

%Line = type {
	%Point,
	%Point
}




define double @distance(%Point %a, %Point %b) {
    %1 = extractvalue %Point %a, 0
    %2 = extractvalue %Point %b, 0
    %3 = call double(double, double) @max_float64 (double %1, double %2)
    %4 = extractvalue %Point %a, 0
    %5 = extractvalue %Point %b, 0
    %6 = call double(double, double) @min_float64 (double %4, double %5)
    %7 = fsub double %3, %6
    %8 = extractvalue %Point %a, 1
    %9 = extractvalue %Point %b, 1
    %10 = call double(double, double) @max_float64 (double %8, double %9)
    %11 = extractvalue %Point %a, 1
    %12 = extractvalue %Point %b, 1
    %13 = call double(double, double) @min_float64 (double %11, double %12)
    %14 = fsub double %10, %13
    %15 = call double(double, double) @pow (double %7, double 2.0)
    %16 = call double(double, double) @pow (double %14, double 2.0)
    %17 = fadd double %15, %16
    %18 = call double(double) @sqrt (double %17)
    ret double %18
}

define double @lineLength(%Line %line) {
    %1 = extractvalue %Line %line, 0
    %2 = extractvalue %Line %line, 1
    %3 = call double(%Point, %Point) @distance (%Point %1, %Point %2)
    ret double %3
}

define i32 @main() {
    %1 = call double(%Line) @lineLength (%Line {
  %Point {
    double 0.0,
    double 0.0
  },
  %Point {
    double 1.0,
    double 1.0
  }
})
    %2 = call double(%Line) @lineLength (%Line {
  %Point {
    double 10.0,
    double 15.0
  },
  %Point {
    double 20.0,
    double 25.0
  }
})
    %3 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* @str1.c8, double %1)
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* @str2.c8, double %2)
    ret i32 0
}


