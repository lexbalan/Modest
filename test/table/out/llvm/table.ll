
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

; MODULE: table

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
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
; -- end print includes --
; -- print imports 'table' --
; -- 0
; -- end print imports 'table' --
; -- strings --
@str1 = private constant [24 x i8] [i8 108, i8 101, i8 110, i8 103, i8 116, i8 104, i8 111, i8 102, i8 40, i8 100, i8 97, i8 116, i8 97, i8 91, i8 48, i8 93, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [12 x i8] [i8 121, i8 48, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [12 x i8] [i8 121, i8 49, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [2 x i8] [i8 124, i8 0]
@str5 = private constant [4 x i8] [i8 32, i8 37, i8 115, i8 0]
@str6 = private constant [2 x i8] [i8 32, i8 0]
@str7 = private constant [3 x i8] [i8 124, i8 10, i8 0]
@str8 = private constant [2 x i8] [i8 43, i8 0]
@str9 = private constant [2 x i8] [i8 45, i8 0]
@str10 = private constant [3 x i8] [i8 43, i8 10, i8 0]
; -- endstrings --
%table_Table = type {
	[0 x %Str8*]*,
	[0 x [0 x %Str8*]]*,
	%Int32,
	%Int32,
	%Bool
};



; we cannot receive VLA by value,
; but we can receive pointer to open array
; and after construct pointer to closed array with required dimensions
define void @table_print(%table_Table* %table) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = alloca %Int32, align 4
	%4 = alloca %Int32, align 4

	; construct pointer to closed VLA array
; -- HANDLE VLA --
	%5 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%6 = load %Int32, %Int32* %5
	%7 = mul %Int32 %6, 1
; -- END HANDLE VLA --
; -- HANDLE VLA --
	%8 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%9 = load %Int32, %Int32* %8
	%10 = mul %Int32 %9, %7
; -- END HANDLE VLA --
; -- CONS PTR TO ARRAY --
	%11 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 1
	%12 = load [0 x [0 x %Str8*]]*, [0 x [0 x %Str8*]]** %11
	%13 = bitcast [0 x [0 x %Str8*]]* %12 to [0 x [0 x %Str8*]]*
	; BEGIN
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str1 to [0 x i8]*), %Int32 %7)
	; +++++++++++++
	%15 = alloca [0 x %Str8*]*, %Int32 1, align 8
; -- INDEX --
; -- INDEX VLA --
	%16 = mul %Int32 0, %7
	%17 = add %Int32 0, %16
	%18 = getelementptr [0 x %Str8*], [0 x [0 x %Str8*]]* %13, %Int32 %17
; -- END INDEX VLA --
	store [0 x %Str8*]* %18, [0 x %Str8*]** %15
; -- INDEX --
	%19 = load [0 x %Str8*]*, [0 x %Str8*]** %15
; -- INDEX VLA --
	%20 = mul %Int32 0, 1
	%21 = add %Int32 0, %20
	%22 = getelementptr %Str8*, [0 x %Str8*]* %19, %Int32 %21
; -- END INDEX VLA --
	%23 = load %Str8*, %Str8** %22
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str2 to [0 x i8]*), %Str8* %23)
	; @@@@@@@@@@@@@
	%25 = alloca [0 x %Str8*]*, %Int32 1, align 8
; -- INDEX --
; -- INDEX VLA --
	%26 = mul %Int32 1, %7
	%27 = add %Int32 0, %26
	%28 = getelementptr [0 x %Str8*], [0 x [0 x %Str8*]]* %13, %Int32 %27
; -- END INDEX VLA --
	store [0 x %Str8*]* %28, [0 x %Str8*]** %25
; -- INDEX --
	%29 = load [0 x %Str8*]*, [0 x %Str8*]** %25
; -- INDEX VLA --
	%30 = mul %Int32 0, 1
	%31 = add %Int32 0, %30
	%32 = getelementptr %Str8*, [0 x %Str8*]* %29, %Int32 %31
; -- END INDEX VLA --
	%33 = load %Str8*, %Str8** %32
	%34 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str3 to [0 x i8]*), %Str8* %33)
	;	// #############

	; array of size of columns (in characters)
; -- HANDLE VLA --
	%35 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%36 = load %Int32, %Int32* %35
	%37 = mul %Int32 %36, 1
