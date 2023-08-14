; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/math.hm






declare %Double @acos(%Double)
declare %Double @asin(%Double)
declare %Double @atan(%Double)
declare %Double @atan2(%Double, %Double)
declare %Double @cos(%Double)
declare %Double @sin(%Double)
declare %Double @tan(%Double)
declare %Double @cosh(%Double)
declare %Double @sinh(%Double)
declare %Double @tanh(%Double)
declare %Double @exp(%Double)
declare %Double @frexp(%Double, %Int*)
declare %Double @ldexp(%Double, %Int)
declare %Double @log(%Double)
declare %Double @log10(%Double)
declare %Double @modf(%Double, %Double*)
declare %Double @pow(%Double, %Double)
declare %Double @sqrt(%Double)
declare %Double @ceil(%Double)
declare %Double @fabs(%Double)
declare %Double @floor(%Double)
declare %Double @fmod(%Double, %Double)


declare %LongDouble @acosl(%LongDouble)
declare %LongDouble @asinl(%LongDouble)
declare %LongDouble @atanl(%LongDouble)
declare %LongDouble @atan2l(%LongDouble, %LongDouble)
declare %LongDouble @cosl(%LongDouble)
declare %LongDouble @sinl(%LongDouble)
declare %LongDouble @tanl(%LongDouble)
declare %LongDouble @acoshl(%LongDouble)
declare %LongDouble @asinhl(%LongDouble)
declare %LongDouble @atanhl(%LongDouble)
declare %LongDouble @coshl(%LongDouble)
declare %LongDouble @sinhl(%LongDouble)
declare %LongDouble @tanhl(%LongDouble)
declare %LongDouble @expl(%LongDouble)
declare %LongDouble @exp2l(%LongDouble)
declare %LongDouble @expm1l(%LongDouble)
declare %LongDouble @frexpl(%LongDouble, %Int*)
declare %Int @ilogbl(%LongDouble)
declare %LongDouble @ldexpl(%LongDouble, %Int)
declare %LongDouble @logl(%LongDouble)
declare %LongDouble @log10l(%LongDouble)
declare %LongDouble @log1pl(%LongDouble)
declare %LongDouble @log2l(%LongDouble)
declare %LongDouble @logbl(%LongDouble)
declare %LongDouble @modfl(%LongDouble, %LongDouble*)
declare %LongDouble @scalbnl(%LongDouble, %Int)
declare %LongDouble @scalblnl(%LongDouble, %LongInt)
declare %LongDouble @cbrtl(%LongDouble)
declare %LongDouble @fabsl(%LongDouble)
declare %LongDouble @hypotl(%LongDouble, %LongDouble)
declare %LongDouble @powl(%LongDouble, %LongDouble)
declare %LongDouble @sqrtl(%LongDouble)
declare %LongDouble @erfl(%LongDouble)
declare %LongDouble @erfcl(%LongDouble)
declare %LongDouble @lgammal(%LongDouble)
declare %LongDouble @tgammal(%LongDouble)
declare %LongDouble @ceill(%LongDouble)
declare %LongDouble @floorl(%LongDouble)
declare %LongDouble @nearbyintl(%LongDouble)
declare %LongDouble @rintl(%LongDouble)
declare %LongInt @lrintl(%LongDouble)
declare %LongLongInt @llrintl(%LongDouble)
declare %LongDouble @roundl(%LongDouble)
declare %LongInt @lroundl(%LongDouble)
declare %LongLongInt @llroundl(%LongDouble)
declare %LongDouble @truncl(%LongDouble)
declare %LongDouble @fmodl(%LongDouble, %LongDouble)
declare %LongDouble @remainderl(%LongDouble, %LongDouble)
declare %LongDouble @remquol(%LongDouble, %LongDouble, %Int*)
declare %LongDouble @copysignl(%LongDouble, %LongDouble)
declare %LongDouble @nanl(%ConstChar*)
declare %LongDouble @nextafterl(%LongDouble, %LongDouble)
declare %LongDouble @nexttowardl(%LongDouble, %LongDouble)
declare %LongDouble @fdiml(%LongDouble, %LongDouble)
declare %LongDouble @fmaxl(%LongDouble, %LongDouble)
declare %LongDouble @fminl(%LongDouble, %LongDouble)
declare %LongDouble @fmal(%LongDouble, %LongDouble, %LongDouble)

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*

declare %Int @fclose(%FILE*)
declare %Int @feof(%FILE*)
declare %Int @ferror(%FILE*)
declare %Int @fflush(%FILE*)
declare %Int @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare %SizeT @fread(i8*, %SizeT, %SizeT, %FILE*)
declare %SizeT @fwrite(i8*, %SizeT, %SizeT, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare %Int @fseek(%FILE*, %LongInt, %Int)
declare %Int @fsetpos(%FILE*, %FposT*)
declare %LongInt @ftell(%FILE*)
declare %Int @remove(%ConstCharStr)
declare %Int @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)


declare %Int @setvbuf(%FILE*, %CharStr, %Int, %SizeT)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare %Int @printf(%ConstCharStr, ...)
declare %Int @scanf(%ConstCharStr, ...)
declare %Int @fprintf(%FILE*, [0 x i8]*, ...)
declare %Int @fscanf(%FILE*, %ConstCharStr, ...)
declare %Int @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare %Int @sprintf(%CharStr, %ConstCharStr, ...)


