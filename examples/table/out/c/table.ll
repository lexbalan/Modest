
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
%File = type %Nat8;
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
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
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
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
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
	%Nat32,
	%Nat32,
	%Bool
};

define void @table_print(%table_Table* %table) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = alloca %Nat32, align 4
	%4 = alloca %Nat32, align 4

	; construct pointer to closed VLA array
	%5 = mul %Int32 1, 1
	%6 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%7 = load %Nat32, %Nat32* %6
	%8 = mul %Nat32 %7, 1
	%9 = mul %Nat32 %7, 8
	%10 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%11 = load %Nat32, %Nat32* %10
	%12 = mul %Nat32 %11, %8
	%13 = mul %Nat32 %11, %9
	%14 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 1
	%15 = load [0 x [0 x %Str8*]]*, [0 x [0 x %Str8*]]** %14
	%16 = bitcast [0 x [0 x %Str8*]]* %15 to [0 x [0 x %Str8*]]*

	; array of size of columns (in characters)
	%17 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%18 = load %Nat32, %Nat32* %17
	%19 = mul %Nat32 %18, 1
	%20 = mul %Nat32 %18, 4
	%21 = alloca %Nat32, %Nat32 %19, align 4
	%22 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%23 = load %Nat32, %Nat32* %22
	%24 = mul %Nat32 %23, 4
	%25 = bitcast %Nat32* %21 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %25, i8 0, %Nat32 %24, i1 0)

	;
	; calculate max length (in chars) of column
	;
; if_0
	%26 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%27 = load [0 x %Str8*]*, [0 x %Str8*]** %26
	%28 = icmp ne [0 x %Str8*]* %27, null
	br %Bool %28 , label %then_0, label %endif_0
then_0:
	store %Nat32 0, %Nat32* %3
; while_1
	br label %again_1
again_1:
	%29 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%30 = load %Nat32, %Nat32* %3
	%31 = load %Nat32, %Nat32* %29
	%32 = icmp ult %Nat32 %30, %31
	br %Bool %32 , label %body_1, label %break_1
body_1:
	%33 = load %Nat32, %Nat32* %3
	%34 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%35 = load [0 x %Str8*]*, [0 x %Str8*]** %34
	%36 = bitcast %Nat32 %33 to %Nat32
	%37 = getelementptr [0 x %Str8*], [0 x %Str8*]* %35, %Int32 0, %Nat32 %36
	%38 = load %Str8*, %Str8** %37
	%39 = call %SizeT @strlen(%Str8* %38)
	%40 = trunc %SizeT %39 to %Nat32
; if_1
	%41 = load %Nat32, %Nat32* %3
	%42 = mul %Nat32 %41, 1
	%43 = add %Int32 0, %42
	%44 = getelementptr %Nat32, [0 x %Nat32]* %21, %Int32 %43
	%45 = load %Nat32, %Nat32* %44
	%46 = icmp ugt %Nat32 %40, %45
	br %Bool %46 , label %then_1, label %endif_1
then_1:
	%47 = load %Nat32, %Nat32* %3
	%48 = mul %Nat32 %47, 1
	%49 = add %Int32 0, %48
	%50 = getelementptr %Nat32, [0 x %Nat32]* %21, %Int32 %49
	store %Nat32 %40, %Nat32* %50
	br label %endif_1
endif_1:
	%51 = load %Nat32, %Nat32* %3
	%52 = add %Nat32 %51, 1
	store %Nat32 %52, %Nat32* %3
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	store %Nat32 0, %Nat32* %3
; while_2
	br label %again_2
again_2:
	%53 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%54 = load %Nat32, %Nat32* %3
	%55 = load %Nat32, %Nat32* %53
	%56 = icmp ult %Nat32 %54, %55
	br %Bool %56 , label %body_2, label %break_2
body_2:
	store %Nat32 0, %Nat32* %4
; while_3
	br label %again_3
again_3:
	%57 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%58 = load %Nat32, %Nat32* %4
	%59 = load %Nat32, %Nat32* %57
	%60 = icmp ult %Nat32 %58, %59
	br %Bool %60 , label %body_3, label %break_3
body_3:
	%61 = load %Nat32, %Nat32* %4
	%62 = load %Nat32, %Nat32* %3
	%63 = mul %Nat32 %62, %8
	%64 = add %Int32 0, %63
	%65 = mul %Nat32 %61, 1
	%66 = add %Int32 %64, %65
	%67 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %16, %Int32 %66
	%68 = load %Str8*, %Str8** %67
	%69 = call %SizeT @strlen(%Str8* %68)
	%70 = trunc %SizeT %69 to %Nat32
