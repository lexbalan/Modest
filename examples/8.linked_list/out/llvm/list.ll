
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
; -- end print includes --
; -- print imports --
; -- end print imports --
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
	%1 = call i8* @malloc(%SizeT 24)
	%2 = bitcast i8* %1 to %list_List*
	%3 = bitcast %list_List* %2 to %list_List*
	%4 = bitcast i8* null to %list_List*
	%5 = icmp eq %list_List* %3, %4
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	%6 = bitcast i8* null to %list_List*
	ret %list_List* %6
	br label %endif_0
endif_0:
	store %list_List zeroinitializer, %list_List* %2
	%8 = bitcast %list_List* %2 to %list_List*
	ret %list_List* %8
}

define %Int32 @list_size_get(%list_List* %list) {
	%1 = bitcast %list_List* %list to %list_List*
	%2 = bitcast i8* null to %list_List*
	%3 = icmp eq %list_List* %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %Int32 0
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%6 = load %Int32, %Int32* %5
	ret %Int32 %6
}

define %list_Node* @list_first_node_get(%list_List* %list) {
	%1 = bitcast %list_List* %list to %list_List*
	%2 = bitcast i8* null to %list_List*
	%3 = icmp eq %list_List* %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8* null to %list_Node*
	ret %list_Node* %4
	br label %endif_0
endif_0:
	%6 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 0
	%7 = load %list_Node*, %list_Node** %6
	%8 = bitcast %list_Node* %7 to %list_Node*
	ret %list_Node* %8
}

define %list_Node* @list_last_node_get(%list_List* %list) {
	%1 = bitcast %list_List* %list to %list_List*
	%2 = bitcast i8* null to %list_List*
	%3 = icmp eq %list_List* %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8* null to %list_Node*
	ret %list_Node* %4
	br label %endif_0
endif_0:
	%6 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 1
	%7 = load %list_Node*, %list_Node** %6
	%8 = bitcast %list_Node* %7 to %list_Node*
	ret %list_Node* %8
}

define %list_Node* @list_node_first(%list_List* %list, %list_Node* %new_node) {
	%1 = bitcast %list_List* %list to %list_List*
	%2 = bitcast i8* null to %list_List*
	%3 = icmp eq %list_List* %1, %2
	%4 = bitcast %list_Node* %new_node to %list_Node*
	%5 = bitcast i8* null to %list_Node*
	%6 = icmp eq %list_Node* %4, %5
	%7 = or %Bool %3, %6
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	%8 = bitcast i8* null to %list_Node*
	ret %list_Node* %8
	br label %endif_0
endif_0:
	%10 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 0
	%11 = bitcast %list_Node* %new_node to %list_Node*
	store %list_Node* %11, %list_Node** %10
	%12 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 1
	%13 = bitcast %list_Node* %new_node to %list_Node*
	store %list_Node* %13, %list_Node** %12
	%14 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%15 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%16 = load %Int32, %Int32* %15
	%17 = add %Int32 %16, 1
	store %Int32 %17, %Int32* %14
	%18 = bitcast %list_Node* %new_node to %list_Node*
	ret %list_Node* %18
}

define %list_Node* @list_node_create() {
	%1 = call i8* @malloc(%SizeT 24)
	%2 = bitcast i8* %1 to %list_Node*
	%3 = bitcast %list_Node* %2 to %list_Node*
	%4 = bitcast i8* null to %list_Node*
	%5 = icmp eq %list_Node* %3, %4
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	%6 = bitcast i8* null to %list_Node*
	ret %list_Node* %6
	br label %endif_0
endif_0:
	store %list_Node zeroinitializer, %list_Node* %2
	%8 = bitcast %list_Node* %2 to %list_Node*
	ret %list_Node* %8
}

define %list_Node* @list_node_next_get(%list_Node* %node) {
	%1 = bitcast %list_Node* %node to %list_Node*
	%2 = bitcast i8* null to %list_Node*
	%3 = icmp eq %list_Node* %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8* null to %list_Node*
	ret %list_Node* %4
	br label %endif_0
endif_0:
	%6 = getelementptr inbounds %list_Node, %list_Node* %node, %Int32 0, %Int32 0
	%7 = load %list_Node*, %list_Node** %6
	%8 = bitcast %list_Node* %7 to %list_Node*
	ret %list_Node* %8
}

