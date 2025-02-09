
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
	%5 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%6 = load %Int32, %Int32* %5
	%7 = mul %Int32 %6, 1  ; calc VLA item size
	%8 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%9 = load %Int32, %Int32* %8
	%10 = mul %Int32 %9, %7  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%11 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 1
	%12 = load [0 x [0 x %Str8*]]*, [0 x [0 x %Str8*]]** %11
	%13 = bitcast [0 x [0 x %Str8*]]* %12 to [0 x [0 x %Str8*]]*
	%14 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%15 = load %Int32, %Int32* %14
	%16 = mul %Int32 %15, 1  ; calc VLA item size
	%17 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%18 = load %Int32, %Int32* %17
	%19 = mul %Int32 %18, %16  ; calc VLA item size

	; array of size of columns (in characters)
	%20 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%21 = load %Int32, %Int32* %20
	%22 = mul %Int32 %21, 1  ; calc VLA item size
	%23 = alloca %Int32, %Int32 %22, align 4
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%24 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	; -- end vol eval --
	; -- zero fill rest of array
	%25 = mul %Int32 %24, 4
	%26 = bitcast %Int32* %23 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %26, i8 0, %Int32 %25, i1 0)

	;
	; calculate max length (in chars) of column
	;
	%27 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%28 = load [0 x %Str8*]*, [0 x %Str8*]** %27
	%29 = icmp ne [0 x %Str8*]* %28, null
	br %Bool %29 , label %then_0, label %endif_0
then_0:
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%30 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%31 = load %Int32, %Int32* %3
	%32 = load %Int32, %Int32* %30
	%33 = icmp ult %Int32 %31, %32
	br %Bool %33 , label %body_1, label %break_1
body_1:
	%34 = load %Int32, %Int32* %3
	%35 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%36 = load [0 x %Str8*]*, [0 x %Str8*]** %35
	%37 = bitcast %Int32 %34 to %Int32
	%38 = getelementptr [0 x %Str8*], [0 x %Str8*]* %36, %Int32 0, %Int32 %37
	%39 = load %Str8*, %Str8** %38
	%40 = call %SizeT @strlen(%Str8* %39)
	%41 = trunc %SizeT %40 to %Int32
	%42 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%43 = mul %Int32 %42, 1
	%44 = add %Int32 0, %43
	%45 = getelementptr %Int32, [0 x %Int32]* %23, %Int32 %44
; -- END INDEX VLA --
	%46 = load %Int32, %Int32* %45
	%47 = icmp ugt %Int32 %41, %46
	br %Bool %47 , label %then_1, label %endif_1
then_1:
	%48 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%49 = mul %Int32 %48, 1
	%50 = add %Int32 0, %49
	%51 = getelementptr %Int32, [0 x %Int32]* %23, %Int32 %50
; -- END INDEX VLA --
	store %Int32 %41, %Int32* %51
	br label %endif_1
endif_1:
	%52 = load %Int32, %Int32* %3
	%53 = add %Int32 %52, 1
	store %Int32 %53, %Int32* %3
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	store %Int32 0, %Int32* %3
	br label %again_2
again_2:
	%54 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%55 = load %Int32, %Int32* %3
	%56 = load %Int32, %Int32* %54
	%57 = icmp ult %Int32 %55, %56
	br %Bool %57 , label %body_2, label %break_2
body_2:
	store %Int32 0, %Int32* %4
	br label %again_3
again_3:
	%58 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%59 = load %Int32, %Int32* %4
	%60 = load %Int32, %Int32* %58
	%61 = icmp ult %Int32 %59, %60
	br %Bool %61 , label %body_3, label %break_3
body_3:
	%62 = load %Int32, %Int32* %4
	%63 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%64 = mul %Int32 %63, %16
	%65 = add %Int32 0, %64
	%66 = mul %Int32 %62, 1
	%67 = add %Int32 %65, %66
	%68 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %13, %Int32 %67
; -- END INDEX VLA --
	%69 = load %Str8*, %Str8** %68
	%70 = call %SizeT @strlen(%Str8* %69)
	%71 = trunc %SizeT %70 to %Int32
	%72 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%73 = mul %Int32 %72, 1
	%74 = add %Int32 0, %73
	%75 = getelementptr %Int32, [0 x %Int32]* %23, %Int32 %74
; -- END INDEX VLA --
	%76 = load %Int32, %Int32* %75
	%77 = icmp ugt %Int32 %71, %76
	br %Bool %77 , label %then_2, label %endif_2
then_2:
	%78 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%79 = mul %Int32 %78, 1
	%80 = add %Int32 0, %79
	%81 = getelementptr %Int32, [0 x %Int32]* %23, %Int32 %80
; -- END INDEX VLA --
	store %Int32 %71, %Int32* %81
	br label %endif_2
endif_2:
	%82 = load %Int32, %Int32* %4
	%83 = add %Int32 %82, 1
	store %Int32 %83, %Int32* %4
	br label %again_3
break_3:
	%84 = load %Int32, %Int32* %3
	%85 = add %Int32 %84, 1
	store %Int32 %85, %Int32* %3
	br label %again_2
