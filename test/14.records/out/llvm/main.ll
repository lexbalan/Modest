
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
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [15 x i8] [i8 108, i8 105, i8 110, i8 101, i8 46, i8 97, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [15 x i8] [i8 108, i8 105, i8 110, i8 101, i8 46, i8 97, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [15 x i8] [i8 108, i8 105, i8 110, i8 101, i8 46, i8 98, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [15 x i8] [i8 108, i8 105, i8 110, i8 101, i8 46, i8 98, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [20 x i8] [i8 112, i8 76, i8 105, i8 110, i8 101, i8 115, i8 91, i8 48, i8 93, i8 46, i8 97, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [20 x i8] [i8 112, i8 76, i8 105, i8 110, i8 101, i8 115, i8 91, i8 48, i8 93, i8 46, i8 97, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [20 x i8] [i8 112, i8 76, i8 105, i8 110, i8 101, i8 115, i8 91, i8 48, i8 93, i8 46, i8 98, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [20 x i8] [i8 112, i8 76, i8 105, i8 110, i8 101, i8 115, i8 91, i8 48, i8 93, i8 46, i8 98, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str9 = private constant [14 x i8] [i8 115, i8 46, i8 120, i8 46, i8 97, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [14 x i8] [i8 115, i8 46, i8 120, i8 46, i8 97, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str11 = private constant [14 x i8] [i8 115, i8 46, i8 120, i8 46, i8 98, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str12 = private constant [14 x i8] [i8 115, i8 46, i8 120, i8 46, i8 98, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str13 = private constant [14 x i8] [i8 120, i8 46, i8 120, i8 46, i8 97, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str14 = private constant [14 x i8] [i8 120, i8 46, i8 120, i8 46, i8 97, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str15 = private constant [14 x i8] [i8 120, i8 46, i8 120, i8 46, i8 98, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str16 = private constant [14 x i8] [i8 120, i8 46, i8 120, i8 46, i8 98, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str17 = private constant [14 x i8] [i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str18 = private constant [13 x i8] [i8 118, i8 101, i8 114, i8 115, i8 105, i8 111, i8 110, i8 32, i8 48, i8 46, i8 55, i8 10, i8 0]
@str19 = private constant [17 x i8] [i8 118, i8 101, i8 114, i8 115, i8 105, i8 111, i8 110, i8 32, i8 110, i8 111, i8 116, i8 32, i8 48, i8 46, i8 55, i8 10, i8 0]
@str20 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@str21 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@str22 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@str23 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@str24 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@str25 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@str26 = private constant [14 x i8] [i8 42, i8 112, i8 114, i8 50, i8 32, i8 61, i8 61, i8 32, i8 42, i8 112, i8 114, i8 51, i8 10, i8 0]
@str27 = private constant [14 x i8] [i8 42, i8 112, i8 114, i8 50, i8 32, i8 33, i8 61, i8 32, i8 42, i8 112, i8 114, i8 51, i8 10, i8 0]
@str28 = private constant [24 x i8] [i8 112, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 49, i8 48, i8 41, i8 10, i8 0]
@str29 = private constant [24 x i8] [i8 112, i8 120, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 50, i8 48, i8 41, i8 10, i8 0]
@str30 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str31 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
%main_Point2D = type {
	%Int32,
	%Int32
};

%main_Point3D = type {
	%Int32,
	%Int32,
	%Int32
};

%main_Point = type {
	%Int32,
	%Int32
};

%main_Line = type {
	%main_Point,
	%main_Point
};

@main_line = internal global %main_Line {
	%main_Point {
		%Int32 10,
		%Int32 11
	},
	%main_Point {
		%Int32 12,
		%Int32 13
	}
}
@main_lines = internal global [3 x %main_Line] [
	%main_Line {
		%main_Point {
			%Int32 1,
			%Int32 2
		},
		%main_Point {
			%Int32 3,
			%Int32 4
		}
	},
	%main_Line {
		%main_Point {
			%Int32 5,
			%Int32 6
		},
		%main_Point {
			%Int32 7,
			%Int32 8
		}
	},
	%main_Line {
		%main_Point {
			%Int32 9,
			%Int32 10
		},
		%main_Point {
			%Int32 11,
			%Int32 12
		}
	}
]
@main_pLines = internal global [3 x %main_Line*] [
	%main_Line* getelementptr ([3 x %main_Line], [3 x %main_Line]* @main_lines, %Int32 0, %Int32 0),
	%main_Line* getelementptr ([3 x %main_Line], [3 x %main_Line]* @main_lines, %Int32 0, %Int32 1),
	%main_Line* getelementptr ([3 x %main_Line], [3 x %main_Line]* @main_lines, %Int32 0, %Int32 2)
]
%main_Struct = type {
	%main_Line*
};

@main_s = internal global %main_Struct {
	%main_Line* getelementptr ([3 x %main_Line], [3 x %main_Line]* @main_lines, %Int32 0, %Int32 0)
}
define internal void @main_test_records() {
	%1 = getelementptr %main_Line, %main_Line* @main_line, %Int32 0, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str1 to [0 x i8]*), %Int32 %2)
	%4 = getelementptr %main_Line, %main_Line* @main_line, %Int32 0, %Int32 0, %Int32 1
	%5 = load %Int32, %Int32* %4
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), %Int32 %5)
	%7 = getelementptr %main_Line, %main_Line* @main_line, %Int32 0, %Int32 1, %Int32 0
	%8 = load %Int32, %Int32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str3 to [0 x i8]*), %Int32 %8)
	%10 = getelementptr %main_Line, %main_Line* @main_line, %Int32 0, %Int32 1, %Int32 1
	%11 = load %Int32, %Int32* %10
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str4 to [0 x i8]*), %Int32 %11)
	%13 = getelementptr [3 x %main_Line*], [3 x %main_Line*]* @main_pLines, %Int32 0, %Int32 0
	%14 = load %main_Line*, %main_Line** %13
	%15 = getelementptr %main_Line, %main_Line* %14, %Int32 0, %Int32 0, %Int32 0
	%16 = load %Int32, %Int32* %15
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str5 to [0 x i8]*), %Int32 %16)
	%18 = getelementptr [3 x %main_Line*], [3 x %main_Line*]* @main_pLines, %Int32 0, %Int32 0
	%19 = load %main_Line*, %main_Line** %18
	%20 = getelementptr %main_Line, %main_Line* %19, %Int32 0, %Int32 0, %Int32 1
	%21 = load %Int32, %Int32* %20
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str6 to [0 x i8]*), %Int32 %21)
	%23 = getelementptr [3 x %main_Line*], [3 x %main_Line*]* @main_pLines, %Int32 0, %Int32 0
	%24 = load %main_Line*, %main_Line** %23
	%25 = getelementptr %main_Line, %main_Line* %24, %Int32 0, %Int32 1, %Int32 0
	%26 = load %Int32, %Int32* %25
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str7 to [0 x i8]*), %Int32 %26)
	%28 = getelementptr [3 x %main_Line*], [3 x %main_Line*]* @main_pLines, %Int32 0, %Int32 0
	%29 = load %main_Line*, %main_Line** %28
	%30 = getelementptr %main_Line, %main_Line* %29, %Int32 0, %Int32 1, %Int32 1
	%31 = load %Int32, %Int32* %30
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str8 to [0 x i8]*), %Int32 %31)
	%33 = getelementptr %main_Struct, %main_Struct* @main_s, %Int32 0, %Int32 0
	%34 = load %main_Line*, %main_Line** %33
	%35 = getelementptr %main_Line, %main_Line* %34, %Int32 0, %Int32 0, %Int32 0
	%36 = load %Int32, %Int32* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str9 to [0 x i8]*), %Int32 %36)
	%38 = getelementptr %main_Struct, %main_Struct* @main_s, %Int32 0, %Int32 0
	%39 = load %main_Line*, %main_Line** %38
	%40 = getelementptr %main_Line, %main_Line* %39, %Int32 0, %Int32 0, %Int32 1
	%41 = load %Int32, %Int32* %40
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str10 to [0 x i8]*), %Int32 %41)
	%43 = getelementptr %main_Struct, %main_Struct* @main_s, %Int32 0, %Int32 0
	%44 = load %main_Line*, %main_Line** %43
	%45 = getelementptr %main_Line, %main_Line* %44, %Int32 0, %Int32 1, %Int32 0
	%46 = load %Int32, %Int32* %45
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str11 to [0 x i8]*), %Int32 %46)
	%48 = getelementptr %main_Struct, %main_Struct* @main_s, %Int32 0, %Int32 0
	%49 = load %main_Line*, %main_Line** %48
	%50 = getelementptr %main_Line, %main_Line* %49, %Int32 0, %Int32 1, %Int32 1
	%51 = load %Int32, %Int32* %50
	%52 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str12 to [0 x i8]*), %Int32 %51)
	%53 = load %main_Struct, %main_Struct* @main_s
	%54 = alloca %main_Struct
	store %main_Struct %53, %main_Struct* %54
	%55 = getelementptr %main_Struct, %main_Struct* %54, %Int32 0, %Int32 0
	%56 = load %main_Line*, %main_Line** %55
	%57 = getelementptr %main_Line, %main_Line* %56, %Int32 0, %Int32 0, %Int32 0
	%58 = load %Int32, %Int32* %57
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str13 to [0 x i8]*), %Int32 %58)
	%60 = getelementptr %main_Struct, %main_Struct* %54, %Int32 0, %Int32 0
	%61 = load %main_Line*, %main_Line** %60
	%62 = getelementptr %main_Line, %main_Line* %61, %Int32 0, %Int32 0, %Int32 1
	%63 = load %Int32, %Int32* %62
	%64 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str14 to [0 x i8]*), %Int32 %63)
	%65 = getelementptr %main_Struct, %main_Struct* %54, %Int32 0, %Int32 0
	%66 = load %main_Line*, %main_Line** %65
	%67 = getelementptr %main_Line, %main_Line* %66, %Int32 0, %Int32 1, %Int32 0
	%68 = load %Int32, %Int32* %67
	%69 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str15 to [0 x i8]*), %Int32 %68)
	%70 = getelementptr %main_Struct, %main_Struct* %54, %Int32 0, %Int32 0
	%71 = load %main_Line*, %main_Line** %70
	%72 = getelementptr %main_Line, %main_Line* %71, %Int32 0, %Int32 1, %Int32 1
	%73 = load %Int32, %Int32* %72
	%74 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str16 to [0 x i8]*), %Int32 %73)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str17 to [0 x i8]*))

	; check value_record_eq for immediate values
	%2 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 7, 1
	%3 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %2, {%Int32,%Int32}* %3
	br %Bool 1 , label %then_0, label %else_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str18 to [0 x i8]*))
	br label %endif_0
