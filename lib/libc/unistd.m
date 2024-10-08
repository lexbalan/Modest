// libc/unistd.m
// thx: https://pubs.opengroup.org/onlinepubs/7908799/xsh/unistd.h.html

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "unistd.h"


include "libc/ctypes64"


//@attribute("extern")
//var environ: *[]*Char
export {
	@property("value.id.c", "SEEK_SET")
	let c_SEEK_SET = 0
	@property("value.id.c", "SEEK_CUR")
	let c_SEEK_CUR = 1
	@property("value.id.c", "SEEK_END")
	let c_SEEK_END = 2

	@property("value.id.c", "STDIN_FILENO")
	let c_STDIN_FILENO = 0
	@property("value.id.c", "STDOUT_FILENO")
	let c_STDOUT_FILENO = 1
	@property("value.id.c", "STDERR_FILENO")
	let c_STDERR_FILENO = 2


	// lockf function - record locking on files
	@property("value.id.c", "F_ULOCK")
	let c_F_ULOCK = 0  // unlock locked sections
	@property("value.id.c", "F_LOCK")
	let c_F_LOCK = 1   // lock a section for exclusive use
	@property("value.id.c", "F_TLOCK")
	let c_F_TLOCK = 2  // test and lock a section for exclusive use
	@property("value.id.c", "F_TEST")
	let c_F_TEST = 3

	@property("value.id.c", "F_OK")
	let c_F_OK = 0  // Test for existence of file
	@property("value.id.c", "R_OK")
	let c_R_OK = 4  // Test for read permission
	@property("value.id.c", "W_OK")
	let c_W_OK = 2  // Test for write permission
	@property("value.id.c", "X_OK")
	let c_X_OK = 1  // Test for execute (search) permission



	/*
	 *  sysconf values per IEEE Std 1003.1, 2008 Edition
	 */
	let _unistd_SC_ARG_MAX = 0
	let _unistd_SC_CHILD_MAX = 1
	let _unistd_SC_CLK_TCK = 2
	let _unistd_SC_NGROUPS_MAX = 3
	let _unistd_SC_OPEN_MAX = 4
	let _unistd_SC_JOB_CONTROL = 5
	let _unistd_SC_SAVED_IDS = 6
	let _unistd_SC_VERSION = 7
	let _unistd_SC_PAGESIZE = 8
	let _unistd_SC_PAGE_SIZE = _unistd_SC_PAGESIZE
	/* These are non-POSIX values we accidentally introduced in 2000 without
	   guarding them.  Keeping them unguarded for backward compatibility. */
	let _unistd_SC_NPROCESSORS_CONF = 9
	let _unistd_SC_NPROCESSORS_ONLN = 10
	let _unistd_SC_PHYS_PAGES = 11
	let _unistd_SC_AVPHYS_PAGES = 12
	/* End of non-POSIX values. */
	let _unistd_SC_MQ_OPEN_MAX = 13
	let _unistd_SC_MQ_PRIO_MAX = 14
	let _unistd_SC_RTSIG_MAX = 15
	let _unistd_SC_SEM_NSEMS_MAX = 16
	let _unistd_SC_SEM_VALUE_MAX = 17
	let _unistd_SC_SIGQUEUE_MAX = 18
	let _unistd_SC_TIMER_MAX = 19
	let _unistd_SC_TZNAME_MAX = 20
	let _unistd_SC_ASYNCHRONOUS_IO = 21
	let _unistd_SC_FSYNC = 22
	let _unistd_SC_MAPPED_FILES = 23
	let _unistd_SC_MEMLOCK = 24
	let _unistd_SC_MEMLOCK_RANGE = 25
	let _unistd_SC_MEMORY_PROTECTION = 26
	let _unistd_SC_MESSAGE_PASSING = 27
	let _unistd_SC_PRIORITIZED_IO = 28
	let _unistd_SC_REALTIME_SIGNALS = 29
	let _unistd_SC_SEMAPHORES = 30
	let _unistd_SC_SHARED_MEMORY_OBJECTS = 31
	let _unistd_SC_SYNCHRONIZED_IO = 32
	let _unistd_SC_TIMERS = 33
	let _unistd_SC_AIO_LISTIO_MAX = 34
	let _unistd_SC_AIO_MAX = 35
	let _unistd_SC_AIO_PRIO_DELTA_MAX = 36
	let _unistd_SC_DELAYTIMER_MAX = 37
	let _unistd_SC_THREAD_KEYS_MAX = 38
	let _unistd_SC_THREAD_STACK_MIN = 39
	let _unistd_SC_THREAD_THREADS_MAX = 40
	let _unistd_SC_TTY_NAME_MAX = 41
	let _unistd_SC_THREADS = 42
	let _unistd_SC_THREAD_ATTR_STACKADDR = 43
	let _unistd_SC_THREAD_ATTR_STACKSIZE = 44
	let _unistd_SC_THREAD_PRIORITY_SCHEDULING = 45
	let _unistd_SC_THREAD_PRIO_INHERIT = 46
	/* _unistd_SC_THREAD_PRIO_PROTECT was _unistd_SC_THREAD_PRIO_CEILING in early drafts */
	let _unistd_SC_THREAD_PRIO_PROTECT = 47
	let _unistd_SC_THREAD_PRIO_CEILING = _unistd_SC_THREAD_PRIO_PROTECT
	let _unistd_SC_THREAD_PROCESS_SHARED = 48
	let _unistd_SC_THREAD_SAFE_FUNCTIONS = 49
	let _unistd_SC_GETGR_R_SIZE_MAX = 50
	let _unistd_SC_GETPW_R_SIZE_MAX = 51
	let _unistd_SC_LOGIN_NAME_MAX = 52
	let _unistd_SC_THREAD_DESTRUCTOR_ITERATIONS = 53
	let _unistd_SC_ADVISORY_INFO = 54
	let _unistd_SC_ATEXIT_MAX = 55
	let _unistd_SC_BARRIERS = 56
	let _unistd_SC_BC_BASE_MAX = 57
	let _unistd_SC_BC_DIM_MAX = 58
	let _unistd_SC_BC_SCALE_MAX = 59
	let _unistd_SC_BC_STRING_MAX = 60
	let _unistd_SC_CLOCK_SELECTION = 61
	let _unistd_SC_COLL_WEIGHTS_MAX = 62
	let _unistd_SC_CPUTIME = 63
	let _unistd_SC_EXPR_NEST_MAX = 64
	let _unistd_SC_HOST_NAME_MAX = 65
	let _unistd_SC_IOV_MAX = 66
	let _unistd_SC_IPV6 = 67
	let _unistd_SC_LINE_MAX = 68
	let _unistd_SC_MONOTONIC_CLOCK = 69
	let _unistd_SC_RAW_SOCKETS = 70
	let _unistd_SC_READER_WRITER_LOCKS = 71
	let _unistd_SC_REGEXP = 72
	let _unistd_SC_RE_DUP_MAX = 73
	let _unistd_SC_SHELL = 74
	let _unistd_SC_SPAWN = 75
	let _unistd_SC_SPIN_LOCKS = 76
	let _unistd_SC_SPORADIC_SERVER = 77
	let _unistd_SC_SS_REPL_MAX = 78
	let _unistd_SC_SYMLOOP_MAX = 79
	let _unistd_SC_THREAD_CPUTIME = 80
	let _unistd_SC_THREAD_SPORADIC_SERVER = 81
	let _unistd_SC_TIMEOUTS = 82
	let _unistd_SC_TRACE = 83
	let _unistd_SC_TRACE_EVENT_FILTER = 84
	let _unistd_SC_TRACE_EVENT_NAME_MAX = 85
	let _unistd_SC_TRACE_INHERIT = 86
	let _unistd_SC_TRACE_LOG = 87
	let _unistd_SC_TRACE_NAME_MAX = 88
	let _unistd_SC_TRACE_SYS_MAX = 89
	let _unistd_SC_TRACE_USER_EVENT_MAX = 90
	let _unistd_SC_TYPED_MEMORY_OBJECTS = 91
	let _unistd_SC_V7_ILP32_OFF32 = 92
	let _unistd_SC_V6_ILP32_OFF32 = _unistd_SC_V7_ILP32_OFF32
	let _unistd_SC_XBS5_ILP32_OFF32 = _unistd_SC_V7_ILP32_OFF32
	let _unistd_SC_V7_ILP32_OFFBIG = 93
	let _unistd_SC_V6_ILP32_OFFBIG = _unistd_SC_V7_ILP32_OFFBIG
	let _unistd_SC_XBS5_ILP32_OFFBIG = _unistd_SC_V7_ILP32_OFFBIG
	let _unistd_SC_V7_LP64_OFF64 = 94
	let _unistd_SC_V6_LP64_OFF64 = _unistd_SC_V7_LP64_OFF64
	let _unistd_SC_XBS5_LP64_OFF64 = _unistd_SC_V7_LP64_OFF64
	let _unistd_SC_V7_LPBIG_OFFBIG = 95
	let _unistd_SC_V6_LPBIG_OFFBIG = _unistd_SC_V7_LPBIG_OFFBIG
	let _unistd_SC_XBS5_LPBIG_OFFBIG = _unistd_SC_V7_LPBIG_OFFBIG
	let _unistd_SC_XOPEN_CRYPT = 96
	let _unistd_SC_XOPEN_ENH_I18N = 97
	let _unistd_SC_XOPEN_LEGACY = 98
	let _unistd_SC_XOPEN_REALTIME = 99
	let _unistd_SC_STREAM_MAX = 100
	let _unistd_SC_PRIORITY_SCHEDULING = 101
	let _unistd_SC_XOPEN_REALTIME_THREADS = 102
	let _unistd_SC_XOPEN_SHM = 103
	let _unistd_SC_XOPEN_STREAMS = 104
	let _unistd_SC_XOPEN_UNIX = 105
	let _unistd_SC_XOPEN_VERSION = 106
	let _unistd_SC_2_CHAR_TERM = 107
	let _unistd_SC_2_C_BIND = 108
	let _unistd_SC_2_C_DEV = 109
	let _unistd_SC_2_FORT_DEV = 110
	let _unistd_SC_2_FORT_RUN = 111
	let _unistd_SC_2_LOCALEDEF = 112
	let _unistd_SC_2_PBS = 113
	let _unistd_SC_2_PBS_ACCOUNTING = 114
	let _unistd_SC_2_PBS_CHECKPOINT = 115
	let _unistd_SC_2_PBS_LOCATE = 116
	let _unistd_SC_2_PBS_MESSAGE = 117
	let _unistd_SC_2_PBS_TRACK = 118
	let _unistd_SC_2_SW_DEV = 119
	let _unistd_SC_2_UPE = 120
	let _unistd_SC_2_VERSION = 121
	let _unistd_SC_THREAD_ROBUST_PRIO_INHERIT = 122
	let _unistd_SC_THREAD_ROBUST_PRIO_PROTECT = 123
	let _unistd_SC_XOPEN_UUCP = 124
	let _unistd_SC_LEVEL1_ICACHE_SIZE = 125
	let _unistd_SC_LEVEL1_ICACHE_ASSOC = 126
	let _unistd_SC_LEVEL1_ICACHE_LINESIZE = 127
	let _unistd_SC_LEVEL1_DCACHE_SIZE = 128
	let _unistd_SC_LEVEL1_DCACHE_ASSOC = 129
	let _unistd_SC_LEVEL1_DCACHE_LINESIZE = 130
	let _unistd_SC_LEVEL2_CACHE_SIZE = 131
	let _unistd_SC_LEVEL2_CACHE_ASSOC = 132
	let _unistd_SC_LEVEL2_CACHE_LINESIZE = 133
	let _unistd_SC_LEVEL3_CACHE_SIZE = 134
	let _unistd_SC_LEVEL3_CACHE_ASSOC = 135
	let _unistd_SC_LEVEL3_CACHE_LINESIZE = 136
	let _unistd_SC_LEVEL4_CACHE_SIZE = 137
	let _unistd_SC_LEVEL4_CACHE_ASSOC = 138
	let _unistd_SC_LEVEL4_CACHE_LINESIZE = 139
	let _unistd_SC_POSIX_26_VERSION = 140

	/*
	 *  pathconf values per IEEE Std 1003.1, 2008 Edition
	 */
	let _unistd_PC_LINK_MAX = 0
	let _unistd_PC_MAX_CANON = 1
	let _unistd_PC_MAX_INPUT = 2
	let _unistd_PC_NAME_MAX = 3
	let _unistd_PC_PATH_MAX = 4
	let _unistd_PC_PIPE_BUF = 5
	let _unistd_PC_CHOWN_RESTRICTED = 6
	let _unistd_PC_NO_TRUNC = 7
	let _unistd_PC_VDISABLE = 8
	let _unistd_PC_ASYNC_IO = 9
	let _unistd_PC_PRIO_IO = 10
	let _unistd_PC_SYNC_IO = 11
	let _unistd_PC_FILESIZEBITS = 12
	let _unistd_PC_2_SYMLINKS = 13
	let _unistd_PC_SYMLINK_MAX = 14
	let _unistd_PC_ALLOC_SIZE_MIN = 15
	let _unistd_PC_REC_INCR_XFER_SIZE = 16
	let _unistd_PC_REC_MAX_XFER_SIZE = 17
	let _unistd_PC_REC_MIN_XFER_SIZE = 18
	let _unistd_PC_REC_XFER_ALIGN = 19
	let _unistd_PC_TIMESTAMP_RESOLUTION = 20

	//$if defined("__CYGWIN__")
	///* Ask for POSIX permission bits support. */
	//let _unistd_PC_POSIX_PERMISSIONS = 90
	///* Ask for full POSIX permission support including uid/gid settings. */
	//let _unistd_PC_POSIX_SECURITY = 91
	//let _unistd_PC_CASE_INSENSITIVE = 92
	//$endif

	/*
	 *  confstr values per IEEE Std 1003.1, 2004 Edition
	 */
	/* Only defined on Cygwin for now. */
	//$if defined("__CYGWIN__")
	let _unistd_CS_PATH = 0
	let _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS = 1
	let _unistd_CS_POSIX_V6_ILP32_OFF32_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS
	let _unistd_CS_XBS5_ILP32_OFF32_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS
	let _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS = 2
	let _unistd_CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS
	let _unistd_CS_XBS5_ILP32_OFF32_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS
	let _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS = 3
	let _unistd_CS_POSIX_V6_ILP32_OFF32_LIBS = _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS
	let _unistd_CS_XBS5_ILP32_OFF32_LIBS = _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS
	let _unistd_CS_XBS5_ILP32_OFF32_LINTFLAGS = 4
	let _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = 5
	let _unistd_CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS
	let _unistd_CS_XBS5_ILP32_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS
	let _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = 6
	let _unistd_CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS
	let _unistd_CS_XBS5_ILP32_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS
	let _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS = 7
	let _unistd_CS_POSIX_V6_ILP32_OFFBIG_LIBS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS
	let _unistd_CS_XBS5_ILP32_OFFBIG_LIBS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS
	let _unistd_CS_XBS5_ILP32_OFFBIG_LINTFLAGS = 8
	let _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS = 9
	let _unistd_CS_POSIX_V6_LP64_OFF64_CFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS
	let _unistd_CS_XBS5_LP64_OFF64_CFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS
	let _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS = 10
	let _unistd_CS_POSIX_V6_LP64_OFF64_LDFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS
	let _unistd_CS_XBS5_LP64_OFF64_LDFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS
	let _unistd_CS_POSIX_V7_LP64_OFF64_LIBS = 11
	let _unistd_CS_POSIX_V6_LP64_OFF64_LIBS = _unistd_CS_POSIX_V7_LP64_OFF64_LIBS
	let _unistd_CS_XBS5_LP64_OFF64_LIBS = _unistd_CS_POSIX_V7_LP64_OFF64_LIBS
	let _unistd_CS_XBS5_LP64_OFF64_LINTFLAGS = 12
	let _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = 13
	let _unistd_CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS
	let _unistd_CS_XBS5_LPBIG_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS
	let _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = 14
	let _unistd_CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS
	let _unistd_CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS
	let _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS = 15
	let _unistd_CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS
	let _unistd_CS_XBS5_LPBIG_OFFBIG_LIBS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS
	let _unistd_CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = 16
	let _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS = 17
	let _unistd_CS_POSIX_V6_WIDTH_RESTRICTED_ENVS = _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS
	let _unistd_CS_XBS5_WIDTH_RESTRICTED_ENVS = _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS
	let _unistd_CS_POSIX_V7_THREADS_CFLAGS = 18
	let _unistd_CS_POSIX_V7_THREADS_LDFLAGS = 19
	let _unistd_CS_V7_ENV = 20
	let _unistd_CS_V6_ENV = _unistd_CS_V7_ENV
	let _unistd_CS_LFS_CFLAGS = 21
	let _unistd_CS_LFS_LDFLAGS = 22
	let _unistd_CS_LFS_LIBS = 23
	let _unistd_CS_LFS_LINTFLAGS = 24
	//$endif



	// access - determine accessibility of a file
	func access (path: *[]ConstChar, amode: Int) -> Int

	// alarm - schedule an alarm signal
	func alarm (seconds: UnsignedInt) -> UnsignedInt

	// brk, sbrk - change data segment size
	func brk (end_data_segment: Ptr) -> Int

	// chdir - change working directory
	func chdir (path: *[]ConstChar) -> Int

	// chroot - change root directory (LEGACY)
	func chroot (path: *[]ConstChar) -> Int

	// chown — change the owner or group of a file or directory
	func chown (pathname: *[]ConstChar, owner: UIDT, group: GIDT) -> Int

	// close - close a file descriptor
	func close (fildes: Int) -> Int

	// confstr - get configurable variables
	func confstr (name: Int, buf: *[]Char, len: SizeT) -> SizeT

	// crypt - string encoding function
	func crypt (key: *[]ConstChar, salt: *[]ConstChar) -> *[]Char

	// ctermid - generate a pathname for the controlling terminal
	func ctermid (s: *[]Char) -> *[]Char

	// cuserid - character login name of the user (LEGACY)
	// not implemented on MacOS!
	func cuserid (s: *[]Char) -> *[]Char

	// dup, dup2 - duplicate an open file descriptor
	func dup (fildes: Int) -> Int

	// dup, dup2 - duplicate an open file descriptor
	func dup2 (fildes: Int, fildes2: Int) -> Int

	// encrypt - encoding function
	func encrypt (block: *[64]Char, edflag: Int) -> Unit

	//
	func execl (path: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
	func execle (path: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
	func execlp (file: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
	func execv (path: *[]ConstChar, argv: *[]ConstChar) -> Int
	func execve (path: *[]ConstChar, argv: *[]ConstChar, envp: *[]ConstChar) -> Int
	func execvp (file: *[]ConstChar, argv: *[]ConstChar) -> Int

	// _exit - terminate a process
	func _exit (status: Int) -> Unit

	// fchown - change owner and group of a file
	func fchown (fildes: Int, owner: UIDT, group: GIDT) -> Int

	// fchdir - change working directory
	func fchdir (fildes: Int) -> Int

	// fdatasync - synchronise the data of a file (REALTIME)
	func fdatasync (fildes: Int) -> Int

	// fork - create a new process
	func fork () -> PIDT

	// fpathconf, pathconf - get configurable pathname variables
	func fpathconf (fildes: Int, name: Int) -> LongInt

	// fsync - synchronise changes to a file
	func fsync (fildes: Int) -> Int

	// ftruncate, truncate - truncate a file to a specified length
	func ftruncate (fildes: Int, length: OffT) -> Int

	// getcwd - get the pathname of the current working directory
	func getcwd (buf: *[]Char, size: SizeT) -> *[]Char

	// getdtablesize - get the file descriptor table size (LEGACY)
	func getdtablesize () -> Int

	// getegid - get the effective group ID
	func getegid () -> GIDT

	// geteuid - get the effective user ID
	func geteuid () -> UIDT

	// getgid - get the real group ID
	func getgid () -> GIDT

	// getgroups - get supplementary group IDs
	func getgroups (gidsetsize: Int, grouplist: *[]GIDT) -> Int

	// gethostid - get an identifier for the current host
	func gethostid () -> Long

	// getlogin - get login name
	func getlogin () -> *[]Char

	// getlogin_r - get login name
	func getlogin_r (name: *[]Char, namesize: SizeT) -> Int

	// getopt, optarg, optind, opterr, optopt - command option parsing
	func getopt (argc: Int, argv: *[]ConstChar, optstring: *[]ConstChar) -> Int

	// getpagesize - get the current page size (LEGACY)
	func getpagesize () -> Int

	// getpass - read a string of characters without echo (LEGACY)
	func getpass (prompt: *[]ConstChar) -> *[]Char

	// getpgid - get the process group ID for a process
	func getpgid (pid: PIDT) -> PIDT

	// getpgrp - get the process group ID of the calling process
	func getpgrp () -> PIDT

	// getpid - get the process ID
	func getpid () -> PIDT

	// getppid - get the parent process ID
	func getppid () -> PIDT

	// getsid - get the process group ID of session leader
	func getsid (pid: PIDT) -> PIDT

	// getuid - get a real user ID
	func getuid () -> UIDT

	// getwd - get the current working directory pathname
	func getwd (path_name: *[]Char) -> *[]Char

	// isatty - test for a terminal device
	func isatty (fildes: Int) -> Int

	// lchown - change the owner and group of a symbolic link
	func lchown (path: *[]ConstChar, owner: UIDT, group: GIDT) -> Int

	// link - link to a file
	func link (path1: *[]ConstChar, path2: *[]ConstChar) -> Int

	// lockf - record locking on files
	func lockf (fildes: Int, function: Int, size: OffT) -> Int

	// lseek - move the read/write file offset
	func lseek (fildes: Int, offset: OffT, whence: Int) -> OffT

	// nice - change nice value of a process
	func nice (incr: Int) -> Int

	// pathconf - get configurable pathname variables
	func pathconf (path: *[]ConstChar, name: Int) -> LongInt

	// pause - suspend the thread until signal is received
	func pause () -> Int

	// pipe - create an interprocess channel
	func pipe (fildes: *[2]Int) -> Int

	// pread - read from a file
	func pread (fildes: Int, buf: Ptr, nbyte: SizeT, offset: OffT) -> SSizeT

	// pthread_atfork - register fork handlers
	func pthread_atfork (prepare: *()->Unit, parent: *()->Unit, child: *()->Unit) -> Int

	// pwrite - write on a file
	func pwrite (fildes: Int, buf: Ptr, nbyte: SizeT, offset: OffT) -> SSizeT

	// read, readv, pread - read from a file
	func read (fildes: Int, buf: Ptr, nbyte: SizeT) -> SSizeT

	// readlink - read the contents of a symbolic link
	func readlink (path: *[]ConstChar, buf: *[]Char, bufsize: SizeT) -> Int

	// rmdir - remove a directory
	func rmdir (path: *[]ConstChar) -> Int

	// sbrk - change space allocation
	func sbrk (incr: IntPtrT) -> Ptr

	// setgid - set-group-ID
	func setgid (gid: GIDT) -> Int

	// setpgid - set process group ID for job control
	func setpgid (pid: PIDT, pgid: PIDT) -> Int

	// setpgrp - set process group ID
	func setpgrp () -> PIDT

	// setregid - set real and effective group IDs
	func setregid (rgid: GIDT, egid: GIDT) -> Int

	// setreuid - set real and effective user IDs
	func setreuid (ruid: UIDT, euid: UIDT) -> Int

	// setsid - create session and set process group ID
	func setsid () -> PIDT

	// setuid - set-user-ID
	func setuid (uid: UIDT) -> Int

	// sleep - suspend execution for an interval of time
	@unused_result
	func sleep (seconds: UnsignedInt) -> UnsignedInt

	// swab - swap bytes
	func swab (src: Ptr, dst: Ptr, nbytes: SSizeT) -> Unit

	// symlink - make symbolic link to a file
	func symlink (path1: *[]ConstChar, path2: *[]ConstChar) -> Int

	// sync - schedule filesystem updates
	func sync () -> Unit

	// sysconf - get configurable system variables
	func sysconf (name: Int) -> LongInt

	// tcgetpgrp - get the foreground process group ID
	func tcgetpgrp (fildes: Int) -> PIDT

	// tcsetpgrp - set the foreground process group ID
	func tcsetpgrp (fildes: Int, pgid_id: PIDT) -> Int

	// truncate - truncate a file to a specified length
	func truncate (path: *[]ConstChar, length: OffT) -> Int

	// ttyname - find pathname of a terminal
	func ttyname (fildes: Int) -> *[]Char

	// ttyname_r - find pathname of a terminal
	func ttyname_r (fildes: Int, name: *[]Char, namesize: SizeT) -> Int

	// ualarm - set the interval timer
	func ualarm (useconds: USecondsT, interval: USecondsT) -> USecondsT

	// unlink - remove a directory entry
	func unlink (path: *[]ConstChar) -> Int

	// usleep - suspend execution for an interval
	func usleep (useconds: USecondsT) -> Int

	// vfork - create new process; share virtual memory
	func vfork () -> PIDT

	// write, writev, pwrite - write on a file
	@unused_result
	func write (fildes: Int, buf: Ptr, nbyte: SizeT) -> SSizeT
}

