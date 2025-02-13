
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
@str1 = private constant [2 x i8] [i8 124, i8 0]
@str2 = private constant [4 x i8] [i8 32, i8 37, i8 115, i8 0]
@str3 = private constant [2 x i8] [i8 32, i8 0]
@str4 = private constant [3 x i8] [i8 124, i8 10, i8 0]
@str5 = private constant [2 x i8] [i8 43, i8 0]
@str6 = private constant [2 x i8] [i8 45, i8 0]
@str7 = private constant [3 x i8] [i8 43, i8 10, i8 0]
; -- endstrings --
%table_Row = type {
};

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
	%5 = mul %Int32 1, 1
	%6 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%7 = load %Int32, %Int32* %6
	%8 = mul %Int32 %7, 1
	%9 = mul %Int32 %7, 8
	%10 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%11 = load %Int32, %Int32* %10
	%12 = mul %Int32 %11, %8
	%13 = mul %Int32 %11, %9
	%14 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 1
	%15 = load [0 x [0 x %Str8*]]*, [0 x [0 x %Str8*]]** %14
	%16 = bitcast [0 x [0 x %Str8*]]* %15 to [0 x [0 x %Str8*]]*

	; array of size of columns (in characters)
	%17 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%18 = load %Int32, %Int32* %17
	%19 = mul %Int32 %18, 1
	%20 = mul %Int32 %18, 4
	%21 = alloca %Int32, %Int32 %19, align 4
	%22 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%23 = load %Int32, %Int32* %22
	%24 = mul %Int32 %23, 4
	%25 = bitcast %Int32* %21 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %25, i8 0, %Int32 %24, i1 0)

	;
	; calculate max length (in chars) of column
	;
	%26 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%27 = load [0 x %Str8*]*, [0 x %Str8*]** %26
	%28 = icmp ne [0 x %Str8*]* %27, null
	br %Bool %28 , label %then_0, label %endif_0
then_0:
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%29 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%30 = load %Int32, %Int32* %3
	%31 = load %Int32, %Int32* %29
	%32 = icmp ult %Int32 %30, %31
	br %Bool %32 , label %body_1, label %break_1
body_1:
	%33 = load %Int32, %Int32* %3
	%34 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%35 = load [0 x %Str8*]*, [0 x %Str8*]** %34
	%36 = bitcast %Int32 %33 to %Int32
	%37 = getelementptr [0 x %Str8*], [0 x %Str8*]* %35, %Int32 0, %Int32 %36
	%38 = load %Str8*, %Str8** %37
	%39 = call %SizeT @strlen(%Str8* %38)
	%40 = trunc %SizeT %39 to %Int32
	%41 = load %Int32, %Int32* %3
	%42 = mul %Int32 %41, 1
	%43 = add %Int32 0, %42
	%44 = getelementptr %Int32, [0 x %Int32]* %21, %Int32 %43
	%45 = load %Int32, %Int32* %44
	%46 = icmp ugt %Int32 %40, %45
	br %Bool %46 , label %then_1, label %endif_1
then_1:
	%47 = load %Int32, %Int32* %3
	%48 = mul %Int32 %47, 1
	%49 = add %Int32 0, %48
	%50 = getelementptr %Int32, [0 x %Int32]* %21, %Int32 %49
	store %Int32 %40, %Int32* %50
	br label %endif_1
endif_1:
	%51 = load %Int32, %Int32* %3
	%52 = add %Int32 %51, 1
	store %Int32 %52, %Int32* %3
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	store %Int32 0, %Int32* %3
	br label %again_2
again_2:
	%53 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%54 = load %Int32, %Int32* %3
	%55 = load %Int32, %Int32* %53
	%56 = icmp ult %Int32 %54, %55
	br %Bool %56 , label %body_2, label %break_2
body_2:
	store %Int32 0, %Int32* %4
	br label %again_3
again_3:
	%57 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%58 = load %Int32, %Int32* %4
	%59 = load %Int32, %Int32* %57
	%60 = icmp ult %Int32 %58, %59
	br %Bool %60 , label %body_3, label %break_3
