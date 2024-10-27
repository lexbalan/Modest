
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
@c_include "time.h"
include "libc/time"
@c_include "unistd.h"
include "libc/unistd"
@c_include "stdlib.h"
include "libc/stdlib"
public func main() -> Int {
	printf("unistd test\n")

	let pid = getpid()
	printf("pid = %d\n", pid)

	let hid = gethostid()
	printf("hostid = %ld\n", hid)

	// current control terminal
	var cterm: [128]Char8
	ctermid(&cterm)
	printf("ctermid = %s\n", &cterm)

	// current working directory
	var cwd: [128]Char8
	getcwd(&cwd, sizeof cwd)
	printf("cwd = %s\n", &cwd)

	let tty = ttyname(0)
	printf("ttyname = %s\n", tty)


	let s = getenv("PATH")
	printf("PATH = %s\n", s)

	while true {
		printf("- hi\n")
		sleep(1)
	}

	return 0
}