else_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str19 to [0 x i8]*))
	br label %endif_0
endif_0:

	; compare two Point2D records
	%6 = alloca %main_Point2D, align 8
	%7 = insertvalue %main_Point2D zeroinitializer, %Int32 1, 0
	%8 = insertvalue %main_Point2D %7, %Int32 2, 1
	store %main_Point2D %8, %main_Point2D* %6
	%9 = alloca %main_Point2D, align 8
	%10 = insertvalue %main_Point2D zeroinitializer, %Int32 10, 0
	%11 = insertvalue %main_Point2D %10, %Int32 20, 1
	store %main_Point2D %11, %main_Point2D* %9
	%12 = bitcast %main_Point2D* %6 to i8*
	%13 = bitcast %main_Point2D* %9 to i8*
	%14 = call i1 (i8*, i8*, i64) @memeq(i8* %12, i8* %13, %Int64 8)
	%15 = icmp ne %Bool %14, 0
	br %Bool %15 , label %then_1, label %else_1
then_1:
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str20 to [0 x i8]*))
	br label %endif_1
else_1:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str21 to [0 x i8]*))
	br label %endif_1
endif_1:


	; compare Point2D with anonymous record
	%18 = alloca %main_Point2D, align 8
	%19 = load %main_Point2D, %main_Point2D* %6
	store %main_Point2D %19, %main_Point2D* %18
	%20 = alloca {%Int32,%Int32}, align 8
	%21 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 1, 0
	%22 = insertvalue {%Int32,%Int32} %21, %Int32 2, 1
	store {%Int32,%Int32} %22, {%Int32,%Int32}* %20
