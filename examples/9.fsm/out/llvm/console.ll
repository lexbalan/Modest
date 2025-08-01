
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
%Size = type i64
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
%File = type {
};

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
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
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
; -- endstrings --; lightfood/console.m

;pragma do_not_include; for Int; for write(); for putchar(); for strlen, strcpy
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



;
; puts
;


;
;// проблема тк puts уже определен в include ^^
;public func puts(s: *Str8) -> Unit {
;	puts8(s)
;}
;
define void @console_puts8(%Str8* %s) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = bitcast %Nat32 %2 to %Nat32
	%4 = getelementptr %Str8, %Str8* %s, %Int32 0, %Nat32 %3
	%5 = load %Char8, %Char8* %4
; if_0
	%6 = icmp eq %Char8 %5, 0
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @console_putchar_utf8(%Char8 %5)
	%8 = load %Nat32, %Nat32* %1
	%9 = add %Nat32 %8, 1
	store %Nat32 %9, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_puts16(%Str16* %s) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	; нельзя просто так взять и вызвать putchar_utf16
	; тк в строке может быть суррогатная пара UTF_16 символов
	%2 = load %Nat32, %Nat32* %1
	%3 = bitcast %Nat32 %2 to %Nat32
	%4 = getelementptr %Str16, %Str16* %s, %Int32 0, %Nat32 %3
	%5 = load %Char16, %Char16* %4
; if_0
	%6 = icmp eq %Char16 %5, 0
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%8 = alloca %Char32, align 4
	%9 = load %Nat32, %Nat32* %1
	%10 = bitcast %Nat32 %9 to %Nat32
	%11 = getelementptr %Str16, %Str16* %s, %Int32 0, %Nat32 %10
	%12 = bitcast %Char16* %11 to [0 x %Char16]*
	%13 = call %Nat8 @utf_utf16_to_utf32([0 x %Char16]* %12, %Char32* %8)
