
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
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

; MODULE: list

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
; -- end print imports --
; -- strings --
@str1 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 105, i8 110, i8 115, i8 101, i8 114, i8 116, i8 95, i8 114, i8 105, i8 103, i8 104, i8 116, i8 10, i8 0]
@str2 = private constant [14 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 103, i8 101, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
@str3 = private constant [17 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 105, i8 110, i8 115, i8 101, i8 114, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]

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


define %list_List* @list_create() {
	%1 = call i8* @malloc(%SizeT 24)
	%2 = bitcast i8* %1 to %list_List*
	%3 = bitcast i8* null to %list_List*
	%4 = icmp eq %list_List* %2, %3
	br i1 %4 , label %then_0, label %endif_0
then_0:
	%5 = bitcast i8* null to %list_List*
	ret %list_List* %5
	br label %endif_0
endif_0:
	store %list_List zeroinitializer, %list_List* %2
	%7 = bitcast %list_List* %2 to %list_List*
	ret %list_List* %7
}

define i32 @list_size_get(%list_List* %list) {
	%1 = bitcast i8* null to %list_List*
	%2 = icmp eq %list_List* %list, %1
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret i32 0
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%5 = load i32, i32* %4
	ret i32 %5
}

define %list_Node* @list_first_node_get(%list_List* %list) {
	%1 = bitcast i8* null to %list_List*
	%2 = icmp eq %list_List* %list, %1
	br i1 %2 , label %then_0, label %endif_0
then_0:
	%3 = bitcast i8* null to %list_Node*
	ret %list_Node* %3
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 0
	%6 = load %list_Node*, %list_Node** %5
	%7 = bitcast %list_Node* %6 to %list_Node*
	ret %list_Node* %7
}

define %list_Node* @list_last_node_get(%list_List* %list) {
	%1 = bitcast i8* null to %list_List*
	%2 = icmp eq %list_List* %list, %1
	br i1 %2 , label %then_0, label %endif_0
then_0:
	%3 = bitcast i8* null to %list_Node*
	ret %list_Node* %3
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 1
	%6 = load %list_Node*, %list_Node** %5
	%7 = bitcast %list_Node* %6 to %list_Node*
	ret %list_Node* %7
}

define %list_Node* @list_node_first(%list_List* %list, %list_Node* %new_node) {
	%1 = bitcast i8* null to %list_List*
	%2 = icmp eq %list_List* %list, %1
	%3 = bitcast i8* null to %list_Node*
	%4 = icmp eq %list_Node* %new_node, %3
	%5 = or i1 %2, %4
	br i1 %5 , label %then_0, label %endif_0
then_0:
	%6 = bitcast i8* null to %list_Node*
	ret %list_Node* %6
	br label %endif_0
endif_0:
	%8 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 0
	%9 = bitcast %list_Node* %new_node to %list_Node*
	store %list_Node* %9, %list_Node** %8
	%10 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 1
	%11 = bitcast %list_Node* %new_node to %list_Node*
	store %list_Node* %11, %list_Node** %10
	%12 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%13 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%14 = load i32, i32* %13
	%15 = add i32 %14, 1
	store i32 %15, i32* %12
	%16 = bitcast %list_Node* %new_node to %list_Node*
	ret %list_Node* %16
}

define %list_Node* @list_node_create() {
	%1 = call i8* @malloc(%SizeT 24)
	%2 = bitcast i8* %1 to %list_Node*
	%3 = bitcast i8* null to %list_Node*
	%4 = icmp eq %list_Node* %2, %3
	br i1 %4 , label %then_0, label %endif_0
then_0:
	%5 = bitcast i8* null to %list_Node*
	ret %list_Node* %5
	br label %endif_0
endif_0:
	store %list_Node zeroinitializer, %list_Node* %2
	%7 = bitcast %list_Node* %2 to %list_Node*
	ret %list_Node* %7
}

define %list_Node* @list_node_next_get(%list_Node* %node) {
	%1 = bitcast i8* null to %list_Node*
	%2 = icmp eq %list_Node* %node, %1
	br i1 %2 , label %then_0, label %endif_0
then_0:
	%3 = bitcast i8* null to %list_Node*
	ret %list_Node* %3
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %list_Node, %list_Node* %node, i32 0, i32 0
	%6 = load %list_Node*, %list_Node** %5
	%7 = bitcast %list_Node* %6 to %list_Node*
	ret %list_Node* %7
}

define %list_Node* @list_node_prev_get(%list_Node* %node) {
	%1 = bitcast i8* null to %list_Node*
	%2 = icmp eq %list_Node* %node, %1
	br i1 %2 , label %then_0, label %endif_0
then_0:
	%3 = bitcast i8* null to %list_Node*
	ret %list_Node* %3
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %list_Node, %list_Node* %node, i32 0, i32 1
	%6 = load %list_Node*, %list_Node** %5
	%7 = bitcast %list_Node* %6 to %list_Node*
	ret %list_Node* %7
}

define i8* @list_node_data_get(%list_Node* %node) {
	%1 = bitcast i8* null to %list_Node*
	%2 = icmp eq %list_Node* %node, %1
	br i1 %2 , label %then_0, label %endif_0
then_0:
	%3 = bitcast i8* null to i8*
	ret i8* %3
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %list_Node, %list_Node* %node, i32 0, i32 2
	%6 = load i8*, i8** %5
	ret i8* %6
}

define void @list_node_insert_right(%list_Node* %left, %list_Node* %new_right) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*))
	%2 = getelementptr inbounds %list_Node, %list_Node* %left, i32 0, i32 0
	%3 = load %list_Node*, %list_Node** %2
	%4 = getelementptr inbounds %list_Node, %list_Node* %left, i32 0, i32 0
	%5 = bitcast %list_Node* %new_right to %list_Node*
	store %list_Node* %5, %list_Node** %4
	%6 = bitcast i8* null to %list_Node*
	%7 = icmp ne %list_Node* %3, %6
	br i1 %7 , label %then_0, label %endif_0
