
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
%Char = type i8;
%ConstChar = type %Char;
%SignedChar = type i8;
%UnsignedChar = type i8;
%Short = type i16;
%UnsignedShort = type i16;
%Int = type i32;
%UnsignedInt = type i32;
%LongInt = type i64;
%UnsignedLongInt = type i64;
%Long = type i64;
%UnsignedLong = type i64;
%LongLong = type i64;
%UnsignedLongLong = type i64;
%LongLongInt = type i64;
%UnsignedLongLongInt = type i64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type i64;
%PtrDiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PIDT = type i32;
%UIDT = type i32;
%GIDT = type i32;
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
; from included stdio
%File = type i8;
%FposT = type i8;
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
; -- end print includes --
; -- print imports --
%list_Node = type {
	%list_Node*, 
	%list_Node*, 
	i8*
};

%list_List = type {
	%list_Node*, 
	%list_Node*, 
	i32
};

declare %list_List* @list_create()
declare i32 @list_size_get(%list_List* %list)
declare %list_Node* @list_first_node_get(%list_List* %list)
declare %list_Node* @list_last_node_get(%list_List* %list)
declare %list_Node* @list_node_first(%list_List* %list, %list_Node* %new_node)
declare %list_Node* @list_node_create()
declare %list_Node* @list_node_next_get(%list_Node* %node)
declare %list_Node* @list_node_prev_get(%list_Node* %node)
declare i8* @list_node_data_get(%list_Node* %node)
declare void @list_node_insert_right(%list_Node* %left, %list_Node* %new_right)
declare %list_Node* @list_node_get(%list_List* %list, i32 %pos)
declare %list_Node* @list_node_insert(%list_List* %list, i32 %pos, %list_Node* %new_node)
declare %list_Node* @list_node_append(%list_List* %list, %list_Node* %new_node)
declare %list_Node* @list_insert(%list_List* %list, i32 %pos, i8* %data)
declare %list_Node* @list_append(%list_List* %list, i8* %data)
; -- end print imports --
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

define internal void @nat32_list_insert(%list_List* %list, i32 %x) {
	; alloc memory for Nat32 value
	%1 = call i8* @malloc(%SizeT 4)
	%2 = bitcast i8* %1 to i32*
	store i32 %x, i32* %2
	%3 = bitcast %list_List* %list to %list_List*
	%4 = bitcast i32* %2 to i8*
	%5 = call %list_Node* @list_append(%list_List* %3, i8* %4)
	ret void
}

define internal void @list_print_forward(%list_List* %list) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
	%2 = alloca %list_Node*, align 8
	%3 = bitcast %list_List* %list to %list_List*
	%4 = call %list_Node* @list_first_node_get(%list_List* %3)
	store %list_Node* %4, %list_Node** %2
	br label %again_1
again_1:
	%5 = load %list_Node*, %list_Node** %2
	%6 = bitcast i8* null to %list_Node*
	%7 = icmp ne %list_Node* %5, %6
	br i1 %7 , label %body_1, label %break_1
body_1:
	%8 = load %list_Node*, %list_Node** %2
	%9 = bitcast %list_Node* %8 to %list_Node*
	%10 = call i8* @list_node_data_get(%list_Node* %9)
	%11 = bitcast i8* %10 to i32*
	%12 = load i32, i32* %11
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str2 to [0 x i8]*), i32 %12)
	%14 = load %list_Node*, %list_Node** %2
	%15 = bitcast %list_Node* %14 to %list_Node*
	%16 = call %list_Node* @list_node_next_get(%list_Node* %15)
	%17 = bitcast %list_Node* %16 to %list_Node*
	store %list_Node* %17, %list_Node** %2
	br label %again_1
break_1:
	ret void
}

define internal void @list_print_backward(%list_List* %list) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*))
	%2 = alloca %list_Node*, align 8
	%3 = bitcast %list_List* %list to %list_List*
	%4 = call %list_Node* @list_last_node_get(%list_List* %3)
	store %list_Node* %4, %list_Node** %2
	br label %again_1
again_1:
	%5 = load %list_Node*, %list_Node** %2
	%6 = bitcast i8* null to %list_Node*
	%7 = icmp ne %list_Node* %5, %6
	br i1 %7 , label %body_1, label %break_1
body_1:
	%8 = load %list_Node*, %list_Node** %2
	%9 = bitcast %list_Node* %8 to %list_Node*
	%10 = call i8* @list_node_data_get(%list_Node* %9)
	%11 = bitcast i8* %10 to i32*
	%12 = load i32, i32* %11
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), i32 %12)
	%14 = load %list_Node*, %list_Node** %2
	%15 = bitcast %list_Node* %14 to %list_Node*
	%16 = call %list_Node* @list_node_prev_get(%list_Node* %15)
	%17 = bitcast %list_Node* %16 to %list_Node*
	store %list_Node* %17, %list_Node** %2
	br label %again_1
