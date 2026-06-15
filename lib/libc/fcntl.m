// libc/fcntl.m

pragma prefix ""

include "libc/ctypes"
include "libc/stat"

// open-only flags
@extern("C", "O_RDONLY")
public const oRdonly = Word32 0x00000000    // open for reading only
@extern("C", "O_WRONLY")
public const oWronly = Word32 0x00000001    // open for writing only
@extern("C", "O_RDWR")
public const oRdwr = Word32 0x00000002      // open for reading and writing
@extern("C", "O_ACCMODE")
public const oAccmode = Word32 0x00000003   // mask for above modes

@extern("C", "O_NONBLOCK")
public const oNonblock = Word32 0x00000004  // no delay
@extern("C", "O_APPEND")
public const oAppend = Word32 0x00000008    // set append mode

@extern("C", "O_CREAT")
public const oCreat = Word32 0x00000200     // create if nonexistent
@extern("C", "O_TRUNC")
public const oTrunc = Word32 0x00000400     // truncate to zero length
@extern("C", "O_EXCL")
public const oExcl = Word32 0x00000800      // error if already exists


/*
 * Constants used for fcntl()
 */

// command values
@extern("C", "F_DUPFD")
public const fDupfd = 0           // duplicate file descriptor
@extern("C", "F_GETFD")
public const fGetfd = 1           // get file descriptor flags
@extern("C", "F_SETFD")
public const fSetfd = 2           // set file descriptor flags
@extern("C", "F_GETFL")
public const fGetfl = 3           // get file status flags
@extern("C", "F_SETFL")
public const fSetfl = 4           // set file status flags
@extern("C", "F_GETOWN")
public const fGetown = 5          // get SIGIO/SIGURG proc/pgrp
@extern("C", "F_SETOWN")
public const fSetown = 6          // set SIGIO/SIGURG proc/pgrp
@extern("C", "F_GETLK")
public const fGetlk = 7           // get record locking information
@extern("C", "F_SETLK")
public const fSetlk = 8           // set record locking information
@extern("C", "F_SETLKW")
public const fSetlkw = 9          // f_SETLK, wait if blocked
@extern("C", "F_CLOSEM")
public const fClosem = 10         // close all fds >= to the one given
@extern("C", "F_MAXFD")
public const fMaxfd = 11          // return the max open fd
@extern("C", "F_DUPFD_CLOEXEC")
public const fDupfdCloexec = 12  // close on exec duplicated fd
@extern("C", "F_GETNOSIGPIPE")
public const fGetnosigpipe = 13   // get SIGPIPE disposition
@extern("C", "F_SETNOSIGPIPE")
public const fSetnosigpipe = 14   // set SIGPIPE disposition
@extern("C", "F_GETPATH")
public const fGetpath = 15        // get pathname associated with fd
@extern("C", "F_ADD_SEALS")
public const fAddSeals = 16      // set seals
@extern("C", "F_GET_SEALS")
public const fGetSeals = 17      // get seals

// file descriptor flags (f_GETFD, f_SETFD)
@extern("C", "FD_CLOEXEC")
public const fdCloexec = 1        // close-on-exec flag

// record locking flags (F_GETLK, F_SETLK, F_SETLKW)
@extern("C", "F_RDLCK")
public const fRdlck = 1  // shared or read lock
@extern("C", "F_UNLCK")
public const fUnlck = 2  // unlock
@extern("C", "F_WRLCK")
public const fWrlck = 3  // exclusive or write lock


public func open (fname: *[]ConstChar, opt: Word32, ...) -> Int
public func creat (fname: *[]ConstChar, mode: ModeT) -> Int
public func fcntl (fd: Int, op: Int, ...) -> Int


