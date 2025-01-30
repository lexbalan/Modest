
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

; MODULE: list

; -- print includes --
; from included ctypes64
%ctypes64_Str = type %Str8;
%ctypes64_Char = type %Char8;
%ctypes64_ConstChar = type %ctypes64_Char;
%ctypes64_SignedChar = type %Int8;
%ctypes64_UnsignedChar = type %Int8;
%ctypes64_Short = type %Int16;
%ctypes64_UnsignedShort = type %Int16;
%ctypes64_Int = type %Int32;
%ctypes64_UnsignedInt = type %Int32;
%ctypes64_LongInt = type %Int64;
%ctypes64_UnsignedLongInt = type %Int64;
%ctypes64_Long = type %Int64;
%ctypes64_UnsignedLong = type %Int64;
%ctypes64_LongLong = type %Int64;
%ctypes64_UnsignedLongLong = type %Int64;
%ctypes64_LongLongInt = type %Int64;
%ctypes64_UnsignedLongLongInt = type %Int64;
%ctypes64_Float = type double;
%ctypes64_Double = type double;
%ctypes64_LongDouble = type double;
%ctypes64_SizeT = type %ctypes64_UnsignedLongInt;
%ctypes64_SSizeT = type %ctypes64_LongInt;
%ctypes64_IntPtrT = type %Int64;
%ctypes64_PtrDiffT = type i8*;
%ctypes64_OffT = type %Int64;
%ctypes64_USecondsT = type %Int32;
%ctypes64_PIDT = type %Int32;
%ctypes64_UIDT = type %Int32;
%ctypes64_GIDT = type %Int32;
; from included stdlib
declare void @abort()
declare %ctypes64_Int @abs(%ctypes64_Int %x)
declare %ctypes64_Int @atexit(void ()* %x)
declare %ctypes64_Double @atof([0 x %ctypes64_ConstChar]* %nptr)
declare %ctypes64_Int @atoi([0 x %ctypes64_ConstChar]* %nptr)
declare %ctypes64_LongInt @atol([0 x %ctypes64_ConstChar]* %nptr)
declare i8* @calloc(%ctypes64_SizeT %num, %ctypes64_SizeT %size)
declare void @exit(%ctypes64_Int %x)
declare void @free(i8* %ptr)
declare %ctypes64_Str* @getenv(%ctypes64_Str* %name)
declare %ctypes64_LongInt @labs(%ctypes64_LongInt %x)
declare %ctypes64_Str* @secure_getenv(%ctypes64_Str* %name)
declare i8* @malloc(%ctypes64_SizeT %size)
declare %ctypes64_Int @system([0 x %ctypes64_ConstChar]* %string)
; from included stdio
%stdio_File = type %Int8;
%stdio_FposT = type %Int8;
%stdio_CharStr = type %ctypes64_Str;
%stdio_ConstCharStr = type %stdio_CharStr;
declare %ctypes64_Int @fclose(%stdio_File* %f)
declare %ctypes64_Int @feof(%stdio_File* %f)
declare %ctypes64_Int @ferror(%stdio_File* %f)
declare %ctypes64_Int @fflush(%stdio_File* %f)
declare %ctypes64_Int @fgetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %stdio_File* @fopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode)
declare %ctypes64_SizeT @fread(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %ctypes64_SizeT @fwrite(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %stdio_File* @freopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode, %stdio_File* %f)
declare %ctypes64_Int @fseek(%stdio_File* %f, %ctypes64_LongInt %offset, %ctypes64_Int %whence)
declare %ctypes64_Int @fsetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %ctypes64_LongInt @ftell(%stdio_File* %f)
declare %ctypes64_Int @remove(%stdio_ConstCharStr* %fname)
declare %ctypes64_Int @rename(%stdio_ConstCharStr* %old_filename, %stdio_ConstCharStr* %new_filename)
declare void @rewind(%stdio_File* %f)
declare void @setbuf(%stdio_File* %f, %stdio_CharStr* %buf)
declare %ctypes64_Int @setvbuf(%stdio_File* %f, %stdio_CharStr* %buf, %ctypes64_Int %mode, %ctypes64_SizeT %size)
declare %stdio_File* @tmpfile()
declare %stdio_CharStr* @tmpnam(%stdio_CharStr* %str)
declare %ctypes64_Int @printf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @scanf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @fprintf(%stdio_File* %f, %ctypes64_Str* %format, ...)
declare %ctypes64_Int @fscanf(%stdio_File* %f, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sscanf(%stdio_ConstCharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sprintf(%stdio_CharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @vfprintf(%stdio_File* %f, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vprintf(%stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsprintf(%stdio_CharStr* %str, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsnprintf(%stdio_CharStr* %str, %ctypes64_SizeT %n, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @__vsnprintf_chk(%stdio_CharStr* %dest, %ctypes64_SizeT %len, %ctypes64_Int %flags, %ctypes64_SizeT %dstlen, %stdio_ConstCharStr* %format, i8* %arg)
declare %ctypes64_Int @fgetc(%stdio_File* %f)
declare %ctypes64_Int @fputc(%ctypes64_Int %char, %stdio_File* %f)
declare %stdio_CharStr* @fgets(%stdio_CharStr* %str, %ctypes64_Int %n, %stdio_File* %f)
declare %ctypes64_Int @fputs(%stdio_ConstCharStr* %str, %stdio_File* %f)
declare %ctypes64_Int @getc(%stdio_File* %f)
declare %ctypes64_Int @getchar()
declare %stdio_CharStr* @gets(%stdio_CharStr* %str)
declare %ctypes64_Int @putc(%ctypes64_Int %char, %stdio_File* %f)
declare %ctypes64_Int @putchar(%ctypes64_Int %char)
declare %ctypes64_Int @puts(%stdio_ConstCharStr* %str)
declare %ctypes64_Int @ungetc(%ctypes64_Int %char, %stdio_File* %f)
declare void @perror(%stdio_ConstCharStr* %str)
; -- end print includes --
; -- print imports 'list' --
; -- 0
; -- end print imports 'list' --
; -- strings --
@str1 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 105, i8 110, i8 115, i8 101, i8 114, i8 116, i8 95, i8 114, i8 105, i8 103, i8 104, i8 116, i8 10, i8 0]
@str2 = private constant [14 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 103, i8 101, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
@str3 = private constant [17 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 105, i8 110, i8 115, i8 101, i8 114, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
; -- endstrings --
%list_Node = type {
	%list_Node*,
	%list_Node*,
	i8*
};

%list_List = type {
	%list_Node*,
	%list_Node*,
	%Int32
};

define %list_List* @list_create() {
	%1 = call i8* @malloc(%ctypes64_SizeT 32)
	%2 = bitcast i8* %1 to %list_List*
	%3 = icmp eq %list_List* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_List* null
	br label %endif_0
endif_0:
	store %list_List zeroinitializer, %list_List* %2
	ret %list_List* %2
}

define %Int32 @list_size_get(%list_List* %list) {
	%1 = icmp eq %list_List* %list, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int32 0
	br label %endif_0
endif_0:
	%3 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%4 = load %Int32, %Int32* %3
	ret %Int32 %4
}

define %list_Node* @list_first_node_get(%list_List* %list) {
	%1 = icmp eq %list_List* %list, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 0
	%4 = load %list_Node*, %list_Node** %3
	ret %list_Node* %4
}

define %list_Node* @list_last_node_get(%list_List* %list) {
	%1 = icmp eq %list_List* %list, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	%4 = load %list_Node*, %list_Node** %3
	ret %list_Node* %4
}

define %list_Node* @list_node_first(%list_List* %list, %list_Node* %new_node) {
	%1 = icmp eq %list_List* %list, null
	%2 = icmp eq %list_Node* %new_node, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%5 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 0
	store %list_Node* %new_node, %list_Node** %5
	%6 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	store %list_Node* %new_node, %list_Node** %6
	%7 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%8 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%9 = load %Int32, %Int32* %8
	%10 = add %Int32 %9, 1
	store %Int32 %10, %Int32* %7
	ret %list_Node* %new_node
}

define %list_Node* @list_node_create() {
	%1 = call i8* @malloc(%ctypes64_SizeT 32)
	%2 = bitcast i8* %1 to %list_Node*
	%3 = icmp eq %list_Node* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	store %list_Node zeroinitializer, %list_Node* %2
	ret %list_Node* %2
}

define %list_Node* @list_node_next_get(%list_Node* %node) {
	%1 = icmp eq %list_Node* %node, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_Node, %list_Node* %node, %Int32 0, %Int32 0
	%4 = load %list_Node*, %list_Node** %3
	ret %list_Node* %4
}

define %list_Node* @list_node_prev_get(%list_Node* %node) {
	%1 = icmp eq %list_Node* %node, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_Node, %list_Node* %node, %Int32 0, %Int32 1
	%4 = load %list_Node*, %list_Node** %3
	ret %list_Node* %4
}

define i8* @list_node_data_get(%list_Node* %node) {
	%1 = icmp eq %list_Node* %node, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret i8* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_Node, %list_Node* %node, %Int32 0, %Int32 2
	%4 = load i8*, i8** %3
	ret i8* %4
}

define void @list_node_insert_right(%list_Node* %left, %list_Node* %new_right) {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*))
	%2 = getelementptr %list_Node, %list_Node* %left, %Int32 0, %Int32 0
	%3 = load %list_Node*, %list_Node** %2
	%4 = getelementptr %list_Node, %list_Node* %left, %Int32 0, %Int32 0
	store %list_Node* %new_right, %list_Node** %4
	%5 = icmp ne %list_Node* %3, null
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	%6 = getelementptr %list_Node, %list_Node* %3, %Int32 0, %Int32 1
	store %list_Node* %new_right, %list_Node** %6
	br label %endif_0
endif_0:
	%7 = getelementptr %list_Node, %list_Node* %new_right, %Int32 0, %Int32 0
	store %list_Node* %3, %list_Node** %7
	%8 = getelementptr %list_Node, %list_Node* %new_right, %Int32 0, %Int32 1
	store %list_Node* %left, %list_Node** %8
	ret void
}



; get list node by number
; if number is out of range returns nil
; if number < 0 - go backward
define %list_Node* @list_node_get(%list_List* %list, %Int32 %pos) {
	%1 = icmp eq %list_List* %list, null
	%2 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%3 = load %Int32, %Int32* %2
	%4 = icmp eq %Int32 %3, 0
	%5 = or %Bool %1, %4
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%7 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([14 x i8]* @str2 to [0 x i8]*), %Int32 %pos)
	%8 = alloca %list_Node*, align 8
	%9 = icmp sge %Int32 %pos, 0
	br %Bool %9 , label %then_1, label %else_1
then_1:
	; go forward
	%10 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 0
	%11 = load %list_Node*, %list_Node** %10
	store %list_Node* %11, %list_Node** %8
	%12 = bitcast %Int32 %pos to %Int32
	%13 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%14 = load %Int32, %Int32* %13
	%15 = icmp ugt %Int32 %12, %14
	br %Bool %15 , label %then_2, label %endif_2
then_2:
	ret %list_Node* null
	br label %endif_2
endif_2:
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_1
again_1:
	%18 = load %Int32, %Int32* %17
	%19 = icmp ult %Int32 %18, %12
	br %Bool %19 , label %body_1, label %break_1
body_1:
	%20 = load %list_Node*, %list_Node** %8
	%21 = getelementptr %list_Node, %list_Node* %20, %Int32 0, %Int32 0
	%22 = load %list_Node*, %list_Node** %21
	store %list_Node* %22, %list_Node** %8
	%23 = load %Int32, %Int32* %17
	%24 = add %Int32 %23, 1
	store %Int32 %24, %Int32* %17
	br label %again_1
break_1:
	br label %endif_1
else_1:
	; go backward
	%25 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	%26 = load %list_Node*, %list_Node** %25
	store %list_Node* %26, %list_Node** %8
	%27 = sub %Int32 0, %pos
	%28 = bitcast %Int32 %27 to %Int32
	%29 = sub %Int32 %28, 1
	%30 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%31 = load %Int32, %Int32* %30
	%32 = icmp ugt %Int32 %29, %31
	br %Bool %32 , label %then_3, label %endif_3
then_3:
	ret %list_Node* null
	br label %endif_3
endif_3:
	%34 = alloca %Int32, align 4
	store %Int32 0, %Int32* %34
	br label %again_2
again_2:
	%35 = load %Int32, %Int32* %34
	%36 = icmp ult %Int32 %35, %29
	br %Bool %36 , label %body_2, label %break_2
body_2:
	%37 = load %list_Node*, %list_Node** %8
	%38 = getelementptr %list_Node, %list_Node* %37, %Int32 0, %Int32 1
	%39 = load %list_Node*, %list_Node** %38
	store %list_Node* %39, %list_Node** %8
	%40 = load %Int32, %Int32* %34
	%41 = add %Int32 %40, 1
	store %Int32 %41, %Int32* %34
	br label %again_2
break_2:
	br label %endif_1
endif_1:
	%42 = load %list_Node*, %list_Node** %8
	ret %list_Node* %42
}

define %list_Node* @list_node_insert(%list_List* %list, %Int32 %pos, %list_Node* %new_node) {
	%1 = icmp eq %list_List* %list, null
	%2 = icmp eq %list_Node* %new_node, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%5 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([17 x i8]* @str3 to [0 x i8]*), %Int32 %pos)
	%6 = call %list_Node* @list_node_get(%list_List* %list, %Int32 %pos)
	%7 = icmp eq %list_Node* %6, null
	br %Bool %7 , label %then_1, label %endif_1
then_1:
	ret %list_Node* null
	br label %endif_1
endif_1:
	%9 = call %list_Node* @list_node_prev_get(%list_Node* %6)
	%10 = icmp eq %list_Node* %9, null
	br %Bool %10 , label %then_2, label %endif_2
then_2:
	ret %list_Node* null
	br label %endif_2
endif_2:
	call void @list_node_insert_right(%list_Node* %9, %list_Node* %new_node)
	%12 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%13 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%14 = load %Int32, %Int32* %13
	%15 = add %Int32 %14, 1
	store %Int32 %15, %Int32* %12
	ret %list_Node* %new_node
}

define %list_Node* @list_node_append(%list_List* %list, %list_Node* %new_node) {
	%1 = icmp eq %list_List* %list, null
	%2 = icmp eq %list_Node* %new_node, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%5 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	%6 = load %list_Node*, %list_Node** %5
	%7 = icmp eq %list_Node* %6, null
	br %Bool %7 , label %then_1, label %else_1
then_1:
	%8 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 0
	store %list_Node* %new_node, %list_Node** %8
	br label %endif_1
else_1:
	%9 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	%10 = load %list_Node*, %list_Node** %9
	call void @list_node_insert_right(%list_Node* %10, %list_Node* %new_node)
	br label %endif_1
endif_1:
	%11 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	store %list_Node* %new_node, %list_Node** %11
	%12 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%13 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%14 = load %Int32, %Int32* %13
	%15 = add %Int32 %14, 1
	store %Int32 %15, %Int32* %12
	ret %list_Node* %new_node
}

define %list_Node* @list_insert(%list_List* %list, %Int32 %pos, i8* %data) {
	%1 = call %list_Node* @list_node_create()
	%2 = icmp eq %list_Node* %1, null
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%4 = getelementptr %list_Node, %list_Node* %1, %Int32 0, %Int32 2
	store i8* %data, i8** %4
	%5 = call %list_Node* @list_node_insert(%list_List* %list, %Int32 %pos, %list_Node* %1)
	ret %list_Node* %5
}

define %list_Node* @list_append(%list_List* %list, i8* %data) {
	%1 = icmp eq %list_List* %list, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = call %list_Node* @list_node_create()
	%4 = icmp eq %list_Node* %3, null
	br %Bool %4 , label %then_1, label %endif_1
then_1:
	ret %list_Node* null
	br label %endif_1
endif_1:
	%6 = getelementptr %list_Node, %list_Node* %3, %Int32 0, %Int32 2
	store i8* %data, i8** %6
	%7 = call %list_Node* @list_node_append(%list_List* %list, %list_Node* %3)
	%8 = icmp eq %list_Node* %7, null
	br %Bool %8 , label %then_2, label %endif_2
then_2:
	%9 = bitcast %list_Node* %3 to i8*
	call void @free(i8* %9)
	br label %endif_2
endif_2:
	ret %list_Node* %7
}