break_2:
	store %Int32 0, %Int32* %3
	br label %again_4
again_4:
	%86 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%87 = load %Int32, %Int32* %3
	%88 = load %Int32, %Int32* %86
	%89 = icmp ult %Int32 %87, %88
	br %Bool %89 , label %body_4, label %break_4
body_4:
	; добавляем по пробелу слева и справа
	; (для красивого отступа)
	%90 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%91 = mul %Int32 %90, 1
	%92 = add %Int32 0, %91
	%93 = getelementptr %Int32, [0 x %Int32]* %23, %Int32 %92
; -- END INDEX VLA --
	%94 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%95 = mul %Int32 %94, 1
	%96 = add %Int32 0, %95
	%97 = getelementptr %Int32, [0 x %Int32]* %23, %Int32 %96
; -- END INDEX VLA --
	%98 = load %Int32, %Int32* %97
	%99 = add %Int32 %98, 2
	store %Int32 %99, %Int32* %93
	%100 = load %Int32, %Int32* %3
	%101 = add %Int32 %100, 1
	store %Int32 %101, %Int32* %3
	br label %again_4
break_4:

	;
	; print table
	;

	; top border
	%102 = bitcast [0 x %Int32]* %23 to [0 x %Int32]*
	%103 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%104 = load %Int32, %Int32* %103
	call void @table_printSep([0 x %Int32]* %102, %Int32 %104)
	%105 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%106 = load [0 x %Str8*]*, [0 x %Str8*]** %105
	%107 = icmp ne [0 x %Str8*]* %106, null
	br %Bool %107 , label %then_3, label %endif_3
then_3:
	%108 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%109 = load [0 x %Str8*]*, [0 x %Str8*]** %108
	%110 = bitcast [0 x %Int32]* %23 to [0 x %Int32]*
	%111 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%112 = load %Int32, %Int32* %111
	call void @table_printRow([0 x %Str8*]* %109, [0 x %Int32]* %110, %Int32 %112)
	%113 = bitcast [0 x %Int32]* %23 to [0 x %Int32]*
	%114 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%115 = load %Int32, %Int32* %114
	call void @table_printSep([0 x %Int32]* %113, %Int32 %115)
	br label %endif_3
endif_3:
	store %Int32 0, %Int32* %3
	br label %again_5
again_5:
	%116 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%117 = load %Int32, %Int32* %3
	%118 = load %Int32, %Int32* %116
	%119 = icmp ult %Int32 %117, %118
	br %Bool %119 , label %body_5, label %break_5
body_5:
	%120 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%121 = mul %Int32 %120, %16
	%122 = add %Int32 0, %121
	%123 = getelementptr [0 x %Str8*], [0 x [0 x %Str8*]]* %13, %Int32 %122
; -- END INDEX VLA --
	%124 = bitcast [0 x %Str8*]* %123 to [0 x %Str8*]*
	%125 = bitcast [0 x %Int32]* %23 to [0 x %Int32]*
	%126 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%127 = load %Int32, %Int32* %126
	call void @table_printRow([0 x %Str8*]* %124, [0 x %Int32]* %125, %Int32 %127)
	%128 = load %Int32, %Int32* %3
	%129 = add %Int32 %128, 1
	store %Int32 %129, %Int32* %3
	%130 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 4
	%131 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%132 = load %Int32, %Int32* %3
	%133 = load %Int32, %Int32* %131
	%134 = icmp ult %Int32 %132, %133
	%135 = load %Bool, %Bool* %130
	%136 = and %Bool %135, %134
	br %Bool %136 , label %then_4, label %endif_4
then_4:
	%137 = bitcast [0 x %Int32]* %23 to [0 x %Int32]*
	%138 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%139 = load %Int32, %Int32* %138
	call void @table_printSep([0 x %Int32]* %137, %Int32 %139)
	br label %endif_4
endif_4:
	br label %again_5
break_5:

	; bottom border
	%140 = bitcast [0 x %Int32]* %23 to [0 x %Int32]*
	%141 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%142 = load %Int32, %Int32* %141
	call void @table_printSep([0 x %Int32]* %140, %Int32 %142)
	%143 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %143)
	ret void
}

define internal void @table_printRow([0 x %Str8*]* %raw_row, [0 x %Int32]* %sz, %Int32 %nCols) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = mul %Int32 %nCols, 1  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%4 = bitcast [0 x %Str8*]* %raw_row to [0 x %Str8*]*
	%5 = mul %Int32 %nCols, 1  ; calc VLA item size
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
; -- INDEX VLA --
	%11 = mul %Int32 %10, 1
	%12 = add %Int32 0, %11
	%13 = getelementptr %Str8*, [0 x %Str8*]* %4, %Int32 %12
; -- END INDEX VLA --
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



; печатает строку отделяющую записи таблицы
; получает указатель на массив с размерами колонок
; и количество элементов в ней
define internal void @table_printSep([0 x %Int32]* %sz, %Int32 %m) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp ult %Int32 %2, %m
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


