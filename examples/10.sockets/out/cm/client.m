include "ctypes64"
include "stdio"
include "stdlib"
include "unistd"
include "socket"



const filename = "file.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func send_file(fp: *File, sockfd: Int) -> Bool {
	var data: [<str_value>]Char8

	while stdio.fgets(&data, bufSize, fp) != nil {
		if socket.send(sockfd, &data, SizeT sizeof([<str_value>]Char8), 0) == -1 {
			return false
		}
		data = []
	}

	return true
}


public func main() -> Int {
	let sockfd = socket.socket(socket.af_INET, socket.c_SOCK_STREAM, 0)
	if sockfd < 0 {
		stdio.perror("[-] Error in socket")
		stdlib.exit(1)
	}

	stdio.printf("[+] Server socket created\n")

	var server_addr: SockAddrIn = SockAddrIn {
		sin_family = socket.af_INET
		sin_port = port
		sin_addr = {
			s_addr = socket.inet_addr(ipAddress)
		}
	}

	let sockaddr = &server_addr
	var e: Int = socket.connect(sockfd, sockaddr, SocklenT sizeof(SockAddrIn))
	if e < 0 {
		stdio.perror("[-] Error in Connecting")
		stdlib.exit(1)
	}

	stdio.printf("[+] Connected to server\n")

	let fp = stdio.fopen(filename, "r")
	if fp == nil {
		stdio.perror("[-] Error in reading file")
		stdlib.exit(1)
	}

	let suc = send_file(fp, sockfd)
	if suc {
		stdio.printf("[+] File data send successfully\n")
	} else {
		stdio.perror("[-] Error in sendung data")
	}

	unistd.close(sockfd)
	stdio.printf("[+] Disconnected from the server\n")

	return 0
}

