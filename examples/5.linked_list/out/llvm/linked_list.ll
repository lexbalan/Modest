


%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*

declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr)
declare i32 @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)
declare i32 @setvbuf(%FILE*, %CharStr, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare i32 @fprintf(%FILE*, [0 x i8]*, ...)
declare i32 @printf(%ConstCharStr, ...)
declare i32 @scanf(%ConstCharStr, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr, ...)
declare i32 @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare i32 @sprintf(%CharStr, %ConstCharStr, ...)
declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr @fgets(%CharStr, i32, %FILE*)
declare i32 @fputs(%ConstCharStr, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr @gets(%CharStr)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr)
declare i32 @ungetc(i32, %FILE*)
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
declare i8* @malloc(i64)
declare i8* @memset(i8*, i32, i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @memcmp(i8*, i8*, i64)
declare void @free(i8*)
declare i32 @strncmp(i8*, i8*, i64)
declare i32 @strcmp(i8*, i8*)
declare i8* @strcpy(i8*, i8*)
declare i64 @strlen(i8*)
declare i32 @ftruncate(i32, %OffT)


declare i32 @creat([0 x i8]*, %ModeT)
declare i32 @open([0 x i8]*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare %OffT @lseek(i32, %OffT, i32)
declare i32 @close(i32)
declare void @exit(i32)
declare %DIR* @opendir([0 x i8]*)
declare i32 @closedir(%DIR*)
declare [0 x i8]* @getcwd([0 x i8]*, i64)
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
  %3 = call i8*(i64) @malloc (i64 %2)
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
  %3 = call i8*(i64) @malloc (i64 %2)
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
  %3 = icmp eq i8* %link, null
  %4 = or i1 %2, %3
  br i1 %4 , label %then_0, label %endif_0
then_0:
  ret %Node* null
  br label %endif_0
endif_0:
  %6 = call %Node*() @linked_list_node_create ()
  %7 = bitcast %Node* %6 to i8*
  %8 = icmp eq i8* %7, null
  br i1 %8 , label %then_1, label %endif_1
then_1:
  ret %Node* null
  br label %endif_1
endif_1:
  %10 = getelementptr inbounds %Node, %Node* %6, i32 0, i32 2
  store i8* %link, i8** %10
  %11 = call %Node*(%List*, %Node*) @linked_list_insert_node (%List* %list, %Node* %6)
  %12 = bitcast %Node* %11 to i8*
  %13 = icmp eq i8* %12, null
  br i1 %13 , label %then_2, label %endif_2
then_2:
  %14 = bitcast %Node* %6 to i8*
  call void(i8*) @free (i8* %14)
  br label %endif_2
endif_2:
  ret %Node* %11
}


