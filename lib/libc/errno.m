/*
 * libc/errno.m
 */

pragma module_nodecorate


/*
 * Error codes
 */
@set("id.c", "EPERM")
public const c_EPERM = 1     // Operation not permitted
@set("id.c", "ENOENT")
public const c_ENOENT = 2    // No such file or directory
@set("id.c", "ESRCH")
public const c_ESRCH = 3     // No such process
@set("id.c", "EINTR")
public const c_EINTR = 4     // Interrupted system call
@set("id.c", "EIO")
public const c_EIO = 5       // Input/output error
@set("id.c", "ENXIO")
public const c_ENXIO = 6     // Device not configured
@set("id.c", "E2BIG")
public const c_E2BIG = 7     // Argument list too long
@set("id.c", "ENOEXEC")
public const c_ENOEXEC = 8   // Exec format error
@set("id.c", "EBADF")
public const c_EBADF = 9     // Bad file descriptor
@set("id.c", "ECHILD")
public const c_ECHILD = 10   // No child processes
@set("id.c", "EDEADLK")
public const c_EDEADLK = 11  // Resource deadlock avoided (11 was EAGAIN)
@set("id.c", "ENOMEM")
public const c_ENOMEM = 12   // Cannot allocate memory
@set("id.c", "EACCES")
public const c_EACCES = 13   // Permission denied
@set("id.c", "EFAULT")
public const c_EFAULT = 14   // Bad address
@set("id.c", "ENOTBLK")
public const c_ENOTBLK = 15  // Block device required
@set("id.c", "EBUSY")
public const c_EBUSY = 16    // Device / Resource busy
@set("id.c", "EEXIST")
public const c_EEXIST = 17   // File exists
@set("id.c", "EXDEV")
public const c_EXDEV = 18    // Cross-device link
@set("id.c", "ENODEV")
public const c_ENODEV = 19   // Operation not supported by device
@set("id.c", "ENOTDIR")
public const c_ENOTDIR = 20  // Not a directory
@set("id.c", "EISDIR")
public const c_EISDIR = 21   // Is a directory
@set("id.c", "EINVAL")
public const c_EINVAL = 22   // Invalid argument
@set("id.c", "ENFILE")
public const c_ENFILE = 23   // Too many open files in system
@set("id.c", "EMFILE")
public const c_EMFILE = 24   // Too many open files
@set("id.c", "ENOTTY")
public const c_ENOTTY = 25   // Inappropriate ioctl for device
@set("id.c", "ETXTBSY")
public const c_ETXTBSY = 26  // Text file busy
@set("id.c", "EFBIG")
public const c_EFBIG = 27    // File too large
@set("id.c", "ENOSPC")
public const c_ENOSPC = 28   // No space left on device
@set("id.c", "ESPIPE")
public const c_ESPIPE = 29   // Illegal seek
@set("id.c", "EROFS")
public const c_EROFS = 30    // Read-only file system
@set("id.c", "EMLINK")
public const c_EMLINK = 31   // Too many links
@set("id.c", "EPIPE")
public const c_EPIPE = 32    // Broken pipe
@set("id.c", "EDOM")
public const c_EDOM = 33     // Numerical argument out of domain
@set("id.c", "ERANGE")
public const c_ERANGE = 34   // Result too large

/* non-blocking and interrupt i/o */
@set("id.c", "EAGAIN")
public const c_EAGAIN = 35           // Resource temporarily unavailable
@set("id.c", "EWOULDBLOCK")
public const c_EWOULDBLOCK = eAGAIN  // Operation would block
@set("id.c", "EINPROGRESS")
public const c_EINPROGRESS = 36      // Operation now in progress
@set("id.c", "EALREADY")
public const c_EALREADY = 37         // Operation already in progress

/* ipc/network software -- argument errors */
@set("id.c", "ENOTSOCK")
public const c_ENOTSOCK = 38         // Socket operation on non-socket
@set("id.c", "EDESTADDRREQ")
public const c_EDESTADDRREQ = 39     // Destination address required
@set("id.c", "EMSGSIZE")
public const c_EMSGSIZE = 40         // Message too long
@set("id.c", "EPROTOTYPE")
public const c_EPROTOTYPE = 41       // Protocol wrong type for socket
@set("id.c", "ENOPROTOOPT")
public const c_ENOPROTOOPT = 42      // Protocol not available
@set("id.c", "EPROTONOSUPPORT")
public const c_EPROTONOSUPPORT = 43  // Protocol not supported
@set("id.c", "ESOCKTNOSUPPORT")
public const c_ESOCKTNOSUPPORT = 44  // Socket type not supported
@set("id.c", "ENOTSUP")
public const c_ENOTSUP = 45          // Operation not supported
@set("id.c", "EPFNOSUPPORT")
public const c_EPFNOSUPPORT = 46     // Protocol family not supported
@set("id.c", "EAFNOSUPPORT")
public const c_EAFNOSUPPORT = 47     // Address family not supported by protocol family
@set("id.c", "EADDRINUSE")
public const c_EADDRINUSE = 48       // Address already in use
@set("id.c", "EADDRNOTAVAIL")
public const c_EADDRNOTAVAIL = 49    // Can't assign requested address

