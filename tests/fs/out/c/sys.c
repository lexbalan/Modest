
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>
//#include <dirent.h>

#include <sys/stat.h>

#include "ff.h"
#include "diskio.h"
//#include "debug_uart.h"
//#include "console.h"

#include "sys.h"


// общий префикс для FAT-FS хранилищ
// example: "/storage/sd/0/LOG.TXT"
#define FF_STORAGE_PREFIX  "/storage/sd/"


#define MAX_FF_FILES  8
#define FF_FD_START   8


#define FF_FNO(fd) (fd - FF_FD_START)
#define FF_FILEPTR(fd) (&ff_fd[FF_FNO(fd)])

// fd gринадлежит FAT-FS диапазону
#define IS_FATFS_FD(fd) ((fd >= FF_FD_START) && (fd < (FF_FD_START + MAX_FF_FILES)))

#define IS_OPEN_FATFS_FD(fd) ((IS_FATFS_FD(fd)) && (ff_isbusy[(FF_FNO(fd))]))



// fat_fs files
bool ff_isbusy[MAX_FF_FILES];
FIL ff_fd[MAX_FF_FILES];

// wrappers around FAT-FS
static int ff_open(int devno, const char *fname);
static int ff_read(int fd, void *buf, size_t len);
static int ff_write(int fd, const void *buf, size_t len);
static long ff_lseek(int fd, long offset, int origin);
static long ff_tell(int fd);
static size_t ff_size(int fd);
static int ff_close(int fd);

static DIR cdir;


static int stdin_read(int fd, void *buf, size_t len);
static int stdout_write(int fd, void *buf, size_t len);
static int stderr_write(int fd, void *buf, size_t len);






FATFS fs;

int sys_init(void)
{
	disk_initialize(0);

    FRESULT res = f_mount(&fs, "", 0);
    if(res != FR_OK) {
        return -1;
    }

	DWORD nclst;
	FATFS* fatfs;
	res = f_getfree("/", &nclst, &fatfs);
	if (res != FR_OK) {
		return -2;
	}

	return 0;
}


int sys_deinit(void)
{
	FRESULT res;

	// Unmount
	res = f_mount(NULL, "", 0);
	if(res != FR_OK) {
		return -1;
	}

	return 0;
}





int sys_chdir(const char *path) {
	FRESULT res;
    res = f_opendir(&cdir, "/");
    if(res != FR_OK) {
        printf("f_opendir() failed, res = %d\r\n", res);
        return -1;
    }
	return 0;
}


static int is_ff_pathname(const char *fname);
static const char *ff_pure_name(const char *fname);
static int ff_devno(const char *fname);


int sys_open(const char *fname, int opt, ...) {
	//printf("open(\"%s\", %d)\n", fname, opt);
	if (is_ff_pathname(fname)) {
		// файл принадлежит FF разделу, попробуем его открыть
		const char *s = ff_pure_name(fname);
		const int devno = ff_devno(fname);
		return ff_open(devno, s);
	}
	printf("???\n");
	return -1;
}


int sys_write(int fd, const void *buf, size_t len) {
	if (fd == STDOUT_FILENO) {
		return stdout_write(fd, (void *)buf, len);
	} else if (IS_OPEN_FATFS_FD(fd)) {
		return ff_write(fd, buf, len);
	} else if (fd == STDERR_FILENO) {
		return stderr_write(fd, (void *)buf, len);
	}
	return -1;
}


int sys_read(int fd, void *buf, size_t len) {
	if (fd == STDIN_FILENO) {
		return stdin_read(fd, buf, len);
	} else if (IS_OPEN_FATFS_FD(fd)) {
		return ff_read(fd, buf, len);
	}
	return -1;
}


long sys_lseek(int fd, long offset, int origin) {
	if (IS_OPEN_FATFS_FD(fd)) {
		return ff_lseek(fd, offset, origin);
	}
	return -1;
}


int sys_close(int fd) {
	if (IS_OPEN_FATFS_FD(fd)) {
		return ff_close(fd);
	}
	return -1;
}


long sys_tell(int fd) {
	if (IS_OPEN_FATFS_FD(fd)) {
		return ff_tell(fd);
	}
	return -1;
}