then_0:
	%8 = getelementptr inbounds %list_Node, %list_Node* %3, i32 0, i32 1
	%9 = bitcast %list_Node* %new_right to %list_Node*
	store %list_Node* %9, %list_Node** %8
	br label %endif_0
endif_0:
	%10 = getelementptr inbounds %list_Node, %list_Node* %new_right, i32 0, i32 0
	%11 = bitcast %list_Node* %3 to %list_Node*
	store %list_Node* %11, %list_Node** %10
	%12 = getelementptr inbounds %list_Node, %list_Node* %new_right, i32 0, i32 1
	%13 = bitcast %list_Node* %left to %list_Node*
	store %list_Node* %13, %list_Node** %12
	ret void
}

define %list_Node* @list_node_get(%list_List* %list, i32 %pos) {
	%1 = bitcast i8* null to %list_List*
	%2 = icmp eq %list_List* %list, %1
	%3 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%4 = load i32, i32* %3
	%5 = icmp eq i32 %4, 0
	%6 = or i1 %2, %5
	br i1 %6 , label %then_0, label %endif_0
then_0:
	%7 = bitcast i8* null to %list_Node*
	ret %list_Node* %7
	br label %endif_0
endif_0:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str2 to [0 x i8]*), i32 %pos)
	%10 = alloca %list_Node*, align 8
	%11 = icmp sge i32 %pos, 0
	br i1 %11 , label %then_1, label %else_1
then_1:
	; go forward
	%12 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 0
	%13 = load %list_Node*, %list_Node** %12
	%14 = bitcast %list_Node* %13 to %list_Node*
	store %list_Node* %14, %list_Node** %10
	%15 = bitcast i32 %pos to i32
	%16 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%17 = load i32, i32* %16
	%18 = icmp ugt i32 %15, %17
	br i1 %18 , label %then_2, label %endif_2
then_2:
	%19 = bitcast i8* null to %list_Node*
	ret %list_Node* %19
	br label %endif_2
endif_2:
	%21 = alloca i32, align 4
	store i32 0, i32* %21
	br label %again_1
