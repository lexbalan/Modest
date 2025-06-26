include "ctypes64"
include "stdio"
include "stdlib"
include "unistd"
include "socket"
/* thx: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming */


const filename = "file.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func send_file (fp: *File, sockfd: Int) -> Bool {
	var data: [bufSize]Char8

	while fgets(&data, lengthof(data), fp) != nil {
		if send(sockfd, &data, SizeT sizeof data, 0) == -1 {
			return false
		}
		data = []
	}

	return true
}


public func main () -> Int {
	let sockfd: Int = socket(c_AF_INET, c_SOCK_STREAM, 0)
	if sockfd < 0 {
		perror("[-] Error in socket")
		exit(1)
	}

	printf("[+] Server socket created\n")

	var server_addr: SockAddrIn = SockAddrIn {
		sin_family = c_AF_INET
		sin_port = port
		sin_addr = {
			s_addr = inet_addr(ipAddress)
		}
	}

	let sockaddr = *SockAddr Ptr &server_addr
	var e: Int = connect(sockfd, sockaddr, SocklenT sizeof(SockAddrIn))
	if e < 0 {
		perror("[-] Error in Connecting")
		exit(1)
	}

	printf("[+] Connected to server\n")

	let fp: *File = fopen(filename, "r")
	if fp == nil {
		perror("[-] Error in reading file")
		exit(1)
	}

	let suc: Bool = send_file(fp, sockfd)
	if suc {
		printf("[+] File data send successfully\n")
	} else {
		perror("[-] Error in sendung data")
	}

	close(sockfd)
	printf("[+] Disconnected from the server\n")

	return 0
}

