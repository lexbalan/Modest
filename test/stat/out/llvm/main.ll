
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/time.hm




%TimeT = type i32;
%ClockT = type i64;
%Struct_tm = type {
	i32, 
	i32, 
	i32, 
	i32, 
	i32, 
	i32, 
	i32, 
	i32, 
	i32, 
	i64, 
	i8*
};



declare i64 @clock()


declare double @difftime(i32 %end, i32 %beginning)


declare i32 @mktime(%Struct_tm* %timeptr)


declare i32 @time(i32* %timer)


declare i8* @asctime(%Struct_tm* %timeptr)


declare i8* @ctime(i32* %timer)


declare %Struct_tm* @gmtime(i32* %timer)


declare %Struct_tm* @localtime(i32* %timer)


declare i64 @strftime(i8* %ptr, i64 %maxsize, i8* %format, %Struct_tm* %timeptr)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stat.hm



%DevT = type i32;
%InoT = type i64;
%ModeT = type i16;
%NLinkT = type i16;
%UIDT = type i32;
%GIDT = type i32;
%BlkSizeT = type i32;
%BlkCntT = type i64;
%DarwinIno64T = type i64;


%DarwinTimeT = type i64;
%Timespec = type {
	i64, 
	i64
};



%Stat = type {
	i32, 
	i16, 
	i16, 
	i64, 
	i32, 
	i32, 
	i32, 
	%Timespec, 
	%Timespec, 
	%Timespec, 
	%Timespec, 
	i64, 
	i64, 
	i32, 
	i32, 
	i32, 
	i32, 
	[2 x i64]
};



declare i32 @"\01_stat"([0 x i8]* %path, %Stat* %stat)



; -- SOURCE: src/main.cm

@str1 = private constant [13 x i8] [i8 115, i8 116, i8 97, i8 116, i8 40, i8 34, i8 37, i8 115, i8 34, i8 41, i8 58, i8 10, i8 0]
@str2 = private constant [9 x i8] [i8 77, i8 97, i8 107, i8 101, i8 102, i8 105, i8 108, i8 101, i8 0]
@str3 = private constant [9 x i8] [i8 77, i8 97, i8 107, i8 101, i8 102, i8 105, i8 108, i8 101, i8 0]
@str4 = private constant [12 x i8] [i8 115, i8 116, i8 97, i8 116, i8 32, i8 101, i8 114, i8 114, i8 111, i8 114, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 32, i8 100, i8 101, i8 118, i8 105, i8 99, i8 101, i8 58, i8 32, i8 37, i8 120, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 32, i8 105, i8 110, i8 111, i8 100, i8 101, i8 58, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@str7 = private constant [10 x i8] [i8 32, i8 85, i8 73, i8 68, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str8 = private constant [10 x i8] [i8 32, i8 71, i8 73, i8 68, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str9 = private constant [11 x i8] [i8 32, i8 114, i8 100, i8 101, i8 118, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str10 = private constant [14 x i8] [i8 32, i8 98, i8 108, i8 107, i8 115, i8 105, i8 122, i8 101, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@str11 = private constant [15 x i8] [i8 32, i8 98, i8 108, i8 111, i8 99, i8 107, i8 115, i8 58, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@str12 = private constant [19 x i8] [i8 32, i8 115, i8 105, i8 122, i8 101, i8 58, i8 32, i8 37, i8 108, i8 108, i8 100, i8 32, i8 98, i8 121, i8 116, i8 101, i8 115, i8 10, i8 0]
@str13 = private constant [14 x i8] [i8 32, i8 110, i8 108, i8 105, i8 110, i8 107, i8 115, i8 58, i8 32, i8 37, i8 104, i8 117, i8 10, i8 0]
@str14 = private constant [11 x i8] [i8 32, i8 112, i8 101, i8 114, i8 109, i8 58, i8 32, i8 37, i8 111, i8 10, i8 0]
@str15 = private constant [2 x i8] [i8 10, i8 0]




define i32 @main() {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str2 to [0 x i8]*))
	%2 = alloca %Stat, align 8
	%3 = bitcast %Stat* %2 to %Stat*
	%4 = call i32 @"\01_stat"([0 x i8]* bitcast ([9 x i8]* @str3 to [0 x i8]*), %Stat* %3)
	%5 = icmp slt i32 %4, 0
	br i1 %5 , label %then_0, label %endif_0
then_0:
	%6 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str4 to [0 x i8]*))
	ret i32 1
	br label %endif_0
endif_0:
	%8 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), i32 %9)
	%11 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 3
	%12 = load i64, i64* %11
	%13 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), i64 %12)
	%14 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 4
	%15 = load i32, i32* %14
	%16 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str7 to [0 x i8]*), i32 %15)
	%17 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 5
	%18 = load i32, i32* %17
	%19 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str8 to [0 x i8]*), i32 %18)
	%20 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 6
	%21 = load i32, i32* %20
	%22 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str9 to [0 x i8]*), i32 %21)
	%23 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 13
	%24 = load i32, i32* %23
	%25 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str10 to [0 x i8]*), i32 %24)
	%26 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 12
	%27 = load i64, i64* %26
	%28 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str11 to [0 x i8]*), i64 %27)
	%29 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 11
	%30 = load i64, i64* %29
	%31 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str12 to [0 x i8]*), i64 %30)
	%32 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 2
	%33 = load i16, i16* %32
	%34 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str13 to [0 x i8]*), i16 %33)
	%35 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 1
	%36 = load i16, i16* %35
	%37 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str14 to [0 x i8]*), i16 %36)
	%38 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 7
	%39 = load %Timespec, %Timespec* %38
	%40 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 8
	%41 = load %Timespec, %Timespec* %40
	%42 = getelementptr inbounds %Stat, %Stat* %2, i32 0, i32 9
	%43 = load %Timespec, %Timespec* %42
	%44 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str15 to [0 x i8]*))
	ret i32 0
}


