
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


declare i32 @fclose(%FILE* %f)
declare i32 @feof(%FILE* %f)
declare i32 @ferror(%FILE* %f)
declare i32 @fflush(%FILE* %f)
declare i32 @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare i32 @fseek(%FILE* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%FILE* %f, %FposT* %pos)
declare i64 @ftell(%FILE* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare i32 @setvbuf(%FILE* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%FILE* %stream, %Str* %format, ...)
declare i32 @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare i32 @fgetc(%FILE* %f)
declare i32 @fputc(i32 %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %FILE* %f)
declare i32 @fputs(%ConstCharStr* %str, %FILE* %f)
declare i32 @getc(%FILE* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %FILE* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)

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
declare i8* @malloc(i64 %size)
declare i8* @memset(i8* %mem, i32 %c, i64 %n)
declare i8* @memcpy(i8* %dst, i8* %src, i64 %len)
declare i32 @memcmp(i8* %ptr1, i8* %ptr2, i64 %num)
declare void @free(i8* %ptr)
declare i32 @strncmp([0 x i8]* %s1, [0 x i8]* %s2, i64 %n)
declare i32 @strcmp([0 x i8]* %s1, [0 x i8]* %s2)
declare [0 x i8]* @strcpy([0 x i8]* %dst, [0 x i8]* %src)
declare i64 @strlen([0 x i8]* %s)


declare i32 @ftruncate(i32 %fd, i32 %size)
















declare i32 @creat(%Str* %path, i32 %mode)
declare i32 @open(%Str* %path, i32 %oflags)
declare i32 @read(i32 %fd, i8* %buf, i32 %len)
declare i32 @write(i32 %fd, i8* %buf, i32 %len)
declare i32 @lseek(i32 %fd, i32 %offset, i32 %whence)
declare i32 @close(i32 %fd)
declare void @exit(i32 %rc)


declare %DIR* @opendir(%Str* %name)
declare i32 @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, i64 %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, i64 %n)


declare void @bcopy(i8* %src, i8* %dst, i64 %n)

; -- SOURCE: src/main.cm

@str1 = private constant [15 x i8] [i8 112, i8 111, i8 105, i8 110, i8 116, i8 40, i8 37, i8 102, i8 44, i8 32, i8 37, i8 102, i8 41, i8 10, i8 0]
@str2 = private constant [18 x i8] [i8 108, i8 105, i8 110, i8 101, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]



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
        double 0.0,
        double 0.0
    },
    %Point {
        double 1.0,
        double 1.0
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
    %3 = call double (double, double) @max(double %1, double %2)
    %4 = extractvalue %Point %a, 0
    %5 = extractvalue %Point %b, 0
    %6 = call double (double, double) @min(double %4, double %5)
    %7 = fsub double %3, %6
    %8 = extractvalue %Point %a, 1
    %9 = extractvalue %Point %b, 1
    %10 = call double (double, double) @max(double %8, double %9)
    %11 = extractvalue %Point %a, 1
    %12 = extractvalue %Point %b, 1
    %13 = call double (double, double) @min(double %11, double %12)
    %14 = fsub double %10, %13
    %15 = call double (double, double) @pow(double %7, double 2.0)
    %16 = call double (double, double) @pow(double %14, double 2.0)
    %17 = fadd double %15, %16
    %18 = call double (double) @sqrt(double %17)
    ret double %18
}

define double @lineLength(%Line %line) {
    %1 = extractvalue %Line %line, 0
    %2 = extractvalue %Line %line, 1
    %3 = call double (%Point, %Point) @distance(%Point %1, %Point %2)
    ret double %3
}

define void @ptr_example() {
    %1 = call i8* (i64) @malloc(i64 16)
    %2 = bitcast i8* %1 to %Point*
    ; access by pointer
    %3 = getelementptr inbounds %Point, %Point* %2, i32 0, i32 0
    store double 10.0, double* %3
    %4 = getelementptr inbounds %Point, %Point* %2, i32 0, i32 1
    store double 20.0, double* %4
    %5 = getelementptr inbounds %Point, %Point* %2, i32 0, i32 0
    %6 = load double, double* %5
    %7 = getelementptr inbounds %Point, %Point* %2, i32 0, i32 1
    %8 = load double, double* %7
    %9 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str1 to [0 x i8]*), double %6, double %8)
    ret void
}

define i32 @main() {
    ; by value
    %1 = load %Line, %Line* @line
    %2 = call double (%Line) @lineLength(%Line %1)
    %3 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str2 to [0 x i8]*), double %2)
    call void () @ptr_example()
    ret i32 0
}


