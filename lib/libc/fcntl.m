// libc/fcntl.m

$pragma module_nodecorate


export {
	// open-only flags
	let o_RDONLY = 0x00000000    // open for reading only
	let o_WRONLY = 0x00000001    // open for writing only
	let o_RDWR = 0x00000002      // open for reading and writing
	let o_ACCMODE = 0x00000003   // mask for above modes

	let o_NONBLOCK = 0x00000004  // no delay
	let o_APPEND = 0x00000008    // set append mode

	let o_CREAT = 0x00000200     // create if nonexistent
	let o_TRUNC = 0x00000400     // truncate to zero length
	let o_EXCL = 0x00000800      // error if already exists


	/*
	 * Constants used for fcntl()
	 */

	// command values
	let f_DUPFD = 0           // duplicate file descriptor
	let f_GETFD = 1           // get file descriptor flags
	let f_SETFD = 2           // set file descriptor flags
	let f_GETFL = 3           // get file status flags
	let f_SETFL = 4           // set file status flags
	let f_GETOWN = 5          // get SIGIO/SIGURG proc/pgrp
	let f_SETOWN = 6          // set SIGIO/SIGURG proc/pgrp
	let f_GETLK = 7           // get record locking information
	let f_SETLK = 8           // set record locking information
	let f_SETLKW = 9          // f_SETLK, wait if blocked
	let f_CLOSEM = 10         // close all fds >= to the one given
	let f_MAXFD = 11          // return the max open fd
	let f_DUPFD_CLOEXEC = 12  // close on exec duplicated fd
	let f_GETNOSIGPIPE = 13   // get SIGPIPE disposition
	let f_SETNOSIGPIPE = 14   // set SIGPIPE disposition
	let f_GETPATH = 15        // get pathname associated with fd
	let f_ADD_SEALS = 16      // set seals
	let f_GET_SEALS = 17      // get seals

	// file descriptor flags (f_GETFD, f_SETFD)
	let c_FD_CLOEXEC = 1      // close-on-exec flag

	// record locking flags (F_GETLK, F_SETLK, F_SETLKW)
	let f_RDLCK = 1  // shared or read lock
	let f_UNLCK = 2  // unlock
	let f_WRLCK = 3  // exclusive or write lock


	func open (fname: *[]ConstChar, opt: Int, ...) -> Int
	func creat (fname: *[]ConstChar, mode: ModeT) -> Int
	func fcntl (fd: Int, op: Int, ...) -> Int
}