; -- END HANDLE VLA --
	%38 = alloca %Int32, %Int32 %37, align 4
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%39 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%40 = load %Int32, %Int32* %39
	; -- end vol eval --
	; -- zero fill rest of array
	%41 = mul %Int32 %40, 4
	%42 = bitcast %Int32* %38 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %42, i8 0, %Int32 %41, i1 0)

	;
	; calculate max length (in chars) of column
	;
	%43 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%44 = load [0 x %Str8*]*, [0 x %Str8*]** %43
	%45 = icmp ne [0 x %Str8*]* %44, null
	br %Bool %45 , label %then_0, label %endif_0
then_0:
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%46 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%47 = load %Int32, %Int32* %3
	%48 = load %Int32, %Int32* %46
	%49 = icmp ult %Int32 %47, %48
	br %Bool %49 , label %body_1, label %break_1
body_1:
; -- INDEX --
	%50 = load %Int32, %Int32* %3
	%51 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%52 = load [0 x %Str8*]*, [0 x %Str8*]** %51
	%53 = bitcast %Int32 %50 to %Int32
	%54 = getelementptr [0 x %Str8*], [0 x %Str8*]* %52, %Int32 0, %Int32 %53
	%55 = load %Str8*, %Str8** %54
	%56 = call %SizeT @strlen(%Str8* %55)
	%57 = trunc %SizeT %56 to %Int32
; -- INDEX --
	%58 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%59 = mul %Int32 %58, 1
	%60 = add %Int32 0, %59
	%61 = getelementptr %Int32, [0 x %Int32]* %38, %Int32 %60
; -- END INDEX VLA --
	%62 = load %Int32, %Int32* %61
	%63 = icmp ugt %Int32 %57, %62
	br %Bool %63 , label %then_1, label %endif_1
then_1:
; -- INDEX --
	%64 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%65 = mul %Int32 %64, 1
	%66 = add %Int32 0, %65
	%67 = getelementptr %Int32, [0 x %Int32]* %38, %Int32 %66
; -- END INDEX VLA --
	store %Int32 %57, %Int32* %67
	br label %endif_1
endif_1:
	%68 = load %Int32, %Int32* %3
	%69 = add %Int32 %68, 1
	store %Int32 %69, %Int32* %3
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	store %Int32 0, %Int32* %3
	br label %again_2
again_2:
	%70 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%71 = load %Int32, %Int32* %3
	%72 = load %Int32, %Int32* %70
	%73 = icmp ult %Int32 %71, %72
	br %Bool %73 , label %body_2, label %break_2
body_2:
	store %Int32 0, %Int32* %4
	br label %again_3
again_3:
	%74 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%75 = load %Int32, %Int32* %4
	%76 = load %Int32, %Int32* %74
	%77 = icmp ult %Int32 %75, %76
	br %Bool %77 , label %body_3, label %break_3
body_3:
; -- INDEX --
	%78 = load %Int32, %Int32* %4
	%79 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%80 = mul %Int32 %79, %7
	%81 = add %Int32 0, %80
	%82 = mul %Int32 %78, 1
	%83 = add %Int32 %81, %82
	%84 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %13, %Int32 %83
; -- END INDEX VLA --
	%85 = load %Str8*, %Str8** %84
	%86 = call %SizeT @strlen(%Str8* %85)
	%87 = trunc %SizeT %86 to %Int32
; -- INDEX --
	%88 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%89 = mul %Int32 %88, 1
	%90 = add %Int32 0, %89
	%91 = getelementptr %Int32, [0 x %Int32]* %38, %Int32 %90
; -- END INDEX VLA --
	%92 = load %Int32, %Int32* %91
	%93 = icmp ugt %Int32 %87, %92
	br %Bool %93 , label %then_2, label %endif_2
then_2:
; -- INDEX --
	%94 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%95 = mul %Int32 %94, 1
	%96 = add %Int32 0, %95
	%97 = getelementptr %Int32, [0 x %Int32]* %38, %Int32 %96
; -- END INDEX VLA --
	store %Int32 %87, %Int32* %97
	br label %endif_2
endif_2:
	%98 = load %Int32, %Int32* %4
	%99 = add %Int32 %98, 1
	store %Int32 %99, %Int32* %4
	br label %again_3
break_3:
	%100 = load %Int32, %Int32* %3
	%101 = add %Int32 %100, 1
	store %Int32 %101, %Int32* %3
	br label %again_2