; if_1
	%14 = icmp eq %Nat8 %13, 0
	br %Bool %14 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%16 = load %Char32, %Char32* %8
	call void @console_putchar_utf32(%Char32 %16)
	%17 = zext %Nat8 %13 to %Nat32
	%18 = load %Nat32, %Nat32* %1
	%19 = add %Nat32 %18, %17
	store %Nat32 %19, %Nat32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_puts32(%Str32* %s) {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = bitcast %Nat32 %2 to %Nat32
	%4 = getelementptr %Str32, %Str32* %s, %Int32 0, %Nat32 %3
	%5 = load %Char32, %Char32* %4
; if_0
	%6 = icmp eq %Char32 %5, 0
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @console_putchar_utf32(%Char32 %5)
	%8 = load %Nat32, %Nat32* %1
	%9 = add %Nat32 %8, 1
	store %Nat32 %9, %Nat32* %1
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
	%2 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%4 = alloca %Char8, align 1
	%5 = load %Nat32, %Nat32* %2
	%6 = bitcast %Nat32 %5 to %Nat32
	%7 = getelementptr %Str8, %Str8* %form, %Int32 0, %Nat32 %6
	%8 = load %Char8, %Char8* %7
	store %Char8 %8, %Char8* %4
; if_0
	%9 = load %Char8, %Char8* %4
	%10 = icmp eq %Char8 %9, 0
	br %Bool %10 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
; if_1
	%12 = load %Char8, %Char8* %4
	%13 = icmp ne %Char8 %12, 123
	br %Bool %13 , label %then_1, label %endif_1
then_1:
; if_2
	%14 = load %Char8, %Char8* %4
	%15 = icmp eq %Char8 %14, 125
	br %Bool %15 , label %then_2, label %endif_2
then_2:
	%16 = load %Nat32, %Nat32* %2
	%17 = add %Nat32 %16, 1
	store %Nat32 %17, %Nat32* %2
	%18 = load %Nat32, %Nat32* %2
	%19 = bitcast %Nat32 %18 to %Nat32
	%20 = getelementptr %Str8, %Str8* %form, %Int32 0, %Nat32 %19
	%21 = load %Char8, %Char8* %20
	store %Char8 %21, %Char8* %4
; if_3
	%22 = load %Char8, %Char8* %4
	%23 = icmp eq %Char8 %22, 125
	br %Bool %23 , label %then_3, label %endif_3
then_3:
	%24 = load %Int32, %Int32* %3
	%25 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %24
	%26 = load %Char8, %Char8* %4
	store %Char8 %26, %Char8* %25
	%27 = load %Int32, %Int32* %3
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %3
	%29 = load %Nat32, %Nat32* %2
	%30 = add %Nat32 %29, 1
	store %Nat32 %30, %Nat32* %2
	br label %endif_3
endif_3:
	br label %again_1
	br label %endif_2
endif_2:
	%32 = load %Int32, %Int32* %3
	%33 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %32
	%34 = load %Char8, %Char8* %4
	store %Char8 %34, %Char8* %33
	%35 = load %Int32, %Int32* %3
	%36 = add %Int32 %35, 1
	store %Int32 %36, %Int32* %3
	%37 = load %Nat32, %Nat32* %2
	%38 = add %Nat32 %37, 1
	store %Nat32 %38, %Nat32* %2
	br label %again_1
	br label %endif_1
endif_1:

	; c == '{'
	%40 = load %Nat32, %Nat32* %2
	%41 = add %Nat32 %40, 1
	store %Nat32 %41, %Nat32* %2
	%42 = load %Nat32, %Nat32* %2
	%43 = bitcast %Nat32 %42 to %Nat32
	%44 = getelementptr %Str8, %Str8* %form, %Int32 0, %Nat32 %43
	%45 = load %Char8, %Char8* %44
	store %Char8 %45, %Char8* %4
; if_4
	%46 = load %Char8, %Char8* %4
	%47 = icmp eq %Char8 %46, 123
	br %Bool %47 , label %then_4, label %endif_4
then_4:
	%48 = load %Int32, %Int32* %3
	%49 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %48
	store %Char8 123, %Char8* %49
	%50 = load %Int32, %Int32* %3
	%51 = add %Int32 %50, 1
	store %Int32 %51, %Int32* %3
	%52 = load %Nat32, %Nat32* %2
	%53 = add %Nat32 %52, 1
	store %Nat32 %53, %Nat32* %2
	br label %again_1
	br label %endif_4
endif_4:
	%55 = load %Nat32, %Nat32* %2
	%56 = add %Nat32 %55, 2
	store %Nat32 %56, %Nat32* %2
	%57 = load %Int32, %Int32* %3
	%58 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %57
;
	%59 = bitcast %Char8* %58 to [0 x %Char8]*
; if_5
	%60 = load %Char8, %Char8* %4
	%61 = icmp eq %Char8 %60, 105
	%62 = load %Char8, %Char8* %4
	%63 = icmp eq %Char8 %62, 100
	%64 = or %Bool %61, %63
	br %Bool %64 , label %then_5, label %else_5
then_5:
	;
	; %i & %d for signed integer (Int)
	;
	%65 = va_arg %__VA_List* %1, %Int32
	%66 = call %Int32 @sprint_dec_int32([0 x %Char8]* %59, %Int32 %65)
	%67 = load %Int32, %Int32* %3
	%68 = add %Int32 %67, %66
	store %Int32 %68, %Int32* %3
	br label %endif_5
else_5:
; if_6
	%69 = load %Char8, %Char8* %4
	%70 = icmp eq %Char8 %69, 110
	br %Bool %70 , label %then_6, label %else_6
then_6:
	;
	; %n for unsigned integer (Nat)
	;
	%71 = va_arg %__VA_List* %1, %Nat32
	%72 = call %Int32 @sprint_dec_n32([0 x %Char8]* %59, %Nat32 %71)
	%73 = load %Int32, %Int32* %3
	%74 = add %Int32 %73, %72
	store %Int32 %74, %Int32* %3
	br label %endif_6
else_6:
; if_7
	%75 = load %Char8, %Char8* %4
	%76 = icmp eq %Char8 %75, 120
	%77 = load %Char8, %Char8* %4
	%78 = icmp eq %Char8 %77, 112
	%79 = or %Bool %76, %78
	br %Bool %79 , label %then_7, label %else_7
then_7:
	;
	; %x for unsigned integer (Nat)
	; %p for pointers
	;
	%80 = va_arg %__VA_List* %1, %Nat32
	%81 = call %Int32 @sprint_hex_nat32([0 x %Char8]* %59, %Nat32 %80)
	%82 = load %Int32, %Int32* %3
	%83 = add %Int32 %82, %81
	store %Int32 %83, %Int32* %3
	br label %endif_7
else_7:
; if_8
	%84 = load %Char8, %Char8* %4
	%85 = icmp eq %Char8 %84, 115
	br %Bool %85 , label %then_8, label %else_8
then_8:
	;
	; %s pointer to string
	;
	%86 = va_arg %__VA_List* %1, %Str8*
	%87 = call [0 x %Char]* @strcpy([0 x %Char8]* %59, %Str8* %86)
	%88 = call %SizeT @strlen(%Str8* %86)
	%89 = trunc %SizeT %88 to %Int32
	%90 = load %Int32, %Int32* %3
	%91 = add %Int32 %90, %89
	store %Int32 %91, %Int32* %3
	br label %endif_8
else_8:
; if_9
	%92 = load %Char8, %Char8* %4
	%93 = icmp eq %Char8 %92, 99
	br %Bool %93 , label %then_9, label %endif_9
then_9:
	;
	; %c for char
	;
	%94 = va_arg %__VA_List* %1, %Char32
	%95 = bitcast [0 x %Char8]* %59 to [4 x %Char8]*
	%96 = call %Nat8 @utf_utf32_to_utf8(%Char32 %94, [4 x %Char8]* %95)
	%97 = sext %Nat8 %96 to %Int32
	%98 = load %Int32, %Int32* %3
	%99 = add %Int32 %98, %97
	store %Int32 %99, %Int32* %3
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
	%100 = load %Int32, %Int32* %3
	ret %Int32 %100
}

