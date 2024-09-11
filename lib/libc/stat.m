
$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "sys/stat.h"

import "libc/ctypes"
import "libc/time"

export type DevT Nat32
export type InoT Nat64
export type ModeT Nat16
export type NLinkT Nat16
export type UIDT Nat32
export type GIDT Nat32
export type BlkSizeT Nat32
export type BlkCntT Nat64

export type DarwinIno64T Nat64

//
//@property("type.id.c", "struct stat")
//export type Stat record {
//	st_dev: DevT			/* номер устройства */
//	st_ino: InoT			/* inode */
//	st_mode: ModeT			/* режим доступа */
//	st_nlink: NLinkT		/* количество жестких ссылок */
//	st_uid: UIDT			/* идентификатор пользователя-владельца */
//	st_gid: GIDT			/* идентификатор группы-владельца */
//	st_rdev: DevT			/* тип устройства (если это устройство) */
//	st_size: OffT			/* общий размер в байтах */
//	st_blksize: BlkSizeT	/* размер блока ввода-вывода в файловой системе */
//	st_blocks: BlkCntT		/* количество выделенных блоков */
//	st_atime: TimeT			/* время последнего доступа */
//	st_mtime: TimeT			/* время последней модификации */
//	st_ctime: TimeT			/* время последнего изменения */
//}


export type DarwinTimeT Nat64

@property("type.id.c", "struct timespec")
export type Timespec record {
	tv_sec: DarwinTimeT
	tv_nsec: Long
}


/* for MACOS see: /Library/Developer/CommandLineTools/SDKs/MacOSX13.0.sdk/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/sys
*/


@property("type.id.c", "struct stat")
export type Stat record {
	st_dev: DevT             // [XSI] ID of device containing file
	st_mode: ModeT           // [XSI] Mode of file (see below)
	st_nlink: NLinkT         // [XSI] Number of hard links
	st_ino: DarwinIno64T     // [XSI] File serial number
	st_uid: UIDT             // [XSI] User ID of the file
	st_gid: GIDT             // [XSI] Group ID of the file
	st_rdev: DevT            // [XSI] Device ID

	//__DARWIN_STRUCT_STAT64_TIMES:
	//+spec -> st_mtimespec
	st_atime: Timespec       // time of last access
	st_mtime: Timespec       // time of last data modification
	st_ctime: Timespec       // time of last status change
	st_birthtime: Timespec   // time of file creation(birth)

	st_size: OffT            // [XSI] file size, in bytes
	st_blocks: BlkCntT       // [XSI] blocks allocated for file
	st_blksize: BlkSizeT     // [XSI] optimal blocksize for I/O
	st_flags: Nat32          // user defined flags for file
	st_gen: Nat32            // file generation number
	st_lspare: Int32         // RESERVED: DO NOT USE!
	st_qspare: [2]Int64      // RESERVED: DO NOT USE!
}


// 01_stat for MACOS
@property("value.id.llvm", "\\01_stat")
export func stat(path: *[]ConstChar, stat: *Stat) -> Int


/*struct stat {
    dev_t     st_dev;     // ID устройства
    ino_t     st_ino;     // Номер inode
    mode_t    st_mode;    // Права доступа
    nlink_t   st_nlink;   // Количество жестких ссылок
    uid_t     st_uid;     // Идентификатор пользователя (владельца)
    gid_t     st_gid;     // Идентификатор группы
    dev_t     st_rdev;    // ID устройства (если это специальный файл)
    off_t     st_size;    // Общий размер в байтах
    blksize_t st_blksize; // Размер блока ввода-вывода
    blkcnt_t  st_blocks;  // Количество выделенных блоков
    time_t    st_atime;   // Время последнего доступа
    time_t    st_mtime;   // Время последней модификации
    time_t    st_ctime;   // Время последнего изменения статуса
};*/


export let c_S_ISUID = 0x0800	// (0004000) set user id on execution
export let c_S_ISGID = 0x0400	// (0002000) set group id on execution
export let c_S_ISTXT = 0x0200	// (0001000) sticky bit

export let c_S_IRWXU = 0x01C0	// (0000700) RWX mask for owner
export let c_S_IRUSR = 0x0100	// (0000400) R for owner
export let c_S_IWUSR = 0x0080	// (0000200) W for owner
export let c_S_IXUSR = 0x0040	// (0000100) X for owner


export let c_S_IREAD = c_S_IRUSR
export let c_S_IWRITE = c_S_IWUSR
export let c_S_IEXEC = c_S_IXUSR


export let c_S_IRWXG = 0x0038  // (0000070) RWX mask for group
export let c_S_IRGRP = 0x0020  // (0000040) R for group
export let c_S_IWGRP = 0x0010  // (0000020) W for group
export let c_S_IXGRP = 0x0008  // (0000010) X for group

export let c_S_IRWXO = 0x0007  // (0000007) RWX mask for other
export let c_S_IROTH = 0x0004  // (0000004) R for other
export let c_S_IWOTH = 0x0002  // (0000002) W for other
export let c_S_IXOTH = 0x0001  // (0000001) X for other


export let c_S_IFMT =   0xF000  // (0170000) export type of file mask
export let c_S_IFIFO =  0x1000  // (0010000) named pipe (fifo)
export let c_S_IFCHR =  0x2000  // (0020000) character special
export let c_S_IFDIR =  0x4000  // (0040000) directory
export let c_S_IFBLK =  0x6000  // (0060000) block special
export let c_S_IFREG =  0x8000  // (0100000) regular
export let c_S_IFLNK =  0xA000  // (0120000) symbolic link
export let c_S_IFSOCK = 0xC000  // (0140000) socket
export let c_S_IFWHT =  0xE000  // (0160000) whiteout
export let c_S_ISVTX =  0x0200  // (0001000) save swapped text even after use



/* is directory */
@property("value.id.c", "S_ISDIR")
export func c_S_ISDIR(m: ModeT) -> Bool {
	return (m and c_S_IFMT) == c_S_IFDIR
}

/* is char special */
@property("value.id.c", "S_ISCHR")
export func c_S_ISCHR(m: ModeT) -> Bool {
	return (m and c_S_IFMT) == c_S_IFCHR
}

/* is block special */
@property("value.id.c", "S_ISBLK")
export func c_S_ISBLK(m: ModeT) -> Bool {
	return (m and c_S_IFMT) == c_S_IFBLK
}

/* is regular file */
@property("value.id.c", "S_ISREG")
export func c_S_ISREG(m: ModeT) -> Bool {
	return (m and c_S_IFMT) == c_S_IFREG
}

/* is fifo or socket */
@property("value.id.c", "S_ISFIFO")
export func c_S_ISFIFO(m: ModeT) -> Bool {
	return (m and c_S_IFMT) == c_S_IFIFO
}

/* is symbolic link */
@property("value.id.c", "S_ISLNK")
export func c_S_ISLNK(m: ModeT) -> Bool {
	return (m and c_S_IFMT) == c_S_IFLNK
}

/* is socket */
@property("value.id.c", "S_ISSOCK")
export func c_S_ISSOCK(m: ModeT) -> Bool {
	return (m and c_S_IFMT) == c_S_IFSOCK
}

/* is whiteout */
@property("value.id.c", "S_ISWHT")
export func c_S_ISWHT(m: ModeT) -> Bool {
	return (m and c_S_IFMT) == c_S_IFWHT
}


