
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64
%PointerToConst = type i8*


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare %Int @setvbuf(%File* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %stream, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


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


; -- SOURCE: src/main.cm

@str1 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 115, i8 10, i8 0]
@str3 = private constant [13 x i8] [i8 115, i8 49, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [13 x i8] [i8 115, i8 50, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [12 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str7 = private constant [12 x i8] [i8 115, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str9 = private constant [23 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 111, i8 105, i8 110, i8 116, i8 101, i8 114, i8 32, i8 116, i8 111, i8 32, i8 115, i8 108, i8 105, i8 99, i8 101, i8 10, i8 0]
@str10 = private constant [46 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]



define void @array_print([0 x i32]* %pa, i32 %len) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	%2 = load i32, i32* %1
	%3 = icmp slt i32 %2, %len
	br i1 %3 , label %body_1, label %break_1
body_1:
	%4 = load i32, i32* %1
	%5 = load i32, i32* %1
	%6 = getelementptr inbounds [0 x i32], [0 x i32]* %pa, i32 0, i32 %5
	%7 = load i32, i32* %6
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*), i32 %4, i32 %7)
	%9 = load i32, i32* %1
	%10 = add i32 %9, 1
	store i32 %10, i32* %1
	br label %again_1
break_1:
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*))
	;
	; by value
	;
	%2 = alloca [10 x i32], align 4
	%3 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%4 = insertvalue [10 x i32] %3, i32 1, 1
	%5 = insertvalue [10 x i32] %4, i32 2, 2
	%6 = insertvalue [10 x i32] %5, i32 3, 3
	%7 = insertvalue [10 x i32] %6, i32 4, 4
	%8 = insertvalue [10 x i32] %7, i32 5, 5
	%9 = insertvalue [10 x i32] %8, i32 6, 6
	%10 = insertvalue [10 x i32] %9, i32 7, 7
	%11 = insertvalue [10 x i32] %10, i32 8, 8
	%12 = insertvalue [10 x i32] %11, i32 9, 9
	store [10 x i32] %12, [10 x i32]* %2
	%13 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i8 1
	%14 = bitcast i32* %13 to [2 x i32]*
	%15 = load [2 x i32], [2 x i32]* %14
	%16 = alloca [2 x i32]
	store [2 x i32] %15, [2 x i32]* %16
	%17 = alloca i32, align 4
	store i32 0, i32* %17
	br label %again_1
again_1:
	%18 = load i32, i32* %17
	%19 = icmp slt i32 %18, 2
	br i1 %19 , label %body_1, label %break_1
body_1:
	%20 = load i32, i32* %17
	%21 = load i32, i32* %17
	%22 = getelementptr inbounds [2 x i32], [2 x i32]* %16, i32 0, i32 %21
	%23 = load i32, i32* %22
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), i32 %20, i32 %23)
	%25 = load i32, i32* %17
	%26 = add i32 %25, 1
	store i32 %26, i32* %17
	br label %again_1
break_1:
	;
	; by ptr
	;
	%27 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i8 5
;
	%28 = bitcast i32* %27 to [4 x i32]*
	%29 = load [4 x i32], [4 x i32]* %28
	%30 = alloca [4 x i32]
	store [4 x i32] %29, [4 x i32]* %30
	store i32 0, i32* %17
	br label %again_2
again_2:
	%31 = load i32, i32* %17
	%32 = icmp slt i32 %31, 4
	br i1 %32 , label %body_2, label %break_2
body_2:
	%33 = load i32, i32* %17
	%34 = load i32, i32* %17
	%35 = getelementptr inbounds [4 x i32], [4 x i32]* %30, i32 0, i32 %34
	%36 = load i32, i32* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str4 to [0 x i8]*), i32 %33, i32 %36)
	%38 = load i32, i32* %17
	%39 = add i32 %38, 1
	store i32 %39, i32* %17
	br label %again_2
