; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Char = type i8
%ConstChar = type %Char
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
declare i8* @malloc(%SizeT)
declare i8* @memset(i8*, %Int, %SizeT)
declare i8* @memcpy(i8*, i8*, %SizeT)
declare %Int @memcmp(i8*, i8*, %SizeT)
declare void @free(i8*)
declare %Int @strncmp(%ConstChar*, %ConstChar*, %SizeT)
declare %Int @strcmp(%ConstChar*, %ConstChar*)
declare %Char* @strcpy(%Char*, %ConstChar*)
declare %SizeT @strlen(%ConstChar*)


declare %Int @ftruncate(%Int, %OffT)















declare %Int @creat([0 x i8]*, %ModeT)
declare %Int @open([0 x i8]*, %Int)
declare %Int @read(%Int, i8*, i32)
declare %Int @write(%Int, i8*, i32)
declare %OffT @lseek(%Int, %OffT, %Int)
declare %Int @close(%Int)
declare void @exit(%Int)


declare %DIR* @opendir([0 x i8]*)
declare %Int @closedir(%DIR*)


declare [0 x i8]* @getcwd([0 x i8]*, %SizeT)
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
  %1 = call i8*(%SizeT) @malloc (%SizeT 0)
  %2 = bitcast i8* %1 to %List*
  %3 = bitcast %List* %2 to i8*
  %4 = icmp eq i8* %3, null
  br i1 %4 , label %then_0, label %endif_0
then_0:
  ret %List* null
  br label %endif_0
endif_0:
  %6 = getelementptr inbounds %List, %List* %2, i32 0, i32 0
  store %Node* null, %Node** %6
  %7 = getelementptr inbounds %List, %List* %2, i32 0, i32 1
  store %Node* null, %Node** %7
  ret %List* %2
}

define i32 @linked_list_size_get(%List* %list) {
  %1 = bitcast %List* %list to i8*
  %2 = icmp eq i8* %1, null
  br i1 %2 , label %then_0, label %endif_0
then_0:
  ret i32 0
  br label %endif_0
endif_0:
  %4 = getelementptr inbounds %List, %List* %list, i32 0, i32 2
  %5 = load i32, i32* %4
  ret i32 %5
}

define %Node* @linked_list_first_get(%List* %list) {
  %1 = bitcast %List* %list to i8*
  %2 = icmp eq i8* %1, null
  br i1 %2 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %4 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
  %5 = load %Node*, %Node** %4
  ret %Node* %5
}

define %Node* @linked_list_last_get(%List* %list) {
  %1 = bitcast %List* %list to i8*
  %2 = icmp eq i8* %1, null
  br i1 %2 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %4 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  %5 = load %Node*, %Node** %4
  ret %Node* %5
}

define %Node* @linked_list_node_create() {
  %1 = call i8*(%SizeT) @malloc (%SizeT 0)
  %2 = bitcast i8* %1 to %Node*
  %3 = bitcast %Node* %2 to i8*
  %4 = icmp eq i8* %3, null
  br i1 %4 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %6 = getelementptr inbounds %Node, %Node* %2, i32 0, i32 1
  store %Node* null, %Node** %6
  %7 = getelementptr inbounds %Node, %Node* %2, i32 0, i32 0
  store %Node* null, %Node** %7
  %8 = getelementptr inbounds %Node, %Node* %2, i32 0, i32 2
  store i8* null, i8** %8
  ret %Node* %2
}

define %Node* @linked_list_node_next_get(%Node* %node) {
  %1 = bitcast %Node* %node to i8*
  %2 = icmp eq i8* %1, null
  br i1 %2 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %4 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 0
  %5 = load %Node*, %Node** %4
  ret %Node* %5
}

define %Node* @linked_list_node_prev_get(%Node* %node) {
  %1 = bitcast %Node* %node to i8*
  %2 = icmp eq i8* %1, null
  br i1 %2 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %4 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 1
  %5 = load %Node*, %Node** %4
  ret %Node* %5
}

define i8* @linked_list_node_link_get(%Node* %node) {
  %1 = bitcast %Node* %node to i8*
  %2 = icmp eq i8* %1, null
  br i1 %2 , label %then_0, label %endif_0
then_0:
  ret i8* null
  br label %endif_0
endif_0:
  %4 = getelementptr inbounds %Node, %Node* %node, i32 0, i32 2
  %5 = load i8*, i8** %4
  %6 = bitcast i8* %5 to i8*
  ret i8* %6
}

define %Node* @linked_list_insert_node(%List* %list, %Node* %new_node) {
  %1 = bitcast %List* %list to i8*
  %2 = icmp eq i8* %1, null
  %3 = bitcast %Node* %new_node to i8*
  %4 = icmp eq i8* %3, null
  %5 = or i1 %2, %4
  br i1 %5 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %7 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
  %8 = load %Node*, %Node** %7
  %9 = bitcast %Node* %8 to i8*
  %10 = icmp eq i8* %9, null
  br i1 %10 , label %then_1, label %endif_1
then_1:
  %11 = getelementptr inbounds %List, %List* %list, i32 0, i32 0
  store %Node* %new_node, %Node** %11
  br label %endif_1
endif_1:
  %12 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  %13 = load %Node*, %Node** %12
  %14 = bitcast %Node* %13 to i8*
  %15 = icmp ne i8* %14, null
  br i1 %15 , label %then_2, label %endif_2
then_2:
  %16 = getelementptr inbounds %List, %List* %list, i32 0, i32 1
  %17 = load %Node*, %Node** %16
  %18 = getelementptr inbounds %Node, %Node* %17, i32 0, i32 0
  store %Node* %new_node, %Node** %18
  %19 = getelementptr inbounds %Node, %Node* %new_node, i32 0, i32 1
  store %Node* %17, %Node** %19
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
  %1 = bitcast %List* %list to i8*
  %2 = icmp eq i8* %1, null
  br i1 %2 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %4 = call %Node*() @linked_list_node_create ()
  %5 = bitcast %Node* %4 to i8*
  %6 = icmp eq i8* %5, null
  br i1 %6 , label %then_1, label %endif_1
then_1:
  ret %Node* null
  br label %endif_1
endif_1:
  %8 = bitcast i8* %link to i8*
  %9 = getelementptr inbounds %Node, %Node* %4, i32 0, i32 2
  store i8* %8, i8** %9
  %10 = call %Node*(%List*, %Node*) @linked_list_insert_node (%List* %list, %Node* %4)
  %11 = bitcast %Node* %10 to i8*
  %12 = icmp eq i8* %11, null
  br i1 %12 , label %then_2, label %endif_2
then_2:
  %13 = bitcast %Node* %4 to i8*
  call void(i8*) @free (i8* %13)
  br label %endif_2
endif_2:
  ret %Node* %10
}