again_1:
	%22 = load i32, i32* %21
	%23 = icmp ult i32 %22, %15
	br i1 %23 , label %body_1, label %break_1
body_1:
	%24 = load %list_Node*, %list_Node** %10
	%25 = getelementptr inbounds %list_Node, %list_Node* %24, i32 0, i32 0
	%26 = load %list_Node*, %list_Node** %25
	%27 = bitcast %list_Node* %26 to %list_Node*
	store %list_Node* %27, %list_Node** %10
	%28 = load i32, i32* %21
	%29 = add i32 %28, 1
	store i32 %29, i32* %21
	br label %again_1
break_1:
	br label %endif_1
else_1:
	; go backward
	%30 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 1
	%31 = load %list_Node*, %list_Node** %30
	%32 = bitcast %list_Node* %31 to %list_Node*
	store %list_Node* %32, %list_Node** %10
	%33 = sub i32 0, %pos
	%34 = bitcast i32 %33 to i32
	%35 = sub i32 %34, 1
	%36 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%37 = load i32, i32* %36
	%38 = icmp ugt i32 %35, %37
	br i1 %38 , label %then_3, label %endif_3
then_3:
	%39 = bitcast i8* null to %list_Node*
	ret %list_Node* %39
	br label %endif_3
endif_3:
	%41 = alloca i32, align 4
	store i32 0, i32* %41
	br label %again_2
again_2:
	%42 = load i32, i32* %41
	%43 = icmp ult i32 %42, %35
	br i1 %43 , label %body_2, label %break_2
body_2:
	%44 = load %list_Node*, %list_Node** %10
	%45 = getelementptr inbounds %list_Node, %list_Node* %44, i32 0, i32 1
	%46 = load %list_Node*, %list_Node** %45
	%47 = bitcast %list_Node* %46 to %list_Node*
	store %list_Node* %47, %list_Node** %10
	%48 = load i32, i32* %41
	%49 = add i32 %48, 1
	store i32 %49, i32* %41
	br label %again_2
break_2:
	br label %endif_1
endif_1:
	%50 = load %list_Node*, %list_Node** %10
	%51 = bitcast %list_Node* %50 to %list_Node*
	ret %list_Node* %51
}

define %list_Node* @list_node_insert(%list_List* %list, i32 %pos, %list_Node* %new_node) {
	%1 = bitcast i8* null to %list_List*
	%2 = icmp eq %list_List* %list, %1
	%3 = bitcast i8* null to %list_Node*
	%4 = icmp eq %list_Node* %new_node, %3
	%5 = or i1 %2, %4
	br i1 %5 , label %then_0, label %endif_0
then_0:
	%6 = bitcast i8* null to %list_Node*
	ret %list_Node* %6
	br label %endif_0
endif_0:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str3 to [0 x i8]*), i32 %pos)
	%9 = bitcast %list_List* %list to %list_List*
	%10 = call %list_Node* @list_node_get(%list_List* %9, i32 %pos)
	%11 = bitcast i8* null to %list_Node*
	%12 = icmp eq %list_Node* %10, %11
	br i1 %12 , label %then_1, label %endif_1
then_1:
	%13 = bitcast i8* null to %list_Node*
	ret %list_Node* %13
	br label %endif_1
endif_1:
	%15 = bitcast %list_Node* %10 to %list_Node*
	%16 = call %list_Node* @list_node_prev_get(%list_Node* %15)
	%17 = bitcast i8* null to %list_Node*
	%18 = icmp eq %list_Node* %16, %17
	br i1 %18 , label %then_2, label %endif_2
then_2:
	%19 = bitcast i8* null to %list_Node*
	ret %list_Node* %19
	br label %endif_2
endif_2:
	%21 = bitcast %list_Node* %16 to %list_Node*
	%22 = bitcast %list_Node* %new_node to %list_Node*
	call void @list_node_insert_right(%list_Node* %21, %list_Node* %22)
	%23 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%24 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%25 = load i32, i32* %24
	%26 = add i32 %25, 1
	store i32 %26, i32* %23
	%27 = bitcast %list_Node* %new_node to %list_Node*
	ret %list_Node* %27
}

