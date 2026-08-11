// libc/stat.m

pragma do_not_include
pragma prefix ""
pragma c_include "sys/stat.h"

include "libc/ctypes64"
include "libc/time"


public type DevT = Nat32
public type InoT = Nat64
public type ModeT = Word16
public type NLinkT = Nat16
public type UIDT = Nat32
public type GIDT = Nat32
public type BlkSizeT = Nat32
public type BlkCntT = Nat64

public type DarwinIno64T = Nat64

//
//@extern("C", "struct stat")
//type Stat {
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


public type DarwinTimeT = Nat64

@extern("C", "struct timespec")
public type Timespec = @public {
	tv_sec: DarwinTimeT
	tv_nsec: Long
}

/* for MACOS see: /Library/Developer/CommandLineTools/SDKs/MacOSX13.0.sdk/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/sys */

@extern("C", "struct stat")
public type Stat = @public {
	st_dev: DevT             // [XSI] ID of device containing file
	st_mode: ModeT           // [XSI] Mode of file (see below)
	st_nlink: NLinkT         // [XSI] Number of hard links
	st_ino: DarwinIno64T     // [XSI] File serial number
	st_uid: UIDT             // [XSI] User ID of the file
	st_gid: GIDT             // [XSI] Group ID of the file
	st_rdev: DevT            // [XSI] Device ID

	//__DARWIN_STRUCT_STAT64_TIMES:
	//+spec ->st_mtimespec
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
@alias("llvm", "\\01_stat")
public func stat (path: *[]ConstChar, stat: *Stat) -> Int


/*
struct stat {
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
};
*/

@extern("C", "S_ISUID") public const sIsuid = 0x0800      // (0004000) set user id on execution
@extern("C", "S_ISGID") public const sIsgid = 0x0400      // (0002000) set group id on execution
@extern("C", "S_ISTXT") public const sIstxt = 0x0200      // (0001000) sticky bit

@extern("C", "S_IRWXU") public const sIrwxu = 0x01C0    // (0000700) RWX mask for owner
@extern("C", "S_IRUSR") public const sIrusr = 0x0100    // (0000400) R for owner
@extern("C", "S_IWUSR") public const sIwusr = 0x0080    // (0000200) W for owner
@extern("C", "S_IXUSR") public const sIxusr = 0x0040    // (0000100) X for owner

@extern("C", "S_IRWXG") public const sIrwxg = 0x0038    // (0000070) RWX mask for group
@extern("C", "S_IRGRP") public const sIrgp = 0x0020    // (0000040) R for group
@extern("C", "S_IWGRP") public const sIwriteg = 0x0010    // (0000020) W for group
@extern("C", "S_IXGRP") public const sIexecg = 0x0008    // (0000010) X for group

@extern("C", "S_IRWXO") public const sIrwxo = 0x0007    // (0000007) RWX mask for other
@extern("C", "S_IROTH") public const sIro = 0x0004    // (0000004) R for other
@extern("C", "S_IWOTH") public const sIwo = 0x0002    // (0000002) W for other
@extern("C", "S_IXOTH") public const sIxo = 0x0001    // (0000001) X for other
@extern("C", "S_IFIFO") public const sIfifo = 0x1000    // (0010000) named pipe (fifo)
@extern("C", "S_IFCHR") public const sIfchr = 0x2000    // (0020000) character special
@extern("C", "S_IFDIR") public const sIfdir = 0x4000    // (0040000) directory
@extern("C", "S_IFBLK") public const sIfblk = 0x6000    // (0060000) block special
@extern("C", "S_IFREG") public const sIfreg = 0x8000    // (0100000) regular
@extern("C", "S_IFLNK") public const sIflnk = 0xA000    // (0120000) symbolic link
@extern("C", "S_IFSOCK") public const sIfsock = 0xC000  // (0140000) socket
@extern("C", "S_IFWHT") public const sIfwht = 0xE000    // (0160000) whiteout
@extern("C", "S_ISVTX") public const sIsvtx = 0x0200    // (0001000) save swapped text even after use
@extern("C", "S_IREAD") public const sIread = sIrusr
@extern("C", "S_IWRITE") public const sIwrite = sIwusr
@extern("C", "S_IEXEC") public const sIexec = sIxusr
@extern("C", "S_IFMT") public const sIfmt = 0xF000      // (0170000) type of file mask


/* is directory */
@extern("C", "S_ISDIR") public func sIsdir (m: ModeT) -> Bool { return m & sIfmt == sIfdir }

/* is char special */
@extern("C", "S_ISCHR") public func sIschr (m: ModeT) -> Bool { return m & sIfmt == sIfchr }

/* is block special */
@extern("C", "S_ISBLK") public func sIsblk (m: ModeT) -> Bool { return m & sIfmt == sIfblk }

/* is regular file */
@extern("C", "S_ISREG") public func sIsreg (m: ModeT) -> Bool { return m & sIfmt == sIfreg }

/* is fifo or socket */
@extern("C", "S_ISFIFO") public func sIsfifo (m: ModeT) -> Bool { return m & sIfmt == sIfifo }

/* is symbolic link */
@extern("C", "S_ISLNK") public func sIslnk (m: ModeT) -> Bool { return m & sIfmt == sIflnk }

/* is socket */
@extern("C", "S_ISSOCK") public func sIssock (m: ModeT) -> Bool { return m & sIfmt == sIfsock }

/* is whiteout */
@extern("C", "S_ISWHT") public func sIswht (m: ModeT) -> Bool { return m & sIfmt == sIfwht }

