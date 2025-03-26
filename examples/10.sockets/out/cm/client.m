
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "unistd.h"
@c_include "arpa/inet.h"


const filename = "file.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func send_file(fp: *File, sockfd: Int) -> Bool {
	var data: [<str_value>]Char8

	while stdio.(&data, bufSize, fp) != nil {
		if socket.(sockfd, &data, SizeT sizeof([<str_value>]Char8), 0) == -1 {
			return false
		}
		data = []
	}

	return true
}


public func main() -> Int {
	let sockfd = socket.(socket., socket., 0)
	if sockfd < 0 {
		stdio.("[-] Error in socket")
		stdlib.(1)
	}

	stdio.("[+] Server socket created\n")

	var server_addr: SockAddrIn = SockAddrIn {
		sin_family = socket.
		sin_port = port
		sin_addr = {
			s_addr = socket.(ipAddress)
		}
	}

	let sockaddr = &server_addr
	var e: Int = socket.(sockfd, sockaddr, SocklenT sizeof(SockAddrIn))
	if e < 0 {
		stdio.("[-] Error in Connecting")
		stdlib.(1)
	}

	stdio.("[+] Connected to server\n")

	let fp = stdio.(filename, "r")
	if fp == nil {
		stdio.("[-] Error in reading file")
		stdlib.(1)
	}

	let suc = send_file(fp, sockfd)
	if suc {
		stdio.("[+] File data send successfully\n")
	} else {
		stdio.("[-] Error in sendung data")
	}

	unistd.(sockfd)
	stdio.("[+] Disconnected from the server\n")

	return 0
}

