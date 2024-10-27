
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8;
%Char = type i8;
%ConstChar = type i8;
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%SocklenT = type i32;
%SizeT = type i64;
%SSizeT = type i64;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdlib.hm



declare void @abort()
declare i32 @abs(i32 %x)
declare i32 @atexit(void ()* %x)
declare double @atof([0 x i8]* %nptr)
declare i32 @atoi([0 x i8]* %nptr)
declare i64 @atol([0 x i8]* %nptr)
declare i8* @calloc(i64 %num, i64 %size)
declare void @exit(i32 %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare i64 @labs(i64 %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(i64 %size)
declare i32 @system([0 x i8]* %string)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str;
%ConstCharStr = type %CharStr;


declare i32 @fclose(%File* %f)
declare i32 @feof(%File* %f)
declare i32 @ferror(%File* %f)
declare i32 @fflush(%File* %f)
declare i32 @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %File* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare i32 @fseek(%File* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%File* %f, %FposT* %pos)
declare i64 @ftell(%File* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare i32 @setvbuf(%File* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%File* %stream, %Str* %format, ...)
declare i32 @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare i32 @vprintf(%ConstCharStr* %format, i8* %args)
declare i32 @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare i32 @vsnprintf(%CharStr* %str, i64 %n, %ConstCharStr* %format, i8* %args)
declare i32 @__vsnprintf_chk(%CharStr* %dest, i64 %len, i32 %flags, i64 %dstlen, %ConstCharStr* %format, i8* %arg)
declare i32 @fgetc(%File* %f)
declare i32 @fputc(i32 %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %File* %f)
declare i32 @fputs(%ConstCharStr* %str, %File* %f)
declare i32 @getc(%File* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %File* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %File* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: /Users/alexbalan/p/Modest/examples/8.linked_list/src/linked_list.hm




; -- SOURCE: src/linked_list.cm

@str1 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 105, i8 110, i8 115, i8 101, i8 114, i8 116, i8 95, i8 114, i8 105, i8 103, i8 104, i8 116, i8 10, i8 0]
@str2 = private constant [26 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 95, i8 108, i8 105, i8 115, i8 116, i8 95, i8 110, i8 111, i8 100, i8 101, i8 95, i8 103, i8 101, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
@str3 = private constant [29 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 95, i8 108, i8 105, i8 115, i8 116, i8 95, i8 110, i8 111, i8 100, i8 101, i8 95, i8 105, i8 110, i8 115, i8 101, i8 114, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]



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


define %List* @linked_list_create() {
	%1 = call i8* @malloc(i64 24)
	%2 = bitcast i8* %1 to %List*
	%3 = icmp eq %List* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %List* null
	br label %endif_0
endif_0:
	store %List zeroinitializer, %List* %2
	%5 = bitcast %List* %2 to %List*
	ret %List* %5
}

define i32 @linked_list_size_get(%List* %list) {
	%1 = icmp eq %List* %list, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret i32 0
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%4 = load i32, i32* %3
	ret i32 %4
}

define %Node* @linked_list_first_node_get(%List* %list) {
	%1 = icmp eq %List* %list, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%4 = load %Node*, %Node** %3
	%5 = bitcast %Node* %4 to %Node*
	ret %Node* %5
}

define %Node* @linked_list_last_node_get(%List* %list) {
	%1 = icmp eq %List* %list, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%4 = load %Node*, %Node** %3
	%5 = bitcast %Node* %4 to %Node*
	ret %Node* %5
}

define %Node* @linked_list_node_first(%List* %list, %Node* %new_node) {
	%1 = icmp eq %List* %list, null
	%2 = icmp eq %Node* %new_node, null
	%3 = or i1 %1, %2
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%6 = bitcast %Node* %new_node to %Node*
	store %Node* %6, %Node** %5
	%7 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%8 = bitcast %Node* %new_node to %Node*
	store %Node* %8, %Node** %7
	%9 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%10 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%11 = load i32, i32* %10
	%12 = add i32 %11, 1
	store i32 %12, i32* %9
	%13 = bitcast %Node* %new_node to %Node*
	ret %Node* %13
}

define %Node* @linked_list_node_create() {
	%1 = call i8* @malloc(i64 24)
	%2 = bitcast i8* %1 to %Node*
	%3 = icmp eq %Node* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	store %Node zeroinitializer, %Node* %2
	%5 = bitcast %Node* %2 to %Node*
	ret %Node* %5
}

define %Node* @linked_list_node_next_get(%Node* %node) {
	%1 = icmp eq %Node* %node, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 0
	%4 = load %Node*, %Node** %3
	%5 = bitcast %Node* %4 to %Node*
	ret %Node* %5
}

define %Node* @linked_list_node_prev_get(%Node* %node) {
	%1 = icmp eq %Node* %node, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 1
	%4 = load %Node*, %Node** %3
	%5 = bitcast %Node* %4 to %Node*
	ret %Node* %5
}

define i8* @linked_list_node_data_get(%Node* %node) {
	%1 = icmp eq %Node* %node, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret i8* null
	br label %endif_0
endif_0:
	%3 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 2
	%4 = load i8*, i8** %3
	ret i8* %4
}

define void @node_insert_right(%Node* %left, %Node* %new_right) {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*))
	%2 = getelementptr inbounds %Node, %Node* %left, i32 0, i32 0
	%3 = load %Node*, %Node** %2
	%4 = getelementptr inbounds %Node, %Node* %left, i32 0, i32 0
	%5 = bitcast %Node* %new_right to %Node*
	store %Node* %5, %Node** %4
	%6 = icmp ne %Node* %3, null
	br i1 %6 , label %then_0, label %endif_0
then_0:
	%7 = getelementptr inbounds %Node, %Node* %3, i32 0, i32 1
	%8 = bitcast %Node* %new_right to %Node*
	store %Node* %8, %Node** %7
	br label %endif_0
endif_0:
	%9 = getelementptr inbounds %Node, %Node* %new_right, i32 0, i32 0
	%10 = bitcast %Node* %3 to %Node*
	store %Node* %10, %Node** %9
	%11 = getelementptr inbounds %Node, %Node* %new_right, i32 0, i32 1
	%12 = bitcast %Node* %left to %Node*
	store %Node* %12, %Node** %11
	ret void
}



define %Node* @linked_list_node_get(%List* %list, i32 %pos) {
	%1 = icmp eq %List* %list, null
	%2 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%3 = load i32, i32* %2
	%4 = icmp eq i32 %3, 0
	%5 = or i1 %1, %4
	br i1 %5 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%7 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str2 to [0 x i8]*), i32 %pos)
	%8 = alloca %Node*, align 8
	%9 = icmp sge i32 %pos, 0
	br i1 %9 , label %then_1, label %else_1
then_1:
	; go forward
	%10 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%11 = load %Node*, %Node** %10
	%12 = bitcast %Node* %11 to %Node*
	store %Node* %12, %Node** %8
	%13 = bitcast i32 %pos to i32
	%14 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%15 = load i32, i32* %14
	%16 = icmp ugt i32 %13, %15
	br i1 %16 , label %then_2, label %endif_2
then_2:
	ret %Node* null
	br label %endif_2
endif_2:
	%18 = alloca i32, align 4
	store i32 0, i32* %18
	br label %again_1
again_1:
	%19 = load i32, i32* %18
	%20 = icmp ult i32 %19, %13
	br i1 %20 , label %body_1, label %break_1
body_1:
	%21 = load %Node*, %Node** %8
	%22 = getelementptr inbounds %Node, %Node* %21, i32 0, i32 0
	%23 = load %Node*, %Node** %22
	%24 = bitcast %Node* %23 to %Node*
	store %Node* %24, %Node** %8
	%25 = load i32, i32* %18
	%26 = add i32 %25, 1
	store i32 %26, i32* %18
	br label %again_1
break_1:
	br label %endif_1
else_1:
	; go backward
	%27 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%28 = load %Node*, %Node** %27
	%29 = bitcast %Node* %28 to %Node*
	store %Node* %29, %Node** %8
	%30 = sub i32 0, %pos
	%31 = bitcast i32 %30 to i32
	%32 = sub i32 %31, 1
	%33 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%34 = load i32, i32* %33
	%35 = icmp ugt i32 %32, %34
	br i1 %35 , label %then_3, label %endif_3
then_3:
	ret %Node* null
	br label %endif_3
endif_3:
	%37 = alloca i32, align 4
	store i32 0, i32* %37
	br label %again_2
again_2:
	%38 = load i32, i32* %37
	%39 = icmp ult i32 %38, %32
	br i1 %39 , label %body_2, label %break_2
body_2:
	%40 = load %Node*, %Node** %8
	%41 = getelementptr inbounds %Node, %Node* %40, i32 0, i32 1
	%42 = load %Node*, %Node** %41
	%43 = bitcast %Node* %42 to %Node*
	store %Node* %43, %Node** %8
	%44 = load i32, i32* %37
	%45 = add i32 %44, 1
	store i32 %45, i32* %37
	br label %again_2
break_2:
	br label %endif_1
endif_1:
	%46 = load %Node*, %Node** %8
	%47 = bitcast %Node* %46 to %Node*
	ret %Node* %47
}

