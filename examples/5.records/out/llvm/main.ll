
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float32 = type float
%Float64 = type double
%Fixed32 = type i32
%Fixed64 = type i64
%Size = type i64
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)


; MODULE: main

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type %Int64;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included math
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
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [15 x i8] [i8 112, i8 111, i8 105, i8 110, i8 116, i8 40, i8 37, i8 102, i8 44, i8 32, i8 37, i8 102, i8 41, i8 10, i8 0]
@.str2 = private constant [18 x i8] [i8 108, i8 105, i8 110, i8 101, i8 32, i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
; -- endstrings --
%Point = type {
	%Float,
	%Float
};

%Line = type {
	%Point,
	%Point
};

@line = internal global %Line {
	%Point {
		%Float 0.0000000000000000,
		%Float 0.0000000000000000
	},
	%Point {
		%Float 1.0000000000000000,
		%Float 1.0000000000000000
	}
}
define internal %Float @max(%Float %a, %Float %b) alwaysinline {
; if_0
	%1 = fcmp ogt %Float %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Float %a
	br label %endif_0
endif_0:
	ret %Float %b
}

define internal %Float @min(%Float %a, %Float %b) alwaysinline {
; if_0
	%1 = fcmp olt %Float %a, %b
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Float %a
	br label %endif_0
endif_0:
	ret %Float %b
}

define internal %Float @distance(%Point %__a, %Point %__b) {
	%a = alloca %Point
	store %Point %__a, %Point* %a
	%b = alloca %Point
	store %Point %__b, %Point* %b
	%1 = getelementptr %Point, %Point* %a, %Int32 0, %Int32 0
	%2 = load %Float, %Float* %1
	%3 = getelementptr %Point, %Point* %b, %Int32 0, %Int32 0
	%4 = load %Float, %Float* %3
	%5 = call %Float @max(%Float %2, %Float %4)
	%6 = getelementptr %Point, %Point* %a, %Int32 0, %Int32 0
	%7 = load %Float, %Float* %6
	%8 = getelementptr %Point, %Point* %b, %Int32 0, %Int32 0
	%9 = load %Float, %Float* %8
	%10 = call %Float @min(%Float %7, %Float %9)
	%11 = fsub %Float %5, %10
	%12 = getelementptr %Point, %Point* %a, %Int32 0, %Int32 1
	%13 = load %Float, %Float* %12
	%14 = getelementptr %Point, %Point* %b, %Int32 0, %Int32 1
	%15 = load %Float, %Float* %14
	%16 = call %Float @max(%Float %13, %Float %15)
	%17 = getelementptr %Point, %Point* %a, %Int32 0, %Int32 1
	%18 = load %Float, %Float* %17
	%19 = getelementptr %Point, %Point* %b, %Int32 0, %Int32 1
	%20 = load %Float, %Float* %19
	%21 = call %Float @min(%Float %18, %Float %20)
	%22 = fsub %Float %16, %21
	%23 = call %Double @pow(%Float %11, %Double 2.0000000000000000)
	%24 = call %Double @pow(%Float %22, %Double 2.0000000000000000)
	%25 = fadd %Double %23, %24
	%26 = call %Double @sqrt(%Double %25)
	ret %Double %26
}

define internal %Float @lineLength(%Line %__line) {
	%line = alloca %Line
	store %Line %__line, %Line* %line
	%1 = getelementptr %Line, %Line* %line, %Int32 0, %Int32 0
	%2 = load %Point, %Point* %1
	%3 = getelementptr %Line, %Line* %line, %Int32 0, %Int32 1
	%4 = load %Point, %Point* %3
	%5 = call %Float @distance(%Point %2, %Point %4)
	ret %Float %5
}

define internal void @ptr_example() {
	%1 = call i8* @malloc(%Size 16)
	%2 = bitcast i8* %1 to %Point*
	%3 = getelementptr %Point, %Point* %2, %Int32 0, %Int32 0
	store %Float 10.0000000000000000, %Float* %3
	%4 = getelementptr %Point, %Point* %2, %Int32 0, %Int32 1
	store %Float 20.0000000000000000, %Float* %4
	%5 = getelementptr %Point, %Point* %2, %Int32 0, %Int32 0
	%6 = load %Float, %Float* %5
	%7 = getelementptr %Point, %Point* %2, %Int32 0, %Int32 1
	%8 = load %Float, %Float* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str1 to [0 x i8]*), %Float %6, %Float %8)
	ret void
}

define %Int @main() {
	%1 = load %Line, %Line* @line
	%2 = call %Float @lineLength(%Line %1)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str2 to [0 x i8]*), %Float %2)
	call void @ptr_example()
	ret %Int 0
}


