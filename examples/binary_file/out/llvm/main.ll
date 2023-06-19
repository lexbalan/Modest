
@str_0 = private constant [9 x i8] c"file.bin\00"
@str_1 = private constant [19 x i8] c"run write_example\0A\00"
@str_2 = private constant [3 x i8] c"wb\00"
@str_3 = private constant [31 x i8] c"error: cannot create file \27%s\27\00"
@str_4 = private constant [3 x i8] c"id\00"
@str_5 = private constant [5 x i8] c"data\00"
@str_6 = private constant [18 x i8] c"run read_example\0A\00"
@str_7 = private constant [3 x i8] c"rb\00"
@str_8 = private constant [29 x i8] c"error: cannot open file \27%s\27\00"
@str_9 = private constant [21 x i8] c"file \27%s\27 contains:\0A\00"
@str_10 = private constant [14 x i8] c"chunk.id: %s\0A\00"
@str_11 = private constant [16 x i8] c"chunk.data: %s\0A\00"
@str_12 = private constant [19 x i8] c"text_file example\0A\00"


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

%DevT = type i32
%InoT = type i16
%ModeT = type i16
%NlinkT = type i16
%BlkCntT = type i16
%OffT = type i32
%UIDT = type i16
%GIDT = type i8
%BlkSizeT = type i16
%TimeT = type i32

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
%DIR = type opaque
declare %DIR* @opendir([0 x i8]*)
declare i32 @closedir(%DIR*)
declare [0 x i8]* @getcwd([0 x i8]*, i64)
declare [0 x i8]* @getenv([0 x i8]*)

%Chunk = type {
	[100 x i8],
	[1024 x i8]
}

define void @write_example() {
  %1 = bitcast [19 x i8]* @str_1 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %3 = bitcast [9 x i8]* @str_0 to %ConstCharStr
  %4 = bitcast [3 x i8]* @str_2 to %ConstCharStr
  %5 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr %3, %ConstCharStr %4)
  %6 = bitcast %FILE* %5 to i8*
  %7 = icmp eq i8* %6, null
  br i1 %7 , label %then_0, label %endif_0
then_0:
  %8 = bitcast [31 x i8]* @str_3 to %ConstCharStr
  %9 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %8, [9 x i8]* @str_0)
  ret void
  br label %endif_0
endif_0:
  %chunk = alloca %Chunk
  %11 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
  %12 = bitcast [100 x i8]* %11 to i8*
  %13 = bitcast [3 x i8]* @str_4 to i8*
  %14 = call i8*(i8*, i8*) @strcpy (i8* %12, i8* %13)
  %15 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
  %16 = bitcast [1024 x i8]* %15 to i8*
  %17 = bitcast [5 x i8]* @str_5 to i8*
  %18 = call i8*(i8*, i8*) @strcpy (i8* %16, i8* %17)
  %19 = bitcast %Chunk* %chunk to i8*
  %20 = getelementptr  %Chunk, %Chunk* null, i32 1
  %21 = ptrtoint  %Chunk* %20 to i64
  %22 = call i64(i8*, i64, i64, %FILE*) @fwrite (i8* %19, i64 %21, i64 1, %FILE* %5)
  %23 = call i32(%FILE*) @fclose (%FILE* %5)
  ret void
}

define void @read_example() {
  %1 = bitcast [18 x i8]* @str_6 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %3 = bitcast [9 x i8]* @str_0 to %ConstCharStr
  %4 = bitcast [3 x i8]* @str_7 to %ConstCharStr
  %5 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr %3, %ConstCharStr %4)
  %6 = bitcast %FILE* %5 to i8*
  %7 = icmp eq i8* %6, null
  br i1 %7 , label %then_0, label %endif_0
then_0:
  %8 = bitcast [29 x i8]* @str_8 to %ConstCharStr
  %9 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %8, [9 x i8]* @str_0)
  ret void
  br label %endif_0
endif_0:
  %chunk = alloca %Chunk
  %11 = bitcast %Chunk* %chunk to i8*
  %12 = getelementptr  %Chunk, %Chunk* null, i32 1
  %13 = ptrtoint  %Chunk* %12 to i64
  %14 = call i64(i8*, i64, i64, %FILE*) @fread (i8* %11, i64 %13, i64 1, %FILE* %5)
  %15 = bitcast [21 x i8]* @str_9 to %ConstCharStr
  %16 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %15, [9 x i8]* @str_0)
  %17 = bitcast [14 x i8]* @str_10 to %ConstCharStr
  %18 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
  %19 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %17, [100 x i8]* %18)
  %20 = bitcast [16 x i8]* @str_11 to %ConstCharStr
  %21 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
  %22 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %20, [1024 x i8]* %21)
  %23 = call i32(%FILE*) @fclose (%FILE* %5)
  ret void
}

define i32 @main() {
  %1 = bitcast [19 x i8]* @str_12 to %ConstCharStr
  %2 = call i32(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  call void() @write_example ()
  call void() @read_example ()
  ret i32 0
}