declare %Int @fgetc(%FILE*)
declare %Int @fputc(%Int, %FILE*)
declare %CharStr @fgets(%CharStr, %Int, %FILE*)
declare %Int @fputs(%ConstCharStr, %FILE*)
declare %Int @getc(%FILE*)
declare %Int @getchar()
declare %CharStr @gets(%CharStr)
declare %Int @putc(%Int, %FILE*)
declare %Int @putchar(%Int)
declare %Int @puts(%ConstCharStr)
declare %Int @ungetc(%Int, %FILE*)
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
declare i8* @malloc(%SizeT)
declare i8* @memset(i8*, %Int, %SizeT)
declare i8* @memcpy(i8*, i8*, %SizeT)
declare %Int @memcmp(i8*, i8*, %SizeT)
declare void @free(i8*)
declare %Int @strncmp(%ConstChar*, %ConstChar*, %SizeT)
declare %Int @strcmp(%ConstChar*, %ConstChar*)
declare %Char* @strcpy(%Char*, %ConstChar*)
declare %SizeT @strlen(%ConstChar*)


declare %Int @ftruncate(%Int, %OffT)















declare %Int @creat([0 x i8]*, %ModeT)
declare %Int @open([0 x i8]*, %Int)
declare %Int @read(%Int, i8*, i32)
declare %Int @write(%Int, i8*, i32)
declare %OffT @lseek(%Int, %OffT, %Int)
declare %Int @close(%Int)
declare void @exit(%Int)


declare %DIR* @opendir([0 x i8]*)
declare %Int @closedir(%DIR*)


declare [0 x i8]* @getcwd([0 x i8]*, %SizeT)
declare [0 x i8]* @getenv([0 x i8]*)

; -- MODULE: /Users/alexbalan/p/Modest/examples/5.records/src/main.cm

@str_1 = private constant [15 x i8] c"point(%f, %f)\0A\00"
@str_2 = private constant [18 x i8] c"line length = %f\0A\00"



%Point = type {
	%Float,
	%Float
}

%Line = type {
	%Point,
	%Point
}

@line = global %Line {
  %Point {
    %Float 0x0,
    %Float 0x0
  },
  %Point {
    %Float 0x3ff0000000000000,
    %Float 0x3ff0000000000000
  }
}
define %Float @max(%Float %a, %Float %b) {
  %1 = fcmp ogt %Float %a, %b
  br i1 %1 , label %then_0, label %endif_0
then_0:
  ret %Float %a
  br label %endif_0
endif_0:
  ret %Float %b
}

define %Float @min(%Float %a, %Float %b) {
  %1 = fcmp olt %Float %a, %b
  br i1 %1 , label %then_0, label %endif_0
then_0:
  ret %Float %a
  br label %endif_0
endif_0:
  ret %Float %b
}



define %Float @lineLength(%Line %line) {
  %1 = extractvalue %Line %line, 0
  %2 = extractvalue %Point %1, 0
  %3 = extractvalue %Line %line, 1
  %4 = extractvalue %Point %3, 0
  %5 = call %Float(%Float, %Float) @max (%Float %2, %Float %4)
  %6 = extractvalue %Line %line, 0
  %7 = extractvalue %Point %6, 0
  %8 = extractvalue %Line %line, 1
  %9 = extractvalue %Point %8, 0
  %10 = call %Float(%Float, %Float) @min (%Float %7, %Float %9)
  %11 = fsub %Float %5, %10
  %12 = extractvalue %Line %line, 0
  %13 = extractvalue %Point %12, 1
  %14 = extractvalue %Line %line, 1
  %15 = extractvalue %Point %14, 1
  %16 = call %Float(%Float, %Float) @max (%Float %13, %Float %15)
  %17 = extractvalue %Line %line, 0
  %18 = extractvalue %Point %17, 1
  %19 = extractvalue %Line %line, 1
  %20 = extractvalue %Point %19, 1
  %21 = call %Float(%Float, %Float) @min (%Float %18, %Float %20)
  %22 = fsub %Float %16, %21
  %23 = call %Double(%Double, %Double) @pow (%Float %11, %Double 0x4000000000000000)
  %24 = call %Double(%Double, %Double) @pow (%Float %22, %Double 0x4000000000000000)
  %25 = fadd %Double %23, %24
  %26 = call %Double(%Double) @sqrt (%Double %25)
  ret %Double %26
}

define void @ptr_example() {
  %1 = call i8*(%SizeT) @malloc (%SizeT 0)
  %2 = bitcast i8* %1 to %Point*
  %3 = getelementptr inbounds %Point, %Point* %2, i32 0, i32 0
  store %Float 0x4024000000000000, %Float* %3
  %4 = getelementptr inbounds %Point, %Point* %2, i32 0, i32 1
  store %Float 0x4034000000000000, %Float* %4
  %5 = bitcast [15 x i8]* @str_1 to %ConstCharStr
  %6 = getelementptr inbounds %Point, %Point* %2, i32 0, i32 0
  %7 = load %Float, %Float* %6
  %8 = getelementptr inbounds %Point, %Point* %2, i32 0, i32 1
  %9 = load %Float, %Float* %8
  %10 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %5, %Float %7, %Float %9)
  ret void
}

define %Int @main() {
  %1 = load %Line, %Line* @line
  %2 = call %Float(%Line) @lineLength (%Line %1)
  %3 = bitcast [18 x i8]* @str_2 to %ConstCharStr
  %4 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %3, %Float %2)
  call void() @ptr_example ()
  ret %Int 0
}


