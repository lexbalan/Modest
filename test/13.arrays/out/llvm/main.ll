
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



%Str = type %Str8
%Char = type i8
%ConstChar = type %Char
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare %Int @setvbuf(%File* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %stream, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(%SizeT %size)
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare %Int @memcmp(i8* %ptr1, i8* %ptr2, %SizeT %num)
declare void @free(i8* %ptr)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)


declare %Int @ftruncate(%Int %fd, %OffT %size)
















declare %Int @creat(%Str* %path, %ModeT %mode)
declare %Int @open(%Str* %path, %Int %oflags)
declare %Int @read(%Int %fd, i8* %buf, i32 %len)
declare %Int @write(%Int %fd, i8* %buf, i32 %len)
declare %OffT @lseek(%Int %fd, %OffT %offset, %Int %whence)
declare %Int @close(%Int %fd)
declare void @exit(%Int %rc)


declare %DIR* @opendir(%Str* %name)
declare %Int @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, %SizeT %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, %SizeT %n)


declare void @bcopy(i8* %src, i8* %dst, %SizeT %n)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/math.hm






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

@str1 = private constant [10 x i8] [i8 102, i8 48, i8 40, i8 34, i8 37, i8 115, i8 34, i8 41, i8 10, i8 0]
@str2 = private constant [15 x i8] [i8 102, i8 48, i8 32, i8 109, i8 105, i8 99, i8 32, i8 61, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@str3 = private constant [9 x i8] [i8 101, i8 109, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str4 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str5 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str6 = private constant [21 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str8 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str10 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [11 x i8] [i8 97, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str12 = private constant [11 x i8] [i8 97, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [11 x i8] [i8 97, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str14 = private constant [11 x i8] [i8 98, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str15 = private constant [11 x i8] [i8 98, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str16 = private constant [11 x i8] [i8 98, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str17 = private constant [8 x i8] [i8 97, i8 32, i8 61, i8 61, i8 32, i8 98, i8 10, i8 0]
@str18 = private constant [8 x i8] [i8 97, i8 32, i8 33, i8 61, i8 32, i8 98, i8 10, i8 0]
@str19 = private constant [11 x i8] [i8 100, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str20 = private constant [11 x i8] [i8 100, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str21 = private constant [11 x i8] [i8 100, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str22 = private constant [11 x i8] [i8 100, i8 91, i8 51, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str23 = private constant [11 x i8] [i8 100, i8 91, i8 52, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str24 = private constant [11 x i8] [i8 100, i8 91, i8 53, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str25 = private constant [12 x i8] [i8 42, i8 112, i8 97, i8 32, i8 61, i8 61, i8 32, i8 42, i8 112, i8 98, i8 10, i8 0]
@str26 = private constant [12 x i8] [i8 42, i8 112, i8 97, i8 32, i8 33, i8 61, i8 32, i8 42, i8 112, i8 98, i8 10, i8 0]
@str27 = private constant [11 x i8] [i8 101, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str28 = private constant [11 x i8] [i8 101, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str29 = private constant [11 x i8] [i8 101, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str30 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str31 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str32 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str33 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 49, i8 48, i8 41, i8 10, i8 0]
@str34 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 50, i8 48, i8 41, i8 10, i8 0]
@str35 = private constant [25 x i8] [i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 51, i8 48, i8 41, i8 10, i8 0]
@str36 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str37 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]



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

@globalArray = global [10 x i32] [
	i32 1,
	i32 2,
	i32 3,
	i32 4,
	i32 5,
	i32 6,
	i32 7,
	i32 8,
	i32 9,
	i32 10
]

define void @f0([30 x i8]* noalias sret([30 x i8]) %0, [20 x i8] %x) {
	%2 = alloca [20 x i8]
	store [20 x i8] %x, [20 x i8]* %2
	store [20 x i8] %x, [20 x i8]* %2
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), [20 x i8]* %2)
	; truncate array
	%4 = alloca [6 x i8]
	; cast_array_to_array
	; cast_composite_to_composite
	; trunk
	%5 = alloca [20 x i8]
	store [20 x i8] %x, [20 x i8]* %5
	%6 = bitcast [20 x i8]* %5 to [6 x i8]*
	;???
	%7 = load [6 x i8], [6 x i8]* %6
	store [6 x i8] %7, [6 x i8]* %4
	; cast_array_to_array
	; cast_composite_to_composite
	; trunk
	%8 = alloca [20 x i8]
	store [20 x i8] %x, [20 x i8]* %8
	%9 = bitcast [20 x i8]* %8 to [6 x i8]*
	;???
	%10 = load [6 x i8], [6 x i8]* %9
	store [6 x i8] %10, [6 x i8]* %4
	%11 = getelementptr inbounds [6 x i8], [6 x i8]* %4, i32 0, i32 5
	store i8 0, i8* %11
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), [6 x i8]* %4)
	; extend array
	%13 = alloca [30 x i8]
	; cast_array_to_array
	; cast_composite_to_composite
	; extend
	%14 = alloca [30 x i8]
	%15 = bitcast [30 x i8]* %14 to [20 x i8]*
	store [20 x i8] %x, [20 x i8]* %15
	%16 = load [30 x i8], [30 x i8]* %14
	;???
	store [30 x i8] %16, [30 x i8]* %13
	; cast_array_to_array
	; cast_composite_to_composite
	; extend
	%17 = alloca [30 x i8]
	%18 = bitcast [30 x i8]* %17 to [20 x i8]*
	store [20 x i8] %x, [20 x i8]* %18
	%19 = load [30 x i8], [30 x i8]* %17
	;???
	store [30 x i8] %19, [30 x i8]* %13
	%20 = getelementptr inbounds [30 x i8], [30 x i8]* %13, i32 0, i32 6
	store i8 77, i8* %20
	%21 = getelementptr inbounds [30 x i8], [30 x i8]* %13, i32 0, i32 7
	store i8 111, i8* %21
	%22 = getelementptr inbounds [30 x i8], [30 x i8]* %13, i32 0, i32 8
	store i8 100, i8* %22
	%23 = getelementptr inbounds [30 x i8], [30 x i8]* %13, i32 0, i32 9
	store i8 101, i8* %23
	%24 = getelementptr inbounds [30 x i8], [30 x i8]* %13, i32 0, i32 10
	store i8 115, i8* %24
	%25 = getelementptr inbounds [30 x i8], [30 x i8]* %13, i32 0, i32 11
	store i8 116, i8* %25
	%26 = getelementptr inbounds [30 x i8], [30 x i8]* %13, i32 0, i32 12
	store i8 33, i8* %26
	%27 = getelementptr inbounds [30 x i8], [30 x i8]* %13, i32 0, i32 13
	store i8 0, i8* %27
	%28 = load [30 x i8], [30 x i8]* %13
	store [30 x i8] %28, [30 x i8]* %0
	%29 = load [30 x i8], [30 x i8]* %13
	store [30 x i8] %29, [30 x i8]* %0
	ret void
}

define %Int @main() {
	; generic array [4]Char8 will be implicit casted to [10]Char8
	%1 = alloca [30 x i8]
	%2 = insertvalue [20 x i8] zeroinitializer, i8 72, 0
	%3 = insertvalue [20 x i8] %2, i8 101, 1
	%4 = insertvalue [20 x i8] %3, i8 108, 2
	%5 = insertvalue [20 x i8] %4, i8 108, 3
	%6 = insertvalue [20 x i8] %5, i8 111, 4
	%7 = insertvalue [20 x i8] %6, i8 32, 5
	%8 = insertvalue [20 x i8] %7, i8 87, 6
	%9 = insertvalue [20 x i8] %8, i8 111, 7
	%10 = insertvalue [20 x i8] %9, i8 114, 8
	%11 = insertvalue [20 x i8] %10, i8 108, 9
	%12 = insertvalue [20 x i8] %11, i8 100, 10
	%13 = insertvalue [20 x i8] %12, i8 33, 11
	%14 = insertvalue [20 x i8] %13, i8 0, 12
	%15 = insertvalue [20 x i8] %14, i8 0, 13
	%16 = insertvalue [20 x i8] %15, i8 0, 14
	%17 = insertvalue [20 x i8] %16, i8 0, 15
	%18 = insertvalue [20 x i8] %17, i8 0, 16
	%19 = insertvalue [20 x i8] %18, i8 0, 17
	%20 = insertvalue [20 x i8] %19, i8 0, 18
	%21 = insertvalue [20 x i8] %20, i8 0, 19; alloca memory for return value
	%22 = alloca [30 x i8]
	call void ([30 x i8]*, [20 x i8]) @f0([30 x i8]* %22, [20 x i8] %21)
	%23 = load [30 x i8], [30 x i8]* %22
	store [30 x i8] %23, [30 x i8]* %1
	%24 = insertvalue [20 x i8] zeroinitializer, i8 72, 0
	%25 = insertvalue [20 x i8] %24, i8 101, 1
	%26 = insertvalue [20 x i8] %25, i8 108, 2
	%27 = insertvalue [20 x i8] %26, i8 108, 3
	%28 = insertvalue [20 x i8] %27, i8 111, 4
	%29 = insertvalue [20 x i8] %28, i8 32, 5
	%30 = insertvalue [20 x i8] %29, i8 87, 6
	%31 = insertvalue [20 x i8] %30, i8 111, 7
	%32 = insertvalue [20 x i8] %31, i8 114, 8
	%33 = insertvalue [20 x i8] %32, i8 108, 9
	%34 = insertvalue [20 x i8] %33, i8 100, 10
	%35 = insertvalue [20 x i8] %34, i8 33, 11
	%36 = insertvalue [20 x i8] %35, i8 0, 12
	%37 = insertvalue [20 x i8] %36, i8 0, 13
	%38 = insertvalue [20 x i8] %37, i8 0, 14
	%39 = insertvalue [20 x i8] %38, i8 0, 15
	%40 = insertvalue [20 x i8] %39, i8 0, 16
	%41 = insertvalue [20 x i8] %40, i8 0, 17
	%42 = insertvalue [20 x i8] %41, i8 0, 18
	%43 = insertvalue [20 x i8] %42, i8 0, 19; alloca memory for return value
	%44 = alloca [30 x i8]
	call void ([30 x i8]*, [20 x i8]) @f0([30 x i8]* %44, [20 x i8] %43)
	%45 = load [30 x i8], [30 x i8]* %44
	store [30 x i8] %45, [30 x i8]* %1
	%46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str3 to [0 x i8]*), [30 x i8]* %1)
	%47 = alloca i32
	store i32 0, i32* %47
	br label %again_1
again_1:
	%48 = load i32, i32* %47
	%49 = icmp slt i32 %48, 10
	br i1 %49 , label %body_1, label %break_1
body_1:
	%50 = load i32, i32* %47
	%51 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 %50
	%52 = load i32, i32* %51
	%53 = load i32, i32* %47
	%54 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str4 to [0 x i8]*), i32 %53, i32 %52)
	%55 = load i32, i32* %47
	%56 = add i32 %55, 1
	store i32 %56, i32* %47
	br label %again_1
break_1:
	%57 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str5 to [0 x i8]*))
	%58 = alloca [3 x i32]
	%59 = insertvalue [3 x i32] zeroinitializer, i32 4, 0
	%60 = insertvalue [3 x i32] %59, i32 5, 1
	%61 = insertvalue [3 x i32] %60, i32 6, 2
	store [3 x i32] %61, [3 x i32]* %58
	store i32 0, i32* %47
	br label %again_2
again_2:
	%62 = load i32, i32* %47
	%63 = icmp slt i32 %62, 3
	br i1 %63 , label %body_2, label %break_2
body_2:
	%64 = load i32, i32* %47
	%65 = getelementptr inbounds [3 x i32], [3 x i32]* %58, i32 0, i32 %64
	%66 = load i32, i32* %65
	%67 = load i32, i32* %47
	%68 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str6 to [0 x i8]*), i32 %67, i32 %66)
	%69 = load i32, i32* %47
	%70 = add i32 %69, 1
	store i32 %70, i32* %47
	br label %again_2
break_2:
	%71 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str7 to [0 x i8]*))
	%72 = alloca [0 x i32]*
	%73 = bitcast [10 x i32]* @globalArray to [0 x i32]*
	store [0 x i32]* %73, [0 x i32]** %72
	store i32 0, i32* %47
	br label %again_3
again_3:
	%74 = load i32, i32* %47
	%75 = icmp slt i32 %74, 3
	br i1 %75 , label %body_3, label %break_3
body_3:
	%76 = load [0 x i32]*, [0 x i32]** %72
	%77 = load i32, i32* %47
	%78 = getelementptr inbounds [0 x i32], [0 x i32]* %76, i32 0, i32 %77
	%79 = load i32, i32* %78
	%80 = load i32, i32* %47
	%81 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str8 to [0 x i8]*), i32 %80, i32 %79)
	%82 = load i32, i32* %47
	%83 = add i32 %82, 1
	store i32 %83, i32* %47
	br label %again_3
