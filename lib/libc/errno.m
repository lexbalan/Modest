/*
 * libc/errno.m
 */

pragma module_nodecorate


/*
 * Error codes
 */
@alias("c", "EPERM")
public const c_EPERM = 1     // Operation not permitted
@alias("c", "ENOENT")
public const c_ENOENT = 2    // No such file or directory
@alias("c", "ESRCH")
public const c_ESRCH = 3     // No such process
@alias("c", "EINTR")
public const c_EINTR = 4     // Interrupted system call
@alias("c", "EIO")
public const c_EIO = 5       // Input/output error
@alias("c", "ENXIO")
public const c_ENXIO = 6     // Device not configured
@alias("c", "E2BIG")
public const c_E2BIG = 7     // Argument list too long
@alias("c", "ENOEXEC")
public const c_ENOEXEC = 8   // Exec format error
@alias("c", "EBADF")
public const c_EBADF = 9     // Bad file descriptor
@alias("c", "ECHILD")
public const c_ECHILD = 10   // No child processes
@alias("c", "EDEADLK")
public const c_EDEADLK = 11  // Resource deadlock avoided (11 was EAGAIN)
@alias("c", "ENOMEM")
public const c_ENOMEM = 12   // Cannot allocate memory
@alias("c", "EACCES")
public const c_EACCES = 13   // Permission denied
@alias("c", "EFAULT")
public const c_EFAULT = 14   // Bad address
@alias("c", "ENOTBLK")
public const c_ENOTBLK = 15  // Block device required
@alias("c", "EBUSY")
public const c_EBUSY = 16    // Device / Resource busy
@alias("c", "EEXIST")
public const c_EEXIST = 17   // File exists
@alias("c", "EXDEV")
public const c_EXDEV = 18    // Cross-device link
@alias("c", "ENODEV")
public const c_ENODEV = 19   // Operation not supported by device
@alias("c", "ENOTDIR")
public const c_ENOTDIR = 20  // Not a directory
@alias("c", "EISDIR")
public const c_EISDIR = 21   // Is a directory
@alias("c", "EINVAL")
public const c_EINVAL = 22   // Invalid argument
@alias("c", "ENFILE")
public const c_ENFILE = 23   // Too many open files in system
@alias("c", "EMFILE")
public const c_EMFILE = 24   // Too many open files
@alias("c", "ENOTTY")
public const c_ENOTTY = 25   // Inappropriate ioctl for device
@alias("c", "ETXTBSY")
public const c_ETXTBSY = 26  // Text file busy
@alias("c", "EFBIG")
public const c_EFBIG = 27    // File too large
@alias("c", "ENOSPC")
public const c_ENOSPC = 28   // No space left on device
@alias("c", "ESPIPE")
public const c_ESPIPE = 29   // Illegal seek
@alias("c", "EROFS")
public const c_EROFS = 30    // Read-only file system
@alias("c", "EMLINK")
public const c_EMLINK = 31   // Too many links
@alias("c", "EPIPE")
public const c_EPIPE = 32    // Broken pipe
@alias("c", "EDOM")
public const c_EDOM = 33     // Numerical argument out of domain
@alias("c", "ERANGE")
public const c_ERANGE = 34   // Result too large

/* non-blocking and interrupt i/o */
@alias("c", "EAGAIN")
public const c_EAGAIN = 35           // Resource temporarily unavailable
@alias("c", "EWOULDBLOCK")
public const c_EWOULDBLOCK = eAGAIN  // Operation would block
@alias("c", "EINPROGRESS")
public const c_EINPROGRESS = 36      // Operation now in progress
@alias("c", "EALREADY")
public const c_EALREADY = 37         // Operation already in progress

/* ipc/network software -- argument errors */
@alias("c", "ENOTSOCK")
public const c_ENOTSOCK = 38         // Socket operation on non-socket
@alias("c", "EDESTADDRREQ")
public const c_EDESTADDRREQ = 39     // Destination address required
@alias("c", "EMSGSIZE")
public const c_EMSGSIZE = 40         // Message too long
@alias("c", "EPROTOTYPE")
public const c_EPROTOTYPE = 41       // Protocol wrong type for socket
@alias("c", "ENOPROTOOPT")
public const c_ENOPROTOOPT = 42      // Protocol not available
@alias("c", "EPROTONOSUPPORT")
public const c_EPROTONOSUPPORT = 43  // Protocol not supported
@alias("c", "ESOCKTNOSUPPORT")
public const c_ESOCKTNOSUPPORT = 44  // Socket type not supported
@alias("c", "ENOTSUP")
public const c_ENOTSUP = 45          // Operation not supported
@alias("c", "EPFNOSUPPORT")
public const c_EPFNOSUPPORT = 46     // Protocol family not supported
@alias("c", "EAFNOSUPPORT")
public const c_EAFNOSUPPORT = 47     // Address family not supported by protocol family
@alias("c", "EADDRINUSE")
public const c_EADDRINUSE = 48       // Address already in use
@alias("c", "EADDRNOTAVAIL")
public const c_EADDRNOTAVAIL = 49    // Can't assign requested address