break_2:
	%40 = alloca [2 x i32], align 4
	%41 = load [2 x i32], [2 x i32]* %16
	store [2 x i32] %41, [2 x i32]* %40
	%42 = alloca [4 x i32], align 4
	%43 = load [4 x i32], [4 x i32]* %30
	store [4 x i32] %43, [4 x i32]* %42
	%44 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i8 2
	%45 = bitcast i32* %44 to [4 x i32]*
	%46 = insertvalue [4 x i32] zeroinitializer, i32 10, 0
	%47 = insertvalue [4 x i32] %46, i32 20, 1
	%48 = insertvalue [4 x i32] %47, i32 30, 2
	%49 = insertvalue [4 x i32] %48, i32 40, 3
	store [4 x i32] %49, [4 x i32]* %45
	store i32 0, i32* %17
	br label %again_3
again_3:
	%50 = load i32, i32* %17
	%51 = icmp slt i32 %50, 10
	br i1 %51 , label %body_3, label %break_3
body_3:
	%52 = load i32, i32* %17
	%53 = load i32, i32* %17
	%54 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i32 %53
	%55 = load i32, i32* %54
	%56 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str5 to [0 x i8]*), i32 %52, i32 %55)
	%57 = load i32, i32* %17
	%58 = add i32 %57, 1
	store i32 %58, i32* %17
	br label %again_3
break_3:
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str6 to [0 x i8]*))
	%60 = alloca [10 x i32], align 4
	%61 = insertvalue [10 x i32] zeroinitializer, i32 10, 0
	%62 = insertvalue [10 x i32] %61, i32 20, 1
	%63 = insertvalue [10 x i32] %62, i32 30, 2
	%64 = insertvalue [10 x i32] %63, i32 40, 3
	%65 = insertvalue [10 x i32] %64, i32 50, 4
	%66 = insertvalue [10 x i32] %65, i32 60, 5
	%67 = insertvalue [10 x i32] %66, i32 70, 6
	%68 = insertvalue [10 x i32] %67, i32 80, 7
	%69 = insertvalue [10 x i32] %68, i32 90, 8
	%70 = insertvalue [10 x i32] %69, i32 100, 9
	store [10 x i32] %70, [10 x i32]* %60
	%71 = getelementptr inbounds [10 x i32], [10 x i32]* %60, i32 0, i8 2
	%72 = bitcast i32* %71 to [4 x i32]*
	%73 = insertvalue [4 x i32] zeroinitializer, i32 0, 0
	%74 = insertvalue [4 x i32] %73, i32 0, 1
	%75 = insertvalue [4 x i32] %74, i32 0, 2
	%76 = insertvalue [4 x i32] %75, i32 0, 3
	store [4 x i32] %76, [4 x i32]* %72
	store i32 0, i32* %17
	br label %again_4
again_4:
	%77 = load i32, i32* %17
	%78 = icmp slt i32 %77, 10
	br i1 %78 , label %body_4, label %break_4
body_4:
	%79 = load i32, i32* %17
	%80 = load i32, i32* %17
	%81 = getelementptr inbounds [10 x i32], [10 x i32]* %60, i32 0, i32 %80
	%82 = load i32, i32* %81
	%83 = bitcast i32 %82 to i32
	%84 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str7 to [0 x i8]*), i32 %79, i32 %83)
	%85 = load i32, i32* %17
	%86 = add i32 %85, 1
	store i32 %86, i32* %17
	br label %again_4
break_4:
	%87 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str8 to [0 x i8]*))
	%88 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str9 to [0 x i8]*))
	%89 = getelementptr inbounds [10 x i32], [10 x i32]* %60, i32 0, i8 2
	%90 = bitcast i32* %89 to [7 x i32]*
	%91 = bitcast [7 x i32]* %90 to [0 x i32]*
	call void ([0 x i32]*, i32) @array_print([0 x i32]* %91, i32 7)
	%92 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([46 x i8]* @str10 to [0 x i8]*))
	%93 = getelementptr inbounds [7 x i32], [7 x i32]* %90, i32 0, i32 0
	store i32 123, i32* %93
	%94 = bitcast [7 x i32]* %90 to [0 x i32]*
	call void ([0 x i32]*, i32) @array_print([0 x i32]* %94, i32 7)
	ret %Int 0
}