define %list_Node* @list_node_prev_get(%list_Node* %node) {
	%1 = bitcast %list_Node* %node to %list_Node*
	%2 = bitcast i8* null to %list_Node*
	%3 = icmp eq %list_Node* %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8* null to %list_Node*
	ret %list_Node* %4
	br label %endif_0
endif_0:
	%6 = getelementptr inbounds %list_Node, %list_Node* %node, %Int32 0, %Int32 1
	%7 = load %list_Node*, %list_Node** %6
	%8 = bitcast %list_Node* %7 to %list_Node*
	ret %list_Node* %8
}

define i8* @list_node_data_get(%list_Node* %node) {
	%1 = bitcast %list_Node* %node to %list_Node*
	%2 = bitcast i8* null to %list_Node*
	%3 = icmp eq %list_Node* %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8* null to i8*
	ret i8* %4
	br label %endif_0
endif_0:
	%6 = getelementptr inbounds %list_Node, %list_Node* %node, %Int32 0, %Int32 2
	%7 = load i8*, i8** %6
	ret i8* %7
}

define void @list_node_insert_right(%list_Node* %left, %list_Node* %new_right) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*))
	%2 = getelementptr inbounds %list_Node, %list_Node* %left, %Int32 0, %Int32 0
	%3 = load %list_Node*, %list_Node** %2
	%4 = getelementptr inbounds %list_Node, %list_Node* %left, %Int32 0, %Int32 0
	%5 = bitcast %list_Node* %new_right to %list_Node*
	store %list_Node* %5, %list_Node** %4
	%6 = bitcast %list_Node* %3 to %list_Node*
	%7 = bitcast i8* null to %list_Node*
	%8 = icmp ne %list_Node* %6, %7
	br %Bool %8 , label %then_0, label %endif_0
then_0:
	%9 = getelementptr inbounds %list_Node, %list_Node* %3, %Int32 0, %Int32 1
	%10 = bitcast %list_Node* %new_right to %list_Node*
	store %list_Node* %10, %list_Node** %9
	br label %endif_0
endif_0:
	%11 = getelementptr inbounds %list_Node, %list_Node* %new_right, %Int32 0, %Int32 0
	%12 = bitcast %list_Node* %3 to %list_Node*
	store %list_Node* %12, %list_Node** %11
	%13 = getelementptr inbounds %list_Node, %list_Node* %new_right, %Int32 0, %Int32 1
	%14 = bitcast %list_Node* %left to %list_Node*
	store %list_Node* %14, %list_Node** %13
	ret void
}

define %list_Node* @list_node_get(%list_List* %list, %Int32 %pos) {
	%1 = bitcast %list_List* %list to %list_List*
	%2 = bitcast i8* null to %list_List*
	%3 = icmp eq %list_List* %1, %2
	%4 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%5 = load %Int32, %Int32* %4
	%6 = icmp eq %Int32 %5, 0
	%7 = or %Bool %3, %6
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	%8 = bitcast i8* null to %list_Node*
	ret %list_Node* %8
	br label %endif_0
endif_0:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str2 to [0 x i8]*), %Int32 %pos)
	%11 = alloca %list_Node*, align 8
	%12 = icmp sge %Int32 %pos, 0
	br %Bool %12 , label %then_1, label %else_1
then_1:
	; go forward
	%13 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 0
	%14 = load %list_Node*, %list_Node** %13
	%15 = bitcast %list_Node* %14 to %list_Node*
	store %list_Node* %15, %list_Node** %11
	%16 = bitcast %Int32 %pos to %Int32
	%17 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%18 = load %Int32, %Int32* %17
	%19 = icmp ugt %Int32 %16, %18
	br %Bool %19 , label %then_2, label %endif_2
then_2:
	%20 = bitcast i8* null to %list_Node*
	ret %list_Node* %20
	br label %endif_2
endif_2:
	%22 = alloca %Int32, align 4
	store %Int32 0, %Int32* %22
	br label %again_1
again_1:
	%23 = load %Int32, %Int32* %22
	%24 = icmp ult %Int32 %23, %16
	br %Bool %24 , label %body_1, label %break_1
