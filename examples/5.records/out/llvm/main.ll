
target triple = "arm64-apple-darwin21.6.0"

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/math.hm






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

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




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

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




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
















declare i32 @creat([0 x i8]*, i32)
declare i32 @open([0 x i8]*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir([0 x i8]*)
declare i32 @closedir(%DIR*)


declare [0 x i8]* @getcwd([0 x i8]*, i64)
declare [0 x i8]* @getenv([0 x i8]*)

; -- MODULE: /Users/alexbalan/p/Modest/examples/5.records/src/main.cm

@str_1 = private constant [15 x i8] c"point(%f, %f)\0A\00"
@str_2 = private constant [18 x i8] c"line length = %f\0A\00"



%Point = type {
	double,
	double
}

%Line = type {
	%Point,
	%Point
}


@line = global %Line {
  %Point {
    double 0x0,
    double 0x0
  },
  %Point {
    double 0x3ff0000000000000,
    double 0x3ff0000000000000
  }
}

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



define double @distance(%Point %a, %Point %b) {
  %1 = extractvalue %Point %a, 0
  %2 = extractvalue %Point %b, 0
  %3 = call double(double, double) @max (double %1, double %2)
  %4 = extractvalue %Point %a, 0
  %5 = extractvalue %Point %b, 0
  %6 = call double(double, double) @min (double %4, double %5)
  %7 = fsub double %3, %6
  %8 = extractvalue %Point %a, 1
  %9 = extractvalue %Point %b, 1
  %10 = call double(double, double) @max (double %8, double %9)
  %11 = extractvalue %Point %a, 1
  %12 = extractvalue %Point %b, 1
  %13 = call double(double, double) @min (double %11, double %12)
  %14 = fsub double %10, %13
  %15 = extractvalue %Point %a, 0
  %16 = extractvalue %Point %b, 0
  %17 = call double(double, double) @max (double %15, double %16)
  %18 = extractvalue %Point %a, 0
  %19 = extractvalue %Point %b, 0
  %20 = call double(double, double) @min (double %18, double %19)
  %21 = fsub double %17, %20
  %22 = call double(double, double) @pow (double %21, double 0x4000000000000000)
  %23 = extractvalue %Point %a, 1
  %24 = extractvalue %Point %b, 1
  %25 = call double(double, double) @max (double %23, double %24)
  %26 = extractvalue %Point %a, 1
  %27 = extractvalue %Point %b, 1
  %28 = call double(double, double) @min (double %26, double %27)
  %29 = fsub double %25, %28
  %30 = call double(double, double) @pow (double %29, double 0x4000000000000000)
  %31 = extractvalue %Point %a, 0
  %32 = extractvalue %Point %b, 0
  %33 = call double(double, double) @max (double %31, double %32)
  %34 = extractvalue %Point %a, 0
  %35 = extractvalue %Point %b, 0
  %36 = call double(double, double) @min (double %34, double %35)
  %37 = fsub double %33, %36
  %38 = call double(double, double) @pow (double %37, double 0x4000000000000000)
  %39 = extractvalue %Point %a, 1
  %40 = extractvalue %Point %b, 1
  %41 = call double(double, double) @max (double %39, double %40)
  %42 = extractvalue %Point %a, 1
  %43 = extractvalue %Point %b, 1
  %44 = call double(double, double) @min (double %42, double %43)
  %45 = fsub double %41, %44
  %46 = call double(double, double) @pow (double %45, double 0x4000000000000000)
  %47 = fadd double %38, %46
  %48 = call double(double) @sqrt (double %47)
  ret double %48
}

define double @lineLength(%Line %line) {
  %1 = extractvalue %Line %line, 0
  %2 = extractvalue %Line %line, 1
  %3 = call double(%Point, %Point) @distance (%Point %1, %Point %2)
  ret double %3
}

define void @ptr_example() {
  %1 = call i8*(i64) @malloc (i64 0)
  %2 = bitcast i8* %1 to %Point*
; access by pointer
  %3 = call i8*(i64) @malloc (i64 0)
  %4 = bitcast i8* %3 to %Point*
  %5 = getelementptr inbounds %Point, %Point* %4, i32 0, i32 0
  store double 0x4024000000000000, double* %5
  %6 = call i8*(i64) @malloc (i64 0)
  %7 = bitcast i8* %6 to %Point*
  %8 = getelementptr inbounds %Point, %Point* %7, i32 0, i32 1
  store double 0x4034000000000000, double* %8
  %9 = bitcast [15 x i8]* @str_1 to %ConstCharStr
  %10 = call i8*(i64) @malloc (i64 0)
  %11 = bitcast i8* %10 to %Point*
  %12 = getelementptr inbounds %Point, %Point* %11, i32 0, i32 0
  %13 = load double, double* %12
  %14 = call i8*(i64) @malloc (i64 0)
  %15 = bitcast i8* %14 to %Point*
  %16 = getelementptr inbounds %Point, %Point* %15, i32 0, i32 1
  %17 = load double, double* %16
  %18 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %9, double %13, double %17)
  ret void
}

define i32 @main() {
; by value
  %1 = load %Line, %Line* @line
  %2 = call double(%Line) @lineLength (%Line %1)
  %3 = bitcast [18 x i8]* @str_2 to %ConstCharStr
  %4 = load %Line, %Line* @line
  %5 = call double(%Line) @lineLength (%Line %4)
  %6 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %3, double %5)
  call void() @ptr_example ()
  ret i32 0
}


