
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
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
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
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
; -- end print includes --
; -- print imports 'main' --
; -- 1

; from import "minmax"
declare %Int32 @minmax_min_int32(%Int32 %a, %Int32 %b)
declare %Int32 @minmax_max_int32(%Int32 %a, %Int32 %b)
declare %Int64 @minmax_min_int64(%Int64 %a, %Int64 %b)
declare %Int64 @minmax_max_int64(%Int64 %a, %Int64 %b)
declare %Nat32 @minmax_min_nat32(%Nat32 %a, %Nat32 %b)
declare %Nat32 @minmax_max_nat32(%Nat32 %a, %Nat32 %b)
declare %Nat64 @minmax_min_nat64(%Nat64 %a, %Nat64 %b)
declare %Nat64 @minmax_max_nat64(%Nat64 %a, %Nat64 %b)
declare %Float32 @minmax_min_float32(%Float32 %a, %Float32 %b)
declare %Float32 @minmax_max_float32(%Float32 %a, %Float32 %b)
declare %Float64 @minmax_min_float64(%Float64 %a, %Float64 %b)
declare %Float64 @minmax_max_float64(%Float64 %a, %Float64 %b)

; end from import "minmax"
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [18 x i8] [i8 108, i8 105, i8 110, i8 101, i8 115, i8 95, i8 48, i8 95, i8 108, i8 101, i8 110, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str2 = private constant [18 x i8] [i8 108, i8 105, i8 110, i8 101, i8 115, i8 95, i8 49, i8 95, i8 108, i8 101, i8 110, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
; -- endstrings --; tests/10.const/src/main.m
@carr = constant [6 x i8] [
	i8 0,
	i8 10,
	i8 15,
	i8 20,
	i8 25,
	i8 30
]
%Point = type {
	%Float64,
	%Float64
};

%Line = type {
	%Point,
	%Point
};

@lines = constant [4 x %Line] [
	%Line {
		%Point {
			%Float64 0.0000000000000000,
			%Float64 0.0000000000000000
		},
		%Point {
			%Float64 1.0000000000000000,
			%Float64 1.0000000000000000
		}
	},
	%Line {
		%Point {
			%Float64 10.0000000000000000,
			%Float64 20.0000000000000000
		},
		%Point {
			%Float64 30.0000000000000000,
			%Float64 40.0000000000000000
		}
	},
	%Line {
		%Point {
			%Float64 0.0000000000000000,
			%Float64 0.0000000000000000
		},
		%Point {
			%Float64 1.0000000000000000,
			%Float64 1.0000000000000000
		}
	},
	%Line {
		%Point {
			%Float64 10.0000000000000000,
			%Float64 20.0000000000000000
		},
		%Point {
			%Float64 30.0000000000000000,
			%Float64 40.0000000000000000
		}
	}
]
%WrappedArray = type {
	%Int32
};



; Pythagorean theorem
define internal %Float @distance(%Point %a, %Point %b) {
	%1 = extractvalue %Point %a, 0
	%2 = extractvalue %Point %b, 0
	%3 = call %Float64 @minmax_max_float64(%Float64 %1, %Float64 %2)
	%4 = extractvalue %Point %a, 0
	%5 = extractvalue %Point %b, 0
	%6 = call %Float64 @minmax_min_float64(%Float64 %4, %Float64 %5)
	%7 = fsub %Float64 %3, %6
	%8 = extractvalue %Point %a, 1
	%9 = extractvalue %Point %b, 1
	%10 = call %Float64 @minmax_max_float64(%Float64 %8, %Float64 %9)
	%11 = extractvalue %Point %a, 1
	%12 = extractvalue %Point %b, 1
	%13 = call %Float64 @minmax_min_float64(%Float64 %11, %Float64 %12)
	%14 = fsub %Float64 %10, %13
	%15 = call %Double @pow(%Float64 %7, %Double 2.0000000000000000)
	%16 = call %Double @pow(%Float64 %14, %Double 2.0000000000000000)
	%17 = fadd %Double %15, %16
	%18 = call %Double @sqrt(%Double %17)
	ret %Double %18
}

define internal %Float @lineLength(%Line %line) {
	%1 = extractvalue %Line %line, 0
	%2 = extractvalue %Line %line, 1
	%3 = call %Float @distance(%Point %1, %Point %2)
	ret %Float %3
}

define %Int @main() {
	%1 = insertvalue %Point zeroinitializer, %Float64 1.0000000000000000, 0
	%2 = insertvalue %Point %1, %Float64 1.0000000000000000, 1
	%3 = insertvalue %Line zeroinitializer, %Point %2, 1
	%4 = call %Float @lineLength(%Line %3)
	%5 = insertvalue %Point zeroinitializer, %Float64 10.0000000000000000, 0
	%6 = insertvalue %Point %5, %Float64 20.0000000000000000, 1
	%7 = insertvalue %Line zeroinitializer, %Point %6, 0
	%8 = insertvalue %Point zeroinitializer, %Float64 30.0000000000000000, 0
	%9 = insertvalue %Point %8, %Float64 40.0000000000000000, 1
	%10 = insertvalue %Line %7, %Point %9, 1
	%11 = call %Float @lineLength(%Line %10)
	%12 = insertvalue %Point zeroinitializer, %Float64 1.0000000000000000, 0
	%13 = insertvalue %Point %12, %Float64 1.0000000000000000, 1
	%14 = insertvalue %Line zeroinitializer, %Point %13, 1
	%15 = call %Float @lineLength(%Line %14)
	%16 = insertvalue %Point zeroinitializer, %Float64 10.0000000000000000, 0
	%17 = insertvalue %Point %16, %Float64 20.0000000000000000, 1
	%18 = insertvalue %Line zeroinitializer, %Point %17, 0
	%19 = insertvalue %Point zeroinitializer, %Float64 30.0000000000000000, 0
	%20 = insertvalue %Point %19, %Float64 40.0000000000000000, 1
	%21 = insertvalue %Line %18, %Point %20, 1
	%22 = call %Float @lineLength(%Line %21)
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str1 to [0 x i8]*), %Float %4)
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str2 to [0 x i8]*), %Float %11)

	;	let y = wa.x

	;	var i: Nat32 = 0
	;	while i < 10 {
	;		let x = wa.array[i]
	;		printf("x[%d]=%d\n", i, x)
	;		++i
	;	}
	ret %Int 0
}


