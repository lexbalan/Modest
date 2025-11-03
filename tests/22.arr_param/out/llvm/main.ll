
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
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
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
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [15 x i8] [i8 116, i8 101, i8 115, i8 116, i8 49, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 33, i8 10, i8 0]
@str2 = private constant [15 x i8] [i8 116, i8 101, i8 115, i8 116, i8 50, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 33, i8 10, i8 0]
@str3 = private constant [15 x i8] [i8 116, i8 101, i8 115, i8 116, i8 51, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 33, i8 10, i8 0]
@str4 = private constant [12 x i8] [i8 100, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
; -- endstrings --


; returns array by value
define internal void @getarr10([10 x %Int32]* %0) {
	%2 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%3 = insertvalue [10 x %Int32] %2, %Int32 2, 2
	%4 = insertvalue [10 x %Int32] %3, %Int32 3, 3
	%5 = insertvalue [10 x %Int32] %4, %Int32 4, 4
	%6 = insertvalue [10 x %Int32] %5, %Int32 5, 5
	%7 = insertvalue [10 x %Int32] %6, %Int32 6, 6
	%8 = insertvalue [10 x %Int32] %7, %Int32 7, 7
	%9 = insertvalue [10 x %Int32] %8, %Int32 8, 8
	%10 = insertvalue [10 x %Int32] %9, %Int32 9, 9
	%11 = zext i8 10 to %Nat32
	store [10 x %Int32] %10, [10 x %Int32]* %0
	ret void
}



; receive & returns array by value
define internal void @arraysAdd([10 x %Int32]* %0, [10 x %Int32] %__a, [10 x %Int32] %__b) {
	%a = alloca [10 x %Int32]
	%2 = zext i8 10 to %Nat32
	store [10 x %Int32] %__a, [10 x %Int32]* %a
	%b = alloca [10 x %Int32]
	%3 = zext i8 10 to %Nat32
	store [10 x %Int32] %__b, [10 x %Int32]* %b
	%4 = alloca [10 x %Int32], align 1
	%5 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %5
; while_1
	br label %again_1
again_1:
	%6 = load %Nat32, %Nat32* %5
	%7 = icmp ult %Nat32 %6, 10
	br %Bool %7 , label %body_1, label %break_1
body_1:
	%8 = load %Nat32, %Nat32* %5
	%9 = bitcast %Nat32 %8 to %Nat32
	%10 = getelementptr [10 x %Int32], [10 x %Int32]* %4, %Int32 0, %Nat32 %9
	%11 = load %Nat32, %Nat32* %5
	%12 = bitcast %Nat32 %11 to %Nat32
	%13 = getelementptr [10 x %Int32], [10 x %Int32]* %a, %Int32 0, %Nat32 %12
	%14 = load %Nat32, %Nat32* %5
	%15 = bitcast %Nat32 %14 to %Nat32
	%16 = getelementptr [10 x %Int32], [10 x %Int32]* %b, %Int32 0, %Nat32 %15
	%17 = load %Int32, %Int32* %13
	%18 = load %Int32, %Int32* %16
	%19 = add %Int32 %17, %18
	store %Int32 %19, %Int32* %10
	%20 = load %Nat32, %Nat32* %5
	%21 = add %Nat32 %20, 1
	store %Nat32 %21, %Nat32* %5
	br label %again_1
break_1:
	%22 = load [10 x %Int32], [10 x %Int32]* %4
	%23 = zext i8 10 to %Nat32
	store [10 x %Int32] %22, [10 x %Int32]* %0
	ret void
}

define %Int32 @main() {; alloca memory for return value
	%1 = alloca [10 x %Int32]
	call void @getarr10([10 x %Int32]* %1)
; if_0
	%2 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%3 = insertvalue [10 x %Int32] %2, %Int32 2, 2
	%4 = insertvalue [10 x %Int32] %3, %Int32 3, 3
	%5 = insertvalue [10 x %Int32] %4, %Int32 4, 4
	%6 = insertvalue [10 x %Int32] %5, %Int32 5, 5
	%7 = insertvalue [10 x %Int32] %6, %Int32 6, 6
	%8 = insertvalue [10 x %Int32] %7, %Int32 7, 7
	%9 = insertvalue [10 x %Int32] %8, %Int32 8, 8
	%10 = insertvalue [10 x %Int32] %9, %Int32 9, 9
	%11 = alloca [10 x %Int32]
	%12 = zext i8 10 to %Nat32
	store [10 x %Int32] %10, [10 x %Int32]* %11
	%13 = bitcast [10 x %Int32]* %1 to i8*
	%14 = bitcast [10 x %Int32]* %11 to i8*
	%15 = call i1 (i8*, i8*, i64) @memeq(i8* %13, i8* %14, %Int64 40)
	%16 = icmp ne %Bool %15, 0
	br %Bool %16 , label %then_0, label %endif_0
then_0:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str1 to [0 x i8]*))
	br label %endif_0