define %Node* @linked_list_node_insert(%List* %list, i32 %pos, %Node* %new_node) {
	%1 = icmp eq %List* %list, null
	%2 = icmp eq %Node* %new_node, null
	%3 = or i1 %1, %2
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%5 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str3 to [0 x i8]*), i32 %pos)
	%6 = bitcast %List* %list to %List*
	%7 = call %Node* @linked_list_node_get(%List* %6, i32 %pos)
	%8 = icmp eq %Node* %7, null
	br i1 %8 , label %then_1, label %endif_1
then_1:
	ret %Node* null
	br label %endif_1
endif_1:
	%10 = bitcast %Node* %7 to %Node*
	%11 = call %Node* @linked_list_node_prev_get(%Node* %10)
	%12 = icmp eq %Node* %11, null
	br i1 %12 , label %then_2, label %endif_2
then_2:
	ret %Node* null
	br label %endif_2
endif_2:
	%14 = bitcast %Node* %11 to %Node*
	%15 = bitcast %Node* %new_node to %Node*
	call void @node_insert_right(%Node* %14, %Node* %15)
	%16 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%17 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%18 = load i32, i32* %17
	%19 = add i32 %18, 1
	store i32 %19, i32* %16
	%20 = bitcast %Node* %new_node to %Node*
	ret %Node* %20
}

