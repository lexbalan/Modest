
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
	%3 = bitcast %List* %2 to %List*
	%4 = icmp eq %List* %3, null
	br i1 %4 , label %then_0, label %endif_0
then_0:
	ret %List* null
	br label %endif_0
endif_0:
	store %List zeroinitializer, %List* %2
	%6 = bitcast %List* %2 to %List*
	ret %List* %6
}

define i32 @linked_list_size_get(%List* %list) {
	%1 = bitcast %List* %list to %List*
	%2 = icmp eq %List* %1, null
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret i32 0
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%5 = load i32, i32* %4
	ret i32 %5
}

define %Node* @linked_list_first_node_get(%List* %list) {
	%1 = bitcast %List* %list to %List*
	%2 = icmp eq %List* %1, null
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%5 = load %Node*, %Node** %4
	%6 = bitcast %Node* %5 to %Node*
	ret %Node* %6
}

define %Node* @linked_list_last_node_get(%List* %list) {
	%1 = bitcast %List* %list to %List*
	%2 = icmp eq %List* %1, null
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%5 = load %Node*, %Node** %4
	%6 = bitcast %Node* %5 to %Node*
	ret %Node* %6
}

define %Node* @linked_list_node_first(%List* %list, %Node* %new_node) {
	%1 = bitcast %List* %list to %List*
	%2 = icmp eq %List* %1, null
	%3 = bitcast %Node* %new_node to %Node*
	%4 = icmp eq %Node* %3, null
	%5 = or i1 %2, %4
	br i1 %5 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%7 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%8 = bitcast %Node* %new_node to %Node*
	store %Node* %8, %Node** %7
	%9 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%10 = bitcast %Node* %new_node to %Node*
	store %Node* %10, %Node** %9
	%11 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%12 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%13 = load i32, i32* %12
	%14 = add i32 %13, 1
	store i32 %14, i32* %11
	%15 = bitcast %Node* %new_node to %Node*
	ret %Node* %15
}

define %Node* @linked_list_node_create() {
	%1 = call i8* @malloc(i64 24)
	%2 = bitcast i8* %1 to %Node*
	%3 = bitcast %Node* %2 to %Node*
	%4 = icmp eq %Node* %3, null
	br i1 %4 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	store %Node zeroinitializer, %Node* %2
	%6 = bitcast %Node* %2 to %Node*
	ret %Node* %6
}

define %Node* @linked_list_node_next_get(%Node* %node) {
	%1 = bitcast %Node* %node to %Node*
	%2 = icmp eq %Node* %1, null
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 0
	%5 = load %Node*, %Node** %4
	%6 = bitcast %Node* %5 to %Node*
	ret %Node* %6
}

define %Node* @linked_list_node_prev_get(%Node* %node) {
	%1 = bitcast %Node* %node to %Node*
	%2 = icmp eq %Node* %1, null
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 1
	%5 = load %Node*, %Node** %4
	%6 = bitcast %Node* %5 to %Node*
	ret %Node* %6
}

define i8* @linked_list_node_data_get(%Node* %node) {
	%1 = bitcast %Node* %node to %Node*
	%2 = icmp eq %Node* %1, null
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret i8* null
	br label %endif_0
endif_0:
	%4 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 2
	%5 = load i8*, i8** %4
	ret i8* %5
}

define void @node_insert_right(%Node* %left, %Node* %new_right) {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*))
	%2 = getelementptr inbounds %Node, %Node* %left, i32 0, i32 0
	%3 = load %Node*, %Node** %2
	%4 = getelementptr inbounds %Node, %Node* %left, i32 0, i32 0
	%5 = bitcast %Node* %new_right to %Node*
	store %Node* %5, %Node** %4
	%6 = bitcast %Node* %3 to %Node*
	%7 = icmp ne %Node* %6, null
	br i1 %7 , label %then_0, label %endif_0
then_0:
	%8 = getelementptr inbounds %Node, %Node* %3, i32 0, i32 1
	%9 = bitcast %Node* %new_right to %Node*
	store %Node* %9, %Node** %8
	br label %endif_0
