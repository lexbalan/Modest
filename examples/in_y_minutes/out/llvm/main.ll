
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
%Float = type %Float32;
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

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [16 x i8] [i8 109, i8 111, i8 100, i8 101, i8 115, i8 116, i8 32, i8 115, i8 97, i8 121, i8 115, i8 32, i8 104, i8 105, i8 10, i8 0]
@.str2 = private constant [26 x i8] [i8 119, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 120, i8 32, i8 45, i8 62, i8 32, i8 97, i8 115, i8 73, i8 110, i8 116, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@.str3 = private constant [13 x i8] [i8 104, i8 101, i8 105, i8 103, i8 104, i8 116, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str4 = private constant [15 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 44, i8 32, i8 77, i8 111, i8 100, i8 101, i8 115, i8 116, i8 33, i8 0]
@.str5 = private constant [21 x i8] [i8 37, i8 115, i8 32, i8 40, i8 115, i8 116, i8 97, i8 114, i8 116, i8 115, i8 32, i8 119, i8 105, i8 116, i8 104, i8 32, i8 37, i8 99, i8 41, i8 10, i8 0]
@.str6 = private constant [4 x i8] [i8 37, i8 100, i8 32, i8 0]
@.str7 = private constant [2 x i8] [i8 10, i8 0]
@.str8 = private constant [15 x i8] [i8 100, i8 105, i8 115, i8 116, i8 97, i8 110, i8 99, i8 101, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str9 = private constant [10 x i8] [i8 112, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str10 = private constant [16 x i8] [i8 99, i8 111, i8 108, i8 111, i8 114, i8 32, i8 105, i8 115, i8 32, i8 103, i8 114, i8 101, i8 101, i8 110, i8 10, i8 0]
@.str11 = private constant [12 x i8] [i8 117, i8 32, i8 124, i8 32, i8 118, i8 32, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@.str12 = private constant [8 x i8] [i8 107, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str13 = private constant [8 x i8] [i8 106, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str14 = private constant [13 x i8] [i8 108, i8 111, i8 103, i8 105, i8 99, i8 32, i8 119, i8 111, i8 114, i8 107, i8 115, i8 10, i8 0]
@.str15 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@.str16 = private constant [16 x i8] [i8 115, i8 117, i8 109, i8 40, i8 48, i8 46, i8 46, i8 53, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --

; This is a line comment. There are no block comments.; sqrt

; `include` pastes a module's names directly into scope — used for C
; bindings and library modules. `import "mymodule"` instead requires a
; `mymodule.` prefix on every name it brings in (see docs/lang).


; --- Types ------------------------------------------------------------------
;
; PascalCase for types, camelCase for everything else. Base types: Bool,
; IntX/NatX/WordX (8/16/32/64/128 — signed/unsigned/bitwise), CharX (8/16/32),
; FloatX (32/64), Str8/Str16/Str32 (= []CharX), Int/Nat/Word (target width).
%Point = type {
	%Float64,
	%Float64
};

%Meters = type %Float64;
%Color = type %Nat8;
%Action = type void ();


; --- Functions ----------------------------------------------------------------
define internal %Float64 @distance(%Point %__a, %Point %__b) alwaysinline {
	%a = alloca %Point
	store %Point %__a, %Point* %a
	%b = alloca %Point
	store %Point %__b, %Point* %b
	%1 = getelementptr %Point, %Point* %a, %Int32 0, %Int32 0
	%2 = getelementptr %Point, %Point* %b, %Int32 0, %Int32 0
	%3 = load %Float64, %Float64* %1
	%4 = load %Float64, %Float64* %2
	%5 = fsub %Float64 %3, %4
	%6 = getelementptr %Point, %Point* %a, %Int32 0, %Int32 1
	%7 = getelementptr %Point, %Point* %b, %Int32 0, %Int32 1
	%8 = load %Float64, %Float64* %6
	%9 = load %Float64, %Float64* %7
	%10 = fsub %Float64 %8, %9
	%11 = fmul %Float64 %5, %5
	%12 = fmul %Float64 %10, %10
	%13 = fadd %Float64 %11, %12
	%14 = call %Double @sqrt(%Float64 %13)
	ret %Double %14
}

define internal %Int32 @sum(%Int32 %n) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	%2 = alloca %Int32, align 4
	store %Int32 0, %Int32* %2
; while_1
	br label %again_1
again_1:
	%3 = load %Int32, %Int32* %2
	%4 = icmp slt %Int32 %3, %n
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = load %Int32, %Int32* %1
	%6 = load %Int32, %Int32* %2
	%7 = add %Int32 %5, %6
	store %Int32 %7, %Int32* %1
	%8 = load %Int32, %Int32* %2
	%9 = add %Int32 %8, 1
	store %Int32 %9, %Int32* %2
	br label %again_1
break_1:
	%10 = load %Int32, %Int32* %1
	ret %Int32 %10
}

define internal void @announce() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str1 to [0 x i8]*))
	ret void
}

define %Int @main() {
	%1 = alloca %Int32, align 4
	store %Int32 42, %Int32* %1
	%2 = alloca %Float64, align 8
	store %Float64 3.1415899999999999, %Float64* %2
	%3 = alloca %Int32, align 4
	store %Int32 10, %Int32* %3
	store %Int32 20, %Int32* %3
	%4 = alloca %Int32, align 4
	store %Int32 40, %Int32* %4
	%5 = alloca %Word64, align 8
	store %Word64 9223372036854775808, %Word64* %5
	%6 = alloca %Int64, align 8
	%7 = load %Word64, %Word64* %5
	%8 = bitcast %Word64 %7 to %Int64
	store %Int64 %8, %Int64* %6
	%9 = load %Word64, %Word64* %5
	%10 = load %Int64, %Int64* %6
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str2 to [0 x i8]*), %Word64 %9, %Int64 %10)
	%12 = alloca %Meters, align 8
	store %Meters 1.8000000000000000, %Meters* %12
	%13 = load %Meters, %Meters* %12
	%14 = bitcast %Meters %13 to %Float64
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str3 to [0 x i8]*), %Float64 %14)
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str5 to [0 x i8]*), %Str8* bitcast ([15 x i8]* @.str4 to [0 x i8]*), %Char8 77)
	%17 = alloca [5 x %Int32], align 4
	%18 = insertvalue [5 x %Int32] zeroinitializer, %Int32 1, 0
	%19 = insertvalue [5 x %Int32] %18, %Int32 2, 1
	%20 = insertvalue [5 x %Int32] %19, %Int32 3, 2
	%21 = insertvalue [5 x %Int32] %20, %Int32 4, 3
	%22 = insertvalue [5 x %Int32] %21, %Int32 5, 4
	%23 = zext i8 5 to %Nat32
	store [5 x %Int32] %22, [5 x %Int32]* %17
	%24 = alloca [2 x %Int32], align 4
	%25 = zext i8 1 to %Nat32
	%26 = getelementptr [5 x %Int32], [5 x %Int32]* %17, %Int32 0, %Nat32 %25
	%27 = bitcast %Int32* %26 to [2 x %Int32]*
	%28 = load [2 x %Int32], [2 x %Int32]* %27
	%29 = zext i8 2 to %Nat32
	store [2 x %Int32] %28, [2 x %Int32]* %24
	%30 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %30
