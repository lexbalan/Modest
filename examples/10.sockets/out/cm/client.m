
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "unistd.h"
@c_include "arpa/inet.h"


const filename = "file.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func send_file(fp: *stdio.File, sockfd: ctypes64.Int) -> Bool {
	var data: [bufSize]Char8

	while stdio.fgets(&data, bufSize, fp) != nil {
		if socket.send(sockfd, &data, ctypes64.SizeT sizeof([bufSize]Char8), 0) == -1 {
			return false
		}
		data = []
	}

	return true
}


public func main() -> ctypes64.Int {
	let sockfd = socket.socket(socket.af_INET, socket.c_SOCK_STREAM, 0)
	if sockfd < 0 {
		stdio.perror("[-] Error in socket")
		stdlib.exit(1)
	}

	stdio.printf("[+] Server socket created\n")

	var server_addr: socket.Struct_sockaddr_in = socket.Struct_sockaddr_in {
		sin_family = socket.af_INET
		sin_port = port
		sin_addr = {
			s_addr = socket.inet_addr(ipAddress)
		}
	}

	let sockaddr = &server_addr
	var e: ctypes64.Int = socket.connect(sockfd, sockaddr, socket.SocklenT sizeof(socket.Struct_sockaddr_in))
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