endif_0:
	%10 = getelementptr inbounds %Node, %Node* %new_right, i32 0, i32 0
	%11 = bitcast %Node* %3 to %Node*
	store %Node* %11, %Node** %10
	%12 = getelementptr inbounds %Node, %Node* %new_right, i32 0, i32 1
	%13 = bitcast %Node* %left to %Node*
	store %Node* %13, %Node** %12
	ret void
}



define %Node* @linked_list_node_get(%List* %list, i32 %pos) {
	%1 = bitcast %List* %list to %List*
	%2 = icmp eq %List* %1, null
	%3 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%4 = load i32, i32* %3
	%5 = icmp eq i32 %4, 0
	%6 = or i1 %2, %5
	br i1 %6 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%8 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str2 to [0 x i8]*), i32 %pos)
	%9 = alloca %Node*, align 8
	%10 = icmp sge i32 %pos, 0
	br i1 %10 , label %then_1, label %else_1
then_1:
	; go forward
	%11 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%12 = load %Node*, %Node** %11
	%13 = bitcast %Node* %12 to %Node*
	store %Node* %13, %Node** %9
	%14 = bitcast i32 %pos to i32
	%15 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%16 = load i32, i32* %15
	%17 = icmp ugt i32 %14, %16
	br i1 %17 , label %then_2, label %endif_2
then_2:
	ret %Node* null
	br label %endif_2
endif_2:
	%19 = alloca i32, align 4
	store i32 0, i32* %19
	br label %again_1
again_1:
	%20 = load i32, i32* %19
	%21 = icmp ult i32 %20, %14
	br i1 %21 , label %body_1, label %break_1
body_1:
	%22 = load %Node*, %Node** %9
	%23 = getelementptr inbounds %Node, %Node* %22, i32 0, i32 0
	%24 = load %Node*, %Node** %23
	%25 = bitcast %Node* %24 to %Node*
	store %Node* %25, %Node** %9
	%26 = load i32, i32* %19
	%27 = add i32 %26, 1
	store i32 %27, i32* %19
	br label %again_1
break_1:
	br label %endif_1
else_1:
	; go backward
	%28 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%29 = load %Node*, %Node** %28
	%30 = bitcast %Node* %29 to %Node*
	store %Node* %30, %Node** %9
	%31 = sub i32 0, %pos
	%32 = bitcast i32 %31 to i32
	%33 = sub i32 %32, 1
	%34 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%35 = load i32, i32* %34
	%36 = icmp ugt i32 %33, %35
	br i1 %36 , label %then_3, label %endif_3
then_3:
	ret %Node* null
	br label %endif_3
endif_3:
	%38 = alloca i32, align 4
	store i32 0, i32* %38
	br label %again_2
again_2:
	%39 = load i32, i32* %38
	%40 = icmp ult i32 %39, %33
	br i1 %40 , label %body_2, label %break_2
body_2:
	%41 = load %Node*, %Node** %9
	%42 = getelementptr inbounds %Node, %Node* %41, i32 0, i32 1
	%43 = load %Node*, %Node** %42
	%44 = bitcast %Node* %43 to %Node*
	store %Node* %44, %Node** %9
	%45 = load i32, i32* %38
	%46 = add i32 %45, 1
	store i32 %46, i32* %38
	br label %again_2
break_2:
	br label %endif_1
endif_1:
	%47 = load %Node*, %Node** %9
	%48 = bitcast %Node* %47 to %Node*
	ret %Node* %48
}

define %Node* @linked_list_node_insert(%List* %list, i32 %pos, %Node* %new_node) {
	%1 = bitcast %List* %list to %List*
	%2 = icmp eq %List* %1, null
	%3 = bitcast %Node* %new_node to %Node*
	%4 = icmp eq %Node* %3, null
	%5 = or i1 %2, %4
	br i1 %5 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%7 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str3 to [0 x i8]*), i32 %pos)
	%8 = bitcast %List* %list to %List*
	%9 = call %Node* @linked_list_node_get(%List* %8, i32 %pos)
	%10 = bitcast %Node* %9 to %Node*
	%11 = icmp eq %Node* %10, null
	br i1 %11 , label %then_1, label %endif_1
