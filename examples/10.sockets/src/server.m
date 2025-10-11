/* thx: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming */

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"
include "libc/socket"


const filename = "file2.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func writeFile (sockFd: Int) -> Bool {
	var buffer: [bufSize]Char8

	let fp = fopen(filename, "w")
	if fp == nil {
		perror("[-] Error in creating file")
		return false
	}

	while true {
		let n = recv(sockFd, &buffer, bufSize, 0)
		if n <= 0 {
			break
		}
		fprintf(fp, "%s", &buffer)
		buffer = []
	}

	return true
}


public func main () -> Int {
	let sockFd = socket(c_AF_INET, c_SOCK_STREAM, 0)
	if sockFd < 0 {
		perror("[-] Error in socket")
		exit(1)
	}

	printf("[+] Server socket created\n")

	var serverAddr = SockAddrIn {
		sin_family = c_AF_INET
		sin_port = port
		sin_addr = Struct_in_addr {
			s_addr = inet_addr(ipAddress)
		}
	}

	let sockAddr = *SockAddr Ptr &serverAddr
	var e = bind(sockFd, sockAddr, unsafe SocklenT sizeof(SockAddrIn))
	if e < 0 {
		perror("[-] Error in Binding")
		exit(1)
	}

	printf("[+] Binding Successfull\n")

	e = listen(sockFd, 10)
	if e != 0 {
		perror("[-] Error in Binding")
		exit(1)
	}

	printf("[+] Listening...\n")

	var addrSize = unsafe SocklenT sizeof(SockAddrIn)
	var newAddr: SockAddrIn
	let sa = *SockAddr Ptr &newAddr
	let newSock = accept(sockFd, sa, &addrSize)

	let suc = writeFile(newSock)
	if suc {
		printf("[+] Data written in the text file")
	} else {
		perror("[-] Cannot write file")
	}

	return 0
}

