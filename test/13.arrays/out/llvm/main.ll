
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
%SizeT = type i64
%SSizeT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare %Int @setvbuf(%FILE* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%FILE* %stream, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
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

@str1 = private constant [22 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str3 = private constant [21 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str5 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [38 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str7 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 80, i8 116, i8 114, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [11 x i8] [i8 98, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [11 x i8] [i8 98, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str10 = private constant [11 x i8] [i8 98, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [11 x i8] [i8 100, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str12 = private constant [11 x i8] [i8 100, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [11 x i8] [i8 100, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str14 = private constant [11 x i8] [i8 100, i8 91, i8 51, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str15 = private constant [11 x i8] [i8 100, i8 91, i8 52, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str16 = private constant [11 x i8] [i8 100, i8 91, i8 53, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]



@globalArray = global [3 x i32] [
    i32 1,
    i32 2,
    i32 3
]

define void @f0([10 x i8] %x) {
    ;
    ret void
}

define %Int @main() {
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
    %13 = icmp slt i32 %12, 3
    br i1 %13 , label %body_1, label %break_1
body_1:
    %14 = load i32, i32* %11
    %15 = getelementptr inbounds [3 x i32], [3 x i32]* @globalArray, i32 0, i32 %14
    %16 = load i32, i32* %15
    %17 = load i32, i32* %11
    %18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str1 to [0 x i8]*), i32 %17, i32 %16)
    %19 = load i32, i32* %11
    %20 = add i32 %19, 1
    store i32 %20, i32* %11
    br label %again_1
break_1:
    %21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str2 to [0 x i8]*))
    %22 = alloca [3 x i32]
    %23 = bitcast [3 x i32]* %22 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %23, i8 0, i32 12, i1 0)
    %24 = insertvalue [3 x i32] zeroinitializer, i32 4, 0
    %25 = insertvalue [3 x i32] %24, i32 5, 1
    %26 = insertvalue [3 x i32] %25, i32 6, 2
    store [3 x i32] %26, [3 x i32]* %22
    store i32 0, i32* %11
    br label %again_2
again_2:
    %27 = load i32, i32* %11
    %28 = icmp slt i32 %27, 3
    br i1 %28 , label %body_2, label %break_2
body_2:
    %29 = load i32, i32* %11
    %30 = getelementptr inbounds [3 x i32], [3 x i32]* %22, i32 0, i32 %29
    %31 = load i32, i32* %30
    %32 = load i32, i32* %11
    %33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*), i32 %32, i32 %31)
    %34 = load i32, i32* %11
    %35 = add i32 %34, 1
    store i32 %35, i32* %11
    br label %again_2
break_2:
    %36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str4 to [0 x i8]*))
    %37 = alloca [0 x i32]*
    %38 = bitcast [3 x i32]* @globalArray to [0 x i32]*
    store [0 x i32]* %38, [0 x i32]** %37
    store i32 0, i32* %11
    br label %again_3
again_3:
    %39 = load i32, i32* %11
    %40 = icmp slt i32 %39, 3
    br i1 %40 , label %body_3, label %break_3
body_3:
    %41 = load [0 x i32]*, [0 x i32]** %37
    %42 = load i32, i32* %11
    %43 = getelementptr inbounds [0 x i32], [0 x i32]* %41, i32 0, i32 %42
    %44 = load i32, i32* %43
    %45 = load i32, i32* %11
    %46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str5 to [0 x i8]*), i32 %45, i32 %44)
    %47 = load i32, i32* %11
    %48 = add i32 %47, 1
    store i32 %48, i32* %11
    br label %again_3
break_3:
    %49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str6 to [0 x i8]*))
    %50 = alloca [0 x i32]*
    %51 = bitcast [3 x i32]* %22 to [0 x i32]*
    store [0 x i32]* %51, [0 x i32]** %50
    store i32 0, i32* %11
    br label %again_4
again_4:
    %52 = load i32, i32* %11
    %53 = icmp slt i32 %52, 3
    br i1 %53 , label %body_4, label %break_4