break_2:
	store %Int32 0, %Int32* %3
	br label %again_4
again_4:
	%102 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%103 = load %Int32, %Int32* %3
	%104 = load %Int32, %Int32* %102
	%105 = icmp ult %Int32 %103, %104
	br %Bool %105 , label %body_4, label %break_4
body_4:
	; добавляем по пробелу слева и справа
	; (для красивого отступа)
; -- INDEX --
	%106 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%107 = mul %Int32 %106, 1
	%108 = add %Int32 0, %107
	%109 = getelementptr %Int32, [0 x %Int32]* %38, %Int32 %108
; -- END INDEX VLA --
; -- INDEX --
	%110 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%111 = mul %Int32 %110, 1
	%112 = add %Int32 0, %111
	%113 = getelementptr %Int32, [0 x %Int32]* %38, %Int32 %112
; -- END INDEX VLA --
	%114 = load %Int32, %Int32* %113
	%115 = add %Int32 %114, 2
	store %Int32 %115, %Int32* %109
	%116 = load %Int32, %Int32* %3
	%117 = add %Int32 %116, 1
	store %Int32 %117, %Int32* %3
	br label %again_4
break_4:

	;
	; print table
	;

	; top border
	%118 = bitcast [0 x %Int32]* %38 to [0 x %Int32]*
	%119 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%120 = load %Int32, %Int32* %119
	call void @table_separator([0 x %Int32]* %118, %Int32 %120)
	%121 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%122 = load [0 x %Str8*]*, [0 x %Str8*]** %121
	%123 = icmp ne [0 x %Str8*]* %122, null
	br %Bool %123 , label %then_3, label %endif_3
then_3:
	%124 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%125 = load [0 x %Str8*]*, [0 x %Str8*]** %124
	%126 = bitcast [0 x %Int32]* %38 to [0 x %Int32]*
	%127 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%128 = load %Int32, %Int32* %127
	call void @table_printRow([0 x %Str8*]* %125, [0 x %Int32]* %126, %Int32 %128)
	%129 = bitcast [0 x %Int32]* %38 to [0 x %Int32]*
	%130 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%131 = load %Int32, %Int32* %130
	call void @table_separator([0 x %Int32]* %129, %Int32 %131)
	br label %endif_3
endif_3:
	store %Int32 0, %Int32* %3
	br label %again_5
again_5:
	%132 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%133 = load %Int32, %Int32* %3
	%134 = load %Int32, %Int32* %132
	%135 = icmp ult %Int32 %133, %134
	br %Bool %135 , label %body_5, label %break_5
body_5:
	; ????????
	%136 = alloca [0 x %Str8*]*, %Int32 1, align 8
; -- INDEX --
	%137 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%138 = mul %Int32 %137, %7
	%139 = add %Int32 0, %138
	%140 = getelementptr [0 x %Str8*], [0 x [0 x %Str8*]]* %13, %Int32 %139
; -- END INDEX VLA --
	store [0 x %Str8*]* %140, [0 x %Str8*]** %136
	; --------
	%141 = load [0 x %Str8*]*, [0 x %Str8*]** %136
	%142 = bitcast [0 x %Str8*]* %141 to [0 x %Str8*]*
	%143 = bitcast [0 x %Int32]* %38 to [0 x %Int32]*
	%144 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%145 = load %Int32, %Int32* %144
	call void @table_printRow([0 x %Str8*]* %142, [0 x %Int32]* %143, %Int32 %145)
	%146 = load %Int32, %Int32* %3
	%147 = add %Int32 %146, 1
	store %Int32 %147, %Int32* %3
	%148 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 4
	%149 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%150 = load %Int32, %Int32* %3
	%151 = load %Int32, %Int32* %149
	%152 = icmp ult %Int32 %150, %151
	%153 = load %Bool, %Bool* %148
	%154 = and %Bool %153, %152
	br %Bool %154 , label %then_4, label %endif_4
then_4:
	%155 = bitcast [0 x %Int32]* %38 to [0 x %Int32]*
	%156 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%157 = load %Int32, %Int32* %156
	call void @table_separator([0 x %Int32]* %155, %Int32 %157)
	br label %endif_4
endif_4:
	br label %again_5
break_5:

	; bottom border
	%158 = bitcast [0 x %Int32]* %38 to [0 x %Int32]*
	%159 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%160 = load %Int32, %Int32* %159
	call void @table_separator([0 x %Int32]* %158, %Int32 %160)
	%161 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %161)
	ret void
}

