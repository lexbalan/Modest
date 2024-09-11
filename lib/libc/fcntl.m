// fcntl.hm

$pragma module_nodecorate


/* open-only flags */
export let c_O_RDONLY = 0x00000000		/* open for reading only */
export let c_O_WRONLY = 0x00000001		/* open for writing only */
export let c_O_RDWR = 0x00000002	    /* open for reading and writing */
export let c_O_ACCMODE = 0x00000003	/* mask for above modes */

export let c_O_NONBLOCK = 0x00000004	/* no delay */
export let c_O_APPEND = 0x00000008		/* set append mode */

export let c_O_CREAT = 0x00000200	/* create if nonexistent */
export let c_O_TRUNC = 0x00000400	/* truncate to zero length */
export let c_O_EXCL = 0x00000800	/* error if already exists */


/*
 * Constants used for fcntl()
 */

/* command values */
export let c_F_DUPFD = 0			/* duplicate file descriptor */
export let c_F_GETFD = 1			/* get file descriptor flags */
export let c_F_SETFD = 2			/* set file descriptor flags */
export let c_F_GETFL = 3			/* get file status flags */
export let c_F_SETFL = 4			/* set file status flags */
export let c_F_GETOWN = 5			/* get SIGIO/SIGURG proc/pgrp */
export let c_F_SETOWN = 6			/* set SIGIO/SIGURG proc/pgrp */
export let c_F_GETLK = 7			/* get record locking information */
export let c_F_SETLK = 8			/* set record locking information */
export let c_F_SETLKW = 9			/* c_F_SETLK; wait if blocked */
export let c_F_CLOSEM = 10			/* close all fds >= to the one given */
export let c_F_MAXFD = 11			/* return the max open fd */
export let c_F_DUPFD_CLOEXEC = 12	/* close on exec duplicated fd */
export let c_F_GETNOSIGPIPE = 13	/* get SIGPIPE disposition */
export let c_F_SETNOSIGPIPE = 14	/* set SIGPIPE disposition */
export let c_F_GETPATH = 15		/* get pathname associated with fd */
export let c_F_ADD_SEALS = 16		/* set seals */
export let c_F_GET_SEALS = 17		/* get seals */


/* file descriptor flags (c_F_GETFD, c_F_SETFD) */
export let c_FD_CLOEXEC = 1	/* close-on-exec flag */

/* record locking flags (F_GETLK, F_SETLK, F_SETLKW) */
export let c_F_RDLCK = 1		/* shared or read lock */
export let c_F_UNLCK = 2		/* unlock */
export let c_F_WRLCK = 3		/* exclusive or write lock */


export func open (fname: *[]ConstChar, opt: Int, ...) -> Int
export func creat (fname: *[]ConstChar, mode: ModeT) -> Int
export func fcntl (fd: Int, op: Int, ...) -> Int


