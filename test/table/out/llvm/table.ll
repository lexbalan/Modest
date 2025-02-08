
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
	%5 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%6 = load %Int32, %Int32* %5
	%7 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%8 = load %Int32, %Int32* %7
	; construct pointer to closed VLA array
	%9 = mul %Int32 %8, 1  ; calc VLA item size
	%10 = mul %Int32 %6, %9  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%11 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 1
	%12 = load [0 x [0 x %Str8*]]*, [0 x [0 x %Str8*]]** %11
	%13 = bitcast [0 x [0 x %Str8*]]* %12 to [0 x [0 x %Str8*]]*
	%14 = mul %Int32 %8, 1  ; calc VLA item size
	%15 = mul %Int32 %6, %14  ; calc VLA item size

	; array of size of columns (in characters)
	%16 = mul %Int32 %8, 1  ; calc VLA item size
	%17 = alloca %Int32, %Int32 %16, align 4
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	; -- end vol eval --
	; -- zero fill rest of array
	%18 = mul %Int32 %8, 4
	%19 = bitcast %Int32* %17 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %19, i8 0, %Int32 %18, i1 0)

	; calculate max length (in chars) of column
	%20 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%21 = load [0 x %Str8*]*, [0 x %Str8*]** %20
	%22 = icmp ne [0 x %Str8*]* %21, null
	br %Bool %22 , label %then_0, label %endif_0
then_0:
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%23 = load %Int32, %Int32* %3
	%24 = icmp ult %Int32 %23, %8
	br %Bool %24 , label %body_1, label %break_1
body_1:
	%25 = load %Int32, %Int32* %3
	%26 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%27 = load [0 x %Str8*]*, [0 x %Str8*]** %26
	%28 = bitcast %Int32 %25 to %Int32
	%29 = getelementptr [0 x %Str8*], [0 x %Str8*]* %27, %Int32 0, %Int32 %28
	%30 = load %Str8*, %Str8** %29
	%31 = call %SizeT @strlen(%Str8* %30)
	%32 = trunc %SizeT %31 to %Int32
	%33 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%34 = mul %Int32 %33, 1
	%35 = add %Int32 0, %34
	%36 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %35
; -- END INDEX VLA --
	%37 = load %Int32, %Int32* %36
	%38 = icmp ugt %Int32 %32, %37
	br %Bool %38 , label %then_1, label %endif_1
then_1:
	%39 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%40 = mul %Int32 %39, 1
	%41 = add %Int32 0, %40
	%42 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %41
; -- END INDEX VLA --
	store %Int32 %32, %Int32* %42
	br label %endif_1
endif_1:
	%43 = load %Int32, %Int32* %3
	%44 = add %Int32 %43, 1
	store %Int32 %44, %Int32* %3
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	store %Int32 0, %Int32* %3
	br label %again_2
again_2:
	%45 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%46 = load %Int32, %Int32* %3
	%47 = load %Int32, %Int32* %45
	%48 = icmp ult %Int32 %46, %47
	br %Bool %48 , label %body_2, label %break_2
body_2:
	store %Int32 0, %Int32* %4
	br label %again_3
again_3:
	%49 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%50 = load %Int32, %Int32* %4
	%51 = load %Int32, %Int32* %49
	%52 = icmp ult %Int32 %50, %51
	br %Bool %52 , label %body_3, label %break_3
body_3:
	%53 = load %Int32, %Int32* %4
	%54 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%55 = mul %Int32 %54, %14
	%56 = add %Int32 0, %55
	%57 = mul %Int32 %53, 1
	%58 = add %Int32 %56, %57
	%59 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %13, %Int32 %58
; -- END INDEX VLA --
	%60 = load %Str8*, %Str8** %59
	%61 = call %SizeT @strlen(%Str8* %60)
	%62 = trunc %SizeT %61 to %Int32
	%63 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%64 = mul %Int32 %63, 1
	%65 = add %Int32 0, %64
	%66 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %65
; -- END INDEX VLA --
	%67 = load %Int32, %Int32* %66
	%68 = icmp ugt %Int32 %62, %67
	br %Bool %68 , label %then_2, label %endif_2
then_2:
	%69 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%70 = mul %Int32 %69, 1
	%71 = add %Int32 0, %70
	%72 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %71
; -- END INDEX VLA --
	store %Int32 %62, %Int32* %72
	br label %endif_2
