
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float32 = type float
%Float64 = type double
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*)
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

; MODULE: console

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included unistd
declare %Int @access([0 x %ConstChar]* %path, %Int %amode)
declare %UnsignedInt @alarm(%UnsignedInt %seconds)
declare %Int @brk(i8* %end_data_segment)
declare %Int @chdir([0 x %ConstChar]* %path)
declare %Int @chroot([0 x %ConstChar]* %path)
declare %Int @chown([0 x %ConstChar]* %pathname, %UIDT %owner, %GIDT %group)
declare %Int @close(%Int %fildes)
declare %SizeT @confstr(%Int %name, [0 x %Char]* %buf, %SizeT %len)
declare [0 x %Char]* @crypt([0 x %ConstChar]* %key, [0 x %ConstChar]* %salt)
declare [0 x %Char]* @ctermid([0 x %Char]* %s)
declare [0 x %Char]* @cuserid([0 x %Char]* %s)
declare %Int @dup(%Int %fildes)
declare %Int @dup2(%Int %fildes, %Int %fildes2)
declare void @encrypt([64 x %Char]* %block, %Int %edflag)
declare %Int @execl([0 x %ConstChar]* %path, [0 x %ConstChar]* %arg0, ...)
declare %Int @execle([0 x %ConstChar]* %path, [0 x %ConstChar]* %arg0, ...)
declare %Int @execlp([0 x %ConstChar]* %file, [0 x %ConstChar]* %arg0, ...)
declare %Int @execv([0 x %ConstChar]* %path, [0 x %ConstChar]* %argv)
declare %Int @execve([0 x %ConstChar]* %path, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %envp)
declare %Int @execvp([0 x %ConstChar]* %file, [0 x %ConstChar]* %argv)
declare void @_exit(%Int %status)
declare %Int @fchown(%Int %fildes, %UIDT %owner, %GIDT %group)
declare %Int @fchdir(%Int %fildes)
declare %Int @fdatasync(%Int %fildes)
declare %PIDT @fork()
declare %LongInt @fpathconf(%Int %fildes, %Int %name)
declare %Int @fsync(%Int %fildes)
declare %Int @ftruncate(%Int %fildes, %OffT %length)
declare [0 x %Char]* @getcwd([0 x %Char]* %buf, %SizeT %size)
declare %Int @getdtablesize()
declare %GIDT @getegid()
declare %UIDT @geteuid()
declare %GIDT @getgid()
declare %Int @getgroups(%Int %gidsetsize, [0 x %GIDT]* %grouplist)
declare %Long @gethostid()
declare [0 x %Char]* @getlogin()
declare %Int @getlogin_r([0 x %Char]* %name, %SizeT %namesize)
declare %Int @getopt(%Int %argc, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %optstring)
declare %Int @getpagesize()
declare [0 x %Char]* @getpass([0 x %ConstChar]* %prompt)
declare %PIDT @getpgid(%PIDT %pid)
declare %PIDT @getpgrp()
declare %PIDT @getpid()
declare %PIDT @getppid()
declare %PIDT @getsid(%PIDT %pid)
declare %UIDT @getuid()
declare [0 x %Char]* @getwd([0 x %Char]* %path_name)
declare %Int @isatty(%Int %fildes)
declare %Int @lchown([0 x %ConstChar]* %path, %UIDT %owner, %GIDT %group)
declare %Int @link([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)
declare %Int @lockf(%Int %fildes, %Int %function, %OffT %size)
declare %OffT @lseek(%Int %fildes, %OffT %offset, %Int %whence)
declare %Int @nice(%Int %incr)
declare %LongInt @pathconf([0 x %ConstChar]* %path, %Int %name)
declare %Int @pause()
declare %Int @pipe([2 x %Int]* %fildes)
declare %SSizeT @pread(%Int %fildes, i8* %buf, %SizeT %nbyte, %OffT %offset)
declare %SSizeT @pwrite(%Int %fildes, i8* %buf, %SizeT %nbyte, %OffT %offset)
declare %SSizeT @read(%Int %fildes, i8* %buf, %SizeT %nbyte)
declare %Int @readlink([0 x %ConstChar]* %path, [0 x %Char]* %buf, %SizeT %bufsize)
declare %Int @rmdir([0 x %ConstChar]* %path)
declare i8* @sbrk(%IntPtrT %incr)
declare %Int @setgid(%GIDT %gid)
declare %Int @setpgid(%PIDT %pid, %PIDT %pgid)
declare %PIDT @setpgrp()
declare %Int @setregid(%GIDT %rgid, %GIDT %egid)
declare %Int @setreuid(%UIDT %ruid, %UIDT %euid)
declare %PIDT @setsid()
declare %Int @setuid(%UIDT %uid)
declare %UnsignedInt @sleep(%UnsignedInt %seconds)
declare void @swab(i8* %src, i8* %dst, %SSizeT %nbytes)
declare %Int @symlink([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)
declare void @sync()
declare %LongInt @sysconf(%Int %name)
declare %PIDT @tcgetpgrp(%Int %fildes)
declare %Int @tcsetpgrp(%Int %fildes, %PIDT %pgid_id)
declare %Int @truncate([0 x %ConstChar]* %path, %OffT %length)
declare [0 x %Char]* @ttyname(%Int %fildes)
declare %Int @ttyname_r(%Int %fildes, [0 x %Char]* %name, %SizeT %namesize)
declare %USecondsT @ualarm(%USecondsT %useconds, %USecondsT %interval)
declare %Int @unlink([0 x %ConstChar]* %path)
declare %Int @usleep(%USecondsT %useconds)
declare %PIDT @vfork()
declare %SSizeT @write(%Int %fildes, i8* %buf, %SizeT %nbyte)
; from included stdio
%File = type %Nat8;
%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; -- end print includes --
; -- print imports 'console' --
; -- 1

; from import "utf"
declare %Nat8 @utf_utf32_to_utf8(%Char32 %c, [4 x %Char8]* %buf)
declare %Nat8 @utf_utf16_to_utf32([0 x %Char16]* %c, %Char32* %result)

; end from import "utf"
; -- end print imports 'console' --
; -- strings --
; -- endstrings --
define void @console_putchar8(%Char8 %c) {
	call void @console_putchar_utf8(%Char8 %c)
	ret void
}

define void @console_putchar16(%Char16 %c) {
	call void @console_putchar_utf16(%Char16 %c)
	ret void
}

define void @console_putchar32(%Char32 %c) {
	call void @console_putchar_utf32(%Char32 %c)
	ret void
}

define void @console_putchar_utf8(%Char8 %c) {
	%1 = zext %Char8 %c to %Word32
	%2 = bitcast %Word32 %1 to %Int32
	%3 = call %Int @putchar(%Int32 %2)
	ret void
}

define void @console_putchar_utf16(%Char16 %c) {
	%1 = alloca [2 x %Char16], align 1
	%2 = getelementptr [2 x %Char16], [2 x %Char16]* %1, %Int32 0, %Int32 0
	store %Char16 %c, %Char16* %2
	%3 = getelementptr [2 x %Char16], [2 x %Char16]* %1, %Int32 0, %Int32 1
	store %Char16 0, %Char16* %3
	%4 = alloca %Char32, align 4
	%5 = bitcast [2 x %Char16]* %1 to [0 x %Char16]*
	%6 = call %Nat8 @utf_utf16_to_utf32([0 x %Char16]* %5, %Char32* %4)
	%7 = load %Char32, %Char32* %4
	call void @console_putchar_utf32(%Char32 %7)
	ret void
}

define void @console_putchar_utf32(%Char32 %c) {
	%1 = alloca [4 x %Char8], align 1
	%2 = call %Nat8 @utf_utf32_to_utf8(%Char32 %c, [4 x %Char8]* %1)
	%3 = sext %Nat8 %2 to %Int32
	%4 = alloca %Int32, align 4
	store %Int32 0, %Int32* %4
; while_1
	br label %again_1
again_1:
	%5 = load %Int32, %Int32* %4
	%6 = icmp slt %Int32 %5, %3
	br %Bool %6 , label %body_1, label %break_1
body_1:
	%7 = load %Int32, %Int32* %4
	%8 = getelementptr [4 x %Char8], [4 x %Char8]* %1, %Int32 0, %Int32 %7
	%9 = load %Char8, %Char8* %8
	call void @console_putchar_utf8(%Char8 %9)
	%10 = load %Int32, %Int32* %4
	%11 = add %Int32 %10, 1
	store %Int32 %11, %Int32* %4
	br label %again_1
break_1:
	ret void
}

define void @console_puts8(%Str8* %s) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%2 = load %Int32, %Int32* %1
	%3 = getelementptr %Str8, %Str8* %s, %Int32 0, %Int32 %2
	%4 = load %Char8, %Char8* %3
; if_0
	%5 = icmp eq %Char8 %4, 0
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @console_putchar_utf8(%Char8 %4)
	%7 = load %Int32, %Int32* %1
	%8 = add %Int32 %7, 1
	store %Int32 %8, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_puts16(%Str16* %s) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	; нельзя просто так взять и вызвать putchar_utf16
	; тк в строке может быть суррогатная пара UTF_16 символов
	%2 = load %Int32, %Int32* %1
	%3 = getelementptr %Str16, %Str16* %s, %Int32 0, %Int32 %2
	%4 = load %Char16, %Char16* %3
; if_0
	%5 = icmp eq %Char16 %4, 0
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%7 = alloca %Char32, align 4
	%8 = load %Int32, %Int32* %1
	%9 = getelementptr %Str16, %Str16* %s, %Int32 0, %Int32 %8
	%10 = bitcast %Char16* %9 to [0 x %Char16]*
	%11 = call %Nat8 @utf_utf16_to_utf32([0 x %Char16]* %10, %Char32* %7)
; if_1
	%12 = icmp eq %Nat8 %11, 0
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%14 = load %Char32, %Char32* %7
	call void @console_putchar_utf32(%Char32 %14)
	%15 = sext %Nat8 %11 to %Int32
	%16 = load %Int32, %Int32* %1
	%17 = add %Int32 %16, %15
	store %Int32 %17, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_puts32(%Str32* %s) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%2 = load %Int32, %Int32* %1
	%3 = getelementptr %Str32, %Str32* %s, %Int32 0, %Int32 %2
	%4 = load %Char32, %Char32* %3
; if_0
	%5 = icmp eq %Char32 %4, 0
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @console_putchar_utf32(%Char32 %4)
	%7 = load %Int32, %Int32* %1
	%8 = add %Int32 %7, 1
	store %Int32 %8, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_print(%Str8* %form, ...) {
	%1 = alloca %__VA_List, align 1
	%2 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = load %__VA_List, %__VA_List* %1
	%4 = call %Int32 @console_vfprint(%Int32 1, %Str8* %form, %__VA_List %3)
	%5 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_end(i8* %5)
	ret void
}

define %Int32 @console_vfprint(%Int32 %fd, %Str8* %form, %__VA_List %va) {
	%1 = alloca i8*
	store %__VA_List %va, i8** %1
	%2 = alloca [256 x %Char8], align 1
	%3 = bitcast [256 x %Char8]* %2 to [0 x %Char8]*
	%4 = load %__VA_List, %__VA_List* %1
	%5 = call %Int32 @console_vsprint([0 x %Char8]* %3, %Str8* %form, %__VA_List %4)
	%6 = getelementptr [256 x %Char8], [256 x %Char8]* %2, %Int32 0, %Int32 %5
	store %Char8 0, %Char8* %6
	%7 = bitcast [256 x %Char8]* %2 to i8*
	%8 = zext %Int32 %5 to %SizeT
	%9 = call %SSizeT @write(%Int32 %fd, i8* %7, %SizeT %8)
	ret %Int32 %5
}

define %Int32 @console_vsprint([0 x %Char8]* %buf, %Str8* %form, %__VA_List %va) {
	%1 = alloca i8*
	store %__VA_List %va, i8** %1
	%2 = alloca %Int32, align 4
	store %Int32 0, %Int32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%4 = alloca %Char8, align 1
	%5 = load %Int32, %Int32* %2
	%6 = getelementptr %Str8, %Str8* %form, %Int32 0, %Int32 %5
	%7 = load %Char8, %Char8* %6
	store %Char8 %7, %Char8* %4
; if_0
	%8 = load %Char8, %Char8* %4
	%9 = icmp eq %Char8 %8, 0
	br %Bool %9 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
; if_1
	%11 = load %Char8, %Char8* %4
	%12 = icmp ne %Char8 %11, 123
	br %Bool %12 , label %then_1, label %endif_1
then_1:
; if_2
	%13 = load %Char8, %Char8* %4
	%14 = icmp eq %Char8 %13, 125
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = load %Int32, %Int32* %2
	%16 = add %Int32 %15, 1
	store %Int32 %16, %Int32* %2
	%17 = load %Int32, %Int32* %2
	%18 = getelementptr %Str8, %Str8* %form, %Int32 0, %Int32 %17
	%19 = load %Char8, %Char8* %18
	store %Char8 %19, %Char8* %4
; if_3
	%20 = load %Char8, %Char8* %4
	%21 = icmp eq %Char8 %20, 125
	br %Bool %21 , label %then_3, label %endif_3
then_3:
	%22 = load %Int32, %Int32* %3
	%23 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %22
	%24 = load %Char8, %Char8* %4
	store %Char8 %24, %Char8* %23
	%25 = load %Int32, %Int32* %3
	%26 = add %Int32 %25, 1
	store %Int32 %26, %Int32* %3
	%27 = load %Int32, %Int32* %2
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %2
	br label %endif_3
endif_3:
	br label %again_1
	br label %endif_2
endif_2:
	%30 = load %Int32, %Int32* %3
	%31 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %30
	%32 = load %Char8, %Char8* %4
	store %Char8 %32, %Char8* %31
	%33 = load %Int32, %Int32* %3
	%34 = add %Int32 %33, 1
	store %Int32 %34, %Int32* %3
	%35 = load %Int32, %Int32* %2
	%36 = add %Int32 %35, 1
	store %Int32 %36, %Int32* %2
	br label %again_1
	br label %endif_1
endif_1:

	; c == '{'
	%38 = load %Int32, %Int32* %2
	%39 = add %Int32 %38, 1
	store %Int32 %39, %Int32* %2
	%40 = load %Int32, %Int32* %2
	%41 = getelementptr %Str8, %Str8* %form, %Int32 0, %Int32 %40
	%42 = load %Char8, %Char8* %41
	store %Char8 %42, %Char8* %4
; if_4
	%43 = load %Char8, %Char8* %4
	%44 = icmp eq %Char8 %43, 123
	br %Bool %44 , label %then_4, label %endif_4
then_4:
	%45 = load %Int32, %Int32* %3
	%46 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %45
	store %Char8 123, %Char8* %46
	%47 = load %Int32, %Int32* %3
	%48 = add %Int32 %47, 1
	store %Int32 %48, %Int32* %3
	%49 = load %Int32, %Int32* %2
	%50 = add %Int32 %49, 1
	store %Int32 %50, %Int32* %2
	br label %again_1
	br label %endif_4
endif_4:
	%52 = load %Int32, %Int32* %2
	%53 = add %Int32 %52, 2
	store %Int32 %53, %Int32* %2
	%54 = load %Int32, %Int32* %3
	%55 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %54
;
	%56 = bitcast %Char8* %55 to [0 x %Char8]*
; if_5
	%57 = load %Char8, %Char8* %4
	%58 = icmp eq %Char8 %57, 105
	%59 = load %Char8, %Char8* %4
	%60 = icmp eq %Char8 %59, 100
	%61 = or %Bool %58, %60
	br %Bool %61 , label %then_5, label %else_5
then_5:
	;
	; %i & %d for signed integer (Int)
	;
	%62 = va_arg %__VA_List* %1, %Int32
	%63 = call %Int32 @sprint_dec_int32([0 x %Char8]* %56, %Int32 %62)
	%64 = load %Int32, %Int32* %3
	%65 = add %Int32 %64, %63
	store %Int32 %65, %Int32* %3
	br label %endif_5
else_5:
; if_6
	%66 = load %Char8, %Char8* %4
	%67 = icmp eq %Char8 %66, 110
	br %Bool %67 , label %then_6, label %else_6
then_6:
	;
	; %n for unsigned integer (Nat)
	;
	%68 = va_arg %__VA_List* %1, %Nat32
	%69 = call %Int32 @sprint_dec_n32([0 x %Char8]* %56, %Nat32 %68)
	%70 = load %Int32, %Int32* %3
	%71 = add %Int32 %70, %69
	store %Int32 %71, %Int32* %3
	br label %endif_6
else_6:
; if_7
	%72 = load %Char8, %Char8* %4
	%73 = icmp eq %Char8 %72, 120
	%74 = load %Char8, %Char8* %4
	%75 = icmp eq %Char8 %74, 112
	%76 = or %Bool %73, %75
	br %Bool %76 , label %then_7, label %else_7
then_7:
	;
	; %x for unsigned integer (Nat)
	; %p for pointers
	;
	%77 = va_arg %__VA_List* %1, %Nat32
	%78 = call %Int32 @sprint_hex_nat32([0 x %Char8]* %56, %Nat32 %77)
	%79 = load %Int32, %Int32* %3
	%80 = add %Int32 %79, %78
	store %Int32 %80, %Int32* %3
	br label %endif_7
else_7:
; if_8
	%81 = load %Char8, %Char8* %4
	%82 = icmp eq %Char8 %81, 115
	br %Bool %82 , label %then_8, label %else_8
then_8:
	;
	; %s pointer to string
	;
	%83 = va_arg %__VA_List* %1, %Str8*
	%84 = call [0 x %Char]* @strcpy([0 x %Char8]* %56, %Str8* %83)
	%85 = call %SizeT @strlen(%Str8* %83)
	%86 = trunc %SizeT %85 to %Int32
	%87 = load %Int32, %Int32* %3
	%88 = add %Int32 %87, %86
	store %Int32 %88, %Int32* %3
	br label %endif_8
else_8:
; if_9
	%89 = load %Char8, %Char8* %4
	%90 = icmp eq %Char8 %89, 99
	br %Bool %90 , label %then_9, label %endif_9
then_9:
	;
	; %c for char
	;
	%91 = va_arg %__VA_List* %1, %Char32
	%92 = bitcast [0 x %Char8]* %56 to [4 x %Char8]*
	%93 = call %Nat8 @utf_utf32_to_utf8(%Char32 %91, [4 x %Char8]* %92)
	%94 = sext %Nat8 %93 to %Int32
	%95 = load %Int32, %Int32* %3
	%96 = add %Int32 %95, %94
	store %Int32 %96, %Int32* %3
	br label %endif_9
endif_9:
	br label %endif_8
endif_8:
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %again_1
break_1:
	%97 = load %Int32, %Int32* %3
	ret %Int32 %97
}

define internal %Char8 @n_to_dec_sym(%Nat8 %n) {
	%1 = add %Nat8 48, %n
	%2 = bitcast %Nat8 %1 to %Word8
	%3 = bitcast %Word8 %2 to %Char8
	ret %Char8 %3
}

define internal %Char8 @n_to_hex_sym(%Nat8 %n) {
; if_0
	%1 = icmp ult %Nat8 %n, 10
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	%2 = call %Char8 @n_to_dec_sym(%Nat8 %n)
	ret %Char8 %2
	br label %endif_0
endif_0:
	%4 = sub %Nat8 %n, 10
	%5 = add %Nat8 65, %4
	%6 = bitcast %Nat8 %5 to %Word8
	%7 = bitcast %Word8 %6 to %Char8
	ret %Char8 %7
}

define internal %Int32 @sprint_hex_nat32([0 x %Char8]* %buf, %Nat32 %x) {
	%1 = alloca [8 x %Char8], align 1
	%2 = alloca %Nat32, align 4
	store %Nat32 %x, %Nat32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%4 = load %Nat32, %Nat32* %2
	%5 = urem %Nat32 %4, 16
	%6 = load %Nat32, %Nat32* %2
	%7 = udiv %Nat32 %6, 16
	store %Nat32 %7, %Nat32* %2
	%8 = load %Int32, %Int32* %3
	%9 = getelementptr [8 x %Char8], [8 x %Char8]* %1, %Int32 0, %Int32 %8
	%10 = trunc %Nat32 %5 to %Nat8
	%11 = call %Char8 @n_to_hex_sym(%Nat8 %10)
	store %Char8 %11, %Char8* %9
	%12 = load %Int32, %Int32* %3
	%13 = add %Int32 %12, 1
	store %Int32 %13, %Int32* %3
; if_0
	%14 = load %Nat32, %Nat32* %2
	%15 = icmp eq %Nat32 %14, 0
	br %Bool %15 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:

	; mirroring into buffer
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
; while_2
	br label %again_2
again_2:
	%18 = load %Int32, %Int32* %3
	%19 = icmp sgt %Int32 %18, 0
	br %Bool %19 , label %body_2, label %break_2
body_2:
	%20 = load %Int32, %Int32* %3
	%21 = sub %Int32 %20, 1
	store %Int32 %21, %Int32* %3
	%22 = load %Int32, %Int32* %17
	%23 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %22
	%24 = load %Int32, %Int32* %3
	%25 = getelementptr [8 x %Char8], [8 x %Char8]* %1, %Int32 0, %Int32 %24
	%26 = load %Char8, %Char8* %25
	store %Char8 %26, %Char8* %23
	%27 = load %Int32, %Int32* %17
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %17
	br label %again_2
break_2:
	%29 = load %Int32, %Int32* %17
	%30 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %29
	store %Char8 0, %Char8* %30
	%31 = load %Int32, %Int32* %17
	ret %Int32 %31
}

define internal %Int32 @sprint_dec_int32([0 x %Char8]* %buf, %Int32 %x) {
	%1 = alloca [11 x %Char8], align 1
	%2 = alloca %Int32, align 4
	store %Int32 %x, %Int32* %2
	%3 = load %Int32, %Int32* %2
	%4 = icmp slt %Int32 %3, 0
; if_0
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = load %Int32, %Int32* %2
	%6 = sub %Int32 0, %5
	store %Int32 %6, %Int32* %2
	br label %endif_0
endif_0:
	%7 = alloca %Int32, align 4
	store %Int32 0, %Int32* %7
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%8 = load %Int32, %Int32* %2
	%9 = srem %Int32 %8, 10
	%10 = load %Int32, %Int32* %2
	%11 = sdiv %Int32 %10, 10
	store %Int32 %11, %Int32* %2
	%12 = load %Int32, %Int32* %7
	%13 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Int32 %12
	%14 = trunc %Int32 %9 to %Nat8
	%15 = call %Char8 @n_to_dec_sym(%Nat8 %14)
	store %Char8 %15, %Char8* %13
	%16 = load %Int32, %Int32* %7
	%17 = add %Int32 %16, 1
	store %Int32 %17, %Int32* %7
; if_1
	%18 = load %Int32, %Int32* %2
	%19 = icmp eq %Int32 %18, 0
	br %Bool %19 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	br label %again_1
break_1:
	%21 = alloca %Int32, align 4
	store %Int32 0, %Int32* %21
; if_2
	br %Bool %4 , label %then_2, label %endif_2
then_2:
	%22 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 0
	store %Char8 45, %Char8* %22
	%23 = load %Int32, %Int32* %21
	%24 = add %Int32 %23, 1
	store %Int32 %24, %Int32* %21
	br label %endif_2
endif_2:
; while_2
	br label %again_2
again_2:
	%25 = load %Int32, %Int32* %7
	%26 = icmp sgt %Int32 %25, 0
	br %Bool %26 , label %body_2, label %break_2
body_2:
	%27 = load %Int32, %Int32* %7
	%28 = sub %Int32 %27, 1
	store %Int32 %28, %Int32* %7
	%29 = load %Int32, %Int32* %21
	%30 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %29
	%31 = load %Int32, %Int32* %7
	%32 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Int32 %31
	%33 = load %Char8, %Char8* %32
	store %Char8 %33, %Char8* %30
	%34 = load %Int32, %Int32* %21
	%35 = add %Int32 %34, 1
	store %Int32 %35, %Int32* %21
	br label %again_2
break_2:
	%36 = load %Int32, %Int32* %21
	%37 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %36
	store %Char8 0, %Char8* %37
	%38 = load %Int32, %Int32* %21
	ret %Int32 %38
}

define internal %Int32 @sprint_dec_n32([0 x %Char8]* %buf, %Nat32 %x) {
	%1 = alloca [11 x %Char8], align 1
	%2 = alloca %Nat32, align 4
	store %Nat32 %x, %Nat32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%4 = load %Nat32, %Nat32* %2
	%5 = urem %Nat32 %4, 10
	%6 = load %Nat32, %Nat32* %2
	%7 = udiv %Nat32 %6, 10
	store %Nat32 %7, %Nat32* %2
	%8 = load %Int32, %Int32* %3
	%9 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Int32 %8
	%10 = trunc %Nat32 %5 to %Nat8
	%11 = call %Char8 @n_to_dec_sym(%Nat8 %10)
	store %Char8 %11, %Char8* %9
	%12 = load %Int32, %Int32* %3
	%13 = add %Int32 %12, 1
	store %Int32 %13, %Int32* %3
; if_0
	%14 = load %Nat32, %Nat32* %2
	%15 = icmp eq %Nat32 %14, 0
	br %Bool %15 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
; while_2
	br label %again_2
again_2:
	%18 = load %Int32, %Int32* %3
	%19 = icmp sgt %Int32 %18, 0
	br %Bool %19 , label %body_2, label %break_2
body_2:
	%20 = load %Int32, %Int32* %3
	%21 = sub %Int32 %20, 1
	store %Int32 %21, %Int32* %3
	%22 = load %Int32, %Int32* %17
	%23 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %22
	%24 = load %Int32, %Int32* %3
	%25 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Int32 %24
	%26 = load %Char8, %Char8* %25
	store %Char8 %26, %Char8* %23
	%27 = load %Int32, %Int32* %17
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %17
	br label %again_2
break_2:
	%29 = load %Int32, %Int32* %17
	%30 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %29
	store %Char8 0, %Char8* %30
	%31 = load %Int32, %Int32* %17
	ret %Int32 %31
}