break_1:
	ret void
}


define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*))
	%2 = call %list_List* @list_create()
	%3 = bitcast i8* null to %list_List*
	%4 = icmp eq %list_List* %2, %3
	br i1 %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	; add some Nat32 values to list
	%7 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %7, i32 0)
	%8 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %8, i32 10)
	%9 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %9, i32 20)
	%10 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %10, i32 30)
	%11 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %11, i32 40)
	%12 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %12, i32 50)
	%13 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %13, i32 60)
	%14 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %14, i32 70)
	%15 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %15, i32 80)
	%16 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %16, i32 90)
	%17 = bitcast %list_List* %2 to %list_List*
	call void @nat32_list_insert(%list_List* %17, i32 100)
	; print list size
	%18 = bitcast %list_List* %2 to %list_List*
	%19 = call i32 @list_size_get(%list_List* %18)
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str7 to [0 x i8]*), i32 %19)
	; print list forward
	%21 = bitcast %list_List* %2 to %list_List*
	call void @list_print_forward(%list_List* %21)
	; print list backward
	%22 = bitcast %list_List* %2 to %list_List*
	call void @list_print_backward(%list_List* %22)
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str8 to [0 x i8]*))
	; test list.node_get
	%24 = alloca i32, align 4
	store i32 0, i32* %24
	br label %again_1
again_1:
	%25 = load i32, i32* %24
	%26 = icmp sge i32 %25, -12
	br i1 %26 , label %body_1, label %break_1
body_1:
	%27 = bitcast %list_List* %2 to %list_List*
	%28 = load i32, i32* %24
	%29 = call %list_Node* @list_node_get(%list_List* %27, i32 %28)
	%30 = bitcast i8* null to %list_Node*
	%31 = icmp eq %list_Node* %29, %30
	br i1 %31 , label %then_1, label %endif_1
then_1:
	%32 = load i32, i32* %24
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str9 to [0 x i8]*), i32 %32)
	%34 = load i32, i32* %24
	%35 = sub i32 %34, 1
	store i32 %35, i32* %24
	br label %again_1
	br label %endif_1
endif_1:
	%37 = bitcast %list_Node* %29 to %list_Node*
	%38 = call i8* @list_node_data_get(%list_Node* %37)
	%39 = bitcast i8* %38 to i32*
	%40 = load i32, i32* %24
	%41 = load i32, i32* %39
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str10 to [0 x i8]*), i32 %40, i32 %41)
	%43 = load i32, i32* %24
	%44 = sub i32 %43, 1
	store i32 %44, i32* %24
	br label %again_1
break_1:
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @str11 to [0 x i8]*))
	store i32 0, i32* %24
	br label %again_2
again_2:
	%46 = load i32, i32* %24
	%47 = icmp sle i32 %46, 12
	br i1 %47 , label %body_2, label %break_2
body_2:
	%48 = bitcast %list_List* %2 to %list_List*
	%49 = load i32, i32* %24
	%50 = call %list_Node* @list_node_get(%list_List* %48, i32 %49)
	%51 = bitcast i8* null to %list_Node*
	%52 = icmp eq %list_Node* %50, %51
	br i1 %52 , label %then_2, label %endif_2
then_2:
	%53 = load i32, i32* %24
	%54 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str12 to [0 x i8]*), i32 %53)
	%55 = load i32, i32* %24
	%56 = add i32 %55, 1
	store i32 %56, i32* %24
	br label %again_2
	br label %endif_2
endif_2:
	%58 = bitcast %list_Node* %50 to %list_Node*
	%59 = call i8* @list_node_data_get(%list_Node* %58)
	%60 = bitcast i8* %59 to i32*
	%61 = load i32, i32* %24
	%62 = load i32, i32* %60
	%63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %61, i32 %62)
	%64 = load i32, i32* %24
	%65 = add i32 %64, 1
	store i32 %65, i32* %24
	br label %again_2
break_2:
	%66 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @str14 to [0 x i8]*))
	%67 = call i8* @malloc(%SizeT 4)
	%68 = bitcast i8* %67 to i32*
	store i32 1234, i32* %68
	%69 = bitcast %list_List* %2 to %list_List*
	%70 = bitcast i32* %68 to i8*
	%71 = call %list_Node* @list_insert(%list_List* %69, i32 4, i8* %70)
	%72 = bitcast %list_List* %2 to %list_List*
	call void @list_print_forward(%list_List* %72)
	ret %Int 0
}