endif_2:
	%73 = load %Int32, %Int32* %4
	%74 = add %Int32 %73, 1
	store %Int32 %74, %Int32* %4
	br label %again_3
break_3:
	%75 = load %Int32, %Int32* %3
	%76 = add %Int32 %75, 1
	store %Int32 %76, %Int32* %3
	br label %again_2
break_2:
	store %Int32 0, %Int32* %3
	br label %again_4
again_4:
	%77 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%78 = load %Int32, %Int32* %3
	%79 = load %Int32, %Int32* %77
	%80 = icmp ult %Int32 %78, %79
	br %Bool %80 , label %body_4, label %break_4
body_4:
	; добавляем по пробелу слева и справа
	; (для красивого отступа)
	%81 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%82 = mul %Int32 %81, 1
	%83 = add %Int32 0, %82
	%84 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %83
; -- END INDEX VLA --
	%85 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%86 = mul %Int32 %85, 1
	%87 = add %Int32 0, %86
	%88 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %87
; -- END INDEX VLA --
	%89 = load %Int32, %Int32* %88
	%90 = add %Int32 %89, 2
	store %Int32 %90, %Int32* %84
	%91 = load %Int32, %Int32* %3
	%92 = add %Int32 %91, 1
	store %Int32 %92, %Int32* %3
	br label %again_4
break_4:

	; top border
	%93 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%94 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%95 = load %Int32, %Int32* %94
	call void @table_printSep([0 x %Int32]* %93, %Int32 %95)
	%96 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%97 = load [0 x %Str8*]*, [0 x %Str8*]** %96
	%98 = icmp ne [0 x %Str8*]* %97, null
	br %Bool %98 , label %then_3, label %endif_3
then_3:
	%99 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%100 = load [0 x %Str8*]*, [0 x %Str8*]** %99
	%101 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%102 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%103 = load %Int32, %Int32* %102
	call void @table_printRow([0 x %Str8*]* %100, [0 x %Int32]* %101, %Int32 %103)
	%104 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%105 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%106 = load %Int32, %Int32* %105
	call void @table_printSep([0 x %Int32]* %104, %Int32 %106)
	br label %endif_3
endif_3:
	store %Int32 0, %Int32* %3
	br label %again_5
again_5:
	%107 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%108 = load %Int32, %Int32* %3
	%109 = load %Int32, %Int32* %107
	%110 = icmp ult %Int32 %108, %109
	br %Bool %110 , label %body_5, label %break_5
body_5:
	%111 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%112 = mul %Int32 %111, %14
	%113 = add %Int32 0, %112
	%114 = getelementptr [0 x %Str8*], [0 x [0 x %Str8*]]* %13, %Int32 %113
; -- END INDEX VLA --
	%115 = bitcast [0 x %Str8*]* %114 to [0 x %Str8*]*
	%116 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%117 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%118 = load %Int32, %Int32* %117
	call void @table_printRow([0 x %Str8*]* %115, [0 x %Int32]* %116, %Int32 %118)
	%119 = load %Int32, %Int32* %3
	%120 = add %Int32 %119, 1
	store %Int32 %120, %Int32* %3

	; print `+--+--+` separator line
	%121 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 4
	%122 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%123 = load %Int32, %Int32* %3
	%124 = load %Int32, %Int32* %122
	%125 = icmp ult %Int32 %123, %124
	%126 = load %Bool, %Bool* %121
	%127 = and %Bool %126, %125
	br %Bool %127 , label %then_4, label %endif_4
then_4:
	%128 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%129 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%130 = load %Int32, %Int32* %129
	call void @table_printSep([0 x %Int32]* %128, %Int32 %130)
	br label %endif_4
endif_4:
	br label %again_5
break_5:

	; bottom border
	%131 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%132 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%133 = load %Int32, %Int32* %132
	call void @table_printSep([0 x %Int32]* %131, %Int32 %133)
	%134 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %134)
	ret void
}

define internal void @table_printRow([0 x %Str8*]* %raw_row, [0 x %Int32]* %sz, %Int32 %ncols) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = mul %Int32 %ncols, 1  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%4 = bitcast [0 x %Str8*]* %raw_row to [0 x %Str8*]*
	%5 = mul %Int32 %ncols, 1  ; calc VLA item size
	%6 = alloca %Int32, align 4
	store %Int32 0, %Int32* %6
	br label %again_1
again_1:
	%7 = load %Int32, %Int32* %6
	%8 = icmp ult %Int32 %7, %ncols
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


