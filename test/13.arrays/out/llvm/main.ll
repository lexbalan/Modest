
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
@str2 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str3 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str4 = private constant [21 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str5 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str6 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str8 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [11 x i8] [i8 97, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str10 = private constant [11 x i8] [i8 97, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [11 x i8] [i8 97, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str12 = private constant [11 x i8] [i8 98, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [11 x i8] [i8 98, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str14 = private constant [11 x i8] [i8 98, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str15 = private constant [8 x i8] [i8 97, i8 32, i8 61, i8 61, i8 32, i8 98, i8 10, i8 0]
@str16 = private constant [8 x i8] [i8 97, i8 32, i8 33, i8 61, i8 32, i8 98, i8 10, i8 0]
@str17 = private constant [11 x i8] [i8 100, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str18 = private constant [11 x i8] [i8 100, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str19 = private constant [11 x i8] [i8 100, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str20 = private constant [11 x i8] [i8 100, i8 91, i8 51, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str21 = private constant [11 x i8] [i8 100, i8 91, i8 52, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str22 = private constant [11 x i8] [i8 100, i8 91, i8 53, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str23 = private constant [11 x i8] [i8 101, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str24 = private constant [11 x i8] [i8 101, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str25 = private constant [11 x i8] [i8 101, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str26 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str27 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str28 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]



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

define void @f0([10 x i8] %x) {
	%1 = alloca [10 x i8]
	store [10 x i8] %x, [10 x i8]* %1
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), [10 x i8]* %1)
	ret void
}

define %Int @main() {
	; generic array [4]Char8 will be implicit casted to [10]Char8
	%1 = insertvalue [10 x i8] zeroinitializer, i8 104, 0
	%2 = insertvalue [10 x i8] %1, i8 105, 1
	%3 = insertvalue [10 x i8] %2, i8 33, 2
	%4 = insertvalue [10 x i8] %3, i8 0, 3
	%5 = insertvalue [10 x i8] %4, i8 0, 4
	%6 = insertvalue [10 x i8] %5, i8 0, 5
	%7 = insertvalue [10 x i8] %6, i8 0, 6
	%8 = insertvalue [10 x i8] %7, i8 0, 7
	%9 = insertvalue [10 x i8] %8, i8 0, 8
	%10 = insertvalue [10 x i8] %9, i8 0, 9
	call void ([10 x i8]) @f0([10 x i8] %10)
	%11 = alloca i32
	store i32 0, i32* %11
	br label %again_1
again_1:
	%12 = load i32, i32* %11
	%13 = icmp slt i32 %12, 10
	br i1 %13 , label %body_1, label %break_1
body_1:
	%14 = load i32, i32* %11
	%15 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 %14
	%16 = load i32, i32* %15
	%17 = load i32, i32* %11
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str2 to [0 x i8]*), i32 %17, i32 %16)
	%19 = load i32, i32* %11
	%20 = add i32 %19, 1
	store i32 %20, i32* %11
	br label %again_1
break_1:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str3 to [0 x i8]*))
	%22 = alloca [3 x i32]
	%23 = insertvalue [3 x i32] zeroinitializer, i32 4, 0
	%24 = insertvalue [3 x i32] %23, i32 5, 1
	%25 = insertvalue [3 x i32] %24, i32 6, 2
	store [3 x i32] %25, [3 x i32]* %22
	store i32 0, i32* %11
	br label %again_2
again_2:
	%26 = load i32, i32* %11
	%27 = icmp slt i32 %26, 3
	br i1 %27 , label %body_2, label %break_2
body_2:
	%28 = load i32, i32* %11
	%29 = getelementptr inbounds [3 x i32], [3 x i32]* %22, i32 0, i32 %28
	%30 = load i32, i32* %29
	%31 = load i32, i32* %11
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str4 to [0 x i8]*), i32 %31, i32 %30)
	%33 = load i32, i32* %11
	%34 = add i32 %33, 1
	store i32 %34, i32* %11
	br label %again_2
break_2:
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str5 to [0 x i8]*))
	%36 = alloca [0 x i32]*
	%37 = bitcast [10 x i32]* @globalArray to [0 x i32]*
	store [0 x i32]* %37, [0 x i32]** %36
	store i32 0, i32* %11
	br label %again_3
again_3:
	%38 = load i32, i32* %11
	%39 = icmp slt i32 %38, 3
	br i1 %39 , label %body_3, label %break_3
body_3:
	%40 = load [0 x i32]*, [0 x i32]** %36
	%41 = load i32, i32* %11
	%42 = getelementptr inbounds [0 x i32], [0 x i32]* %40, i32 0, i32 %41
	%43 = load i32, i32* %42
	%44 = load i32, i32* %11
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str6 to [0 x i8]*), i32 %44, i32 %43)
	%46 = load i32, i32* %11
	%47 = add i32 %46, 1
	store i32 %47, i32* %11
	br label %again_3
break_3:
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str7 to [0 x i8]*))
	%49 = alloca [0 x i32]*
	%50 = bitcast [3 x i32]* %22 to [0 x i32]*
	store [0 x i32]* %50, [0 x i32]** %49
	store i32 0, i32* %11
	br label %again_4
again_4:
	%51 = load i32, i32* %11
	%52 = icmp slt i32 %51, 3
	br i1 %52 , label %body_4, label %break_4
body_4:
	%53 = load [0 x i32]*, [0 x i32]** %49
	%54 = load i32, i32* %11
	%55 = getelementptr inbounds [0 x i32], [0 x i32]* %53, i32 0, i32 %54
	%56 = load i32, i32* %55
	%57 = load i32, i32* %11
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str8 to [0 x i8]*), i32 %57, i32 %56)
	%59 = load i32, i32* %11
	%60 = add i32 %59, 1
	store i32 %60, i32* %11
	br label %again_4
