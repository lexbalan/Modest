include "ctypes64"
include "stdio"
include "stdlib"
include "socket"
/* thx: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming */


const filename = "file2.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func write_file (sockfd: Int) -> Bool {
	var buffer: [bufSize]Char8

	let fp: *File = fopen(filename, "w")
	if fp == nil {
		perror("[-] Error in creating file")
		return false
	}

	while true {
		let n: SSizeT = recv(sockfd, &buffer, bufSize, 0)

		if n <= 0 {
			break
		}

		fprintf(fp, "%s", &buffer)
		buffer = []
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
		sin_addr = Struct_in_addr {
			s_addr = inet_addr(ipAddress)
		}
	}

	let sockaddr = *SockAddr Ptr &server_addr
	var e: Int = bind(sockfd, sockaddr, unsafe SocklenT sizeof(SockAddrIn))
	if e < 0 {
		perror("[-] Error in Binding")
		exit(1)
	}

	printf("[+] Binding Successfull\n")

	e = listen(sockfd, 10)
	if e != 0 {
		perror("[-] Error in Binding")
		exit(1)
	}

	printf("[+] Listening...\n")

	var addr_size: SocklenT = unsafe SocklenT sizeof(SockAddrIn)
	var new_addr: SockAddrIn
	let sa = *SockAddr Ptr &new_addr
	let new_sock: Int = accept(sockfd, sa, &addr_size)

	let suc: Bool = write_file(new_sock)
	if suc {
		printf("[+] Data written in the text file")
	} else {
		perror("[-] Cannot write file")
	}

	return 0
}