define %Node* @linked_list_node_append(%List* %list, %Node* %new_node) {
	%1 = icmp eq %List* %list, null
	%2 = icmp eq %Node* %new_node, null
	%3 = or i1 %1, %2
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%6 = load %Node*, %Node** %5
	%7 = icmp eq %Node* %6, null
	br i1 %7 , label %then_1, label %else_1
then_1:
	%8 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%9 = bitcast %Node* %new_node to %Node*
	store %Node* %9, %Node** %8
	br label %endif_1
else_1:
	%10 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%11 = load %Node*, %Node** %10
	%12 = bitcast %Node* %11 to %Node*
	%13 = bitcast %Node* %new_node to %Node*
	call void @node_insert_right(%Node* %12, %Node* %13)
	br label %endif_1
endif_1:
	%14 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%15 = bitcast %Node* %new_node to %Node*
	store %Node* %15, %Node** %14
	%16 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%17 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%18 = load i32, i32* %17
	%19 = add i32 %18, 1
	store i32 %19, i32* %16
	%20 = bitcast %Node* %new_node to %Node*
	ret %Node* %20
}

define %Node* @linked_list_insert(%List* %list, i32 %pos, i8* %data) {
	%1 = call %Node* @linked_list_node_create()
	%2 = icmp eq %Node* %1, null
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %Node, %Node* %1, i32 0, i32 2
	store i8* %data, i8** %4
	%5 = bitcast %List* %list to %List*
	%6 = bitcast %Node* %1 to %Node*
	%7 = call %Node* @linked_list_node_insert(%List* %5, i32 %pos, %Node* %6)
	%8 = bitcast %Node* %7 to %Node*
	ret %Node* %8
}

define %Node* @linked_list_append(%List* %list, i8* %data) {
	%1 = icmp eq %List* %list, null
	br i1 %1 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%3 = call %Node* @linked_list_node_create()
	%4 = icmp eq %Node* %3, null
	br i1 %4 , label %then_1, label %endif_1
then_1:
	ret %Node* null
	br label %endif_1
endif_1:
	%6 = getelementptr inbounds %Node, %Node* %3, i32 0, i32 2
	store i8* %data, i8** %6
	%7 = bitcast %List* %list to %List*
	%8 = bitcast %Node* %3 to %Node*
	%9 = call %Node* @linked_list_node_append(%List* %7, %Node* %8)
	%10 = icmp eq %Node* %9, null
	br i1 %10 , label %then_2, label %endif_2
then_2:
	%11 = bitcast %Node* %3 to i8*
	call void @free(i8* %11)
	br label %endif_2
endif_2:
	%12 = bitcast %Node* %9 to %Node*
	ret %Node* %12
}


