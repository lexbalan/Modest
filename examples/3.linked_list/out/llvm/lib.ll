@str_0 = private constant [21 x i8] c"list_print_forward:\0A\00"
@str_1 = private constant [8 x i8] c"v = %d\0A\00"
@str_2 = private constant [22 x i8] c"list_print_backward:\0A\00"
@str_3 = private constant [8 x i8] c"v = %d\0A\00"
@str_4 = private constant [21 x i8] c"linked list example\0A\00"
@str_5 = private constant [26 x i8] c"error: cannot create list\00"
@str_6 = private constant [22 x i8] c"linked list size: %d\0A\00"

%Long = type i64
%LongLong = type i64
%Float = type float
%Double = type double
%LongDouble = type double
%SizeT = type i64







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

%FILE = type opaque
%DIR = type opaque
declare i8* @malloc(%SizeT)
declare i8* @memset(i8*, i8, %SizeT)
declare i8* @memcpy(i8*, i8*, %SizeT)
declare i64 @memcmp(i8*, i8*, %SizeT)
declare void @free(i8*)
declare i32 @putchar(i8)
declare i64 @strncmp([0 x i8]*, [0 x i8]*, %SizeT)
declare i64 @strcmp([0 x i8]*, [0 x i8]*)
declare i8* @strcpy([0 x i8]*, [0 x i8]*)
declare %SizeT @strlen([0 x i8]*)





declare i32 @printf([0 x i8]*, ...)
declare i64 @scanf([0 x i8]*, ...)
declare i64 @sscanf(i8*, [0 x i8]*, ...)
declare i64 @sprintf(i8*, [0 x i8]*, ...)
declare i64 @chdir([0 x i8]*)
declare %FILE* @fopen([0 x i8]*, [0 x i8]*)
declare i64 @fclose(%FILE*)
declare i64 @fprintf(%FILE*, [0 x i8]*, ...)
declare i64 @fseek(%FILE*, i64, i64)
declare i64 @ftruncate(i64, %OffT)
declare %SizeT @fwrite(i8*, %SizeT, %SizeT, %FILE*)
declare %SizeT @fread(i8*, %SizeT, %SizeT, %FILE*)













declare i64 @creat([0 x i8]*, %ModeT)
declare i64 @open([0 x i8]*, i64)
declare i64 @read(i64, i8*, i32)
declare i64 @write(i64, i8*, i32)
declare %OffT @lseek(i64, %OffT, i64)
declare i64 @close(i64)
declare void @exit(i64)
declare %DIR* @opendir([0 x i8]*)
declare i64 @closedir(%DIR*)
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


