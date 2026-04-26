
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
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports private 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports private 'main' --
; -- print imports public 'main' --
; -- end print imports public 'main' --
; -- strings --
@.str1 = private constant [15 x i8] [i8 108, i8 105, i8 110, i8 101, i8 46, i8 97, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str2 = private constant [15 x i8] [i8 108, i8 105, i8 110, i8 101, i8 46, i8 97, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str3 = private constant [15 x i8] [i8 108, i8 105, i8 110, i8 101, i8 46, i8 98, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str4 = private constant [15 x i8] [i8 108, i8 105, i8 110, i8 101, i8 46, i8 98, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str5 = private constant [20 x i8] [i8 112, i8 76, i8 105, i8 110, i8 101, i8 115, i8 91, i8 48, i8 93, i8 46, i8 97, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str6 = private constant [20 x i8] [i8 112, i8 76, i8 105, i8 110, i8 101, i8 115, i8 91, i8 48, i8 93, i8 46, i8 97, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str7 = private constant [20 x i8] [i8 112, i8 76, i8 105, i8 110, i8 101, i8 115, i8 91, i8 48, i8 93, i8 46, i8 98, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str8 = private constant [20 x i8] [i8 112, i8 76, i8 105, i8 110, i8 101, i8 115, i8 91, i8 48, i8 93, i8 46, i8 98, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str9 = private constant [14 x i8] [i8 115, i8 46, i8 120, i8 46, i8 97, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str10 = private constant [14 x i8] [i8 115, i8 46, i8 120, i8 46, i8 97, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str11 = private constant [14 x i8] [i8 115, i8 46, i8 120, i8 46, i8 98, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str12 = private constant [14 x i8] [i8 115, i8 46, i8 120, i8 46, i8 98, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str13 = private constant [14 x i8] [i8 120, i8 46, i8 120, i8 46, i8 97, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str14 = private constant [14 x i8] [i8 120, i8 46, i8 120, i8 46, i8 97, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str15 = private constant [14 x i8] [i8 120, i8 46, i8 120, i8 46, i8 98, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str16 = private constant [14 x i8] [i8 120, i8 46, i8 120, i8 46, i8 98, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str17 = private constant [14 x i8] [i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str18 = private constant [13 x i8] [i8 118, i8 101, i8 114, i8 115, i8 105, i8 111, i8 110, i8 32, i8 48, i8 46, i8 55, i8 10, i8 0]
@.str19 = private constant [17 x i8] [i8 118, i8 101, i8 114, i8 115, i8 105, i8 111, i8 110, i8 32, i8 110, i8 111, i8 116, i8 32, i8 48, i8 46, i8 55, i8 10, i8 0]
@.str20 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@.str21 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@.str22 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@.str23 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@.str24 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@.str25 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@.str26 = private constant [14 x i8] [i8 42, i8 112, i8 114, i8 50, i8 32, i8 61, i8 61, i8 32, i8 42, i8 112, i8 114, i8 51, i8 10, i8 0]
@.str27 = private constant [14 x i8] [i8 42, i8 112, i8 114, i8 50, i8 32, i8 33, i8 61, i8 32, i8 42, i8 112, i8 114, i8 51, i8 10, i8 0]
@.str28 = private constant [24 x i8] [i8 112, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 49, i8 48, i8 41, i8 10, i8 0]
@.str29 = private constant [24 x i8] [i8 112, i8 120, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 50, i8 48, i8 41, i8 10, i8 0]
@.str30 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@.str31 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
%main_Point2D = type {
	%Nat32,
	%Nat32
};

%main_Point3D = type {
	%Nat32,
	%Nat32,
	%Nat32
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
%main_Structx = type {
	%main_Line*
};

@main_s = internal global %main_Structx {
	%main_Line* getelementptr ([3 x %main_Line], [3 x %main_Line]* @main_lines, %Int32 0, %Int32 0)
}
define internal void @main_test_records() {
	%1 = getelementptr %main_Line, %main_Line* @main_line, %Int32 0, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str1 to [0 x i8]*), %Int32 %2)
	%4 = getelementptr %main_Line, %main_Line* @main_line, %Int32 0, %Int32 0, %Int32 1
	%5 = load %Int32, %Int32* %4
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str2 to [0 x i8]*), %Int32 %5)
	%7 = getelementptr %main_Line, %main_Line* @main_line, %Int32 0, %Int32 1, %Int32 0
	%8 = load %Int32, %Int32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str3 to [0 x i8]*), %Int32 %8)
	%10 = getelementptr %main_Line, %main_Line* @main_line, %Int32 0, %Int32 1, %Int32 1
	%11 = load %Int32, %Int32* %10
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str4 to [0 x i8]*), %Int32 %11)
	%13 = getelementptr [3 x %main_Line*], [3 x %main_Line*]* @main_pLines, %Int32 0, %Int32 0
	%14 = load %main_Line*, %main_Line** %13
	%15 = getelementptr %main_Line, %main_Line* %14, %Int32 0, %Int32 0, %Int32 0
	%16 = load %Int32, %Int32* %15
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str5 to [0 x i8]*), %Int32 %16)
	%18 = getelementptr [3 x %main_Line*], [3 x %main_Line*]* @main_pLines, %Int32 0, %Int32 0
	%19 = load %main_Line*, %main_Line** %18
	%20 = getelementptr %main_Line, %main_Line* %19, %Int32 0, %Int32 0, %Int32 1
	%21 = load %Int32, %Int32* %20
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str6 to [0 x i8]*), %Int32 %21)
	%23 = getelementptr [3 x %main_Line*], [3 x %main_Line*]* @main_pLines, %Int32 0, %Int32 0
	%24 = load %main_Line*, %main_Line** %23
	%25 = getelementptr %main_Line, %main_Line* %24, %Int32 0, %Int32 1, %Int32 0
	%26 = load %Int32, %Int32* %25
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str7 to [0 x i8]*), %Int32 %26)
	%28 = getelementptr [3 x %main_Line*], [3 x %main_Line*]* @main_pLines, %Int32 0, %Int32 0
	%29 = load %main_Line*, %main_Line** %28
	%30 = getelementptr %main_Line, %main_Line* %29, %Int32 0, %Int32 1, %Int32 1
	%31 = load %Int32, %Int32* %30
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str8 to [0 x i8]*), %Int32 %31)
	%33 = getelementptr %main_Structx, %main_Structx* @main_s, %Int32 0, %Int32 0
	%34 = load %main_Line*, %main_Line** %33
	%35 = getelementptr %main_Line, %main_Line* %34, %Int32 0, %Int32 0, %Int32 0
	%36 = load %Int32, %Int32* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str9 to [0 x i8]*), %Int32 %36)
	%38 = getelementptr %main_Structx, %main_Structx* @main_s, %Int32 0, %Int32 0
	%39 = load %main_Line*, %main_Line** %38
	%40 = getelementptr %main_Line, %main_Line* %39, %Int32 0, %Int32 0, %Int32 1
	%41 = load %Int32, %Int32* %40
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str10 to [0 x i8]*), %Int32 %41)
	%43 = getelementptr %main_Structx, %main_Structx* @main_s, %Int32 0, %Int32 0
	%44 = load %main_Line*, %main_Line** %43
	%45 = getelementptr %main_Line, %main_Line* %44, %Int32 0, %Int32 1, %Int32 0
	%46 = load %Int32, %Int32* %45
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str11 to [0 x i8]*), %Int32 %46)
	%48 = getelementptr %main_Structx, %main_Structx* @main_s, %Int32 0, %Int32 0
	%49 = load %main_Line*, %main_Line** %48
	%50 = getelementptr %main_Line, %main_Line* %49, %Int32 0, %Int32 1, %Int32 1
	%51 = load %Int32, %Int32* %50
	%52 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str12 to [0 x i8]*), %Int32 %51)
	%53 = load %main_Structx, %main_Structx* @main_s
	%54 = alloca %main_Structx
	store %main_Structx %53, %main_Structx* %54
	%55 = getelementptr %main_Structx, %main_Structx* %54, %Int32 0, %Int32 0
	%56 = load %main_Line*, %main_Line** %55
	%57 = getelementptr %main_Line, %main_Line* %56, %Int32 0, %Int32 0, %Int32 0
	%58 = load %Int32, %Int32* %57
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str13 to [0 x i8]*), %Int32 %58)
	%60 = getelementptr %main_Structx, %main_Structx* %54, %Int32 0, %Int32 0
	%61 = load %main_Line*, %main_Line** %60
	%62 = getelementptr %main_Line, %main_Line* %61, %Int32 0, %Int32 0, %Int32 1
	%63 = load %Int32, %Int32* %62
	%64 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str14 to [0 x i8]*), %Int32 %63)
	%65 = getelementptr %main_Structx, %main_Structx* %54, %Int32 0, %Int32 0
	%66 = load %main_Line*, %main_Line** %65
	%67 = getelementptr %main_Line, %main_Line* %66, %Int32 0, %Int32 1, %Int32 0
	%68 = load %Int32, %Int32* %67
	%69 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str15 to [0 x i8]*), %Int32 %68)
	%70 = getelementptr %main_Structx, %main_Structx* %54, %Int32 0, %Int32 0
	%71 = load %main_Line*, %main_Line** %70
	%72 = getelementptr %main_Line, %main_Line* %71, %Int32 0, %Int32 1, %Int32 1
	%73 = load %Int32, %Int32* %72
	%74 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str16 to [0 x i8]*), %Int32 %73)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str17 to [0 x i8]*))
	%2 = insertvalue {%Nat32,%Nat32,%Nat32} zeroinitializer, %Nat32 7, 1
	%3 = insertvalue {%Nat32,%Nat32,%Nat32} %2, %Nat32 100, 2
	%4 = alloca {%Nat32,%Nat32,%Nat32}
	store {%Nat32,%Nat32,%Nat32} %3, {%Nat32,%Nat32,%Nat32}* %4