define %list_Node* @list_node_append(%list_List* %list, %list_Node* %new_node) {
	%1 = bitcast i8* null to %list_List*
	%2 = icmp eq %list_List* %list, %1
	%3 = bitcast i8* null to %list_Node*
	%4 = icmp eq %list_Node* %new_node, %3
	%5 = or i1 %2, %4
	br i1 %5 , label %then_0, label %endif_0
then_0:
	%6 = bitcast i8* null to %list_Node*
	ret %list_Node* %6
	br label %endif_0
endif_0:
	%8 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 1
	%9 = load %list_Node*, %list_Node** %8
	%10 = bitcast i8* null to %list_Node*
	%11 = icmp eq %list_Node* %9, %10
	br i1 %11 , label %then_1, label %else_1
then_1:
	%12 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 0
	%13 = bitcast %list_Node* %new_node to %list_Node*
	store %list_Node* %13, %list_Node** %12
	br label %endif_1
else_1:
	%14 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 1
	%15 = load %list_Node*, %list_Node** %14
	%16 = bitcast %list_Node* %15 to %list_Node*
	%17 = bitcast %list_Node* %new_node to %list_Node*
	call void @list_node_insert_right(%list_Node* %16, %list_Node* %17)
	br label %endif_1
endif_1:
	%18 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 1
	%19 = bitcast %list_Node* %new_node to %list_Node*
	store %list_Node* %19, %list_Node** %18
	%20 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%21 = getelementptr inbounds %list_List, %list_List* %list, i32 0, i32 2
	%22 = load i32, i32* %21
	%23 = add i32 %22, 1
	store i32 %23, i32* %20
	%24 = bitcast %list_Node* %new_node to %list_Node*
	ret %list_Node* %24
}

define %list_Node* @list_insert(%list_List* %list, i32 %pos, i8* %data) {
	%1 = call %list_Node* @list_node_create()
	%2 = bitcast i8* null to %list_Node*
	%3 = icmp eq %list_Node* %1, %2
	br i1 %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8* null to %list_Node*
	ret %list_Node* %4
	br label %endif_0
endif_0:
	%6 = getelementptr inbounds %list_Node, %list_Node* %1, i32 0, i32 2
	store i8* %data, i8** %6
	%7 = bitcast %list_List* %list to %list_List*
	%8 = bitcast %list_Node* %1 to %list_Node*
	%9 = call %list_Node* @list_node_insert(%list_List* %7, i32 %pos, %list_Node* %8)
	%10 = bitcast %list_Node* %9 to %list_Node*
	ret %list_Node* %10
}

define %list_Node* @list_append(%list_List* %list, i8* %data) {
	%1 = bitcast i8* null to %list_List*
	%2 = icmp eq %list_List* %list, %1
	br i1 %2 , label %then_0, label %endif_0
then_0:
	%3 = bitcast i8* null to %list_Node*
	ret %list_Node* %3
	br label %endif_0
endif_0:
	%5 = call %list_Node* @list_node_create()
	%6 = bitcast i8* null to %list_Node*
	%7 = icmp eq %list_Node* %5, %6
	br i1 %7 , label %then_1, label %endif_1
then_1:
	%8 = bitcast i8* null to %list_Node*
	ret %list_Node* %8
	br label %endif_1
endif_1:
	%10 = getelementptr inbounds %list_Node, %list_Node* %5, i32 0, i32 2
	store i8* %data, i8** %10
	%11 = bitcast %list_List* %list to %list_List*
	%12 = bitcast %list_Node* %5 to %list_Node*
	%13 = call %list_Node* @list_node_append(%list_List* %11, %list_Node* %12)
	%14 = bitcast i8* null to %list_Node*
	%15 = icmp eq %list_Node* %13, %14
	br i1 %15 , label %then_2, label %endif_2
then_2:
	%16 = bitcast %list_Node* %5 to i8*
	call void @free(i8* %16)
	br label %endif_2
endif_2:
	%17 = bitcast %list_Node* %13 to %list_Node*
	ret %list_Node* %17
}