break_3:
	%84 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str9 to [0 x i8]*))
	%85 = alloca [0 x i32]*
	%86 = bitcast [3 x i32]* %58 to [0 x i32]*
	store [0 x i32]* %86, [0 x i32]** %85
	store i32 0, i32* %47
	br label %again_4
again_4:
	%87 = load i32, i32* %47
	%88 = icmp slt i32 %87, 3
	br i1 %88 , label %body_4, label %break_4
body_4:
	%89 = load [0 x i32]*, [0 x i32]** %85
	%90 = load i32, i32* %47
	%91 = getelementptr inbounds [0 x i32], [0 x i32]* %89, i32 0, i32 %90
	%92 = load i32, i32* %91
	%93 = load i32, i32* %47
	%94 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str10 to [0 x i8]*), i32 %93, i32 %92)
	%95 = load i32, i32* %47
	%96 = add i32 %95, 1
	store i32 %96, i32* %47
	br label %again_4
break_4:
	; assign array to array 1
	; (with equal types)
	%97 = alloca [3 x i32]
	%98 = insertvalue [3 x i32] zeroinitializer, i32 1, 0
	%99 = insertvalue [3 x i32] %98, i32 2, 1
	%100 = insertvalue [3 x i32] %99, i32 3, 2
	store [3 x i32] %100, [3 x i32]* %97
	%101 = getelementptr inbounds [3 x i32], [3 x i32]* %97, i32 0, i32 0
	%102 = load i32, i32* %101
	%103 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str11 to [0 x i8]*), i32 %102)
	%104 = getelementptr inbounds [3 x i32], [3 x i32]* %97, i32 0, i32 1
	%105 = load i32, i32* %104
	%106 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str12 to [0 x i8]*), i32 %105)
	%107 = getelementptr inbounds [3 x i32], [3 x i32]* %97, i32 0, i32 2
	%108 = load i32, i32* %107
	%109 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str13 to [0 x i8]*), i32 %108)
	; create (and initialize) new variable b
	; (with type [3]Int32)
	; this variable are copy of array a
	%110 = alloca [3 x i32]
	%111 = load [3 x i32], [3 x i32]* %97
	store [3 x i32] %111, [3 x i32]* %110
	%112 = load [3 x i32], [3 x i32]* %97
	store [3 x i32] %112, [3 x i32]* %110
	%113 = getelementptr inbounds [3 x i32], [3 x i32]* %110, i32 0, i32 0
	%114 = load i32, i32* %113
	%115 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str14 to [0 x i8]*), i32 %114)
	%116 = getelementptr inbounds [3 x i32], [3 x i32]* %110, i32 0, i32 1
	%117 = load i32, i32* %116
	%118 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str15 to [0 x i8]*), i32 %117)
	%119 = getelementptr inbounds [3 x i32], [3 x i32]* %110, i32 0, i32 2
	%120 = load i32, i32* %119
	%121 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str16 to [0 x i8]*), i32 %120)
	; check equality between two arrays (by value)
	%122 = bitcast [3 x i32]* %97 to i8*
	%123 = bitcast [3 x i32]* %110 to i8*
	
	%124 = call i1 (i8*, i8*, i64) @memeq( i8* %122, i8* %123, i64 12)
	%125 = icmp ne i1 %124, 0
	br i1 %125 , label %then_0, label %else_0