; if_0
; -- cons_composite_from_composite_by_adr --
	%5 = bitcast {%Nat32,%Nat32,%Nat32}* %4 to {%Nat32,%Nat32,%Nat32}*
	%6 = load {%Nat32,%Nat32,%Nat32}, {%Nat32,%Nat32,%Nat32}* %5
; -- end cons_composite_from_composite_by_adr --
	%7 = insertvalue {%Nat32,%Nat32,%Nat32} zeroinitializer, %Nat32 7, 1
	%8 = insertvalue {%Nat32,%Nat32,%Nat32} %7, %Nat32 100, 2
	%9 = alloca {%Nat32,%Nat32,%Nat32}
	store {%Nat32,%Nat32,%Nat32} %6, {%Nat32,%Nat32,%Nat32}* %9
	%10 = alloca {%Nat32,%Nat32,%Nat32}
	store {%Nat32,%Nat32,%Nat32} %8, {%Nat32,%Nat32,%Nat32}* %10
	%11 = bitcast {%Nat32,%Nat32,%Nat32}* %9 to i8*
	%12 = bitcast {%Nat32,%Nat32,%Nat32}* %10 to i8*
	%13 = call i1 (i8*, i8*, i64) @memeq(i8* %11, i8* %12, %Int64 16)
	%14 = icmp ne %Bool %13, 0
	br %Bool %14 , label %then_0, label %else_0