define internal %Char8 @n_to_dec_sym(%Nat8 %n) alwaysinline {
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
	%3 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %3
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
	%8 = load %Nat32, %Nat32* %3
	%9 = bitcast %Nat32 %8 to %Nat32
	%10 = getelementptr [8 x %Char8], [8 x %Char8]* %1, %Int32 0, %Nat32 %9
	%11 = trunc %Nat32 %5 to %Nat8
	%12 = call %Char8 @n_to_hex_sym(%Nat8 %11)
	store %Char8 %12, %Char8* %10
	%13 = load %Nat32, %Nat32* %3
	%14 = add %Nat32 %13, 1
	store %Nat32 %14, %Nat32* %3
; if_0
	%15 = load %Nat32, %Nat32* %2
	%16 = icmp eq %Nat32 %15, 0
	br %Bool %16 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:

	; mirroring into buffer
	%18 = alloca %Int32, align 4
	store %Int32 0, %Int32* %18
; while_2
	br label %again_2
again_2:
	%19 = load %Nat32, %Nat32* %3
	%20 = icmp ugt %Nat32 %19, 0
	br %Bool %20 , label %body_2, label %break_2
body_2:
	%21 = load %Nat32, %Nat32* %3
	%22 = sub %Nat32 %21, 1
	store %Nat32 %22, %Nat32* %3
	%23 = load %Int32, %Int32* %18
	%24 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %23
	%25 = load %Nat32, %Nat32* %3
	%26 = bitcast %Nat32 %25 to %Nat32
	%27 = getelementptr [8 x %Char8], [8 x %Char8]* %1, %Int32 0, %Nat32 %26
	%28 = load %Char8, %Char8* %27
	store %Char8 %28, %Char8* %24
	%29 = load %Int32, %Int32* %18
	%30 = add %Int32 %29, 1
	store %Int32 %30, %Int32* %18
	br label %again_2
break_2:
	%31 = load %Int32, %Int32* %18
	%32 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %31
	store %Char8 0, %Char8* %32
	%33 = load %Int32, %Int32* %18
	ret %Int32 %33
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
	%7 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %7
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
	%12 = load %Nat32, %Nat32* %7
	%13 = bitcast %Nat32 %12 to %Nat32
	%14 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Nat32 %13
	%15 = trunc %Int32 %9 to %Nat8
	%16 = call %Char8 @n_to_dec_sym(%Nat8 %15)
	store %Char8 %16, %Char8* %14
	%17 = load %Nat32, %Nat32* %7
	%18 = add %Nat32 %17, 1
	store %Nat32 %18, %Nat32* %7
; if_1
	%19 = load %Int32, %Int32* %2
	%20 = icmp eq %Int32 %19, 0
	br %Bool %20 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	br label %again_1
break_1:
	%22 = alloca %Int32, align 4
	store %Int32 0, %Int32* %22
; if_2
	br %Bool %4 , label %then_2, label %endif_2
then_2:
	%23 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 0
	store %Char8 45, %Char8* %23
	%24 = load %Int32, %Int32* %22
	%25 = add %Int32 %24, 1
	store %Int32 %25, %Int32* %22
	br label %endif_2
endif_2:
; while_2
	br label %again_2
again_2:
	%26 = load %Nat32, %Nat32* %7
	%27 = icmp ugt %Nat32 %26, 0
	br %Bool %27 , label %body_2, label %break_2
body_2:
	%28 = load %Nat32, %Nat32* %7
	%29 = sub %Nat32 %28, 1
	store %Nat32 %29, %Nat32* %7
	%30 = load %Int32, %Int32* %22
	%31 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %30
	%32 = load %Nat32, %Nat32* %7
	%33 = bitcast %Nat32 %32 to %Nat32
	%34 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Nat32 %33
	%35 = load %Char8, %Char8* %34
	store %Char8 %35, %Char8* %31
	%36 = load %Int32, %Int32* %22
	%37 = add %Int32 %36, 1
	store %Int32 %37, %Int32* %22
	br label %again_2
break_2:
	%38 = load %Int32, %Int32* %22
	%39 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %38
	store %Char8 0, %Char8* %39
	%40 = load %Int32, %Int32* %22
	ret %Int32 %40
}