body_3:
	%61 = load %Int32, %Int32* %4
	%62 = load %Int32, %Int32* %3
	%63 = mul %Int32 %62, %8
	%64 = add %Int32 0, %63
	%65 = mul %Int32 %61, 1
	%66 = add %Int32 %64, %65
	%67 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %16, %Int32 %66
	%68 = load %Str8*, %Str8** %67
	%69 = call %SizeT @strlen(%Str8* %68)
	%70 = trunc %SizeT %69 to %Int32
	%71 = load %Int32, %Int32* %4
	%72 = mul %Int32 %71, 1
	%73 = add %Int32 0, %72
	%74 = getelementptr %Int32, [0 x %Int32]* %21, %Int32 %73
	%75 = load %Int32, %Int32* %74
	%76 = icmp ugt %Int32 %70, %75
	br %Bool %76 , label %then_2, label %endif_2
then_2:
	%77 = load %Int32, %Int32* %4
	%78 = mul %Int32 %77, 1
	%79 = add %Int32 0, %78
	%80 = getelementptr %Int32, [0 x %Int32]* %21, %Int32 %79
	store %Int32 %70, %Int32* %80
	br label %endif_2
endif_2:
	%81 = load %Int32, %Int32* %4
	%82 = add %Int32 %81, 1
	store %Int32 %82, %Int32* %4
	br label %again_3
break_3:
	%83 = load %Int32, %Int32* %3
	%84 = add %Int32 %83, 1
	store %Int32 %84, %Int32* %3
	br label %again_2
break_2:
	store %Int32 0, %Int32* %3
	br label %again_4
again_4:
	%85 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%86 = load %Int32, %Int32* %3
	%87 = load %Int32, %Int32* %85
	%88 = icmp ult %Int32 %86, %87
	br %Bool %88 , label %body_4, label %break_4
body_4:
	; добавляем по пробелу слева и справа
	; (для красивого отступа)
	%89 = load %Int32, %Int32* %3
	%90 = mul %Int32 %89, 1
	%91 = add %Int32 0, %90
	%92 = getelementptr %Int32, [0 x %Int32]* %21, %Int32 %91
	%93 = load %Int32, %Int32* %3
	%94 = mul %Int32 %93, 1
	%95 = add %Int32 0, %94
	%96 = getelementptr %Int32, [0 x %Int32]* %21, %Int32 %95
	%97 = load %Int32, %Int32* %96
	%98 = add %Int32 %97, 2
	store %Int32 %98, %Int32* %92
	%99 = load %Int32, %Int32* %3
	%100 = add %Int32 %99, 1
	store %Int32 %100, %Int32* %3
	br label %again_4
break_4:

	;
	; print table
	;

	; top border
	%101 = bitcast [0 x %Int32]* %21 to [0 x %Int32]*
	%102 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%103 = load %Int32, %Int32* %102
	call void @table_separator([0 x %Int32]* %101, %Int32 %103)
	%104 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%105 = load [0 x %Str8*]*, [0 x %Str8*]** %104
	%106 = icmp ne [0 x %Str8*]* %105, null
	br %Bool %106 , label %then_3, label %endif_3
then_3:
	%107 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%108 = load [0 x %Str8*]*, [0 x %Str8*]** %107
	%109 = bitcast [0 x %Int32]* %21 to [0 x %Int32]*
	%110 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%111 = load %Int32, %Int32* %110
	call void @table_printRow([0 x %Str8*]* %108, [0 x %Int32]* %109, %Int32 %111)
	%112 = bitcast [0 x %Int32]* %21 to [0 x %Int32]*
	%113 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%114 = load %Int32, %Int32* %113
	call void @table_separator([0 x %Int32]* %112, %Int32 %114)
	br label %endif_3
endif_3:
	store %Int32 0, %Int32* %3
	br label %again_5
again_5:
	%115 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%116 = load %Int32, %Int32* %3
	%117 = load %Int32, %Int32* %115
	%118 = icmp ult %Int32 %116, %117
	br %Bool %118 , label %body_5, label %break_5
body_5:
	%119 = load %Int32, %Int32* %3
	%120 = mul %Int32 %119, %8
	%121 = add %Int32 0, %120
	%122 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %16, %Int32 %121
	%123 = bitcast [0 x %Str8*]* %122 to [0 x %Str8*]*
	%124 = bitcast [0 x %Int32]* %21 to [0 x %Int32]*
	%125 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%126 = load %Int32, %Int32* %125
	call void @table_printRow([0 x %Str8*]* %123, [0 x %Int32]* %124, %Int32 %126)
	%127 = load %Int32, %Int32* %3
	%128 = add %Int32 %127, 1
	store %Int32 %128, %Int32* %3
	%129 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 4
	%130 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%131 = load %Int32, %Int32* %3
	%132 = load %Int32, %Int32* %130
	%133 = icmp ult %Int32 %131, %132
	%134 = load %Bool, %Bool* %129
	%135 = and %Bool %134, %133
	br %Bool %135 , label %then_4, label %endif_4