body_1:
	%25 = load %list_Node*, %list_Node** %11
	%26 = getelementptr inbounds %list_Node, %list_Node* %25, %Int32 0, %Int32 0
	%27 = load %list_Node*, %list_Node** %26
	%28 = bitcast %list_Node* %27 to %list_Node*
	store %list_Node* %28, %list_Node** %11
	%29 = load %Int32, %Int32* %22
	%30 = add %Int32 %29, 1
	store %Int32 %30, %Int32* %22
	br label %again_1
break_1:
	br label %endif_1
else_1:
	; go backward
	%31 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 1
	%32 = load %list_Node*, %list_Node** %31
	%33 = bitcast %list_Node* %32 to %list_Node*
	store %list_Node* %33, %list_Node** %11
	%34 = sub %Int32 0, %pos
	%35 = bitcast %Int32 %34 to %Int32
	%36 = sub %Int32 %35, 1
	%37 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%38 = load %Int32, %Int32* %37
	%39 = icmp ugt %Int32 %36, %38
	br %Bool %39 , label %then_3, label %endif_3
then_3:
	%40 = bitcast i8* null to %list_Node*
	ret %list_Node* %40
	br label %endif_3
endif_3:
	%42 = alloca %Int32, align 4
	store %Int32 0, %Int32* %42
	br label %again_2
again_2:
	%43 = load %Int32, %Int32* %42
	%44 = icmp ult %Int32 %43, %36
	br %Bool %44 , label %body_2, label %break_2
body_2:
	%45 = load %list_Node*, %list_Node** %11
	%46 = getelementptr inbounds %list_Node, %list_Node* %45, %Int32 0, %Int32 1
	%47 = load %list_Node*, %list_Node** %46
	%48 = bitcast %list_Node* %47 to %list_Node*
	store %list_Node* %48, %list_Node** %11
	%49 = load %Int32, %Int32* %42
	%50 = add %Int32 %49, 1
	store %Int32 %50, %Int32* %42
	br label %again_2
break_2:
	br label %endif_1
endif_1:
	%51 = load %list_Node*, %list_Node** %11
	%52 = bitcast %list_Node* %51 to %list_Node*
	ret %list_Node* %52
}

define %list_Node* @list_node_insert(%list_List* %list, %Int32 %pos, %list_Node* %new_node) {
	%1 = bitcast %list_List* %list to %list_List*
	%2 = bitcast i8* null to %list_List*
	%3 = icmp eq %list_List* %1, %2
	%4 = bitcast %list_Node* %new_node to %list_Node*
	%5 = bitcast i8* null to %list_Node*
	%6 = icmp eq %list_Node* %4, %5
	%7 = or %Bool %3, %6
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	%8 = bitcast i8* null to %list_Node*
	ret %list_Node* %8
	br label %endif_0
endif_0:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str3 to [0 x i8]*), %Int32 %pos)
	%11 = bitcast %list_List* %list to %list_List*
	%12 = call %list_Node* @list_node_get(%list_List* %11, %Int32 %pos)
	%13 = bitcast %list_Node* %12 to %list_Node*
	%14 = bitcast i8* null to %list_Node*
	%15 = icmp eq %list_Node* %13, %14
	br %Bool %15 , label %then_1, label %endif_1
then_1:
	%16 = bitcast i8* null to %list_Node*
	ret %list_Node* %16
	br label %endif_1
endif_1:
	%18 = bitcast %list_Node* %12 to %list_Node*
	%19 = call %list_Node* @list_node_prev_get(%list_Node* %18)
	%20 = bitcast %list_Node* %19 to %list_Node*
	%21 = bitcast i8* null to %list_Node*
	%22 = icmp eq %list_Node* %20, %21
	br %Bool %22 , label %then_2, label %endif_2
then_2:
	%23 = bitcast i8* null to %list_Node*
	ret %list_Node* %23
	br label %endif_2
endif_2:
	%25 = bitcast %list_Node* %19 to %list_Node*
	%26 = bitcast %list_Node* %new_node to %list_Node*
	call void @list_node_insert_right(%list_Node* %25, %list_Node* %26)
	%27 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%28 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%29 = load %Int32, %Int32* %28
	%30 = add %Int32 %29, 1
	store %Int32 %30, %Int32* %27
	%31 = bitcast %list_Node* %new_node to %list_Node*
	ret %list_Node* %31
}

