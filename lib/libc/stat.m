// libc/stat.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "sys/stat.h"

include "libc/ctypes64"
include "libc/time"


public type DevT Nat32
public type InoT Nat64
public type ModeT Word16
public type NLinkT Nat16
public type UIDT Nat32
public type GIDT Nat32
public type BlkSizeT Nat32
public type BlkCntT Nat64

public type DarwinIno64T Nat64

//
//@set("id.c", "struct stat")
//type Stat record {
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


public type DarwinTimeT Nat64

@set("id.c", "struct timespec")
public type Timespec record {
	public tv_sec: DarwinTimeT
	public tv_nsec: Long
}


	/* for MACOS see: /Library/Developer/CommandLineTools/SDKs/MacOSX13.0.sdk/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/sys
	*/

@set("id.c", "struct stat")
public type Stat record {
	public st_dev: DevT             // [XSI] ID of device containing file
	public st_mode: ModeT           // [XSI] Mode of file (see below)
	public st_nlink: NLinkT         // [XSI] Number of hard links
	public st_ino: DarwinIno64T     // [XSI] File serial number
	public st_uid: UIDT             // [XSI] User ID of the file
	public st_gid: GIDT             // [XSI] Group ID of the file
	public st_rdev: DevT            // [XSI] Device ID

	//__DARWIN_STRUCT_STAT64_TIMES:
	//+spec ->st_mtimespec
	public st_atime: Timespec       // time of last access
	public st_mtime: Timespec       // time of last data modification
	public st_ctime: Timespec       // time of last status change
	public st_birthtime: Timespec   // time of file creation(birth)

	public st_size: OffT            // [XSI] file size, in bytes
	public st_blocks: BlkCntT       // [XSI] blocks allocated for file
	public st_blksize: BlkSizeT     // [XSI] optimal blocksize for I/O
	public st_flags: Nat32          // user defined flags for file
	public st_gen: Nat32            // file generation number
	public st_lspare: Int32         // RESERVED: DO NOT USE!
	public st_qspare: [2]Int64      // RESERVED: DO NOT USE!
}


	// 01_stat for MACOS
@set("id.llvm", "\\01_stat")
public func stat(path: *[]ConstChar, stat: *Stat) -> Int


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


public const s_ISUID = 0x0800	// (0004000) set user id on execution
public const s_ISGID = 0x0400	// (0002000) set group id on execution
public const s_ISTXT = 0x0200	// (0001000) sticky bit

public const s_IRWXU = 0x01C0	// (0000700) RWX mask for owner
public const s_IRUSR = 0x0100	// (0000400) R for owner
public const s_IWUSR = 0x0080	// (0000200) W for owner
public const s_IXUSR = 0x0040	// (0000100) X for owner

public const s_IREAD = s_IRUSR
public const s_IWRITE = s_IWUSR
public const s_IEXEC = s_IXUSR

public const s_IRWXG = 0x0038    // (0000070) RWX mask for group
public const s_IRGRP = 0x0020    // (0000040) R for group
public const s_IWGRP = 0x0010    // (0000020) W for group
public const s_IXGRP = 0x0008    // (0000010) X for group

public const s_IRWXO = 0x0007    // (0000007) RWX mask for other
public const s_IROTH = 0x0004    // (0000004) R for other
public const s_IWOTH = 0x0002    // (0000002) W for other
public const s_IXOTH = 0x0001    // (0000001) X for other

public const s_IFMT = 0xF000     // (0170000) type of file mask
public const s_IFIFO = 0x1000    // (0010000) named pipe (fifo)
public const s_IFCHR = 0x2000    // (0020000) character special
public const s_IFDIR = 0x4000    // (0040000) directory
public const s_IFBLK = 0x6000    // (0060000) block special
public const s_IFREG = 0x8000    // (0100000) regular
public const s_IFLNK = 0xA000    // (0120000) symbolic link
public const s_IFSOCK = 0xC000   // (0140000) socket
public const s_IFWHT = 0xE000    // (0160000) whiteout
public const s_ISVTX = 0x0200    // (0001000) save swapped text even after use


	/* is directory */
@set("id.c", "S_ISDIR")
public func s_ISDIR(m: ModeT) -> Bool {
	return (m and s_IFMT) == s_IFDIR
}

	/* is char special */
@set("id.c", "S_ISCHR")
public func s_ISCHR(m: ModeT) -> Bool {
	return (m and s_IFMT) == s_IFCHR
}

	/* is block special */
@set("id.c", "S_ISBLK")
public func s_ISBLK(m: ModeT) -> Bool {
	return (m and s_IFMT) == s_IFBLK
}

	/* is regular file */
@set("id.c", "S_ISREG")
public func s_ISREG(m: ModeT) -> Bool {
	return (m and s_IFMT) == s_IFREG
}

	/* is fifo or socket */
@set("id.c", "S_ISFIFO")
public func s_ISFIFO(m: ModeT) -> Bool {
	return (m and s_IFMT) == s_IFIFO
}

	/* is symbolic link */
@set("id.c", "S_ISLNK")
public func s_ISLNK(m: ModeT) -> Bool {
	return (m and s_IFMT) == s_IFLNK
}

	/* is socket */
@set("id.c", "S_ISSOCK")
public func s_ISSOCK(m: ModeT) -> Bool {
	return (m and s_IFMT) == s_IFSOCK
}

	/* is whiteout */
@set("id.c", "S_ISWHT")
public func s_ISWHT(m: ModeT) -> Bool {
	return (m and s_IFMT) == s_IFWHT
}