body_4:
    %54 = load [0 x i32]*, [0 x i32]** %50
    %55 = load i32, i32* %11
    %56 = getelementptr inbounds [0 x i32], [0 x i32]* %54, i32 0, i32 %55
    %57 = load i32, i32* %56
    %58 = load i32, i32* %11
    %59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str7 to [0 x i8]*), i32 %58, i32 %57)
    %60 = load i32, i32* %11
    %61 = add i32 %60, 1
    store i32 %61, i32* %11
    br label %again_4
break_4:
    ; 1. В LLVM нехрен создавать локальные массивы как insertvalue
    ; assign array to array 1
    ; (with equal types)
    %62 = alloca [3 x i32]
    %63 = bitcast [3 x i32]* %62 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %63, i8 0, i32 12, i1 0)
    %64 = insertvalue [3 x i32] zeroinitializer, i32 1, 0
    %65 = insertvalue [3 x i32] %64, i32 2, 1
    %66 = insertvalue [3 x i32] %65, i32 3, 2
    store [3 x i32] %66, [3 x i32]* %62
    %67 = alloca [3 x i32]
    %68 = bitcast [3 x i32]* %67 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %68, i8 0, i32 12, i1 0)
    %69 = bitcast [3 x i32]* %67 to i8*
    %70 = bitcast [3 x i32]* %62 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %69, i8* %70, i32 12, i1 0)
    %71 = getelementptr inbounds [3 x i32], [3 x i32]* %67, i32 0, i32 0
    %72 = load i32, i32* %71
    %73 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str8 to [0 x i8]*), i32 %72)
    %74 = getelementptr inbounds [3 x i32], [3 x i32]* %67, i32 0, i32 1
    %75 = load i32, i32* %74
    %76 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str9 to [0 x i8]*), i32 %75)
    %77 = getelementptr inbounds [3 x i32], [3 x i32]* %67, i32 0, i32 2
    %78 = load i32, i32* %77
    %79 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str10 to [0 x i8]*), i32 %78)
    ; assign array to array 2
    ; (with array extending)
    %80 = alloca [3 x i32]
    %81 = bitcast [3 x i32]* %80 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %81, i8 0, i32 12, i1 0)
    %82 = insertvalue [3 x i32] zeroinitializer, i32 10, 0
    %83 = insertvalue [3 x i32] %82, i32 20, 1
    %84 = insertvalue [3 x i32] %83, i32 30, 2
    store [3 x i32] %84, [3 x i32]* %80
    %85 = alloca [6 x i32]
    %86 = bitcast [6 x i32]* %85 to i8*
    call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %86, i8 0, i32 24, i1 0)
    %87 = bitcast [6 x i32]* %85 to i8*
    %88 = bitcast [3 x i32]* %80 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %87, i8* %88, i32 12, i1 0)
    %89 = getelementptr inbounds [6 x i32], [6 x i32]* %85, i32 0, i32 0
    %90 = load i32, i32* %89
    %91 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str11 to [0 x i8]*), i32 %90)
    %92 = getelementptr inbounds [6 x i32], [6 x i32]* %85, i32 0, i32 1
    %93 = load i32, i32* %92
    %94 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str12 to [0 x i8]*), i32 %93)
    %95 = getelementptr inbounds [6 x i32], [6 x i32]* %85, i32 0, i32 2
    %96 = load i32, i32* %95
    %97 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str13 to [0 x i8]*), i32 %96)
    %98 = getelementptr inbounds [6 x i32], [6 x i32]* %85, i32 0, i32 3
    %99 = load i32, i32* %98
    %100 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str14 to [0 x i8]*), i32 %99)
    %101 = getelementptr inbounds [6 x i32], [6 x i32]* %85, i32 0, i32 4
    %102 = load i32, i32* %101
    %103 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str15 to [0 x i8]*), i32 %102)
    %104 = getelementptr inbounds [6 x i32], [6 x i32]* %85, i32 0, i32 5
    %105 = load i32, i32* %104
    %106 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str16 to [0 x i8]*), i32 %105)
    ret %Int 0
}


