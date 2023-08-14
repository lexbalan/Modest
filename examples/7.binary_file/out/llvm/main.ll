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


declare i64 @clock()
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

; -- MODULE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




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

; -- MODULE: /Users/alexbalan/p/Modest/examples/7.binary_file/src/main.cm

@str_1 = private constant [9 x i8] c"file.bin\00"
@str_2 = private constant [19 x i8] c"run write_example\0A\00"
@str_3 = private constant [3 x i8] c"wb\00"
@str_4 = private constant [31 x i8] c"error: cannot create file \27%s\27\00"
@str_5 = private constant [3 x i8] c"id\00"
@str_6 = private constant [5 x i8] c"data\00"
@str_7 = private constant [18 x i8] c"run read_example\0A\00"
@str_8 = private constant [3 x i8] c"rb\00"
@str_9 = private constant [29 x i8] c"error: cannot open file \27%s\27\00"
@str_10 = private constant [21 x i8] c"file \27%s\27 contains:\0A\00"
@str_11 = private constant [14 x i8] c"chunk.id: %s\0A\00"
@str_12 = private constant [16 x i8] c"chunk.data: %s\0A\00"
@str_13 = private constant [19 x i8] c"text_file example\0A\00"





%Chunk = type {
	[100 x i8],
	[1024 x i8]
}

define void @write_example() {
  %1 = bitcast [19 x i8]* @str_2 to %ConstCharStr
  %2 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %3 = bitcast [9 x i8]* @str_1 to %ConstCharStr
  %4 = bitcast [3 x i8]* @str_3 to %ConstCharStr
  %5 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr %3, %ConstCharStr %4)
  %6 = icmp eq %FILE* %5, null
  br i1 %6 , label %then_0, label %endif_0
then_0:
  %7 = bitcast [31 x i8]* @str_4 to %ConstCharStr
  %8 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %7, [9 x i8]* @str_1)
  ret void
  br label %endif_0
endif_0:
  %chunk = alloca %Chunk
  %10 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
  %11 = bitcast [100 x i8]* %10 to %Char*
  %12 = bitcast [3 x i8]* @str_5 to %Char*
  %13 = call %Char*(%Char*, %ConstChar*) @strcpy (%Char* %11, %Char* %12)
  %14 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
  %15 = bitcast [1024 x i8]* %14 to %Char*
  %16 = bitcast [5 x i8]* @str_6 to %Char*
  %17 = call %Char*(%Char*, %ConstChar*) @strcpy (%Char* %15, %Char* %16)
  %18 = bitcast %Chunk* %chunk to i8*
  %19 = call %SizeT(i8*, %SizeT, %SizeT, %FILE*) @fwrite (i8* %18, %SizeT 0, %SizeT 1, %FILE* %5)
  %20 = call %Int(%FILE*) @fclose (%FILE* %5)
  ret void
}

define void @read_example() {
  %1 = bitcast [18 x i8]* @str_7 to %ConstCharStr
  %2 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  %3 = bitcast [9 x i8]* @str_1 to %ConstCharStr
  %4 = bitcast [3 x i8]* @str_8 to %ConstCharStr
  %5 = call %FILE*(%ConstCharStr, %ConstCharStr) @fopen (%ConstCharStr %3, %ConstCharStr %4)
  %6 = icmp eq %FILE* %5, null
  br i1 %6 , label %then_0, label %endif_0
then_0:
  %7 = bitcast [29 x i8]* @str_9 to %ConstCharStr
  %8 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %7, [9 x i8]* @str_1)
  ret void
  br label %endif_0
endif_0:
  %chunk = alloca %Chunk
  %10 = bitcast %Chunk* %chunk to i8*
  %11 = call %SizeT(i8*, %SizeT, %SizeT, %FILE*) @fread (i8* %10, %SizeT 0, %SizeT 1, %FILE* %5)
  %12 = bitcast [21 x i8]* @str_10 to %ConstCharStr
  %13 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %12, [9 x i8]* @str_1)
  %14 = bitcast [14 x i8]* @str_11 to %ConstCharStr
  %15 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 0
  %16 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %14, [100 x i8]* %15)
  %17 = bitcast [16 x i8]* @str_12 to %ConstCharStr
  %18 = getelementptr inbounds %Chunk, %Chunk* %chunk, i32 0, i32 1
  %19 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %17, [1024 x i8]* %18)
  %20 = call %Int(%FILE*) @fclose (%FILE* %5)
  ret void
}

define %Int @main() {
  %1 = bitcast [19 x i8]* @str_13 to %ConstCharStr
  %2 = call %Int(%ConstCharStr, ...) @printf (%ConstCharStr %1)
  call void() @write_example ()
  call void() @read_example ()
  ret %Int 0
}


