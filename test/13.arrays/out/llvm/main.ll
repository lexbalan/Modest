
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/misc/minmax.hm


declare i32 @min_int32(i32 %a, i32 %b)
declare i32 @max_int32(i32 %a, i32 %b)
declare i64 @min_int64(i64 %a, i64 %b)
declare i64 @max_int64(i64 %a, i64 %b)
declare i32 @min_nat32(i32 %a, i32 %b)
declare i32 @max_nat32(i32 %a, i32 %b)
declare i64 @min_nat64(i64 %a, i64 %b)
declare i64 @max_nat64(i64 %a, i64 %b)
declare float @min_float32(float %a, float %b)
declare float @max_float32(float %a, float %b)
declare double @min_float64(double %a, double %b)
declare double @max_float64(double %a, double %b)

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
    %1 = alloca i32
    store i32 0, i32* %1
    br label %again_1
again_1:
    %2 = load i32, i32* %1
    %3 = icmp slt i32 %2, 3
    br i1 %3 , label %body_1, label %break_1
body_1:
    %4 = load i32, i32* %1
    %5 = getelementptr inbounds [3 x i32], [3 x i32]* @globalArray, i32 0, i32 %4
    %6 = load i32, i32* %5
    %7 = load i32, i32* %1
    %8 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str1 to [0 x i8]*), i32 %7, i32 %6)
    %9 = load i32, i32* %1
    %10 = add i32 %9, 1
    store i32 %10, i32* %1
    br label %again_1
break_1:
    %11 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str2 to [0 x i8]*))
    %12 = insertvalue [3 x i32] zeroinitializer, i32 4, 0
    %13 = insertvalue [3 x i32] %12, i32 5, 1
    %14 = insertvalue [3 x i32] %13, i32 6, 2
    %15 = alloca [3 x i32]
    store [3 x i32] %14, [3 x i32]* %15
    store i32 0, i32* %1
    br label %again_2
again_2:
    %16 = load i32, i32* %1
    %17 = icmp slt i32 %16, 3
    br i1 %17 , label %body_2, label %break_2
body_2:
    %18 = load i32, i32* %1
    %19 = getelementptr inbounds [3 x i32], [3 x i32]* %15, i32 0, i32 %18
    %20 = load i32, i32* %19
    %21 = load i32, i32* %1
    %22 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*), i32 %21, i32 %20)
    %23 = load i32, i32* %1
    %24 = add i32 %23, 1
    store i32 %24, i32* %1
    br label %again_2
break_2:
    %25 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str4 to [0 x i8]*))
    %26 = alloca [0 x i32]*
    %27 = bitcast [3 x i32]* @globalArray to [0 x i32]*
    store [0 x i32]* %27, [0 x i32]** %26
    store i32 0, i32* %1
    br label %again_3
again_3:
    %28 = load i32, i32* %1
    %29 = icmp slt i32 %28, 3
    br i1 %29 , label %body_3, label %break_3
body_3:
    %30 = load [0 x i32]*, [0 x i32]** %26
    %31 = load i32, i32* %1
    %32 = getelementptr inbounds [0 x i32], [0 x i32]* %30, i32 0, i32 %31
    %33 = load i32, i32* %32
    %34 = load i32, i32* %1
    %35 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str5 to [0 x i8]*), i32 %34, i32 %33)
    %36 = load i32, i32* %1
    %37 = add i32 %36, 1
    store i32 %37, i32* %1
    br label %again_3
break_3:
    %38 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str6 to [0 x i8]*))
    %39 = alloca [0 x i32]*
    %40 = bitcast [3 x i32]* %15 to [0 x i32]*
    store [0 x i32]* %40, [0 x i32]** %39
    store i32 0, i32* %1
    br label %again_4
again_4:
    %41 = load i32, i32* %1
    %42 = icmp slt i32 %41, 3
    br i1 %42 , label %body_4, label %break_4
body_4:
    %43 = load [0 x i32]*, [0 x i32]** %39
    %44 = load i32, i32* %1
    %45 = getelementptr inbounds [0 x i32], [0 x i32]* %43, i32 0, i32 %44
    %46 = load i32, i32* %45
    %47 = load i32, i32* %1
    %48 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str7 to [0 x i8]*), i32 %47, i32 %46)
    %49 = load i32, i32* %1
    %50 = add i32 %49, 1
    store i32 %50, i32* %1
    br label %again_4
break_4:
    ret i32 0
}


