


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


%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*

declare %Int @fclose(%FILE*)
declare %Int @feof(%FILE*)
declare %Int @ferror(%FILE*)
declare %Int @fflush(%FILE*)
declare %Int @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare %SizeT @fread(i8*, %SizeT, %SizeT, %FILE*)
declare %SizeT @fwrite(i8*, %SizeT, %SizeT, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare %Int @fseek(%FILE*, %LongInt, %Int)
declare %Int @fsetpos(%FILE*, %FposT*)
declare %LongInt @ftell(%FILE*)
declare %Int @remove(%ConstCharStr)
declare %Int @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)
declare %Int @setvbuf(%FILE*, %CharStr, %Int, %SizeT)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare %Int @printf(%ConstCharStr, ...)
declare %Int @scanf(%ConstCharStr, ...)
declare %Int @fprintf(%FILE*, [0 x i8]*, ...)
declare %Int @fscanf(%FILE*, %ConstCharStr, ...)
declare %Int @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare %Int @sprintf(%CharStr, %ConstCharStr, ...)
declare %Int @fgetc(%FILE*)
declare %Int @fputc(%Int, %FILE*)
declare %CharStr @fgets(%CharStr, %Int, %FILE*)
declare %Int @fputs(%ConstCharStr, %FILE*)
declare %Int @getc(%FILE*)
declare %Int @getchar()
declare %CharStr @gets(%CharStr)
declare %Int @putc(%Int, %FILE*)
declare %Int @putchar(%Int)
declare %Int @puts(%ConstCharStr)
declare %Int @ungetc(%Int, %FILE*)
declare void @perror(%ConstCharStr)

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
  %1 = getelementptr  %List, %List* null, i32 1
  %2 = ptrtoint  %List* %1 to i64
  %3 = call i8*(%SizeT) @malloc (i64 %2)
  %4 = bitcast i8* %3 to %List*
  %5 = bitcast %List* %4 to i8*
  %6 = icmp eq i8* %5, null
  br i1 %6 , label %then_0, label %endif_0
then_0:
  ret %List* null
  br label %endif_0
endif_0:
  %8 = getelementptr inbounds %List, %List* %4, i32 0, i32 0
  store %Node* null, %Node** %8
  %9 = getelementptr inbounds %List, %List* %4, i32 0, i32 1
  store %Node* null, %Node** %9
  ret %List* %4
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
  %1 = getelementptr  %Node, %Node* null, i32 1
  %2 = ptrtoint  %Node* %1 to i64
  %3 = call i8*(%SizeT) @malloc (i64 %2)
  %4 = bitcast i8* %3 to %Node*
  %5 = bitcast %Node* %4 to i8*
  %6 = icmp eq i8* %5, null
  br i1 %6 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %8 = getelementptr inbounds %Node, %Node* %4, i32 0, i32 1
  store %Node* null, %Node** %8
  %9 = getelementptr inbounds %Node, %Node* %4, i32 0, i32 0
  store %Node* null, %Node** %9
  %10 = getelementptr inbounds %Node, %Node* %4, i32 0, i32 2
  store i8* null, i8** %10
  ret %Node* %4
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
  ret i8* %5
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
  %8 = getelementptr inbounds %Node, %Node* %4, i32 0, i32 2
  store i8* %link, i8** %8
  %9 = call %Node*(%List*, %Node*) @linked_list_insert_node (%List* %list, %Node* %4)
  %10 = bitcast %Node* %9 to i8*
  %11 = icmp eq i8* %10, null
  br i1 %11 , label %then_2, label %endif_2
then_2:
  %12 = bitcast %Node* %4 to i8*
  call void(i8*) @free (i8* %12)
  br label %endif_2
endif_2:
  ret %Node* %9
}