break_4:
	; assign array to array 1
	; (with equal types)
	%61 = alloca [3 x i32]
	%62 = insertvalue [3 x i32] zeroinitializer, i32 1, 0
	%63 = insertvalue [3 x i32] %62, i32 2, 1
	%64 = insertvalue [3 x i32] %63, i32 3, 2
	store [3 x i32] %64, [3 x i32]* %61
	%65 = getelementptr inbounds [3 x i32], [3 x i32]* %61, i32 0, i32 0
	%66 = load i32, i32* %65
	%67 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str9 to [0 x i8]*), i32 %66)
	%68 = getelementptr inbounds [3 x i32], [3 x i32]* %61, i32 0, i32 1
	%69 = load i32, i32* %68
	%70 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str10 to [0 x i8]*), i32 %69)
	%71 = getelementptr inbounds [3 x i32], [3 x i32]* %61, i32 0, i32 2
	%72 = load i32, i32* %71
	%73 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str11 to [0 x i8]*), i32 %72)
	; create (and initialize) new variable b
	; (with type [3]Int32)
	; this variable are copy of array a
	%74 = alloca [3 x i32]
	%75 = bitcast [3 x i32]* %74 to i8*
	%76 = bitcast [3 x i32]* %61 to i8*
	call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %75, i8* %76, i32 12, i1 0)
	%77 = getelementptr inbounds [3 x i32], [3 x i32]* %74, i32 0, i32 0
	%78 = load i32, i32* %77
	%79 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str12 to [0 x i8]*), i32 %78)
	%80 = getelementptr inbounds [3 x i32], [3 x i32]* %74, i32 0, i32 1
	%81 = load i32, i32* %80
	%82 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str13 to [0 x i8]*), i32 %81)
	%83 = getelementptr inbounds [3 x i32], [3 x i32]* %74, i32 0, i32 2
	%84 = load i32, i32* %83
	%85 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str14 to [0 x i8]*), i32 %84)
	; check equality between two arrays (by value)
	%86 = bitcast [3 x i32]* %61 to i8*
	%87 = bitcast [3 x i32]* %74 to i8*
	
	%88 = call i1 (i8*, i8*, i64) @memeq( i8* %86, i8* %87, i64 12)
	%89 = icmp ne i1 %88, 0
	br i1 %89 , label %then_0, label %else_0
then_0:
	%90 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str15 to [0 x i8]*))
	br label %endif_0
else_0:
	%91 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str16 to [0 x i8]*))
	br label %endif_0