; if_2
	%71 = load %Nat32, %Nat32* %4
	%72 = mul %Nat32 %71, 1
	%73 = add %Int32 0, %72
	%74 = getelementptr %Nat32, [0 x %Nat32]* %21, %Int32 %73
	%75 = load %Nat32, %Nat32* %74
	%76 = icmp ugt %Nat32 %70, %75
	br %Bool %76 , label %then_2, label %endif_2
then_2:
	%77 = load %Nat32, %Nat32* %4
	%78 = mul %Nat32 %77, 1
	%79 = add %Int32 0, %78
	%80 = getelementptr %Nat32, [0 x %Nat32]* %21, %Int32 %79
	store %Nat32 %70, %Nat32* %80
	br label %endif_2
endif_2:
	%81 = load %Nat32, %Nat32* %4
	%82 = add %Nat32 %81, 1
	store %Nat32 %82, %Nat32* %4
	br label %again_3
break_3:
	%83 = load %Nat32, %Nat32* %3
	%84 = add %Nat32 %83, 1
	store %Nat32 %84, %Nat32* %3
	br label %again_2
break_2:
	store %Nat32 0, %Nat32* %3
; while_4
	br label %again_4
again_4:
	%85 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%86 = load %Nat32, %Nat32* %3
	%87 = load %Nat32, %Nat32* %85
	%88 = icmp ult %Nat32 %86, %87
	br %Bool %88 , label %body_4, label %break_4
body_4:
	; добавляем по пробелу слева и справа
	; (для красивого отступа)
	%89 = load %Nat32, %Nat32* %3
	%90 = mul %Nat32 %89, 1
	%91 = add %Int32 0, %90
	%92 = getelementptr %Nat32, [0 x %Nat32]* %21, %Int32 %91
	%93 = load %Nat32, %Nat32* %3
	%94 = mul %Nat32 %93, 1
	%95 = add %Int32 0, %94
	%96 = getelementptr %Nat32, [0 x %Nat32]* %21, %Int32 %95
	%97 = load %Nat32, %Nat32* %96
	%98 = add %Nat32 %97, 2
	store %Nat32 %98, %Nat32* %92
	%99 = load %Nat32, %Nat32* %3
	%100 = add %Nat32 %99, 1
	store %Nat32 %100, %Nat32* %3
	br label %again_4
break_4:

	;
	; print table
	;

	; top border
	%101 = bitcast [0 x %Nat32]* %21 to [0 x %Nat32]*
	%102 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%103 = load %Nat32, %Nat32* %102
	call void @separator([0 x %Nat32]* %101, %Nat32 %103)
; if_3
	%104 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%105 = load [0 x %Str8*]*, [0 x %Str8*]** %104
	%106 = icmp ne [0 x %Str8*]* %105, null
	br %Bool %106 , label %then_3, label %endif_3
then_3:
	%107 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%108 = load [0 x %Str8*]*, [0 x %Str8*]** %107
	%109 = bitcast [0 x %Nat32]* %21 to [0 x %Nat32]*
	%110 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%111 = load %Nat32, %Nat32* %110
	call void @printRow([0 x %Str8*]* %108, [0 x %Nat32]* %109, %Nat32 %111)
	%112 = bitcast [0 x %Nat32]* %21 to [0 x %Nat32]*
	%113 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%114 = load %Nat32, %Nat32* %113
	call void @separator([0 x %Nat32]* %112, %Nat32 %114)
	br label %endif_3
endif_3:
	store %Nat32 0, %Nat32* %3
; while_5
	br label %again_5
again_5:
	%115 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%116 = load %Nat32, %Nat32* %3
	%117 = load %Nat32, %Nat32* %115
	%118 = icmp ult %Nat32 %116, %117
	br %Bool %118 , label %body_5, label %break_5
body_5:
	%119 = load %Nat32, %Nat32* %3
	%120 = mul %Nat32 %119, %8
	%121 = add %Int32 0, %120
	%122 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %16, %Int32 %121
	%123 = bitcast [0 x %Str8*]* %122 to [0 x %Str8*]*
	%124 = bitcast [0 x %Nat32]* %21 to [0 x %Nat32]*
	%125 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%126 = load %Nat32, %Nat32* %125
	call void @printRow([0 x %Str8*]* %123, [0 x %Nat32]* %124, %Nat32 %126)
	%127 = load %Nat32, %Nat32* %3
	%128 = add %Nat32 %127, 1
	store %Nat32 %128, %Nat32* %3
; if_4
	%129 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 4
	%130 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%131 = load %Nat32, %Nat32* %3
	%132 = load %Nat32, %Nat32* %130
	%133 = icmp ult %Nat32 %131, %132
	%134 = load %Bool, %Bool* %129
	%135 = and %Bool %134, %133
	br %Bool %135 , label %then_4, label %endif_4
