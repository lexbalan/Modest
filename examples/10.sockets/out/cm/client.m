
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

	while fgets(&data, bufSize, fp) != nil {
		if send(sockfd, &data, ctypes64.SizeT sizeof([bufSize]Char8), 0) == -1 {
			return false
		}
		data = []
	}

	return true
}


public func main() -> ctypes64.Int {
	let sockfd = socket(af_INET, c_SOCK_STREAM, 0)
	if sockfd < 0 {
		perror("[-] Error in socket")
		exit(1)
	}

	printf("[+] Server socket created\n")

	var server_addr: socket.Struct_sockaddr_in = socket.Struct_sockaddr_in {
		sin_family = af_INET
		sin_port = port
		sin_addr = {
			s_addr = inet_addr(ipAddress)
		}
	}

	let sockaddr = &server_addr
	var e: ctypes64.Int = connect(sockfd, sockaddr, socket.SocklenT sizeof(socket.Struct_sockaddr_in))
	if e < 0 {
		perror("[-] Error in Connecting")
		exit(1)
	}

	printf("[+] Connected to server\n")

	let fp = fopen(filename, "r")
	if fp == nil {
		perror("[-] Error in reading file")
		exit(1)
	}

	let suc = send_file(fp, sockfd)
	if suc {
		printf("[+] File data send successfully\n")
	} else {
		perror("[-] Error in sendung data")
	}

	close(sockfd)
	printf("[+] Disconnected from the server\n")

	return 0
}

