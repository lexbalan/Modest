
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
; -- print imports 'main' --
; -- 1
; ?? list ??
; from import
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

declare %list_List* @list_create()
declare %Int32 @list_size_get(%list_List* %list)
declare %list_Node* @list_first_node_get(%list_List* %list)
declare %list_Node* @list_last_node_get(%list_List* %list)
declare %list_Node* @list_node_first(%list_List* %list, %list_Node* %new_node)
declare %list_Node* @list_node_create()
declare %list_Node* @list_node_next_get(%list_Node* %node)
declare %list_Node* @list_node_prev_get(%list_Node* %node)
declare i8* @list_node_data_get(%list_Node* %node)
declare void @list_node_insert_right(%list_Node* %left, %list_Node* %new_right)
declare %list_Node* @list_node_get(%list_List* %list, %Int32 %pos)
declare %list_Node* @list_node_insert(%list_List* %list, %Int32 %pos, %list_Node* %new_node)
declare %list_Node* @list_node_append(%list_List* %list, %list_Node* %new_node)
declare %list_Node* @list_insert(%list_List* %list, %Int32 %pos, i8* %data)
declare %list_Node* @list_append(%list_List* %list, i8* %data)
; end from import
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [21 x i8] [i8 108, i8 105, i8 115, i8 116, i8 95, i8 112, i8 114, i8 105, i8 110, i8 116, i8 95, i8 102, i8 111, i8 114, i8 119, i8 97, i8 114, i8 100, i8 58, i8 10, i8 0]
@str2 = private constant [8 x i8] [i8 118, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str3 = private constant [22 x i8] [i8 108, i8 105, i8 115, i8 116, i8 95, i8 112, i8 114, i8 105, i8 110, i8 116, i8 95, i8 98, i8 97, i8 99, i8 107, i8 119, i8 97, i8 114, i8 100, i8 58, i8 10, i8 0]
@str4 = private constant [8 x i8] [i8 118, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str5 = private constant [21 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 32, i8 108, i8 105, i8 115, i8 116, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 108, i8 105, i8 115, i8 116, i8 0]
@str7 = private constant [22 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 32, i8 108, i8 105, i8 115, i8 116, i8 32, i8 115, i8 105, i8 122, i8 101, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str8 = private constant [30 x i8] [i8 10, i8 108, i8 105, i8 115, i8 116, i8 46, i8 110, i8 111, i8 100, i8 101, i8 95, i8 103, i8 101, i8 116, i8 40, i8 108, i8 105, i8 115, i8 116, i8 44, i8 32, i8 110, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str9 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 32, i8 37, i8 105, i8 32, i8 110, i8 111, i8 116, i8 32, i8 101, i8 120, i8 105, i8 115, i8 116, i8 10, i8 0]
@str10 = private constant [15 x i8] [i8 108, i8 105, i8 115, i8 116, i8 40, i8 37, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [43 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str12 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 32, i8 37, i8 105, i8 32, i8 110, i8 111, i8 116, i8 32, i8 101, i8 120, i8 105, i8 115, i8 116, i8 10, i8 0]
@str13 = private constant [15 x i8] [i8 108, i8 105, i8 115, i8 116, i8 40, i8 37, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str14 = private constant [43 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
; -- endstrings --


; wrap around linked list for list.List Nat32
define internal void @nat32_list_insert(%list_List* %lst, %Int32 %x) {
	; alloc memory for Nat32 value
	%1 = call i8* @malloc(%ctypes64_SizeT 4)
	%2 = bitcast i8* %1 to %Int32*
	store %Int32 %x, %Int32* %2
	%3 = bitcast %Int32* %2 to i8*
	%4 = call %list_Node* @list_append(%list_List* %lst, i8* %3)
	ret void
}



; show list conent from first item to last
define internal void @list_print_forward(%list_List* %lst) {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
	%2 = alloca %list_Node*, align 8
	%3 = call %list_Node* @list_first_node_get(%list_List* %lst)
	store %list_Node* %3, %list_Node** %2
	br label %again_1
again_1:
	%4 = load %list_Node*, %list_Node** %2
	%5 = icmp ne %list_Node* %4, null
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %list_Node*, %list_Node** %2
	%7 = call i8* @list_node_data_get(%list_Node* %6)
	%8 = bitcast i8* %7 to %Int32*
	%9 = load %Int32, %Int32* %8
	%10 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([8 x i8]* @str2 to [0 x i8]*), %Int32 %9)
	%11 = load %list_Node*, %list_Node** %2
	%12 = call %list_Node* @list_node_next_get(%list_Node* %11)
	store %list_Node* %12, %list_Node** %2
	br label %again_1
break_1:
	ret void
}



; show list conent from last item to first
define internal void @list_print_backward(%list_List* %lst) {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*))
	%2 = alloca %list_Node*, align 8
	%3 = call %list_Node* @list_last_node_get(%list_List* %lst)
	store %list_Node* %3, %list_Node** %2
	br label %again_1
again_1:
	%4 = load %list_Node*, %list_Node** %2
	%5 = icmp ne %list_Node* %4, null
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %list_Node*, %list_Node** %2
	%7 = call i8* @list_node_data_get(%list_Node* %6)
	%8 = bitcast i8* %7 to %Int32*
	%9 = load %Int32, %Int32* %8
	%10 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), %Int32 %9)
	%11 = load %list_Node*, %list_Node** %2
	%12 = call %list_Node* @list_node_prev_get(%list_Node* %11)
	store %list_Node* %12, %list_Node** %2
	br label %again_1
break_1:
	ret void
}

define %ctypes64_Int @main() {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*))
	%2 = call %list_List* @list_create()

	;list0.size  // access to private field of record
	%3 = icmp eq %list_List* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	ret %ctypes64_Int 1
	br label %endif_0