; while_1
	br label %again_1
again_1:
	%31 = load %Nat32, %Nat32* %30
	%32 = icmp ult %Nat32 %31, 5
	br %Bool %32 , label %body_1, label %break_1
body_1:
	%33 = load %Nat32, %Nat32* %30
	%34 = bitcast %Nat32 %33 to %Nat32
	%35 = getelementptr [5 x %Int32], [5 x %Int32]* %17, %Int32 0, %Nat32 %34
	%36 = load %Int32, %Int32* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @.str6 to [0 x i8]*), %Int32 %36)
	%38 = load %Nat32, %Nat32* %30
	%39 = add %Nat32 %38, 1
	store %Nat32 %39, %Nat32* %30
	br label %again_1
break_1:
	%40 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str7 to [0 x i8]*))
	%41 = alloca %Point
	store %Point zeroinitializer, %Point* %41
	%42 = insertvalue %Point zeroinitializer, %Float64 3.0000000000000000, 0
	%43 = insertvalue %Point %42, %Float64 4.0000000000000000, 1
	%44 = alloca %Point
	store %Point %43, %Point* %44
	%45 = load %Point, %Point* %41
	%46 = load %Point, %Point* %44
	%47 = call %Float64 @distance(%Point %45, %Point %46)
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str8 to [0 x i8]*), %Float64 %47)
	%49 = alloca %Point, align 8
	%50 = load %Point, %Point* %44
	store %Point %50, %Point* %49
	%51 = alloca %Point*, align 8
	store %Point* %49, %Point** %51
	%52 = load %Point*, %Point** %51
	%53 = getelementptr %Point, %Point* %52, %Int32 0, %Int32 0
	store %Float64 99.0000000000000000, %Float64* %53
	%54 = getelementptr %Point, %Point* %49, %Int32 0, %Int32 0
	%55 = load %Float64, %Float64* %54
	%56 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str9 to [0 x i8]*), %Float64 %55)
	%57 = alloca %Color, align 1
	store %Color 1, %Color* %57
