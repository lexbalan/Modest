
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "arpa/inet.h"


const filename = "file2.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func write_file(sockfd: ctypes64.Int) -> Bool {
	var buffer: [bufSize]Char8

	let fp = fopen(filename, "w")
	if fp == nil {
		perror("[-] Error in creating file")
		return false
	}

	while true {
		let n = recv(sockfd, &buffer, bufSize, 0)

		if n <= 0 {
			break
		}

		fprintf(fp, "%s", &buffer)
		buffer = []
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
		sin_addr = socket.Struct_in_addr {
			s_addr = inet_addr(ipAddress)
		}
	}

	let sockaddr = &server_addr
	var e: ctypes64.Int = bind(sockfd, sockaddr, socket.SocklenT sizeof(socket.Struct_sockaddr_in))
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

	var addr_size: socket.SocklenT = socket.SocklenT sizeof(socket.Struct_sockaddr_in)
	var new_addr: socket.Struct_sockaddr_in
	let sa = &new_addr
	let new_sock = accept(sockfd, sa, &addr_size)

	let suc = write_file(new_sock)
	if suc {
		printf("[+] Data written in the text file")
	} else {
		perror("[-] Cannot write file")
	}

	return 0
}

