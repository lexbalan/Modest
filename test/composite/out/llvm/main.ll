
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
; -- end print imports --
; -- strings --
@str1 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 49, i8 32, i8 40, i8 101, i8 113, i8 41, i8 58, i8 32, i8 0]
@str2 = private constant [4 x i8] [i8 101, i8 113, i8 10, i8 0]
@str3 = private constant [4 x i8] [i8 110, i8 101, i8 10, i8 0]
@str4 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 50, i8 32, i8 40, i8 110, i8 101, i8 41, i8 58, i8 32, i8 0]
@str5 = private constant [4 x i8] [i8 101, i8 113, i8 10, i8 0]
@str6 = private constant [4 x i8] [i8 110, i8 101, i8 10, i8 0]
@str7 = private constant [19 x i8] [i8 97, i8 114, i8 114, i8 114, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --

%RGB24 = type {
	%Int8,
	%Int8,
	%Int8
};


@rgb0 = internal global [2 x %RGB24] [
	%RGB24 {
		%Int8 200,
		%Int8 0,
		%Int8 0
	},
	%RGB24 {
		%Int8 200,
		%Int8 0,
		%Int8 0
	}
]

%AnimationPoint = type {
	%RGB24,
	%Int32
};


@ap = internal global %AnimationPoint {
	%RGB24 {
		%Int8 200,
		%Int8 0,
		%Int8 0
	},
	%Int32 3000
}
@animation0_points = internal global [5 x %AnimationPoint] [
	%AnimationPoint {
		%RGB24 {
			%Int8 200,
			%Int8 0,
			%Int8 0
		},
		%Int32 3
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 0,
			%Int8 200,
			%Int8 0
		},
		%Int32 30
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 100,
			%Int8 100,
			%Int8 0
		},
		%Int32 300
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 254,
			%Int8 254,
			%Int8 0
		},
		%Int32 20
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 0,
			%Int8 0,
			%Int8 255
		},
		%Int32 3000
	}
]
@animation1_points = internal global [5 x %AnimationPoint] [
	%AnimationPoint {
		%RGB24 {
			%Int8 200,
			%Int8 0,
			%Int8 0
		},
		%Int32 3
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 0,
			%Int8 200,
			%Int8 0
		},
		%Int32 30
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 100,
			%Int8 100,
			%Int8 0
		},
		%Int32 300
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 254,
			%Int8 254,
			%Int8 0
		},
		%Int32 20
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 0,
			%Int8 0,
			%Int8 255
		},
		%Int32 3000
	}
]
@animation2_points = internal global [5 x %AnimationPoint] [
	%AnimationPoint {
		%RGB24 {
			%Int8 200,
			%Int8 0,
			%Int8 0
		},
		%Int32 3
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 0,
			%Int8 200,
			%Int8 0
		},
		%Int32 30
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 100,
			%Int8 100,
			%Int8 0
		},
		%Int32 300
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 255,
			%Int8 254,
			%Int8 0
		},
		%Int32 20
	},
	%AnimationPoint {
		%RGB24 {
			%Int8 0,
			%Int8 0,
			%Int8 255
		},
		%Int32 3000
	}
]

define internal void @xy({%Int32,%Int32} %x) {
	ret void
}


@arrr = internal global [3 x [3 x %Int32]] [
	[3 x %Int32] [
		%Int32 1,
		%Int32 2,
		%Int32 3
	],
	[3 x %Int32] [
		%Int32 4,
		%Int32 5,
		%Int32 6
	],
	[3 x %Int32] [
		%Int32 7,
		%Int32 8,
		%Int32 9
	]
]
@x = internal global void ()* zeroinitializer
@arry = internal global [3 x [3 x void ()*]] zeroinitializer

define %Int32 @main() {
	%1 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 10, 0
	%2 = insertvalue {%Int32,%Int32} %1, %Int32 20, 1
	call void @xy({%Int32,%Int32} %2)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*))
	%4 = bitcast [5 x %AnimationPoint]* @animation0_points to i8*
	%5 = bitcast [5 x %AnimationPoint]* @animation1_points to i8*
	%6 = call i1 (i8*, i8*, i64) @memeq(i8* %4, i8* %5, %Int64 40)
	%7 = icmp ne %Bool %6, 0
	br %Bool %7 , label %then_0, label %else_0
then_0:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str2 to [0 x i8]*))
	br label %endif_0
else_0:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
endif_0:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str4 to [0 x i8]*))
	%11 = bitcast [5 x %AnimationPoint]* @animation1_points to i8*
	%12 = bitcast [5 x %AnimationPoint]* @animation2_points to i8*
	%13 = call i1 (i8*, i8*, i64) @memeq(i8* %11, i8* %12, %Int64 40)
	%14 = icmp ne %Bool %13, 0
	br %Bool %14 , label %then_1, label %else_1
then_1:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str5 to [0 x i8]*))
	br label %endif_1
else_1:
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str6 to [0 x i8]*))
	br label %endif_1
endif_1:
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_1
again_1:
	%18 = load %Int32, %Int32* %17
	%19 = icmp slt %Int32 %18, 3
	br %Bool %19 , label %body_1, label %break_1
body_1:
	%20 = alloca %Int32, align 4
	store %Int32 0, %Int32* %20
	br label %again_2
again_2:
	%21 = load %Int32, %Int32* %20
	%22 = icmp slt %Int32 %21, 3
	br %Bool %22 , label %body_2, label %break_2
body_2:
	%23 = load %Int32, %Int32* %17
	%24 = load %Int32, %Int32* %20
	%25 = load %Int32, %Int32* %17
	%26 = getelementptr inbounds [3 x [3 x %Int32]], [3 x [3 x %Int32]]* @arrr, %Int32 0, %Int32 %25
	%27 = load %Int32, %Int32* %20
	%28 = getelementptr inbounds [3 x %Int32], [3 x %Int32]* %26, %Int32 0, %Int32 %27
	%29 = load %Int32, %Int32* %28
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str7 to [0 x i8]*), %Int32 %23, %Int32 %24, %Int32 %29)
	%31 = load %Int32, %Int32* %20
	%32 = add %Int32 %31, 1
	store %Int32 %32, %Int32* %20
	br label %again_2
break_2:
	%33 = load %Int32, %Int32* %17
	%34 = add %Int32 %33, 1
	store %Int32 %34, %Int32* %17
	br label %again_1
break_1:
	ret %Int32 0
}


