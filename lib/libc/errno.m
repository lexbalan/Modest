/*
 * libc/errno.m
 */

//pragma prefix ""


import "errno_abi"


public func get () -> Int32 {
    return *errno_abi.__errno_location()
}

public func set (value: Int32) -> Unit {
    *errno_abi.__errno_location() = value
}


/*
 * Error codes
 */
@extern("C", "EPERM")
public const c_EPERM = 1     // Operation not permitted
@extern("C", "ENOENT")
public const c_ENOENT = 2    // No such file or directory
@extern("C", "ESRCH")
public const c_ESRCH = 3     // No such process
@extern("C", "EINTR")
public const c_EINTR = 4     // Interrupted system call
@extern("C", "EIO")
public const c_EIO = 5       // Input/output error
@extern("C", "ENXIO")
public const c_ENXIO = 6     // Device not configured
@extern("C", "E2BIG")
public const c_E2BIG = 7     // Argument list too long
@extern("C", "ENOEXEC")
public const c_ENOEXEC = 8   // Exec format error
@extern("C", "EBADF")
public const c_EBADF = 9     // Bad file descriptor
@extern("C", "ECHILD")
public const c_ECHILD = 10   // No child processes
@extern("C", "EDEADLK")
public const c_EDEADLK = 11  // Resource deadlock avoided (11 was EAGAIN)
@extern("C", "ENOMEM")
public const c_ENOMEM = 12   // Cannot allocate memory
@extern("C", "EACCES")
public const c_EACCES = 13   // Permission denied
@extern("C", "EFAULT")
public const c_EFAULT = 14   // Bad address
@extern("C", "ENOTBLK")
public const c_ENOTBLK = 15  // Block device required
@extern("C", "EBUSY")
public const c_EBUSY = 16    // Device / Resource busy
@extern("C", "EEXIST")
public const c_EEXIST = 17   // File exists
@extern("C", "EXDEV")
public const c_EXDEV = 18    // Cross-device link
@extern("C", "ENODEV")
public const c_ENODEV = 19   // Operation not supported by device
@extern("C", "ENOTDIR")
public const c_ENOTDIR = 20  // Not a directory
@extern("C", "EISDIR")
public const c_EISDIR = 21   // Is a directory
@extern("C", "EINVAL")
public const c_EINVAL = 22   // Invalid argument
@extern("C", "ENFILE")
public const c_ENFILE = 23   // Too many open files in system
@extern("C", "EMFILE")
public const c_EMFILE = 24   // Too many open files
@extern("C", "ENOTTY")
public const c_ENOTTY = 25   // Inappropriate ioctl for device
@extern("C", "ETXTBSY")
public const c_ETXTBSY = 26  // Text file busy
@extern("C", "EFBIG")
public const c_EFBIG = 27    // File too large
@extern("C", "ENOSPC")
public const c_ENOSPC = 28   // No space left on device
@extern("C", "ESPIPE")
public const c_ESPIPE = 29   // Illegal seek
@extern("C", "EROFS")
public const c_EROFS = 30    // Read-only file system
@extern("C", "EMLINK")
public const c_EMLINK = 31   // Too many links
@extern("C", "EPIPE")
public const c_EPIPE = 32    // Broken pipe
@extern("C", "EDOM")
public const c_EDOM = 33     // Numerical argument out of domain
@extern("C", "ERANGE")
public const c_ERANGE = 34   // Result too large

/* non-blocking and interrupt i/o */
@extern("C", "EAGAIN")
public const c_EAGAIN = 35           // Resource temporarily unavailable
@extern("C", "EWOULDBLOCK")
public const c_EWOULDBLOCK = c_EAGAIN  // Operation would block
@extern("C", "EINPROGRESS")
public const c_EINPROGRESS = 36      // Operation now in progress
@extern("C", "EALREADY")
public const c_EALREADY = 37         // Operation already in progress

/* ipc/network software -- argument errors */
@extern("C", "ENOTSOCK")
public const c_ENOTSOCK = 38         // Socket operation on non-socket
@extern("C", "EDESTADDRREQ")
public const c_EDESTADDRREQ = 39     // Destination address required
@extern("C", "EMSGSIZE")
public const c_EMSGSIZE = 40         // Message too long
@extern("C", "EPROTOTYPE")
public const c_EPROTOTYPE = 41       // Protocol wrong type for socket
@extern("C", "ENOPROTOOPT")
public const c_ENOPROTOOPT = 42      // Protocol not available
@extern("C", "EPROTONOSUPPORT")
public const c_EPROTONOSUPPORT = 43  // Protocol not supported
@extern("C", "ESOCKTNOSUPPORT")
public const c_ESOCKTNOSUPPORT = 44  // Socket type not supported
@extern("C", "ENOTSUP")
public const c_ENOTSUP = 45          // Operation not supported
@extern("C", "EPFNOSUPPORT")
public const c_EPFNOSUPPORT = 46     // Protocol family not supported
@extern("C", "EAFNOSUPPORT")
public const c_EAFNOSUPPORT = 47     // Address family not supported by protocol family
@extern("C", "EADDRINUSE")
public const c_EADDRINUSE = 48       // Address already in use
@extern("C", "EADDRNOTAVAIL")
public const c_EADDRNOTAVAIL = 49    // Can't assign requested address