define %list_Node* @list_node_append(%list_List* %list, %list_Node* %new_node) {
	%1 = bitcast %list_List* %list to %list_List*
	%2 = bitcast i8* null to %list_List*
	%3 = icmp eq %list_List* %1, %2
	%4 = bitcast %list_Node* %new_node to %list_Node*
	%5 = bitcast i8* null to %list_Node*
	%6 = icmp eq %list_Node* %4, %5
	%7 = or %Bool %3, %6
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	%8 = bitcast i8* null to %list_Node*
	ret %list_Node* %8
	br label %endif_0
endif_0:
	%10 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 1
	%11 = load %list_Node*, %list_Node** %10
	%12 = bitcast %list_Node* %11 to %list_Node*
	%13 = bitcast i8* null to %list_Node*
	%14 = icmp eq %list_Node* %12, %13
	br %Bool %14 , label %then_1, label %else_1
then_1:
	%15 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 0
	%16 = bitcast %list_Node* %new_node to %list_Node*
	store %list_Node* %16, %list_Node** %15
	br label %endif_1
else_1:
	%17 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 1
	%18 = load %list_Node*, %list_Node** %17
	%19 = bitcast %list_Node* %18 to %list_Node*
	%20 = bitcast %list_Node* %new_node to %list_Node*
	call void @list_node_insert_right(%list_Node* %19, %list_Node* %20)
	br label %endif_1
endif_1:
	%21 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 1
	%22 = bitcast %list_Node* %new_node to %list_Node*
	store %list_Node* %22, %list_Node** %21
	%23 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%24 = getelementptr inbounds %list_List, %list_List* %list, %Int32 0, %Int32 2
	%25 = load %Int32, %Int32* %24
	%26 = add %Int32 %25, 1
	store %Int32 %26, %Int32* %23
	%27 = bitcast %list_Node* %new_node to %list_Node*
	ret %list_Node* %27
}

define %list_Node* @list_insert(%list_List* %list, %Int32 %pos, i8* %data) {
	%1 = call %list_Node* @list_node_create()
	%2 = bitcast %list_Node* %1 to %list_Node*
	%3 = bitcast i8* null to %list_Node*
	%4 = icmp eq %list_Node* %2, %3
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = bitcast i8* null to %list_Node*
	ret %list_Node* %5
	br label %endif_0
endif_0:
	%7 = getelementptr inbounds %list_Node, %list_Node* %1, %Int32 0, %Int32 2
	store i8* %data, i8** %7
	%8 = bitcast %list_List* %list to %list_List*
	%9 = bitcast %list_Node* %1 to %list_Node*
	%10 = call %list_Node* @list_node_insert(%list_List* %8, %Int32 %pos, %list_Node* %9)
	%11 = bitcast %list_Node* %10 to %list_Node*
	ret %list_Node* %11
}

define %list_Node* @list_append(%list_List* %list, i8* %data) {
	%1 = bitcast %list_List* %list to %list_List*
	%2 = bitcast i8* null to %list_List*
	%3 = icmp eq %list_List* %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = bitcast i8* null to %list_Node*
	ret %list_Node* %4
	br label %endif_0
endif_0:
	%6 = call %list_Node* @list_node_create()
	%7 = bitcast %list_Node* %6 to %list_Node*
	%8 = bitcast i8* null to %list_Node*
	%9 = icmp eq %list_Node* %7, %8
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = bitcast i8* null to %list_Node*
	ret %list_Node* %10
	br label %endif_1
endif_1:
	%12 = getelementptr inbounds %list_Node, %list_Node* %6, %Int32 0, %Int32 2
	store i8* %data, i8** %12
	%13 = bitcast %list_List* %list to %list_List*
	%14 = bitcast %list_Node* %6 to %list_Node*
	%15 = call %list_Node* @list_node_append(%list_List* %13, %list_Node* %14)
	%16 = bitcast %list_Node* %15 to %list_Node*
	%17 = bitcast i8* null to %list_Node*
	%18 = icmp eq %list_Node* %16, %17
	br %Bool %18 , label %then_2, label %endif_2
then_2:
	%19 = bitcast %list_Node* %6 to i8*
	call void @free(i8* %19)
	br label %endif_2
endif_2:
	%20 = bitcast %list_Node* %15 to %list_Node*
	ret %list_Node* %20
}


