
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
%VA_List = type i8*
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

; MODULE: animation

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
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
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
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
; -- end print includes --
; -- print imports --
%led_LedController = type {
	%Bool,
	%Int32,
	%Int32,
	%Int32,
	%Int32,
	%Int32
};

declare %Bool @led_isFree(%led_LedController* %led)
declare void @led_reset(%led_LedController* %led)
declare void @led_start(%led_LedController* %led, %Int8 %brightness, %Int32 %time)
declare void @led_step(%led_LedController* %led)
; -- end print imports --
; -- strings --
@str1 = private constant [6 x i8] [i8 83, i8 84, i8 79, i8 80, i8 10, i8 0]
; -- endstrings --

%animation_AnimationPoint = type {
	%Int8,
	%Int32
};

%animation_Animation = type {
	%Int32,
	[0 x %animation_AnimationPoint]*
};


@led0 = global %led_LedController zeroinitializer
@animation0_points = global [4 x %animation_AnimationPoint] [
	%animation_AnimationPoint {
		%Int8 120,
		%Int32 200
	},
	%animation_AnimationPoint {
		%Int8 120,
		%Int32 200
	},
	%animation_AnimationPoint {
		%Int8 80,
		%Int32 200
	},
	%animation_AnimationPoint {
		%Int8 0,
		%Int32 200
	}
]
@animation0 = global %animation_Animation {
	%Int32 4,
	[0 x %animation_AnimationPoint]* @animation0_points
}

%animation_AnimationState = type {
	%Bool,
	%animation_Animation*,
	%Int32,
	%Bool
};


define %Bool @animation_isBusy(%animation_AnimationState* %astate) {
	%1 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 0
	%2 = load %Bool, %Bool* %1
	ret %Bool %2
}

define void @animation_stop(%animation_AnimationState* %astate) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str1 to [0 x i8]*))
	%2 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 3
	store %Bool 1, %Bool* %2
	ret void
}

define void @animation_startt(%animation_AnimationState* %astate) {
	%1 = bitcast %animation_AnimationState* %astate to %animation_AnimationState*
	%2 = bitcast %animation_Animation* @animation0 to %animation_Animation*
	call void @animation_start(%animation_AnimationState* %1, %animation_Animation* %2)
	ret void
}

define void @animation_start(%animation_AnimationState* %astate, %animation_Animation* %a) {
	%1 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 2
	store %Int32 0, %Int32* %1
	%2 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 1
	%3 = bitcast %animation_Animation* %a to %animation_Animation*
	store %animation_Animation* %3, %animation_Animation** %2
	%4 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 0
	store %Bool 1, %Bool* %4
	ret void
}

define void @animation_step(%animation_AnimationState* %astate) {
	%1 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 0
	%2 = load %Bool, %Bool* %1
	%3 = xor %Bool %2, -1
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret void
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 1
	%6 = load %animation_Animation*, %animation_Animation** %5
	%7 = bitcast i8* null to %animation_Animation*
	%8 = icmp eq %animation_Animation* %6, %7
	br %Bool %8 , label %then_1, label %endif_1
then_1:
	ret void
	br label %endif_1
endif_1:
	; Если выработали все точки - заканчиваем
	%10 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 2
	%11 = load %Int32, %Int32* %10
	%12 = getelementptr inbounds %animation_Animation, %animation_Animation* %6, %Int32 0, %Int32 0
	%13 = load %Int32, %Int32* %12
	%14 = icmp ugt %Int32 %11, %13
	%15 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 3
	%16 = load %Bool, %Bool* %15
	%17 = or %Bool %14, %16
	br %Bool %17 , label %then_2, label %endif_2
then_2:
	%18 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 1
	%19 = bitcast i8* null to %animation_Animation*
	store %animation_Animation* %19, %animation_Animation** %18
	%20 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 0
	store %Bool 0, %Bool* %20
	ret void
	br label %endif_2
endif_2:
	; Если мы здесь значит анимация должна выполняться
	; Смотрим если лед пришел в предыдущую точку то даем след задание
	%22 = bitcast %led_LedController* @led0 to %led_LedController*
	%23 = call %Bool @led_isFree(%led_LedController* %22)
	br %Bool %23 , label %then_3, label %endif_3
then_3:
	%24 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 1
	%25 = load %animation_Animation*, %animation_Animation** %24
	%26 = getelementptr inbounds %animation_Animation, %animation_Animation* %25, %Int32 0, %Int32 1
	%27 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 2
	%28 = load %Int32, %Int32* %27
	%29 = load [0 x %animation_AnimationPoint]*, [0 x %animation_AnimationPoint]** %26
	%30 = getelementptr inbounds [0 x %animation_AnimationPoint], [0 x %animation_AnimationPoint]* %29, %Int32 0, %Int32 %28
	%31 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 2
	%32 = getelementptr inbounds %animation_AnimationState, %animation_AnimationState* %astate, %Int32 0, %Int32 2
	%33 = load %Int32, %Int32* %32
	%34 = add %Int32 %33, 1
	store %Int32 %34, %Int32* %31
	%35 = bitcast %led_LedController* @led0 to %led_LedController*
	%36 = getelementptr inbounds %animation_AnimationPoint, %animation_AnimationPoint* %30, %Int32 0, %Int32 0
	%37 = load %Int8, %Int8* %36
	%38 = getelementptr inbounds %animation_AnimationPoint, %animation_AnimationPoint* %30, %Int32 0, %Int32 1
	%39 = load %Int32, %Int32* %38
	call void @led_start(%led_LedController* %35, %Int8 %37, %Int32 %39)
	br label %endif_3
endif_3:
	%40 = bitcast %led_LedController* @led0 to %led_LedController*
	call void @led_step(%led_LedController* %40)
	ret void
}


