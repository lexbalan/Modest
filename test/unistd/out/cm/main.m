
include "libc/ctypes64"
include "libc/stdio"
include "libc/time"
include "libc/unistd"

func main() -> Int {
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
	printf("s = %s\n", s)

	while true {
		printf("- hi\n")
		sleep(1)
	}

	return 0
}