then_0:
	%126 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str17 to [0 x i8]*))
	br label %endif_0
else_0:
	%127 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str18 to [0 x i8]*))
	br label %endif_0
endif_0:
	; assign array to array 2
	; (with array extending)
	%128 = alloca [3 x i32]
	%129 = insertvalue [3 x i32] zeroinitializer, i32 10, 0
	%130 = insertvalue [3 x i32] %129, i32 20, 1
	%131 = insertvalue [3 x i32] %130, i32 30, 2
	store [3 x i32] %131, [3 x i32]* %128
	%132 = alloca [6 x i32]
	; cast_array_to_array
	; cast_composite_to_composite
	; JUST
	; as ptr
	%133 = bitcast [3 x i32]* %128 to [6 x i32]*
	%134 = load [6 x i32], [6 x i32]* %133
	;???
	store [6 x i32] %134, [6 x i32]* %132
	; cast_array_to_array
	; cast_composite_to_composite
	; JUST
	; as ptr
	%135 = bitcast [3 x i32]* %128 to [6 x i32]*
	%136 = load [6 x i32], [6 x i32]* %135
	;???
	store [6 x i32] %136, [6 x i32]* %132
	%137 = getelementptr inbounds [6 x i32], [6 x i32]* %132, i32 0, i32 0
	%138 = load i32, i32* %137
	%139 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str19 to [0 x i8]*), i32 %138)
	%140 = getelementptr inbounds [6 x i32], [6 x i32]* %132, i32 0, i32 1
	%141 = load i32, i32* %140
	%142 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str20 to [0 x i8]*), i32 %141)
	%143 = getelementptr inbounds [6 x i32], [6 x i32]* %132, i32 0, i32 2
	%144 = load i32, i32* %143
	%145 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str21 to [0 x i8]*), i32 %144)
	%146 = getelementptr inbounds [6 x i32], [6 x i32]* %132, i32 0, i32 3
	%147 = load i32, i32* %146
	%148 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str22 to [0 x i8]*), i32 %147)
	%149 = getelementptr inbounds [6 x i32], [6 x i32]* %132, i32 0, i32 4
	%150 = load i32, i32* %149
	%151 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str23 to [0 x i8]*), i32 %150)
	%152 = getelementptr inbounds [6 x i32], [6 x i32]* %132, i32 0, i32 5
	%153 = load i32, i32* %152
	%154 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str24 to [0 x i8]*), i32 %153)
	; check equality between two arrays (by pointer)
	%155 = bitcast [3 x i32]* %97 to i8*
	%156 = bitcast [3 x i32]* %110 to i8*
	
	%157 = call i1 (i8*, i8*, i64) @memeq( i8* %155, i8* %156, i64 12)
	%158 = icmp ne i1 %157, 0
	br i1 %158 , label %then_1, label %else_1