then_0:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str18 to [0 x i8]*))
	br label %endif_0
else_0:
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str19 to [0 x i8]*))
	br label %endif_0
endif_0:
	%17 = alloca %main_Point2D, align 4
	%18 = insertvalue %main_Point2D zeroinitializer, %Nat32 1, 0
	%19 = insertvalue %main_Point2D %18, %Nat32 2, 1
	store %main_Point2D %19, %main_Point2D* %17
	%20 = alloca %main_Point2D, align 4
	%21 = insertvalue %main_Point2D zeroinitializer, %Nat32 10, 0
	%22 = insertvalue %main_Point2D %21, %Nat32 20, 1
	store %main_Point2D %22, %main_Point2D* %20
; if_1
	%23 = bitcast %main_Point2D* %17 to i8*
	%24 = bitcast %main_Point2D* %20 to i8*
	%25 = call i1 (i8*, i8*, i64) @memeq(i8* %23, i8* %24, %Int64 8)
	%26 = icmp ne %Bool %25, 0
	br %Bool %26 , label %then_1, label %else_1
then_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str20 to [0 x i8]*))
	br label %endif_1
else_1:
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str21 to [0 x i8]*))
	br label %endif_1
endif_1:
	%29 = alloca %main_Point2D, align 4
	%30 = load %main_Point2D, %main_Point2D* %17
	store %main_Point2D %30, %main_Point2D* %29
	%31 = alloca {%Nat32,%Nat32}, align 4
	%32 = insertvalue {%Nat32,%Nat32} zeroinitializer, %Nat32 1, 0
	%33 = insertvalue {%Nat32,%Nat32} %32, %Nat32 2, 1
	store {%Nat32,%Nat32} %33, {%Nat32,%Nat32}* %31
; if_2
; -- cons_composite_from_composite_by_adr --
	%34 = bitcast {%Nat32,%Nat32}* %31 to %main_Point2D*
	%35 = load %main_Point2D, %main_Point2D* %34
; -- end cons_composite_from_composite_by_adr --
	%36 = alloca %main_Point2D
	store %main_Point2D %35, %main_Point2D* %36
	%37 = bitcast %main_Point2D* %29 to i8*
	%38 = bitcast %main_Point2D* %36 to i8*
	%39 = call i1 (i8*, i8*, i64) @memeq(i8* %37, i8* %38, %Int64 8)
	%40 = icmp ne %Bool %39, 0
	br %Bool %40 , label %then_2, label %else_2
then_2:
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str22 to [0 x i8]*))
	br label %endif_2
else_2:
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str23 to [0 x i8]*))
	br label %endif_2