; if_0
	%58 = load %Color, %Color* %57
	%59 = icmp eq %Color %58, 1
	br %Bool %59 , label %then_0, label %endif_0
then_0:
	%60 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str10 to [0 x i8]*))
	br label %endif_0
endif_0:
	%61 = alloca %Word32, align 4
	%62 = zext i8 15 to %Word32
	store %Word32 %62, %Word32* %61
	%63 = alloca %Word32, align 4
	%64 = zext i8 51 to %Word32
	store %Word32 %64, %Word32* %63
	%65 = load %Word32, %Word32* %61
	%66 = load %Word32, %Word32* %63
	%67 = or %Word32 %65, %66
	%68 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str11 to [0 x i8]*), %Word32 %67)
	%69 = alloca %Int32, align 4
	store %Int32 0, %Int32* %69
; while_2
	br label %again_2
again_2:
	%70 = load %Int32, %Int32* %69
	%71 = icmp slt %Int32 %70, 5
	br %Bool %71 , label %body_2, label %break_2
body_2:
	%72 = load %Int32, %Int32* %69
	%73 = add %Int32 %72, 1
	store %Int32 %73, %Int32* %69
; if_1
	%74 = load %Int32, %Int32* %69
	%75 = icmp eq %Int32 %74, 3
	br %Bool %75 , label %then_1, label %endif_1
then_1:
	br label %again_2
	br label %endif_1
endif_1:
	%77 = load %Int32, %Int32* %69
	%78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str12 to [0 x i8]*), %Int32 %77)
	br label %again_2
break_2:
	%79 = alloca %Int32, align 4
	store %Int32 0, %Int32* %79
; while_3
	br label %again_3
again_3:
	br %Bool 1 , label %body_3, label %break_3
body_3:
; if_2
	%80 = load %Int32, %Int32* %79
	%81 = icmp eq %Int32 %80, 2
	br %Bool %81 , label %then_2, label %endif_2
then_2:
	br label %break_3
	br label %endif_2
endif_2:
	%83 = load %Int32, %Int32* %79
	%84 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str13 to [0 x i8]*), %Int32 %83)
	%85 = load %Int32, %Int32* %79
	%86 = add %Int32 %85, 1
	store %Int32 %86, %Int32* %79
	br label %again_3
break_3:
; if_3
	%87 = load %Int32, %Int32* %1
	%88 = icmp sgt %Int32 %87, 0
	%89 = load %Int32, %Int32* %3
	%90 = icmp slt %Int32 %89, 0
	%91 = xor %Bool %90, 1
	%92 = and %Bool %88, %91
	br %Bool %92 , label %then_3, label %endif_3
then_3:
	%93 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str14 to [0 x i8]*))
	br label %endif_3
endif_3:
	%94 = alloca %Action*, align 8
	store %Action* @announce, %Action** %94
	%95 = load %Action*, %Action** %94
	call void %95()
	%96 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str15 to [0 x i8]*), %Size 16)
	%97 = call %Int32 @sum(%Int32 5)
	%98 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str16 to [0 x i8]*), %Int32 %97)
	ret %Int 0
}