define internal void @table_printRow([0 x %Str8*]* %raw_row, [0 x %Int32]* %sz, %Int32 %nCols) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	;printf("? = %x\n", unsafe Word64 raw_row)
; -- HANDLE VLA --
	%3 = mul %Int32 %nCols, 1
; -- END HANDLE VLA --
; -- CONS PTR TO ARRAY --
	%4 = bitcast [0 x %Str8*]* %raw_row to [0 x %Str8*]*
	%5 = alloca %Int32, align 4
	store %Int32 0, %Int32* %5
	br label %again_1
again_1:
	%6 = load %Int32, %Int32* %5
	%7 = icmp ult %Int32 %6, %nCols
	br %Bool %7 , label %body_1, label %break_1
body_1:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str4 to [0 x i8]*))
; -- INDEX --
	%9 = load %Int32, %Int32* %5
; -- INDEX VLA --
	%10 = mul %Int32 %9, 1
	%11 = add %Int32 0, %10
	%12 = getelementptr %Str8*, [0 x %Str8*]* %4, %Int32 %11
; -- END INDEX VLA --
	%13 = load %Str8*, %Str8** %12
	%14 = alloca %Int32, align 4
	%15 = call %SizeT @strlen(%Str8* %13)
	%16 = trunc %SizeT %15 to %Int32
	store %Int32 %16, %Int32* %14
; -- INDEX --
	%17 = getelementptr %Str8, %Str8* %13, %Int32 0, %Int32 0
	%18 = load %Char8, %Char8* %17
	%19 = icmp ne %Char8 %18, 0
	br %Bool %19 , label %then_0, label %endif_0
then_0:
	%20 = load %Int32, %Int32* %14
	%21 = add %Int32 %20, 1
	store %Int32 %21, %Int32* %14
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str5 to [0 x i8]*), %Str8* %13)
	br label %endif_0
endif_0:
	%23 = alloca %Int32, align 4
	store %Int32 0, %Int32* %23
	br label %again_2
again_2:
; -- INDEX --
	%24 = load %Int32, %Int32* %5
	%25 = bitcast %Int32 %24 to %Int32
	%26 = getelementptr [0 x %Int32], [0 x %Int32]* %sz, %Int32 0, %Int32 %25
	%27 = load %Int32, %Int32* %26
	%28 = load %Int32, %Int32* %14
	%29 = sub %Int32 %27, %28
	%30 = load %Int32, %Int32* %23
	%31 = icmp ult %Int32 %30, %29
	br %Bool %31 , label %body_2, label %break_2
body_2:
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str6 to [0 x i8]*))
	%33 = load %Int32, %Int32* %23
	%34 = add %Int32 %33, 1
	store %Int32 %34, %Int32* %23
	br label %again_2
break_2:
	%35 = load %Int32, %Int32* %5
	%36 = add %Int32 %35, 1
	store %Int32 %36, %Int32* %5
	br label %again_1
break_1:
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str7 to [0 x i8]*))
	%38 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %38)
	ret void
}



; печатает строку +---+---+ отделяющую записи таблицы
; получает указатель на массив с размерами колонок
; и количество элементов в ней
define internal void @table_separator([0 x %Int32]* %sz, %Int32 %n) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp ult %Int32 %2, %n
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str8 to [0 x i8]*))
	%5 = alloca %Int32, align 4
	store %Int32 0, %Int32* %5
	br label %again_2
again_2:
; -- INDEX --
	%6 = load %Int32, %Int32* %1
	%7 = bitcast %Int32 %6 to %Int32
	%8 = getelementptr [0 x %Int32], [0 x %Int32]* %sz, %Int32 0, %Int32 %7
	%9 = load %Int32, %Int32* %5
	%10 = load %Int32, %Int32* %8
	%11 = icmp ult %Int32 %9, %10
	br %Bool %11 , label %body_2, label %break_2
body_2:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str9 to [0 x i8]*))
	%13 = load %Int32, %Int32* %5
	%14 = add %Int32 %13, 1
	store %Int32 %14, %Int32* %5
	br label %again_2
break_2:
	%15 = load %Int32, %Int32* %1
	%16 = add %Int32 %15, 1
	store %Int32 %16, %Int32* %1
	br label %again_1
break_1:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str10 to [0 x i8]*))
	ret void
}