/* ipc/network software -- operational errors */
@alias("c", "ENETDOWN")
public const c_ENETDOWN = 50         // Network is down
@alias("c", "ENETUNREACH")
public const c_ENETUNREACH = 51      // Network is unreachable
@alias("c", "ENETRESET")
public const c_ENETRESET = 52        // Network dropped connection on reset
@alias("c", "ECONNABORTED")
public const c_ECONNABORTED = 53     // Software caused connection abort
@alias("c", "ECONNRESET")
public const c_ECONNRESET = 54       // Connection reset by peer
@alias("c", "ENOBUFS")
public const c_ENOBUFS = 55          // No buffer space available
@alias("c", "EISCONN")
public const c_EISCONN = 56          // Socket is already connected
@alias("c", "ENOTCONN")
public const c_ENOTCONN = 57         // Socket is not connected
@alias("c", "ESHUTDOWN")
public const c_ESHUTDOWN = 58        // Can't send after socket shutdown
@alias("c", "ETOOMANYREFS")
public const c_ETOOMANYREFS = 59     // Too many references: can't splice
@alias("c", "ETIMEDOUT")
public const c_ETIMEDOUT = 60        // Operation timed out
@alias("c", "ECONNREFUSED")
public const c_ECONNREFUSED = 61     // Connection refused
@alias("c", "ELOOP")
public const c_ELOOP = 62            // Too many levels of symbolic links
@alias("c", "ENAMETOOLONG")
public const c_ENAMETOOLONG = 63     // File name too long

/* should be rearranged */
@alias("c", "EHOSTDOWN")
public const c_EHOSTDOWN = 64        // Host is down
@alias("c", "EHOSTUNREACH")
public const c_EHOSTUNREACH = 65     // No route to host
@alias("c", "ENOTEMPTY")
public const c_ENOTEMPTY = 66        // Directory not empty

/* quotas & mush */
//public const c_EPROCLIM = 67  // Too many processes
//public const c_EUSERS = 68    // Too many users
@alias("c", "EDQUOT")
public const c_EDQUOT = 69           // Disc quota exceeded

/* Network File System */
@alias("c", "ESTALE")
public const c_ESTALE = 70           // Stale NFS file handle
//public const c_EREMOTE = 71  // Too many levels of remote in path
//public const c_EBADRPC = 72  // RPC struct is bad
//public const c_ERPCMISMATCH = 73   // RPC version wrong
//public const c_EPROGUNAVAIL = 74   // RPC prog. not avail
//public const c_EPROGMISMATCH = 75  // Program version wrong
//public const c_EPROCUNAVAIL = 76   // Bad procedure for program

@alias("c", "ENOLCK")
public const c_ENOLCK = 77           // No locks available
@alias("c", "ENOSYS")
public const c_ENOSYS = 78           // Function not implemented

//public const c_EFTYPE = 79     // Inappropriate file type or format
//public const c_EAUTH = 80      // Authentication error
//public const c_ENEEDAUTH = 81  // Need authenticator
//
///* Intelligent device errors */
//public const c_EPWROFF = 82  // Device power is off
//public const c_EDEVERR = 83  // Device error, e.g. paper out

@alias("c", "EOVERFLOW")
public const c_EOVERFLOW = 84        // Value too large to be stored in data type

/* Program loading errors */
//public const c_EBADEXEC = 85    // Bad executable
//public const c_EBADARCH = 86    // Bad CPU type in executable
//public const c_ESHLIBVERS = 87  // Shared library version mismatch
//public const c_EBADMACHO = 88   // Malformed Macho file

@alias("c", "ECANCELED")
public const c_ECANCELED = 89        // Operation canceled

@alias("c", "EIDRM")
public const c_EIDRM = 90            // Identifier removed
@alias("c", "ENOMSG")
public const c_ENOMSG = 91           // No message of desired type
@alias("c", "EILSEQ")
public const c_EILSEQ = 92           // Illegal byte sequence

//public const c_ENOATTR = 93  // Attribute not found

@alias("c", "EBADMSG")
public const c_EBADMSG = 94          // Bad message
@alias("c", "EMULTIHOP")
public const c_EMULTIHOP = 95        // Reserved
@alias("c", "ENODATA")
public const c_ENODATA = 96          // No message available on STREAM
@alias("c", "ENOLINK")
public const c_ENOLINK = 97          // Reserved
@alias("c", "ENOSR")
public const c_ENOSR = 98            // No STREAM resources
@alias("c", "ENOSTR")
public const c_ENOSTR = 99           // Not a STREAM
@alias("c", "EPROTO")
public const c_EPROTO = 100          // Protocol error
@alias("c", "ETIME")
public const c_ETIME = 101           // STREAM ioctl timeout
@alias("c", "EOPNOTSUPP")
public const c_EOPNOTSUPP = 102      // Operation not supported on socket
@alias("c", "ENOPOLICY")
public const c_ENOPOLICY = 103       // No such policy registered

/* pseudo-errors returned inside kernel to modify return to process */
@alias("c", "ERESTART")
public const c_ERESTART = -1         // restart syscall
@alias("c", "EJUSTRETURN")
public const c_EJUSTRETURN = -2      // don't modify regs, just return