then_4:
	%136 = bitcast [0 x %Nat32]* %21 to [0 x %Nat32]*
	%137 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%138 = load %Nat32, %Nat32* %137
	call void @separator([0 x %Nat32]* %136, %Nat32 %138)
	br label %endif_4
endif_4:
	br label %again_5
break_5:

	; bottom border
	%139 = bitcast [0 x %Nat32]* %21 to [0 x %Nat32]*
	%140 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%141 = load %Nat32, %Nat32* %140
	call void @separator([0 x %Nat32]* %139, %Nat32 %141)
	%142 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %142)
	ret void
}

define internal void @printRow([0 x %Str8*]* %raw_row, [0 x %Nat32]* %sz, %Nat32 %nCols) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = mul %Int32 1, 1
	%4 = mul %Nat32 %nCols, 1
	%5 = mul %Nat32 %nCols, 8
	%6 = bitcast [0 x %Str8*]* %raw_row to [0 x %Str8*]*
	%7 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %7
; while_1
	br label %again_1
again_1:
	%8 = load %Nat32, %Nat32* %7
	%9 = icmp ult %Nat32 %8, %nCols
	br %Bool %9 , label %body_1, label %break_1
body_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str1 to [0 x i8]*))
	%11 = load %Nat32, %Nat32* %7
	%12 = mul %Nat32 %11, 1
	%13 = add %Int32 0, %12
	%14 = getelementptr %Str8*, [0 x %Str8*]* %6, %Int32 %13
	%15 = load %Str8*, %Str8** %14
	%16 = alloca %Nat32, align 4
	%17 = call %SizeT @strlen(%Str8* %15)
	%18 = trunc %SizeT %17 to %Nat32
	store %Nat32 %18, %Nat32* %16
; if_0
	%19 = getelementptr %Str8, %Str8* %15, %Int32 0, %Int32 0
	%20 = load %Char8, %Char8* %19
	%21 = icmp ne %Char8 %20, 0
	br %Bool %21 , label %then_0, label %endif_0
then_0:
	%22 = load %Nat32, %Nat32* %16
	%23 = add %Nat32 %22, 1
	store %Nat32 %23, %Nat32* %16
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str2 to [0 x i8]*), %Str8* %15)
	br label %endif_0
endif_0:
	%25 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %25
; while_2
	br label %again_2
again_2:
	%26 = load %Nat32, %Nat32* %7
	%27 = bitcast %Nat32 %26 to %Nat32
	%28 = getelementptr [0 x %Nat32], [0 x %Nat32]* %sz, %Int32 0, %Nat32 %27
	%29 = load %Nat32, %Nat32* %28
	%30 = load %Nat32, %Nat32* %16
	%31 = sub %Nat32 %29, %30
	%32 = load %Nat32, %Nat32* %25
	%33 = icmp ult %Nat32 %32, %31
	br %Bool %33 , label %body_2, label %break_2
body_2:
	%34 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str3 to [0 x i8]*))
	%35 = load %Nat32, %Nat32* %25
	%36 = add %Nat32 %35, 1
	store %Nat32 %36, %Nat32* %25
	br label %again_2
break_2:
	%37 = load %Nat32, %Nat32* %7
	%38 = add %Nat32 %37, 1
	store %Nat32 %38, %Nat32* %7
	br label %again_1
break_1:
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str4 to [0 x i8]*))
	%40 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %40)
	ret void
}

define internal void @separator([0 x %Nat32]* %sz, %Nat32 %n) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ult %Nat32 %2, %n
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str5 to [0 x i8]*))
	%5 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %5
; while_2
	br label %again_2
again_2:
	%6 = load %Nat32, %Nat32* %1
	%7 = bitcast %Nat32 %6 to %Nat32
	%8 = getelementptr [0 x %Nat32], [0 x %Nat32]* %sz, %Int32 0, %Nat32 %7
	%9 = load %Nat32, %Nat32* %5
	%10 = load %Nat32, %Nat32* %8
	%11 = icmp ult %Nat32 %9, %10
	br %Bool %11 , label %body_2, label %break_2
body_2:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str6 to [0 x i8]*))
	%13 = load %Nat32, %Nat32* %5
	%14 = add %Nat32 %13, 1
	store %Nat32 %14, %Nat32* %5
	br label %again_2
break_2:
	%15 = load %Nat32, %Nat32* %1
	%16 = add %Nat32 %15, 1
	store %Nat32 %16, %Nat32* %1
	br label %again_1
break_1:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str7 to [0 x i8]*))
	ret void
}


