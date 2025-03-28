include "ctypes64"
include "stdio"
include "stdlib"
include "socket"



const filename = "file2.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func write_file(sockfd: Int) -> Bool {
	var buffer: [<str_value>]Char8

	let fp = stdio.fopen(filename, "w")
	if fp == nil {
		stdio.perror("[-] Error in creating file")
		return false
	}

	while true {
		let n = socket.recv(sockfd, &buffer, bufSize, 0)

		if n <= 0 {
			break
		}

		stdio.fprintf(fp, "%s", &buffer)
		buffer = []
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
		sin_addr = Struct_in_addr {
			s_addr = socket.inet_addr(ipAddress)
		}
	}

	let sockaddr = &server_addr
	var e: Int = socket.bind(sockfd, sockaddr, SocklenT sizeof(SockAddrIn))
	if e < 0 {
		stdio.perror("[-] Error in Binding")
		stdlib.exit(1)
	}

	stdio.printf("[+] Binding Successfull\n")

	e = socket.listen(sockfd, 10)
	if e != 0 {
		stdio.perror("[-] Error in Binding")
		stdlib.exit(1)
	}

	stdio.printf("[+] Listening...\n")

	var addr_size: SocklenT = SocklenT sizeof(SockAddrIn)
	var new_addr: SockAddrIn
	let sa = &new_addr
	let new_sock = socket.accept(sockfd, sa, &addr_size)

	let suc = write_file(new_sock)
	if suc {
		stdio.printf("[+] Data written in the text file")
	} else {
		stdio.perror("[-] Cannot write file")
	}

	return 0
}

