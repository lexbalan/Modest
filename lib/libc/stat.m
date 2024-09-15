// libc/stat.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "sys/stat.h"

import "libc/ctypes"
import "libc/time"


export {
	type DevT Nat32
	type InoT Nat64
	type ModeT Nat16
	type NLinkT Nat16
	type UIDT Nat32
	type GIDT Nat32
	type BlkSizeT Nat32
	type BlkCntT Nat64

	type DarwinIno64T Nat64

	//
	//@property("type.id.c", "struct stat")
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


	type DarwinTimeT Nat64

	@property("type.id.c", "struct timespec")
	type Timespec record {
		tv_sec: DarwinTimeT
		tv_nsec: Long
	}


	/* for MACOS see: /Library/Developer/CommandLineTools/SDKs/MacOSX13.0.sdk/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/sys
	*/


	@property("type.id.c", "struct stat")
	type Stat record {
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
	func stat(path: *[]ConstChar, stat: *Stat) -> Int


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


	let s_ISUID = 0x0800	// (0004000) set user id on execution
	let s_ISGID = 0x0400	// (0002000) set group id on execution
	let s_ISTXT = 0x0200	// (0001000) sticky bit

	let s_IRWXU = 0x01C0	// (0000700) RWX mask for owner
	let s_IRUSR = 0x0100	// (0000400) R for owner
	let s_IWUSR = 0x0080	// (0000200) W for owner
	let s_IXUSR = 0x0040	// (0000100) X for owner

	let s_IREAD = s_IRUSR
	let s_IWRITE = s_IWUSR
	let s_IEXEC = s_IXUSR

	let s_IRWXG = 0x0038   // (0000070) RWX mask for group
	let s_IRGRP = 0x0020   // (0000040) R for group
	let s_IWGRP = 0x0010   // (0000020) W for group
	let s_IXGRP = 0x0008   // (0000010) X for group

	let s_IRWXO = 0x0007   // (0000007) RWX mask for other
	let s_IROTH = 0x0004   // (0000004) R for other
	let s_IWOTH = 0x0002   // (0000002) W for other
	let s_IXOTH = 0x0001   // (0000001) X for other

	let s_IFMT = 0xF000    // (0170000) type of file mask
	let s_IFIFO = 0x1000   // (0010000) named pipe (fifo)
	let s_IFCHR = 0x2000   // (0020000) character special
	let s_IFDIR = 0x4000   // (0040000) directory
	let s_IFBLK = 0x6000   // (0060000) block special
	let s_IFREG = 0x8000   // (0100000) regular
	let s_IFLNK = 0xA000   // (0120000) symbolic link
	let s_IFSOCK = 0xC000  // (0140000) socket
	let s_IFWHT = 0xE000   // (0160000) whiteout
	let s_ISVTX = 0x0200   // (0001000) save swapped text even after use


	/* is directory */
	@property("value.id.c", "S_ISDIR")
	func s_ISDIR(m: ModeT) -> Bool {
		return (m and s_IFMT) == s_IFDIR
	}

	/* is char special */
	@property("value.id.c", "S_ISCHR")
	func s_ISCHR(m: ModeT) -> Bool {
		return (m and s_IFMT) == s_IFCHR
	}

	/* is block special */
	@property("value.id.c", "S_ISBLK")
	func s_ISBLK(m: ModeT) -> Bool {
		return (m and s_IFMT) == s_IFBLK
	}

	/* is regular file */
	@property("value.id.c", "S_ISREG")
	func s_ISREG(m: ModeT) -> Bool {
		return (m and s_IFMT) == s_IFREG
	}

	/* is fifo or socket */
	@property("value.id.c", "S_ISFIFO")
	func s_ISFIFO(m: ModeT) -> Bool {
		return (m and s_IFMT) == s_IFIFO
	}

	/* is symbolic link */
	@property("value.id.c", "S_ISLNK")
	func s_ISLNK(m: ModeT) -> Bool {
		return (m and s_IFMT) == s_IFLNK
	}

	/* is socket */
	@property("value.id.c", "S_ISSOCK")
	func s_ISSOCK(m: ModeT) -> Bool {
		return (m and s_IFMT) == s_IFSOCK
	}

	/* is whiteout */
	@property("value.id.c", "S_ISWHT")
	func s_ISWHT(m: ModeT) -> Bool {
		return (m and s_IFMT) == s_IFWHT
	}
}