then_1:
	%159 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str25 to [0 x i8]*))
	br label %endif_1
else_1:
	%160 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str26 to [0 x i8]*))
	br label %endif_1
endif_1:
	;
	; Check assination local literal array
	;
	;let aa = [111] + [222] + [333]
	; cons literal array from var items
	%161 = alloca %Int
	store %Int 100, %Int* %161
	%162 = alloca %Int
	store %Int 200, %Int* %162
	%163 = alloca %Int
	store %Int 300, %Int* %163
	; immutable, non immediate value (array)
	%164 = load %Int, %Int* %161
	%165 = load %Int, %Int* %162
	%166 = load %Int, %Int* %163
	%167 = insertvalue [3 x %Int] zeroinitializer, %Int %164, 0
	%168 = insertvalue [3 x %Int] %167, %Int %165, 1
	%169 = insertvalue [3 x %Int] %168, %Int %166, 2
	%170 = alloca [3 x %Int]
	store [3 x %Int] %169, [3 x %Int]* %170
	; check local literal array assignation to local array
	%171 = alloca [4 x i32]
	; cast_array_to_array
	; cast_composite_to_composite
	; JUST
	; as ptr
	%172 = bitcast [3 x %Int]* %170 to [4 x i32]*
	%173 = load [4 x i32], [4 x i32]* %172
	;???
	store [4 x i32] %173, [4 x i32]* %171
	; cast_array_to_array
	; cast_composite_to_composite
	; JUST
	; as ptr
	%174 = bitcast [3 x %Int]* %170 to [4 x i32]*
	%175 = load [4 x i32], [4 x i32]* %174
	;???
	store [4 x i32] %175, [4 x i32]* %171
	%176 = getelementptr inbounds [4 x i32], [4 x i32]* %171, i32 0, i32 0
	%177 = load i32, i32* %176
	%178 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str27 to [0 x i8]*), i32 %177)
	%179 = getelementptr inbounds [4 x i32], [4 x i32]* %171, i32 0, i32 1
	%180 = load i32, i32* %179
	%181 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str28 to [0 x i8]*), i32 %180)
	%182 = getelementptr inbounds [4 x i32], [4 x i32]* %171, i32 0, i32 2
	%183 = load i32, i32* %182
	%184 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str29 to [0 x i8]*), i32 %183)
	; check local literal array assignation to global array
	; cast_array_to_array
	; cast_composite_to_composite
	; JUST
	; as ptr
	%185 = bitcast [3 x %Int]* %170 to [10 x i32]*
	%186 = load [10 x i32], [10 x i32]* %185
	;???
	store [10 x i32] %186, [10 x i32]* @globalArray
	; cast_array_to_array
	; cast_composite_to_composite
	; JUST
	; as ptr
	%187 = bitcast [3 x %Int]* %170 to [10 x i32]*
	%188 = load [10 x i32], [10 x i32]* %187
	;???
	store [10 x i32] %188, [10 x i32]* @globalArray
	%189 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 0
	%190 = load i32, i32* %189
	%191 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str30 to [0 x i8]*), i32 0, i32 %190)
	%192 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 1
	%193 = load i32, i32* %192
	%194 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str31 to [0 x i8]*), i32 1, i32 %193)
	%195 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 2
	%196 = load i32, i32* %195
	%197 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str32 to [0 x i8]*), i32 2, i32 %196)
	%198 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%199 = insertvalue [10 x i32] %198, i32 0, 1
	%200 = insertvalue [10 x i32] %199, i32 0, 2
	%201 = insertvalue [10 x i32] %200, i32 0, 3
	%202 = insertvalue [10 x i32] %201, i32 0, 4
	%203 = insertvalue [10 x i32] %202, i32 0, 5
	%204 = insertvalue [10 x i32] %203, i32 0, 6
	%205 = insertvalue [10 x i32] %204, i32 0, 7
	%206 = insertvalue [10 x i32] %205, i32 0, 8
	%207 = insertvalue [10 x i32] %206, i32 0, 9
	store [10 x i32] %207, [10 x i32]* @globalArray
	; проверка того как локальная константа-массив
	; "замораживает" свои элементы
	%208 = alloca i32
	store i32 10, i32* %208
	%209 = alloca i32
	store i32 20, i32* %209
	%210 = alloca i32
	store i32 30, i32* %210
	%211 = load i32, i32* %208
	%212 = load i32, i32* %209
	%213 = load i32, i32* %210
	%214 = insertvalue [3 x i32] zeroinitializer, i32 %211, 0
	%215 = insertvalue [3 x i32] %214, i32 %212, 1
	%216 = insertvalue [3 x i32] %215, i32 %213, 2
	%217 = alloca [3 x i32]
	store [3 x i32] %216, [3 x i32]* %217
	store i32 111, i32* %208
	store i32 222, i32* %209
	store i32 333, i32* %210
	%218 = getelementptr inbounds [3 x i32], [3 x i32]* %217, i32 0, i32 0
	%219 = load i32, i32* %218
	%220 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str33 to [0 x i8]*), i32 0, i32 %219)
	%221 = getelementptr inbounds [3 x i32], [3 x i32]* %217, i32 0, i32 1
	%222 = load i32, i32* %221
	%223 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str34 to [0 x i8]*), i32 1, i32 %222)
	%224 = getelementptr inbounds [3 x i32], [3 x i32]* %217, i32 0, i32 2
	%225 = load i32, i32* %224
	%226 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str35 to [0 x i8]*), i32 2, i32 %225)
	%227 = insertvalue [3 x i32] zeroinitializer, i32 10, 0
	%228 = insertvalue [3 x i32] %227, i32 20, 1
	%229 = insertvalue [3 x i32] %228, i32 30, 2
	%230 = alloca [3 x i32]
	store [3 x i32] %229, [3 x i32]* %230
	%231 = bitcast [3 x i32]* %217 to i8*
	%232 = bitcast [3 x i32]* %230 to i8*
	
	%233 = call i1 (i8*, i8*, i64) @memeq( i8* %231, i8* %232, i64 12)
	%234 = icmp ne i1 %233, 0
	br i1 %234 , label %then_2, label %else_2
then_2:
	%235 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str36 to [0 x i8]*))
	br label %endif_2
else_2:
	%236 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str37 to [0 x i8]*))
	br label %endif_2
endif_2:
	ret %Int 0
}