then_4:
	%136 = bitcast [0 x %Int32]* %21 to [0 x %Int32]*
	%137 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%138 = load %Int32, %Int32* %137
	call void @table_separator([0 x %Int32]* %136, %Int32 %138)
	br label %endif_4
endif_4:
	br label %again_5
break_5:

	; bottom border
	%139 = bitcast [0 x %Int32]* %21 to [0 x %Int32]*
	%140 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%141 = load %Int32, %Int32* %140
	call void @table_separator([0 x %Int32]* %139, %Int32 %141)
	%142 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %142)
	ret void
}

define internal void @table_printRow([0 x %Str8*]* %raw_row, [0 x %Int32]* %sz, %Int32 %nCols) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = mul %Int32 %nCols, 1
	%4 = mul %Int32 %nCols, 8
	%5 = bitcast [0 x %Str8*]* %raw_row to [0 x %Str8*]*
	%6 = alloca %Int32, align 4
	store %Int32 0, %Int32* %6
	br label %again_1
again_1:
	%7 = load %Int32, %Int32* %6
	%8 = icmp ult %Int32 %7, %nCols
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str1 to [0 x i8]*))
	%10 = load %Int32, %Int32* %6
	%11 = mul %Int32 %10, 1
	%12 = add %Int32 0, %11
	%13 = getelementptr %Str8*, [0 x %Str8*]* %5, %Int32 %12
	%14 = load %Str8*, %Str8** %13
	%15 = alloca %Int32, align 4
	%16 = call %SizeT @strlen(%Str8* %14)
	%17 = trunc %SizeT %16 to %Int32
	store %Int32 %17, %Int32* %15
	%18 = getelementptr %Str8, %Str8* %14, %Int32 0, %Int32 0
	%19 = load %Char8, %Char8* %18
	%20 = icmp ne %Char8 %19, 0
	br %Bool %20 , label %then_0, label %endif_0
then_0:
	%21 = load %Int32, %Int32* %15
	%22 = add %Int32 %21, 1
	store %Int32 %22, %Int32* %15
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str2 to [0 x i8]*), %Str8* %14)
	br label %endif_0
endif_0:
	%24 = alloca %Int32, align 4
	store %Int32 0, %Int32* %24
	br label %again_2
again_2:
	%25 = load %Int32, %Int32* %6
	%26 = bitcast %Int32 %25 to %Int32
	%27 = getelementptr [0 x %Int32], [0 x %Int32]* %sz, %Int32 0, %Int32 %26
	%28 = load %Int32, %Int32* %27
	%29 = load %Int32, %Int32* %15
	%30 = sub %Int32 %28, %29
	%31 = load %Int32, %Int32* %24
	%32 = icmp ult %Int32 %31, %30
	br %Bool %32 , label %body_2, label %break_2
body_2:
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str3 to [0 x i8]*))
	%34 = load %Int32, %Int32* %24
	%35 = add %Int32 %34, 1
	store %Int32 %35, %Int32* %24
	br label %again_2
break_2:
	%36 = load %Int32, %Int32* %6
	%37 = add %Int32 %36, 1
	store %Int32 %37, %Int32* %6
	br label %again_1
break_1:
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str4 to [0 x i8]*))
	%39 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %39)
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
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str5 to [0 x i8]*))
	%5 = alloca %Int32, align 4
	store %Int32 0, %Int32* %5
	br label %again_2
again_2:
	%6 = load %Int32, %Int32* %1
	%7 = bitcast %Int32 %6 to %Int32
	%8 = getelementptr [0 x %Int32], [0 x %Int32]* %sz, %Int32 0, %Int32 %7
	%9 = load %Int32, %Int32* %5
	%10 = load %Int32, %Int32* %8
	%11 = icmp ult %Int32 %9, %10
	br %Bool %11 , label %body_2, label %break_2
body_2:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str6 to [0 x i8]*))
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
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str7 to [0 x i8]*))
	ret void
}


