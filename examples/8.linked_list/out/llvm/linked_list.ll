
target triple = "arm64-apple-darwin21.6.0"

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Char = type i8
%ConstChar = type i8
%SignedChar = type i8
%UnsignedChar = type i8
%Short = type i16
%UnsignedShort = type i16
%Int = type i32
%UnsignedInt = type i32
%LongInt = type i64
%UnsignedLongInt = type i64
%Long = type i64
%UnsignedLong = type i64
%LongLong = type i64
%UnsignedLongLong = type i64
%LongLongInt = type i64
%UnsignedLongLongInt = type i64
%Float = type double
%Double = type double
%LongDouble = type double
%SizeT = type i64
%SSizeT = type i64

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%OffT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(i64)
declare i8* @memset(i8*, i32, i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @memcmp(i8*, i8*, i64)
declare void @free(i8*)
declare i32 @strncmp(i8*, i8*, i64)
declare i32 @strcmp(i8*, i8*)
declare i8* @strcpy(i8*, i8*)
declare i64 @strlen(i8*)


declare i32 @ftruncate(i32, i32)
















declare i32 @creat([0 x i8]*, i32)
declare i32 @open([0 x i8]*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir([0 x i8]*)
declare i32 @closedir(%DIR*)


declare [0 x i8]* @getcwd([0 x i8]*, i64)
declare [0 x i8]* @getenv([0 x i8]*)

; -- MODULE: /Users/alexbalan/p/Modest/examples/8.linked_list/src/linked_list.hm



; -- MODULE: /Users/alexbalan/p/Modest/examples/8.linked_list/src/linked_list.cm




%Node = type {
	%Node*,
	%Node*,
	i8*
}

%List = type {
	%Node*,
	%Node*,
	i32
}


define %List* @linked_list_create() {
  %1 = call i8*(i64) @malloc (i64 0)
  %2 = bitcast i8* %1 to %List*
  %3 = call i8*(i64) @malloc (i64 0)
  %4 = bitcast i8* %3 to %List*
  %5 = icmp eq %List* %4, null
  br i1 %5 , label %then_0, label %endif_0
then_0:
  ret %List* null
  br label %endif_0
endif_0:
;list.size >= list.head
  %7 = call i8*(i64) @malloc (i64 0)
  %8 = bitcast i8* %7 to %List*
  %9 = getelementptr inbounds %List, %List* %8, i32 0, i32 0
  store %Node* null, %Node** %9
  %10 = call i8*(i64) @malloc (i64 0)
  %11 = bitcast i8* %10 to %List*
  %12 = getelementptr inbounds %List, %List* %11, i32 0, i32 1
  store %Node* null, %Node** %12
  %13 = call i8*(i64) @malloc (i64 0)
  %14 = bitcast i8* %13 to %List*
  ret %List* %14
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

define %Node* @linked_list_first_get(%List* %list) {
  %1 = icmp eq %List* %list, null
  br i1 %1 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %3 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
  %4 = load %Node*, %Node** %3
  ret %Node* %4
}

define %Node* @linked_list_last_get(%List* %list) {
  %1 = icmp eq %List* %list, null
  br i1 %1 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %3 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  %4 = load %Node*, %Node** %3
  ret %Node* %4
}

define %Node* @linked_list_node_create() {
  %1 = call i8*(i64) @malloc (i64 0)
  %2 = bitcast i8* %1 to %Node*
  %3 = call i8*(i64) @malloc (i64 0)
  %4 = bitcast i8* %3 to %Node*
  %5 = icmp eq %Node* %4, null
  br i1 %5 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %7 = call i8*(i64) @malloc (i64 0)
  %8 = bitcast i8* %7 to %Node*
  %9 = getelementptr inbounds %Node, %Node* %8, i32 0, i32 1
  store %Node* null, %Node** %9
  %10 = call i8*(i64) @malloc (i64 0)
  %11 = bitcast i8* %10 to %Node*
  %12 = getelementptr inbounds %Node, %Node* %11, i32 0, i32 0
  store %Node* null, %Node** %12
  %13 = call i8*(i64) @malloc (i64 0)
  %14 = bitcast i8* %13 to %Node*
  %15 = getelementptr inbounds %Node, %Node* %14, i32 0, i32 2
  store i8* null, i8** %15
  %16 = call i8*(i64) @malloc (i64 0)
  %17 = bitcast i8* %16 to %Node*
  ret %Node* %17
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
  ret %Node* %4
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
  ret %Node* %4
}

define i8* @linked_list_node_link_get(%Node* %node) {
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

define %Node* @linked_list_insert_node(%List* %list, %Node* %new_node) {
  %1 = icmp eq %List* %list, null
  %2 = icmp eq %Node* %new_node, null
  %3 = or i1 %1, %2
  br i1 %3 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %5 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
  %6 = load %Node*, %Node** %5
  %7 = icmp eq %Node* %6, null
  br i1 %7 , label %then_1, label %endif_1
then_1:
  %8 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
  store %Node* %new_node, %Node** %8
  br label %endif_1
endif_1:
  %9 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  %10 = load %Node*, %Node** %9
  %11 = icmp ne %Node* %10, null
  br i1 %11 , label %then_2, label %endif_2
then_2:
  %12 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  %13 = load %Node*, %Node** %12
  %14 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  %15 = load %Node*, %Node** %14
  %16 = getelementptr inbounds %Node, %Node* %15, i32 0, i32 0
  store %Node* %new_node, %Node** %16
  %17 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  %18 = load %Node*, %Node** %17
  %19 = getelementptr inbounds %Node, %Node* %new_node, i32 0, i32 1
  store %Node* %18, %Node** %19
  br label %endif_2
endif_2:
  %20 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  store %Node* %new_node, %Node** %20
  %21 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
  %22 = load i32, i32* %21
  %23 = add i32 %22, 1
  %24 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
  store i32 %23, i32* %24
  ret %Node* %new_node
}

define %Node* @linked_list_insert(%List* %list, i8* %link) {
  %1 = icmp eq %List* %list, null
  br i1 %1 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %3 = call %Node*() @linked_list_node_create ()
  %4 = call %Node*() @linked_list_node_create ()
  %5 = icmp eq %Node* %4, null
  br i1 %5 , label %then_1, label %endif_1
then_1:
  ret %Node* null
  br label %endif_1
endif_1:
  %7 = call %Node*() @linked_list_node_create ()
  %8 = getelementptr inbounds %Node, %Node* %7, i32 0, i32 2
  store i8* %link, i8** %8
  %9 = call %Node*() @linked_list_node_create ()
  %10 = call %Node*(%List*, %Node*) @linked_list_insert_node (%List* %list, %Node* %9)
  %11 = call %Node*() @linked_list_node_create ()
  %12 = call %Node*(%List*, %Node*) @linked_list_insert_node (%List* %list, %Node* %11)
  %13 = icmp eq %Node* %12, null
  br i1 %13 , label %then_2, label %endif_2
then_2:
  %14 = call %Node*() @linked_list_node_create ()
  %15 = bitcast %Node* %14 to i8*
  call void(i8*) @free (i8* %15)
  br label %endif_2
endif_2:
  %16 = call %Node*() @linked_list_node_create ()
  %17 = call %Node*(%List*, %Node*) @linked_list_insert_node (%List* %list, %Node* %16)
  ret %Node* %17
}