/* ipc/network software -- operational errors */
@set("id.c", "ENETDOWN")
public const c_ENETDOWN = 50         // Network is down
@set("id.c", "ENETUNREACH")
public const c_ENETUNREACH = 51      // Network is unreachable
@set("id.c", "ENETRESET")
public const c_ENETRESET = 52        // Network dropped connection on reset
@set("id.c", "ECONNABORTED")
public const c_ECONNABORTED = 53     // Software caused connection abort
@set("id.c", "ECONNRESET")
public const c_ECONNRESET = 54       // Connection reset by peer
@set("id.c", "ENOBUFS")
public const c_ENOBUFS = 55          // No buffer space available
@set("id.c", "EISCONN")
public const c_EISCONN = 56          // Socket is already connected
@set("id.c", "ENOTCONN")
public const c_ENOTCONN = 57         // Socket is not connected
@set("id.c", "ESHUTDOWN")
public const c_ESHUTDOWN = 58        // Can't send after socket shutdown
@set("id.c", "ETOOMANYREFS")
public const c_ETOOMANYREFS = 59     // Too many references: can't splice
@set("id.c", "ETIMEDOUT")
public const c_ETIMEDOUT = 60        // Operation timed out
@set("id.c", "ECONNREFUSED")
public const c_ECONNREFUSED = 61     // Connection refused
@set("id.c", "ELOOP")
public const c_ELOOP = 62            // Too many levels of symbolic links
@set("id.c", "ENAMETOOLONG")
public const c_ENAMETOOLONG = 63     // File name too long

/* should be rearranged */
@set("id.c", "EHOSTDOWN")
public const c_EHOSTDOWN = 64        // Host is down
@set("id.c", "EHOSTUNREACH")
public const c_EHOSTUNREACH = 65     // No route to host
@set("id.c", "ENOTEMPTY")
public const c_ENOTEMPTY = 66        // Directory not empty

/* quotas & mush */
//public const c_EPROCLIM = 67  // Too many processes
//public const c_EUSERS = 68    // Too many users
@set("id.c", "EDQUOT")
public const c_EDQUOT = 69           // Disc quota exceeded

/* Network File System */
@set("id.c", "ESTALE")
public const c_ESTALE = 70           // Stale NFS file handle
//public const c_EREMOTE = 71  // Too many levels of remote in path
//public const c_EBADRPC = 72  // RPC struct is bad
//public const c_ERPCMISMATCH = 73   // RPC version wrong
//public const c_EPROGUNAVAIL = 74   // RPC prog. not avail
//public const c_EPROGMISMATCH = 75  // Program version wrong
//public const c_EPROCUNAVAIL = 76   // Bad procedure for program

@set("id.c", "ENOLCK")
public const c_ENOLCK = 77           // No locks available
@set("id.c", "ENOSYS")
public const c_ENOSYS = 78           // Function not implemented

//public const c_EFTYPE = 79     // Inappropriate file type or format
//public const c_EAUTH = 80      // Authentication error
//public const c_ENEEDAUTH = 81  // Need authenticator
//
///* Intelligent device errors */
//public const c_EPWROFF = 82  // Device power is off
//public const c_EDEVERR = 83  // Device error, e.g. paper out

@set("id.c", "EOVERFLOW")
public const c_EOVERFLOW = 84        // Value too large to be stored in data type

/* Program loading errors */
//public const c_EBADEXEC = 85    // Bad executable
//public const c_EBADARCH = 86    // Bad CPU type in executable
//public const c_ESHLIBVERS = 87  // Shared library version mismatch
//public const c_EBADMACHO = 88   // Malformed Macho file

@set("id.c", "ECANCELED")
public const c_ECANCELED = 89        // Operation canceled

@set("id.c", "EIDRM")
public const c_EIDRM = 90            // Identifier removed
@set("id.c", "ENOMSG")
public const c_ENOMSG = 91           // No message of desired type
@set("id.c", "EILSEQ")
public const c_EILSEQ = 92           // Illegal byte sequence

//public const c_ENOATTR = 93  // Attribute not found

@set("id.c", "EBADMSG")
public const c_EBADMSG = 94          // Bad message
@set("id.c", "EMULTIHOP")
public const c_EMULTIHOP = 95        // Reserved
@set("id.c", "ENODATA")
public const c_ENODATA = 96          // No message available on STREAM
@set("id.c", "ENOLINK")
public const c_ENOLINK = 97          // Reserved
@set("id.c", "ENOSR")
public const c_ENOSR = 98            // No STREAM resources
@set("id.c", "ENOSTR")
public const c_ENOSTR = 99           // Not a STREAM
@set("id.c", "EPROTO")
public const c_EPROTO = 100          // Protocol error
@set("id.c", "ETIME")
public const c_ETIME = 101           // STREAM ioctl timeout
@set("id.c", "EOPNOTSUPP")
public const c_EOPNOTSUPP = 102      // Operation not supported on socket
@set("id.c", "ENOPOLICY")
public const c_ENOPOLICY = 103       // No such policy registered

/* pseudo-errors returned inside kernel to modify return to process */
@set("id.c", "ERESTART")
public const c_ERESTART = -1         // restart syscall
@set("id.c", "EJUSTRETURN")
public const c_EJUSTRETURN = -2      // don't modify regs, just return