define internal %Int32 @sprint_dec_n32([0 x %Char8]* %buf, %Nat32 %x) {
	%1 = alloca [11 x %Char8], align 1
	%2 = alloca %Nat32, align 4
	store %Nat32 %x, %Nat32* %2
	%3 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %3
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
	%8 = load %Nat32, %Nat32* %3
	%9 = bitcast %Nat32 %8 to %Nat32
	%10 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Nat32 %9
	%11 = trunc %Nat32 %5 to %Nat8
	%12 = call %Char8 @n_to_dec_sym(%Nat8 %11)
	store %Char8 %12, %Char8* %10
	%13 = load %Nat32, %Nat32* %3
	%14 = add %Nat32 %13, 1
	store %Nat32 %14, %Nat32* %3
; if_0
	%15 = load %Nat32, %Nat32* %2
	%16 = icmp eq %Nat32 %15, 0
	br %Bool %16 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%18 = alloca %Int32, align 4
	store %Int32 0, %Int32* %18
; while_2
	br label %again_2
again_2:
	%19 = load %Nat32, %Nat32* %3
	%20 = icmp ugt %Nat32 %19, 0
	br %Bool %20 , label %body_2, label %break_2
body_2:
	%21 = load %Nat32, %Nat32* %3
	%22 = sub %Nat32 %21, 1
	store %Nat32 %22, %Nat32* %3
	%23 = load %Int32, %Int32* %18
	%24 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %23
	%25 = load %Nat32, %Nat32* %3
	%26 = bitcast %Nat32 %25 to %Nat32
	%27 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Nat32 %26
	%28 = load %Char8, %Char8* %27
	store %Char8 %28, %Char8* %24
	%29 = load %Int32, %Int32* %18
	%30 = add %Int32 %29, 1
	store %Int32 %30, %Int32* %18
	br label %again_2
break_2:
	%31 = load %Int32, %Int32* %18
	%32 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %31
	store %Char8 0, %Char8* %32
	%33 = load %Int32, %Int32* %18
	ret %Int32 %33
}


