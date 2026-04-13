#ifndef SYS_H
#define SYS_H

typedef int sys_Int;
typedef unsigned int sys_Nat;
typedef unsigned int sys_Word;
typedef long long sys_Long;
typedef size_t sys_Size;


int sys_init(void);
int sys_deinit(void);

int sys_chdir(const char *path);
int sys_open(const char *fname, int opt, ...);
int sys_stat(const char *fname, struct stat *stat);
int sys_fstat(int fd, struct stat *stat);
int sys_unlink(const char *fname);
int sys_write(int fd, const void *buf, size_t len);
int sys_read(int fd, void *buf, size_t len);
long sys_lseek(int fd, long offset, int origin);
long sys_tell(int fd);
int sys_close(int fd);

#endif /* SYS_H */