int sys_stat(const char *fname, struct stat *stat) {
	int fd = sys_open(fname, 0);
	if (fd < 0) {
		printf("stat cannot open file! fd = %d\n", fd);
		//errno = EBADF;
		return -1;
	}
	fstat(fd, stat);
	close(fd);
	return 0;
}


int sys_fstat(int fd, struct stat *stat) {
	*stat = (struct stat){0};
	if (!IS_OPEN_FATFS_FD(fd)) {
		//errno = EBADF;
		return -1;
	}
	stat->st_size = ff_size(fd);
	return 0;
}



int sys_unlink(const char *fname) {
	printf("unlink(\"%s\")\n", fname);
	if (is_ff_pathname(fname)) {
		const char *s = ff_pure_name(fname);
		FRESULT res = f_unlink(s);
		if(res != FR_OK) {
			printf("f_unlink() failed, res = %d\r\n", res);
			return -1;
		}
		return 0;
	}

	//errno = EBADF;
	return -1;
}



//--------------------------------------------------------------------------------
//
//--------------------------------------------------------------------------------


static int ff_open(int devno, const char *fname) {
	// ищем свободный FF файловый дескриптор
	int fd = -1;
	for (int i=0; i < MAX_FF_FILES; i++) {
		if (ff_isbusy[i] == false) {
			ff_isbusy[i] = true;
			fd = i + FF_FD_START;
			break;
		}
	}

	if (fd < 0) {
		return -1;  // there's no free file descriptor
	}

	*FF_FILEPTR(fd) = (FIL){0};

	FRESULT res = f_open(FF_FILEPTR(fd), fname, FA_READ);
    if (res != FR_OK) {
		printf("ff_open, f_open error = %d\n", res);
        return -1;
    }

	return fd;
}


static int ff_read(int fd, void *buf, size_t len) {
	UINT bytesRead;
	//FRESULT f_read (FIL* fp, void* buff, UINT btr, UINT* br);
	FRESULT res = f_read(FF_FILEPTR(fd), buf, (UINT)len, &bytesRead);
	if (res == FR_OK) {
		return (int)bytesRead;
	}
	return -1;
}


static int ff_write(int fd, const void *buf, size_t len) {
	UINT bytesWritten;
	FRESULT res = f_write(FF_FILEPTR(fd), (void *)buf, (UINT)len, &bytesWritten);
	if (res == FR_OK) {
		return (int)bytesWritten;
	}
	return -1;
}


static long ff_lseek(int fd, long offset, int origin) {
	FRESULT res;
	FIL *ff = FF_FILEPTR(fd);
	if (origin == SEEK_SET) {
		res = f_lseek(ff, (FSIZE_t)offset);
		if(res == FR_OK) {
			return f_tell(ff);
		}
	}

	return -1;
}


static size_t ff_size(int fd) {
	return f_size(FF_FILEPTR(fd));
}


static long ff_tell(int fd) {
	return f_tell(FF_FILEPTR(fd));
}


static int ff_close(int fd) {
	FRESULT res = f_close(FF_FILEPTR(fd));
	if(res != FR_OK) {
		printf("f_close() failed, res = %d\r\n", res);
		return -1;
	}

	ff_isbusy[FF_FNO(fd)] = false;
	return 0;
}



static int stdin_read(int fd, void *buf, size_t len) {
	//return debug_uart_read(buf, len);
	return -1; //console_read(buf, len);
}


static int stdout_write(int fd, void *buf, size_t len) {
	return -1;//console_write(buf, len);
}


static int stderr_write(int fd, void *buf, size_t len) {
	return -1;//console_write(buf, len);
}


static int is_ff_pathname(const char *fname) {
	const int prefix_len = strlen(FF_STORAGE_PREFIX);
	return strncmp(fname, FF_STORAGE_PREFIX, prefix_len) == 0;
}

// получает полный путь к файлу
// возвращает порядковый номер накопителя
static int ff_devno(const char *fname) {
	//const int prefix_len = strlen(FF_STORAGE_PREFIX);
	return 0;//&fname[prefix_len];
}

// получает полный путь к файлу
// возвращает имя файла на накопителе
static const char *ff_pure_name(const char *fname) {
	const int prefix_len = strlen(FF_STORAGE_PREFIX);
	return &fname[prefix_len+2]; //skip: "0/"
}