endif_2:
	%43 = alloca {%Nat32,%Nat32}, align 4
	%44 = insertvalue {%Nat32,%Nat32} zeroinitializer, %Nat32 1, 0
	%45 = insertvalue {%Nat32,%Nat32} %44, %Nat32 2, 1
	store {%Nat32,%Nat32} %45, {%Nat32,%Nat32}* %43
; if_3
; -- cons_composite_from_composite_by_adr --
	%46 = bitcast {%Nat32,%Nat32}* %43 to {%Nat32,%Nat32}*
	%47 = load {%Nat32,%Nat32}, {%Nat32,%Nat32}* %46
; -- end cons_composite_from_composite_by_adr --
	%48 = alloca {%Nat32,%Nat32}
	store {%Nat32,%Nat32} %47, {%Nat32,%Nat32}* %48
	%49 = bitcast {%Nat32,%Nat32}* %31 to i8*
	%50 = bitcast {%Nat32,%Nat32}* %48 to i8*
	%51 = call i1 (i8*, i8*, i64) @memeq(i8* %49, i8* %50, %Int64 8)
	%52 = icmp ne %Bool %51, 0
	br %Bool %52 , label %then_3, label %else_3
then_3:
	%53 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str24 to [0 x i8]*))
	br label %endif_3
else_3:
	%54 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str25 to [0 x i8]*))
	br label %endif_3
endif_3:
; if_4
; -- cons_composite_from_composite_by_adr --
	%55 = bitcast {%Nat32,%Nat32}* %31 to %main_Point2D*
	%56 = load %main_Point2D, %main_Point2D* %55
; -- end cons_composite_from_composite_by_adr --
	%57 = alloca %main_Point2D
	store %main_Point2D %56, %main_Point2D* %57
	%58 = bitcast %main_Point2D* %29 to i8*
	%59 = bitcast %main_Point2D* %57 to i8*
	%60 = call i1 (i8*, i8*, i64) @memeq(i8* %58, i8* %59, %Int64 8)
	%61 = icmp ne %Bool %60, 0
	br %Bool %61 , label %then_4, label %else_4
then_4:
	%62 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str26 to [0 x i8]*))
	br label %endif_4
else_4:
	%63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str27 to [0 x i8]*))
	br label %endif_4
endif_4:
	%64 = insertvalue %main_Point2D zeroinitializer, %Nat32 100, 0
	%65 = insertvalue %main_Point2D %64, %Nat32 200, 1
	store %main_Point2D %65, %main_Point2D* %29
	store {%Nat32,%Nat32} zeroinitializer, {%Nat32,%Nat32}* %31
	%66 = alloca %Int32, align 4
	store %Int32 10, %Int32* %66
	%67 = alloca %Int32, align 4
	store %Int32 20, %Int32* %67
	%68 = load %Int32, %Int32* %66
	%69 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 %68, 0
	%70 = load %Int32, %Int32* %67
	%71 = insertvalue {%Int32,%Int32} %69, %Int32 %70, 1
	%72 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %71, {%Int32,%Int32}* %72
	store %Int32 111, %Int32* %66
	store %Int32 222, %Int32* %67
	%73 = getelementptr {%Int32,%Int32}, {%Int32,%Int32}* %72, %Int32 0, %Int32 0
	%74 = load %Int32, %Int32* %73
	%75 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str28 to [0 x i8]*), %Int32 %74)
	%76 = getelementptr {%Int32,%Int32}, {%Int32,%Int32}* %72, %Int32 0, %Int32 1
	%77 = load %Int32, %Int32* %76
	%78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @.str29 to [0 x i8]*), %Int32 %77)
; if_5
; -- cons_composite_from_composite_by_adr --
	%79 = bitcast {%Int32,%Int32}* %72 to {%Int32,%Int32}*
	%80 = load {%Int32,%Int32}, {%Int32,%Int32}* %79
; -- end cons_composite_from_composite_by_adr --
	%81 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 10, 0
	%82 = insertvalue {%Int32,%Int32} %81, %Int32 20, 1
	%83 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %80, {%Int32,%Int32}* %83
	%84 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %82, {%Int32,%Int32}* %84
	%85 = bitcast {%Int32,%Int32}* %83 to i8*
	%86 = bitcast {%Int32,%Int32}* %84 to i8*
	%87 = call i1 (i8*, i8*, i64) @memeq(i8* %85, i8* %86, %Int64 8)
	%88 = icmp ne %Bool %87, 0
	br %Bool %88 , label %then_5, label %else_5
then_5:
	%89 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str30 to [0 x i8]*))
	br label %endif_5
else_5:
	%90 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str31 to [0 x i8]*))
	br label %endif_5
endif_5:
	call void @main_test_records()
	ret %Int 0
}