then_1:
	ret %Node* null
	br label %endif_1
endif_1:
	%13 = bitcast %Node* %9 to %Node*
	%14 = call %Node* @linked_list_node_prev_get(%Node* %13)
	%15 = bitcast %Node* %14 to %Node*
	%16 = icmp eq %Node* %15, null
	br i1 %16 , label %then_2, label %endif_2
then_2:
	ret %Node* null
	br label %endif_2
endif_2:
	%18 = bitcast %Node* %14 to %Node*
	%19 = bitcast %Node* %new_node to %Node*
	call void @node_insert_right(%Node* %18, %Node* %19)
	%20 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%21 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%22 = load i32, i32* %21
	%23 = add i32 %22, 1
	store i32 %23, i32* %20
	%24 = bitcast %Node* %new_node to %Node*
	ret %Node* %24
}

define %Node* @linked_list_node_append(%List* %list, %Node* %new_node) {
	%1 = bitcast %List* %list to %List*
	%2 = icmp eq %List* %1, null
	%3 = bitcast %Node* %new_node to %Node*
	%4 = icmp eq %Node* %3, null
	%5 = or i1 %2, %4
	br i1 %5 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%7 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%8 = load %Node*, %Node** %7
	%9 = bitcast %Node* %8 to %Node*
	%10 = icmp eq %Node* %9, null
	br i1 %10 , label %then_1, label %else_1
then_1:
	%11 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
	%12 = bitcast %Node* %new_node to %Node*
	store %Node* %12, %Node** %11
	br label %endif_1
else_1:
	%13 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%14 = load %Node*, %Node** %13
	%15 = bitcast %Node* %14 to %Node*
	%16 = bitcast %Node* %new_node to %Node*
	call void @node_insert_right(%Node* %15, %Node* %16)
	br label %endif_1
endif_1:
	%17 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
	%18 = bitcast %Node* %new_node to %Node*
	store %Node* %18, %Node** %17
	%19 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%20 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
	%21 = load i32, i32* %20
	%22 = add i32 %21, 1
	store i32 %22, i32* %19
	%23 = bitcast %Node* %new_node to %Node*
	ret %Node* %23
}

define %Node* @linked_list_insert(%List* %list, i32 %pos, i8* %data) {
	%1 = call %Node* @linked_list_node_create()
	%2 = bitcast %Node* %1 to %Node*
	%3 = icmp eq %Node* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%5 = getelementptr inbounds %Node, %Node* %1, i32 0, i32 2
	store i8* %data, i8** %5
	%6 = bitcast %List* %list to %List*
	%7 = bitcast %Node* %1 to %Node*
	%8 = call %Node* @linked_list_node_insert(%List* %6, i32 %pos, %Node* %7)
	%9 = bitcast %Node* %8 to %Node*
	ret %Node* %9
}

define %Node* @linked_list_append(%List* %list, i8* %data) {
	%1 = bitcast %List* %list to %List*
	%2 = icmp eq %List* %1, null
	br i1 %2 , label %then_0, label %endif_0
then_0:
	ret %Node* null
	br label %endif_0
endif_0:
	%4 = call %Node* @linked_list_node_create()
	%5 = bitcast %Node* %4 to %Node*
	%6 = icmp eq %Node* %5, null
	br i1 %6 , label %then_1, label %endif_1
then_1:
	ret %Node* null
	br label %endif_1
endif_1:
	%8 = getelementptr inbounds %Node, %Node* %4, i32 0, i32 2
	store i8* %data, i8** %8
	%9 = bitcast %List* %list to %List*
	%10 = bitcast %Node* %4 to %Node*
	%11 = call %Node* @linked_list_node_append(%List* %9, %Node* %10)
	%12 = bitcast %Node* %11 to %Node*
	%13 = icmp eq %Node* %12, null
	br i1 %13 , label %then_2, label %endif_2
then_2:
	%14 = bitcast %Node* %4 to i8*
	call void @free(i8* %14)
	br label %endif_2
endif_2:
	%15 = bitcast %Node* %11 to %Node*
	ret %Node* %15
}