endif_0:
	%18 = insertvalue [10 x i8] zeroinitializer, i8 10, 1
	%19 = insertvalue [10 x i8] %18, i8 20, 2
	%20 = insertvalue [10 x i8] %19, i8 30, 3
	%21 = insertvalue [10 x i8] %20, i8 40, 4
	%22 = insertvalue [10 x i8] %21, i8 50, 5
	%23 = insertvalue [10 x i8] %22, i8 60, 6
	%24 = insertvalue [10 x i8] %23, i8 70, 7
	%25 = insertvalue [10 x i8] %24, i8 80, 8
	%26 = insertvalue [10 x i8] %25, i8 90, 9
	%27 = alloca [10 x i8]
	%28 = zext i8 10 to %Nat32
	store [10 x i8] %26, [10 x i8]* %27
	%29 = load [10 x %Int32], [10 x %Int32]* %1
	%30 = insertvalue [10 x %Int32] zeroinitializer, %Int32 10, 1
	%31 = insertvalue [10 x %Int32] %30, %Int32 20, 2
	%32 = insertvalue [10 x %Int32] %31, %Int32 30, 3
	%33 = insertvalue [10 x %Int32] %32, %Int32 40, 4
	%34 = insertvalue [10 x %Int32] %33, %Int32 50, 5
	%35 = insertvalue [10 x %Int32] %34, %Int32 60, 6
	%36 = insertvalue [10 x %Int32] %35, %Int32 70, 7
	%37 = insertvalue [10 x %Int32] %36, %Int32 80, 8
	%38 = insertvalue [10 x %Int32] %37, %Int32 90, 9; alloca memory for return value
	%39 = alloca [10 x %Int32]
	call void @arraysAdd([10 x %Int32]* %39, [10 x %Int32] %29, [10 x %Int32] %38)
; if_1
	%40 = insertvalue [10 x %Int32] zeroinitializer, %Int32 11, 1
	%41 = insertvalue [10 x %Int32] %40, %Int32 22, 2
	%42 = insertvalue [10 x %Int32] %41, %Int32 33, 3
	%43 = insertvalue [10 x %Int32] %42, %Int32 44, 4
	%44 = insertvalue [10 x %Int32] %43, %Int32 55, 5
	%45 = insertvalue [10 x %Int32] %44, %Int32 66, 6
	%46 = insertvalue [10 x %Int32] %45, %Int32 77, 7
	%47 = insertvalue [10 x %Int32] %46, %Int32 88, 8
	%48 = insertvalue [10 x %Int32] %47, %Int32 99, 9
	%49 = alloca [10 x %Int32]
	%50 = zext i8 10 to %Nat32
	store [10 x %Int32] %48, [10 x %Int32]* %49
	%51 = bitcast [10 x %Int32]* %39 to i8*
	%52 = bitcast [10 x %Int32]* %49 to i8*
	%53 = call i1 (i8*, i8*, i64) @memeq(i8* %51, i8* %52, %Int64 40)
	%54 = icmp ne %Bool %53, 0
	br %Bool %54 , label %then_1, label %endif_1
then_1:
	%55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*))
	br label %endif_1
endif_1:
	%56 = load [10 x %Int32], [10 x %Int32]* %1
	%57 = load [10 x %Int32], [10 x %Int32]* %1; alloca memory for return value
	%58 = alloca [10 x %Int32]
	call void @arraysAdd([10 x %Int32]* %58, [10 x %Int32] %56, [10 x %Int32] %57)
; if_2
	%59 = insertvalue [10 x %Int32] zeroinitializer, %Int32 2, 1
	%60 = insertvalue [10 x %Int32] %59, %Int32 4, 2
	%61 = insertvalue [10 x %Int32] %60, %Int32 6, 3
	%62 = insertvalue [10 x %Int32] %61, %Int32 8, 4
	%63 = insertvalue [10 x %Int32] %62, %Int32 10, 5
	%64 = insertvalue [10 x %Int32] %63, %Int32 12, 6
	%65 = insertvalue [10 x %Int32] %64, %Int32 14, 7
	%66 = insertvalue [10 x %Int32] %65, %Int32 16, 8
	%67 = insertvalue [10 x %Int32] %66, %Int32 18, 9
	%68 = alloca [10 x %Int32]
	%69 = zext i8 10 to %Nat32
	store [10 x %Int32] %67, [10 x %Int32]* %68
	%70 = bitcast [10 x %Int32]* %58 to i8*
	%71 = bitcast [10 x %Int32]* %68 to i8*
	%72 = call i1 (i8*, i8*, i64) @memeq(i8* %70, i8* %71, %Int64 40)
	%73 = icmp ne %Bool %72, 0
	br %Bool %73 , label %then_2, label %endif_2
then_2:
	%74 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str3 to [0 x i8]*))
	br label %endif_2
endif_2:
	%75 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %75
; while_1
	br label %again_1
again_1:
	%76 = load %Nat32, %Nat32* %75
	%77 = icmp ult %Nat32 %76, 10
	br %Bool %77 , label %body_1, label %break_1
body_1:
	%78 = load %Nat32, %Nat32* %75
	%79 = load %Nat32, %Nat32* %75
	%80 = bitcast %Nat32 %79 to %Nat32
	%81 = getelementptr [10 x %Int32], [10 x %Int32]* %58, %Int32 0, %Nat32 %80
	%82 = load %Int32, %Int32* %81
	%83 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str4 to [0 x i8]*), %Nat32 %78, %Int32 %82)
	%84 = load %Nat32, %Nat32* %75
	%85 = add %Nat32 %84, 1
	store %Nat32 %85, %Nat32* %75
	br label %again_1
break_1:
	ret %Int32 0
}