/* ipc/network software -- operational errors */
@extern("C", "ENETDOWN")
public const c_ENETDOWN = 50         // Network is down
@extern("C", "ENETUNREACH")
public const c_ENETUNREACH = 51      // Network is unreachable
@extern("C", "ENETRESET")
public const c_ENETRESET = 52        // Network dropped connection on reset
@extern("C", "ECONNABORTED")
public const c_ECONNABORTED = 53     // Software caused connection abort
@extern("C", "ECONNRESET")
public const c_ECONNRESET = 54       // Connection reset by peer
@extern("C", "ENOBUFS")
public const c_ENOBUFS = 55          // No buffer space available
@extern("C", "EISCONN")
public const c_EISCONN = 56          // Socket is already connected
@extern("C", "ENOTCONN")
public const c_ENOTCONN = 57         // Socket is not connected
@extern("C", "ESHUTDOWN")
public const c_ESHUTDOWN = 58        // Can't send after socket shutdown
@extern("C", "ETOOMANYREFS")
public const c_ETOOMANYREFS = 59     // Too many references: can't splice
@extern("C", "ETIMEDOUT")
public const c_ETIMEDOUT = 60        // Operation timed out
@extern("C", "ECONNREFUSED")
public const c_ECONNREFUSED = 61     // Connection refused
@extern("C", "ELOOP")
public const c_ELOOP = 62            // Too many levels of symbolic links
@extern("C", "ENAMETOOLONG")
public const c_ENAMETOOLONG = 63     // File name too long

/* should be rearranged */
@extern("C", "EHOSTDOWN")
public const c_EHOSTDOWN = 64        // Host is down
@extern("C", "EHOSTUNREACH")
public const c_EHOSTUNREACH = 65     // No route to host
@extern("C", "ENOTEMPTY")
public const c_ENOTEMPTY = 66        // Directory not empty

/* quotas & mush */
//public const c_EPROCLIM = 67  // Too many processes
//public const c_EUSERS = 68    // Too many users
@extern("C", "EDQUOT")
public const c_EDQUOT = 69           // Disc quota exceeded

/* Network File System */
@extern("C", "ESTALE")
public const c_ESTALE = 70           // Stale NFS file handle
//public const c_EREMOTE = 71  // Too many levels of remote in path
//public const c_EBADRPC = 72  // RPC struct is bad
//public const c_ERPCMISMATCH = 73   // RPC version wrong
//public const c_EPROGUNAVAIL = 74   // RPC prog. not avail
//public const c_EPROGMISMATCH = 75  // Program version wrong
//public const c_EPROCUNAVAIL = 76   // Bad procedure for program

@extern("C", "ENOLCK")
public const c_ENOLCK = 77           // No locks available
@extern("C", "ENOSYS")
public const c_ENOSYS = 78           // Function not implemented

//public const c_EFTYPE = 79     // Inappropriate file type or format
//public const c_EAUTH = 80      // Authentication error
//public const c_ENEEDAUTH = 81  // Need authenticator
//
///* Intelligent device errors */
//public const c_EPWROFF = 82  // Device power is off
//public const c_EDEVERR = 83  // Device error, e.g. paper out

@extern("C", "EOVERFLOW")
public const c_EOVERFLOW = 84        // Value too large to be stored in data type

/* Program loading errors */
//public const c_EBADEXEC = 85    // Bad executable
//public const c_EBADARCH = 86    // Bad CPU type in executable
//public const c_ESHLIBVERS = 87  // Shared library version mismatch
//public const c_EBADMACHO = 88   // Malformed Macho file

@extern("C", "ECANCELED")
public const c_ECANCELED = 89        // Operation canceled

@extern("C", "EIDRM")
public const c_EIDRM = 90            // Identifier removed
@extern("C", "ENOMSG")
public const c_ENOMSG = 91           // No message of desired type
@extern("C", "EILSEQ")
public const c_EILSEQ = 92           // Illegal byte sequence

//public const c_ENOATTR = 93  // Attribute not found

@extern("C", "EBADMSG")
public const c_EBADMSG = 94          // Bad message
@extern("C", "EMULTIHOP")
public const c_EMULTIHOP = 95        // Reserved
@extern("C", "ENODATA")
public const c_ENODATA = 96          // No message available on STREAM
@extern("C", "ENOLINK")
public const c_ENOLINK = 97          // Reserved
@extern("C", "ENOSR")
public const c_ENOSR = 98            // No STREAM resources
@extern("C", "ENOSTR")
public const c_ENOSTR = 99           // Not a STREAM
@extern("C", "EPROTO")
public const c_EPROTO = 100          // Protocol error
@extern("C", "ETIME")
public const c_ETIME = 101           // STREAM ioctl timeout
@extern("C", "EOPNOTSUPP")
public const c_EOPNOTSUPP = 102      // Operation not supported on socket
@extern("C", "ENOPOLICY")
public const c_ENOPOLICY = 103       // No such policy registered

/* pseudo-errors returned inside kernel to modify return to process */
@extern("C", "ERESTART")
public const c_ERESTART = -1         // restart syscall
@extern("C", "EJUSTRETURN")
public const c_EJUSTRETURN = -2      // don't modify regs, just return