; -- cons_composite_from_composite_by_adr --
	%23 = bitcast {%Int32,%Int32}* %20 to %main_Point2D*
	%24 = load %main_Point2D, %main_Point2D* %23
; -- end cons_composite_from_composite_by_adr --
	%25 = alloca %main_Point2D
	store %main_Point2D %24, %main_Point2D* %25
	%26 = bitcast %main_Point2D* %18 to i8*
	%27 = bitcast %main_Point2D* %25 to i8*
	%28 = call i1 (i8*, i8*, i64) @memeq(i8* %26, i8* %27, %Int64 8)
	%29 = icmp ne %Bool %28, 0
	br %Bool %29 , label %then_2, label %else_2
then_2:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str22 to [0 x i8]*))
	br label %endif_2
else_2:
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str23 to [0 x i8]*))
	br label %endif_2
endif_2:


	; comparison between two anonymous record
	%32 = alloca {%Int32,%Int32}, align 8
	%33 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 1, 0
	%34 = insertvalue {%Int32,%Int32} %33, %Int32 2, 1
	store {%Int32,%Int32} %34, {%Int32,%Int32}* %32
; -- cons_composite_from_composite_by_adr --
	%35 = bitcast {%Int32,%Int32}* %32 to {%Int32,%Int32}*
	%36 = load {%Int32,%Int32}, {%Int32,%Int32}* %35
