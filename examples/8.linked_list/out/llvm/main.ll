
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

%Node = type {
	%Node*, 
	%Node*, 
	i8*
};

%List = type {
	%Node*, 
	%Node*, 
	i32
};


declare %List* @list_create()
declare i32 @list_size_get(%List* %list)
declare %Node* @list_first_node_get(%List* %list)
declare %Node* @list_last_node_get(%List* %list)
declare %Node* @list_node_first(%List* %list, %Node* %new_node)
declare %Node* @list_node_create()
declare %Node* @list_node_next_get(%Node* %node)
declare %Node* @list_node_prev_get(%Node* %node)
declare i8* @list_node_data_get(%Node* %node)
declare void @list_node_insert_right(%Node* %left, %Node* %new_right)
declare %Node* @list_node_get(%List* %list, i32 %pos)
declare %Node* @list_node_insert(%List* %list, i32 %pos, %Node* %new_node)
declare %Node* @list_node_append(%List* %list, %Node* %new_node)
declare %Node* @list_insert(%List* %list, i32 %pos, i8* %data)
declare %Node* @list_append(%List* %list, i8* %data)
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

define void @nat32_list_insert(%List* %list, i32 %x) {
	; alloc memory for Nat32 value
	%1 = call i8* @malloc(%SizeT 4)
	%2 = bitcast i8* %1 to i32*
	store i32 %x, i32* %2
	%3 = bitcast %List* %list to %List*
	%4 = bitcast i32* %2 to i8*
	%5 = call %Node* @list_append(%List* %3, i8* %4)
	ret void
}

define void @list_print_forward(%List* %list) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
	%2 = alloca %Node*, align 8
	%3 = bitcast %List* %list to %List*
	%4 = call %Node* @list_first_node_get(%List* %3)
	store %Node* %4, %Node** %2
	br label %again_1
again_1:
	%5 = load %Node*, %Node** %2
	%6 = icmp ne %Node* %5, null
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load %Node*, %Node** %2
	%8 = bitcast %Node* %7 to %Node*
	%9 = call i8* @list_node_data_get(%Node* %8)
	%10 = bitcast i8* %9 to i32*
	%11 = load i32, i32* %10
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str2 to [0 x i8]*), i32 %11)
	%13 = load %Node*, %Node** %2
	%14 = bitcast %Node* %13 to %Node*
	%15 = call %Node* @list_node_next_get(%Node* %14)
	%16 = bitcast %Node* %15 to %Node*
	store %Node* %16, %Node** %2
	br label %again_1
break_1:
	ret void
}

define void @list_print_backward(%List* %list) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*))
	%2 = alloca %Node*, align 8
	%3 = bitcast %List* %list to %List*
	%4 = call %Node* @list_last_node_get(%List* %3)
	store %Node* %4, %Node** %2
	br label %again_1
again_1:
	%5 = load %Node*, %Node** %2
	%6 = icmp ne %Node* %5, null
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load %Node*, %Node** %2
	%8 = bitcast %Node* %7 to %Node*
	%9 = call i8* @list_node_data_get(%Node* %8)
	%10 = bitcast i8* %9 to i32*
	%11 = load i32, i32* %10
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), i32 %11)
	%13 = load %Node*, %Node** %2
	%14 = bitcast %Node* %13 to %Node*
	%15 = call %Node* @list_node_prev_get(%Node* %14)
	%16 = bitcast %Node* %15 to %Node*
	store %Node* %16, %Node** %2
	br label %again_1
break_1:
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*))
	%2 = call %List* @list_create()
	%3 = icmp eq %List* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	; add some Nat32 values to list
	%6 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %6, i32 0)
	%7 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %7, i32 10)
	%8 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %8, i32 20)
	%9 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %9, i32 30)
	%10 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %10, i32 40)
	%11 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %11, i32 50)
	%12 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %12, i32 60)
	%13 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %13, i32 70)
	%14 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %14, i32 80)
	%15 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %15, i32 90)
	%16 = bitcast %List* %2 to %List*
	call void @nat32_list_insert(%List* %16, i32 100)
	; print list size
	%17 = bitcast %List* %2 to %List*
	%18 = call i32 @list_size_get(%List* %17)
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str7 to [0 x i8]*), i32 %18)
	; print list forward
	%20 = bitcast %List* %2 to %List*
	call void @list_print_forward(%List* %20)
	; print list backward
	%21 = bitcast %List* %2 to %List*
	call void @list_print_backward(%List* %21)
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str8 to [0 x i8]*))
	; test list.node_get
	%23 = alloca i32, align 4
	store i32 0, i32* %23
	br label %again_1
again_1:
	%24 = load i32, i32* %23
	%25 = icmp sge i32 %24, -12
	br i1 %25 , label %body_1, label %break_1
body_1:
	%26 = bitcast %List* %2 to %List*
	%27 = load i32, i32* %23
	%28 = call %Node* @list_node_get(%List* %26, i32 %27)
	%29 = icmp eq %Node* %28, null
	br i1 %29 , label %then_1, label %endif_1
then_1:
	%30 = load i32, i32* %23
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str9 to [0 x i8]*), i32 %30)
	%32 = load i32, i32* %23
	%33 = sub i32 %32, 1
	store i32 %33, i32* %23
	br label %again_1
	br label %endif_1
endif_1:
	%35 = bitcast %Node* %28 to %Node*
	%36 = call i8* @list_node_data_get(%Node* %35)
	%37 = bitcast i8* %36 to i32*
	%38 = load i32, i32* %23
	%39 = load i32, i32* %37
	%40 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str10 to [0 x i8]*), i32 %38, i32 %39)
	%41 = load i32, i32* %23
	%42 = sub i32 %41, 1
	store i32 %42, i32* %23
	br label %again_1
break_1:
	%43 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @str11 to [0 x i8]*))
	store i32 0, i32* %23
	br label %again_2
again_2:
	%44 = load i32, i32* %23
	%45 = icmp sle i32 %44, 12
	br i1 %45 , label %body_2, label %break_2
body_2:
	%46 = bitcast %List* %2 to %List*
	%47 = load i32, i32* %23
	%48 = call %Node* @list_node_get(%List* %46, i32 %47)
	%49 = icmp eq %Node* %48, null
	br i1 %49 , label %then_2, label %endif_2
then_2:
	%50 = load i32, i32* %23
	%51 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str12 to [0 x i8]*), i32 %50)
	%52 = load i32, i32* %23
	%53 = add i32 %52, 1
	store i32 %53, i32* %23
	br label %again_2
	br label %endif_2
endif_2:
	%55 = bitcast %Node* %48 to %Node*
	%56 = call i8* @list_node_data_get(%Node* %55)
	%57 = bitcast i8* %56 to i32*
	%58 = load i32, i32* %23
	%59 = load i32, i32* %57
	%60 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %58, i32 %59)
	%61 = load i32, i32* %23
	%62 = add i32 %61, 1
	store i32 %62, i32* %23
	br label %again_2
break_2:
	%63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @str14 to [0 x i8]*))
	%64 = call i8* @malloc(%SizeT 4)
	%65 = bitcast i8* %64 to i32*
	store i32 1234, i32* %65
	%66 = bitcast %List* %2 to %List*
	%67 = bitcast i32* %65 to i8*
	%68 = call %Node* @list_insert(%List* %66, i32 4, i8* %67)
	%69 = bitcast %List* %2 to %List*
	call void @list_print_forward(%List* %69)
	ret %Int 0
}