endif_0:

	; add some Nat32 values to list
	call void @nat32_list_insert(%list_List* %2, %Int32 0)
	call void @nat32_list_insert(%list_List* %2, %Int32 10)
	call void @nat32_list_insert(%list_List* %2, %Int32 20)
	call void @nat32_list_insert(%list_List* %2, %Int32 30)
	call void @nat32_list_insert(%list_List* %2, %Int32 40)
	call void @nat32_list_insert(%list_List* %2, %Int32 50)
	call void @nat32_list_insert(%list_List* %2, %Int32 60)
	call void @nat32_list_insert(%list_List* %2, %Int32 70)
	call void @nat32_list_insert(%list_List* %2, %Int32 80)
	call void @nat32_list_insert(%list_List* %2, %Int32 90)
	call void @nat32_list_insert(%list_List* %2, %Int32 100)

	; print list size
	%6 = call %Int32 @list_size_get(%list_List* %2)
	%7 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([22 x i8]* @str7 to [0 x i8]*), %Int32 %6)

	; print list forward
	call void @list_print_forward(%list_List* %2)

	; print list backward
	call void @list_print_backward(%list_List* %2)
	%8 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([30 x i8]* @str8 to [0 x i8]*))

	; test list.node_get
	%9 = alloca %Int32, align 4
	store %Int32 0, %Int32* %9
	br label %again_1
again_1:
	%10 = load %Int32, %Int32* %9
	%11 = icmp sge %Int32 %10, -12
	br %Bool %11 , label %body_1, label %break_1
body_1:
	%12 = load %Int32, %Int32* %9
	%13 = call %list_Node* @list_node_get(%list_List* %2, %Int32 %12)
	%14 = icmp eq %list_Node* %13, null
	br %Bool %14 , label %then_1, label %endif_1
then_1:
	%15 = load %Int32, %Int32* %9
	%16 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([19 x i8]* @str9 to [0 x i8]*), %Int32 %15)
	%17 = load %Int32, %Int32* %9
	%18 = sub %Int32 %17, 1
	store %Int32 %18, %Int32* %9
	br label %again_1
	br label %endif_1
endif_1:
	%20 = call i8* @list_node_data_get(%list_Node* %13)
	%21 = bitcast i8* %20 to %Int32*
	%22 = load %Int32, %Int32* %9
	%23 = load %Int32, %Int32* %21
	%24 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str10 to [0 x i8]*), %Int32 %22, %Int32 %23)
	%25 = load %Int32, %Int32* %9
	%26 = sub %Int32 %25, 1
	store %Int32 %26, %Int32* %9
	br label %again_1
break_1:
	%27 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([43 x i8]* @str11 to [0 x i8]*))
	store %Int32 0, %Int32* %9
	br label %again_2
again_2:
	%28 = load %Int32, %Int32* %9
	%29 = icmp sle %Int32 %28, 12
	br %Bool %29 , label %body_2, label %break_2
body_2:
	%30 = load %Int32, %Int32* %9
	%31 = call %list_Node* @list_node_get(%list_List* %2, %Int32 %30)
	%32 = icmp eq %list_Node* %31, null
	br %Bool %32 , label %then_2, label %endif_2
then_2:
	%33 = load %Int32, %Int32* %9
	%34 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([19 x i8]* @str12 to [0 x i8]*), %Int32 %33)
	%35 = load %Int32, %Int32* %9
	%36 = add %Int32 %35, 1
	store %Int32 %36, %Int32* %9
	br label %again_2
	br label %endif_2
endif_2:
	%38 = call i8* @list_node_data_get(%list_Node* %31)
	%39 = bitcast i8* %38 to %Int32*
	%40 = load %Int32, %Int32* %9
	%41 = load %Int32, %Int32* %39
	%42 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), %Int32 %40, %Int32 %41)
	%43 = load %Int32, %Int32* %9
	%44 = add %Int32 %43, 1
	store %Int32 %44, %Int32* %9
	br label %again_2
break_2:
	%45 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([43 x i8]* @str14 to [0 x i8]*))
	%46 = call i8* @malloc(%ctypes64_SizeT 4)
	%47 = bitcast i8* %46 to %Int32*
	store %Int32 1234, %Int32* %47
	%48 = bitcast %Int32* %47 to i8*
	%49 = call %list_Node* @list_insert(%list_List* %2, %Int32 4, i8* %48)
	call void @list_print_forward(%list_List* %2)
	ret %ctypes64_Int 0
}