endif_0:
	; assign array to array 2
	; (with array extending)
	%92 = alloca [3 x i32]
	%93 = insertvalue [3 x i32] zeroinitializer, i32 10, 0
	%94 = insertvalue [3 x i32] %93, i32 20, 1
	%95 = insertvalue [3 x i32] %94, i32 30, 2
	store [3 x i32] %95, [3 x i32]* %92
	%96 = alloca [6 x i32]
	%97 = bitcast [6 x i32]* %96 to i8*
	%98 = bitcast [3 x i32]* %92 to i8*
	call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %97, i8* %98, i32 12, i1 0)
	%99 = ptrtoint [6 x i32]* %96 to i64
	%100 = add i64 %99, 12
	%101 = inttoptr i64 %100 to i8*
	%102 = bitcast i8* %101 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %102, i8 0, i32 12, i1 0)
	%103 = getelementptr inbounds [6 x i32], [6 x i32]* %96, i32 0, i32 0
	%104 = load i32, i32* %103
	%105 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str17 to [0 x i8]*), i32 %104)
	%106 = getelementptr inbounds [6 x i32], [6 x i32]* %96, i32 0, i32 1
	%107 = load i32, i32* %106
	%108 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str18 to [0 x i8]*), i32 %107)
	%109 = getelementptr inbounds [6 x i32], [6 x i32]* %96, i32 0, i32 2
	%110 = load i32, i32* %109
	%111 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str19 to [0 x i8]*), i32 %110)
	%112 = getelementptr inbounds [6 x i32], [6 x i32]* %96, i32 0, i32 3
	%113 = load i32, i32* %112
	%114 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str20 to [0 x i8]*), i32 %113)
	%115 = getelementptr inbounds [6 x i32], [6 x i32]* %96, i32 0, i32 4
	%116 = load i32, i32* %115
	%117 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str21 to [0 x i8]*), i32 %116)
	%118 = getelementptr inbounds [6 x i32], [6 x i32]* %96, i32 0, i32 5
	%119 = load i32, i32* %118
	%120 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str22 to [0 x i8]*), i32 %119)
	;
	; Check assination local literal array
	;
	;let aa = [111] + [222] + [333]
	; cons literal array from var items
	%121 = alloca %Int
	store %Int 100, %Int* %121
	%122 = alloca %Int
	store %Int 200, %Int* %122
	%123 = alloca %Int
	store %Int 300, %Int* %123
	; immutable, non immediate value (array)
	%124 = load %Int, %Int* %121
	%125 = load %Int, %Int* %122
	%126 = load %Int, %Int* %123
	%127 = insertvalue [3 x %Int] zeroinitializer, %Int %124, 0
	%128 = insertvalue [3 x %Int] %127, %Int %125, 1
	%129 = insertvalue [3 x %Int] %128, %Int %126, 2
	%130 = alloca [3 x %Int]
	store [3 x %Int] %129, [3 x %Int]* %130
	; check local literal array assignation to local array
	%131 = alloca [4 x i32]
	%132 = bitcast [4 x i32]* %131 to i8*
	%133 = bitcast [3 x %Int]* %130 to i8*
	call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %132, i8* %133, i32 12, i1 0)
	%134 = ptrtoint [4 x i32]* %131 to i64
	%135 = add i64 %134, 12
	%136 = inttoptr i64 %135 to i8*
	%137 = bitcast i8* %136 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %137, i8 0, i32 4, i1 0)
	%138 = getelementptr inbounds [4 x i32], [4 x i32]* %131, i32 0, i32 0
	%139 = load i32, i32* %138
	%140 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str23 to [0 x i8]*), i32 %139)
	%141 = getelementptr inbounds [4 x i32], [4 x i32]* %131, i32 0, i32 1
	%142 = load i32, i32* %141
	%143 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str24 to [0 x i8]*), i32 %142)
	%144 = getelementptr inbounds [4 x i32], [4 x i32]* %131, i32 0, i32 2
	%145 = load i32, i32* %144
	%146 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str25 to [0 x i8]*), i32 %145)
	; check local literal array assignation to global array
	%147 = bitcast [10 x i32]* @globalArray to i8*
	%148 = bitcast [3 x %Int]* %130 to i8*
	call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %147, i8* %148, i32 12, i1 0)
	%149 = ptrtoint [10 x i32]* @globalArray to i64
	%150 = add i64 %149, 12
	%151 = inttoptr i64 %150 to i8*
	%152 = bitcast i8* %151 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %152, i8 0, i32 28, i1 0)
	%153 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 0
	%154 = load i32, i32* %153
	%155 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str26 to [0 x i8]*), i32 0, i32 %154)
	%156 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 1
	%157 = load i32, i32* %156
	%158 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str27 to [0 x i8]*), i32 1, i32 %157)
	%159 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray, i32 0, i32 2
	%160 = load i32, i32* %159
	%161 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str28 to [0 x i8]*), i32 2, i32 %160)
	ret %Int 0
}