; -- end cons_composite_from_composite_by_adr --
	%37 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %36, {%Int32,%Int32}* %37
	%38 = bitcast {%Int32,%Int32}* %20 to i8*
	%39 = bitcast {%Int32,%Int32}* %37 to i8*
	%40 = call i1 (i8*, i8*, i64) @memeq(i8* %38, i8* %39, %Int64 8)
	%41 = icmp ne %Bool %40, 0
	br %Bool %41 , label %then_3, label %else_3
then_3:
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str24 to [0 x i8]*))
	br label %endif_3
else_3:
	%43 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str25 to [0 x i8]*))
	br label %endif_3
endif_3:

	; comparison between two record (by pointer)
; -- cons_composite_from_composite_by_adr --
	%44 = bitcast {%Int32,%Int32}* %20 to %main_Point2D*
	%45 = load %main_Point2D, %main_Point2D* %44
; -- end cons_composite_from_composite_by_adr --
	%46 = alloca %main_Point2D
	store %main_Point2D %45, %main_Point2D* %46
	%47 = bitcast %main_Point2D* %18 to i8*
	%48 = bitcast %main_Point2D* %46 to i8*
	%49 = call i1 (i8*, i8*, i64) @memeq(i8* %47, i8* %48, %Int64 8)
	%50 = icmp ne %Bool %49, 0
	br %Bool %50 , label %then_4, label %else_4
then_4:
	%51 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str26 to [0 x i8]*))
	br label %endif_4
else_4:
	%52 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str27 to [0 x i8]*))
	br label %endif_4
endif_4:

;
;	var prx = &p2d2
;	var prx2 = &prx
;	var pry = &p2d3
;
;	if **prx2 == *pry {
;		printf("**prx2 == *pry\n")
;	} else {
;		printf("**prx2 != *pry\n")
;	}
;

	; assign record by pointer
	%53 = insertvalue %main_Point2D zeroinitializer, %Int32 100, 0
	%54 = insertvalue %main_Point2D %53, %Int32 200, 1
	store %main_Point2D %54, %main_Point2D* %18
	store {%Int32,%Int32} zeroinitializer, {%Int32,%Int32}* %20

	; cons Point3D from Point2D (record extension)
	; (it is possible if dst record contained all fields from src record
	; and their types are equal)  ((EXPERIMENTAL))
	%55 = alloca %main_Point3D, align 16
; -- cons_composite_from_composite_by_adr --
	%56 = bitcast %main_Point2D* %18 to %main_Point3D*
	%57 = load %main_Point3D, %main_Point3D* %56
; -- end cons_composite_from_composite_by_adr --
	store %main_Point3D %57, %main_Point3D* %55


	; проверка того как локальная константа-массив
	; "замораживает" свои элементы
	%58 = alloca %Int32, align 4
	store %Int32 10, %Int32* %58
	%59 = alloca %Int32, align 4
	store %Int32 20, %Int32* %59
	%60 = load %Int32, %Int32* %58
	%61 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 %60, 0
	%62 = load %Int32, %Int32* %59
	%63 = insertvalue {%Int32,%Int32} %61, %Int32 %62, 1
	%64 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %63, {%Int32,%Int32}* %64
	store %Int32 111, %Int32* %58
	store %Int32 222, %Int32* %59
	%65 = getelementptr {%Int32,%Int32}, {%Int32,%Int32}* %64, %Int32 0, %Int32 0
	%66 = load %Int32, %Int32* %65
	%67 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str28 to [0 x i8]*), %Int32 %66)
	%68 = getelementptr {%Int32,%Int32}, {%Int32,%Int32}* %64, %Int32 0, %Int32 1
	%69 = load %Int32, %Int32* %68
	%70 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str29 to [0 x i8]*), %Int32 %69)
; -- cons_composite_from_composite_by_adr --
	%71 = bitcast {%Int32,%Int32}* %64 to {%Int32,%Int32}*
	%72 = load {%Int32,%Int32}, {%Int32,%Int32}* %71
; -- end cons_composite_from_composite_by_adr --
	%73 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 10, 0
	%74 = insertvalue {%Int32,%Int32} %73, %Int32 20, 1
	%75 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %72, {%Int32,%Int32}* %75
	%76 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %74, {%Int32,%Int32}* %76
	%77 = bitcast {%Int32,%Int32}* %75 to i8*
	%78 = bitcast {%Int32,%Int32}* %76 to i8*
	%79 = call i1 (i8*, i8*, i64) @memeq(i8* %77, i8* %78, %Int64 8)
	%80 = icmp ne %Bool %79, 0
	br %Bool %80 , label %then_5, label %else_5
then_5:
	%81 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str30 to [0 x i8]*))
	br label %endif_5
else_5:
	%82 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str31 to [0 x i8]*))
	br label %endif_5
endif_5:
	call void @main_test_records()
	ret %Int 0
}


