
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
%ctypes64_Str = type %Str8;
%ctypes64_Char = type %Char8;
%ctypes64_ConstChar = type %ctypes64_Char;
%ctypes64_SignedChar = type %Int8;
%ctypes64_UnsignedChar = type %Int8;
%ctypes64_Short = type %Int16;
%ctypes64_UnsignedShort = type %Int16;
%ctypes64_Int = type %Int32;
%ctypes64_UnsignedInt = type %Int32;
%ctypes64_LongInt = type %Int64;
%ctypes64_UnsignedLongInt = type %Int64;
%ctypes64_Long = type %Int64;
%ctypes64_UnsignedLong = type %Int64;
%ctypes64_LongLong = type %Int64;
%ctypes64_UnsignedLongLong = type %Int64;
%ctypes64_LongLongInt = type %Int64;
%ctypes64_UnsignedLongLongInt = type %Int64;
%ctypes64_Float = type double;
%ctypes64_Double = type double;
%ctypes64_LongDouble = type double;
%ctypes64_SizeT = type %ctypes64_UnsignedLongInt;
%ctypes64_SSizeT = type %ctypes64_LongInt;
%ctypes64_IntPtrT = type %Int64;
%ctypes64_PtrDiffT = type i8*;
%ctypes64_OffT = type %Int64;
%ctypes64_USecondsT = type %Int32;
%ctypes64_PIDT = type %Int32;
%ctypes64_UIDT = type %Int32;
%ctypes64_GIDT = type %Int32;
; from included stdio
%stdio_File = type %Int8;
%stdio_FposT = type %Int8;
%stdio_CharStr = type %ctypes64_Str;
%stdio_ConstCharStr = type %stdio_CharStr;
declare %ctypes64_Int @fclose(%stdio_File* %f)
declare %ctypes64_Int @feof(%stdio_File* %f)
declare %ctypes64_Int @ferror(%stdio_File* %f)
declare %ctypes64_Int @fflush(%stdio_File* %f)
declare %ctypes64_Int @fgetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %stdio_File* @fopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode)
declare %ctypes64_SizeT @fread(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %ctypes64_SizeT @fwrite(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %stdio_File* @freopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode, %stdio_File* %f)
declare %ctypes64_Int @fseek(%stdio_File* %f, %ctypes64_LongInt %offset, %ctypes64_Int %whence)
declare %ctypes64_Int @fsetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %ctypes64_LongInt @ftell(%stdio_File* %f)
declare %ctypes64_Int @remove(%stdio_ConstCharStr* %fname)
declare %ctypes64_Int @rename(%stdio_ConstCharStr* %old_filename, %stdio_ConstCharStr* %new_filename)
declare void @rewind(%stdio_File* %f)
declare void @setbuf(%stdio_File* %f, %stdio_CharStr* %buf)
declare %ctypes64_Int @setvbuf(%stdio_File* %f, %stdio_CharStr* %buf, %ctypes64_Int %mode, %ctypes64_SizeT %size)
declare %stdio_File* @tmpfile()
declare %stdio_CharStr* @tmpnam(%stdio_CharStr* %str)
declare %ctypes64_Int @printf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @scanf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @fprintf(%stdio_File* %f, %ctypes64_Str* %format, ...)
declare %ctypes64_Int @fscanf(%stdio_File* %f, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sscanf(%stdio_ConstCharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sprintf(%stdio_CharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @vfprintf(%stdio_File* %f, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vprintf(%stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsprintf(%stdio_CharStr* %str, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsnprintf(%stdio_CharStr* %str, %ctypes64_SizeT %n, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @__vsnprintf_chk(%stdio_CharStr* %dest, %ctypes64_SizeT %len, %ctypes64_Int %flags, %ctypes64_SizeT %dstlen, %stdio_ConstCharStr* %format, i8* %arg)
declare %ctypes64_Int @fgetc(%stdio_File* %f)
declare %ctypes64_Int @fputc(%ctypes64_Int %char, %stdio_File* %f)
declare %stdio_CharStr* @fgets(%stdio_CharStr* %str, %ctypes64_Int %n, %stdio_File* %f)
declare %ctypes64_Int @fputs(%stdio_ConstCharStr* %str, %stdio_File* %f)
declare %ctypes64_Int @getc(%stdio_File* %f)
declare %ctypes64_Int @getchar()
declare %stdio_CharStr* @gets(%stdio_CharStr* %str)
declare %ctypes64_Int @putc(%ctypes64_Int %char, %stdio_File* %f)
declare %ctypes64_Int @putchar(%ctypes64_Int %char)
declare %ctypes64_Int @puts(%stdio_ConstCharStr* %str)
declare %ctypes64_Int @ungetc(%ctypes64_Int %char, %stdio_File* %f)
declare void @perror(%stdio_ConstCharStr* %str)
; from included stdlib
declare void @abort()
declare %ctypes64_Int @abs(%ctypes64_Int %x)
declare %ctypes64_Int @atexit(void ()* %x)
declare %ctypes64_Double @atof([0 x %ctypes64_ConstChar]* %nptr)
declare %ctypes64_Int @atoi([0 x %ctypes64_ConstChar]* %nptr)
declare %ctypes64_LongInt @atol([0 x %ctypes64_ConstChar]* %nptr)
declare i8* @calloc(%ctypes64_SizeT %num, %ctypes64_SizeT %size)
declare void @exit(%ctypes64_Int %x)
declare void @free(i8* %ptr)
declare %ctypes64_Str* @getenv(%ctypes64_Str* %name)
declare %ctypes64_LongInt @labs(%ctypes64_LongInt %x)
declare %ctypes64_Str* @secure_getenv(%ctypes64_Str* %name)
declare i8* @malloc(%ctypes64_SizeT %size)
declare %ctypes64_Int @system([0 x %ctypes64_ConstChar]* %string)
; from included math
declare %ctypes64_Double @acos(%ctypes64_Double %x)
declare %ctypes64_Double @asin(%ctypes64_Double %x)
declare %ctypes64_Double @atan(%ctypes64_Double %x)
declare %ctypes64_Double @atan2(%ctypes64_Double %a, %ctypes64_Double %b)
declare %ctypes64_Double @cos(%ctypes64_Double %x)
declare %ctypes64_Double @sin(%ctypes64_Double %x)
declare %ctypes64_Double @tan(%ctypes64_Double %x)
declare %ctypes64_Double @cosh(%ctypes64_Double %x)
declare %ctypes64_Double @sinh(%ctypes64_Double %x)
declare %ctypes64_Double @tanh(%ctypes64_Double %x)
declare %ctypes64_Double @exp(%ctypes64_Double %x)
declare %ctypes64_Double @frexp(%ctypes64_Double %a, %ctypes64_Int* %i)
declare %ctypes64_Double @ldexp(%ctypes64_Double %a, %ctypes64_Int %i)
declare %ctypes64_Double @log(%ctypes64_Double %x)
declare %ctypes64_Double @log10(%ctypes64_Double %x)
declare %ctypes64_Double @modf(%ctypes64_Double %a, %ctypes64_Double* %b)
declare %ctypes64_Double @pow(%ctypes64_Double %a, %ctypes64_Double %b)
declare %ctypes64_Double @sqrt(%ctypes64_Double %x)
declare %ctypes64_Double @ceil(%ctypes64_Double %x)
declare %ctypes64_Double @fabs(%ctypes64_Double %x)
declare %ctypes64_Double @floor(%ctypes64_Double %x)
declare %ctypes64_Double @fmod(%ctypes64_Double %a, %ctypes64_Double %b)
declare %ctypes64_LongDouble @acosl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @asinl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @atanl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @atan2l(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @cosl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @sinl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @tanl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @acoshl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @asinhl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @atanhl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @coshl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @sinhl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @tanhl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @expl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @exp2l(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @expm1l(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @frexpl(%ctypes64_LongDouble %a, %ctypes64_Int* %i)
declare %ctypes64_Int @ilogbl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @ldexpl(%ctypes64_LongDouble %a, %ctypes64_Int %i)
declare %ctypes64_LongDouble @logl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @log10l(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @log1pl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @log2l(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @logbl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @modfl(%ctypes64_LongDouble %a, %ctypes64_LongDouble* %b)
declare %ctypes64_LongDouble @scalbnl(%ctypes64_LongDouble %a, %ctypes64_Int %i)
declare %ctypes64_LongDouble @scalblnl(%ctypes64_LongDouble %a, %ctypes64_LongInt %i)
declare %ctypes64_LongDouble @cbrtl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @fabsl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @hypotl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @powl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @sqrtl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @erfl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @erfcl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @lgammal(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @tgammal(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @ceill(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @floorl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @nearbyintl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @rintl(%ctypes64_LongDouble %x)
declare %ctypes64_LongInt @lrintl(%ctypes64_LongDouble %x)
declare %ctypes64_LongLongInt @llrintl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @roundl(%ctypes64_LongDouble %x)
declare %ctypes64_LongInt @lroundl(%ctypes64_LongDouble %x)
declare %ctypes64_LongLongInt @llroundl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @truncl(%ctypes64_LongDouble %x)
declare %ctypes64_LongDouble @fmodl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @remainderl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @remquol(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b, %ctypes64_Int* %i)
declare %ctypes64_LongDouble @copysignl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @nanl(%ctypes64_ConstChar* %x)
declare %ctypes64_LongDouble @nextafterl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @nexttowardl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @fdiml(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @fmaxl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @fminl(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b)
declare %ctypes64_LongDouble @fmal(%ctypes64_LongDouble %a, %ctypes64_LongDouble %b, %ctypes64_LongDouble %c)
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [9 x i8] [i8 100, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [9 x i8] [i8 100, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [12 x i8] [i8 102, i8 108, i8 111, i8 97, i8 116, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str4 = private constant [8 x i8] [i8 50, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [10 x i8] [i8 50, i8 47, i8 51, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str6 = private constant [8 x i8] [i8 115, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str7 = private constant [8 x i8] [i8 107, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str8 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str9 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 70, i8 108, i8 111, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@str10 = private constant [12 x i8] [i8 115, i8 108, i8 111, i8 112, i8 101, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
; -- endstrings --
define internal double @squareOfCircle(double %radius) {
	%1 = call %ctypes64_Double @pow(double %radius, %ctypes64_Double 2.0000000000000000)
	%2 = fmul %ctypes64_Double %1, 3.1415926535897931
	ret %ctypes64_Double %2
}

%Point2D = type {
	%ctypes64_Int,
	%ctypes64_Int
};

define internal float @slope(%Point2D %a, %Point2D %b) {
	%1 = extractvalue %Point2D %a, 0
	%2 = extractvalue %Point2D %b, 0
	%3 = sub %ctypes64_Int %1, %2
	%4 = call %ctypes64_Int @abs(%ctypes64_Int %3)
	%5 = extractvalue %Point2D %a, 1
	%6 = extractvalue %Point2D %b, 1
	%7 = sub %ctypes64_Int %5, %6
	%8 = call %ctypes64_Int @abs(%ctypes64_Int %7)
	%9 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ctypes64_Int %4)
	%10 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([9 x i8]* @str2 to [0 x i8]*), %ctypes64_Int %8)
	%11 = sitofp %ctypes64_Int %8 to float
	%12 = sitofp %ctypes64_Int %4 to float
	%13 = fdiv float %11, %12
	ret float %13
}

define %ctypes64_Int @main() {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([12 x i8]* @str3 to [0 x i8]*))
	%2 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), %Int32 2)
	%3 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([10 x i8]* @str5 to [0 x i8]*), double 0.6666666666666666)
	%4 = call double @squareOfCircle(double 10.0000000000000000)
	%5 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([8 x i8]* @str6 to [0 x i8]*), double %4)
	%6 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([8 x i8]* @str7 to [0 x i8]*), double 0.1250000000000000)
	%7 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str8 to [0 x i8]*), %Int32 4)
	%8 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([23 x i8]* @str9 to [0 x i8]*), %Int32 8)

	; printf %f ожидает получить double а не float!
	%9 = insertvalue %Point2D zeroinitializer, %ctypes64_Int 10, 0
	%10 = insertvalue %Point2D %9, %ctypes64_Int 20, 1
	%11 = insertvalue %Point2D zeroinitializer, %ctypes64_Int 30, 0
	%12 = insertvalue %Point2D %11, %ctypes64_Int 50, 1
	%13 = call float @slope(%Point2D %10, %Point2D %12)
	%14 = fpext float %13 to double
	%15 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([12 x i8]* @str10 to [0 x i8]*), double %14)
	ret %ctypes64_Int 0
}


