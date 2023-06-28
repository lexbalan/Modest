
@str_0 = private constant [18 x i8] c"line length = %f\0A\00"



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


%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*

declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr)
declare i32 @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)
declare i32 @setvbuf(%FILE*, %CharStr, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare i32 @printf(%ConstCharStr, ...)
declare i32 @scanf(%ConstCharStr, ...)
declare i32 @fprintf(%FILE*, [0 x i8]*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr, ...)
declare i32 @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare i32 @sprintf(%CharStr, %ConstCharStr, ...)
declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr @fgets(%CharStr, i32, %FILE*)
declare i32 @fputs(%ConstCharStr, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr @gets(%CharStr)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr)

%Point = type {
	double,
	double
}

%Line = type {
	%Point,
	%Point
}
@line = global %Line {%Point {double 0x0, double 0x0}, %Point {double 0x3ff0000000000000, double 0x3ff0000000000000}}
define double @max(double %a, double %b) {
  %1 = fcmp ogt double %a, %b
  br i1 %1 , label %then_0, label %endif_0
then_0:
  ret double %a
  br label %endif_0
endif_0:
  ret double %b
}

define double @min(double %a, double %b) {
  %1 = fcmp olt double %a, %b
  br i1 %1 , label %then_0, label %endif_0
then_0:
  ret double %a
  br label %endif_0
endif_0:
  ret double %b
}

define double @lineLength(%Line %line) {
  %1 = extractvalue %Line %line, 0
  %2 = extractvalue %Point %1, 0
  %3 = extractvalue %Line %line, 1
  %4 = extractvalue %Point %3, 0
  %5 = call double(double, double) @max (double %2, double %4)
  %6 = extractvalue %Line %line, 0
  %7 = extractvalue %Point %6, 0
  %8 = extractvalue %Line %line, 1
  %9 = extractvalue %Point %8, 0
  %10 = call double(double, double) @min (double %7, double %9)
  %11 = fsub double %5, %10
  %12 = extractvalue %Line %line, 0
  %13 = extractvalue %Point %12, 1
  %14 = extractvalue %Line %line, 1
  %15 = extractvalue %Point %14, 1
  %16 = call double(double, double) @max (double %13, double %15)
  %17 = extractvalue %Line %line, 0
  %18 = extractvalue %Point %17, 1
  %19 = extractvalue %Line %line, 1
  %20 = extractvalue %Point %19, 1
  %21 = call double(double, double) @min (double %18, double %20)
  %22 = fsub double %16, %21
  %23 = call double(double, double) @pow (double %11, double 0x4000000000000000)
  %24 = call double(double, double) @pow (double %22, double 0x4000000000000000)
  %25 = fadd double %23, %24
  %26 = call double(double) @sqrt (double %25)
  ret double %26
}

define i32 @main() {
  %1 = load %Line, %Line* @line
  %2 = call double(%Line) @lineLength (%Line %1)
  %3 = bitcast [18 x i8]* @str_0 to %ConstCharStr
  %4 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %3, double %2)
  ret i32 0
}


