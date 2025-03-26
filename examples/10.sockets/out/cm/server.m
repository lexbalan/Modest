
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "arpa/inet.h"


const filename = "file2.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func write_file(sockfd: Int) -> Bool {
	var buffer: [<str_value>]Char8

	let fp = stdio.(filename, "w")
	if fp == nil {
		stdio.("[-] Error in creating file")
		return false
	}

	while true {
		let n = socket.(sockfd, &buffer, bufSize, 0)

		if n <= 0 {
			break
		}

		stdio.(fp, "%s", &buffer)
		buffer = []
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
		sin_addr = Struct_in_addr {
			s_addr = socket.(ipAddress)
		}
	}

	let sockaddr = &server_addr
	var e: Int = socket.(sockfd, sockaddr, SocklenT sizeof(SockAddrIn))
	if e < 0 {
		stdio.("[-] Error in Binding")
		stdlib.(1)
	}

	stdio.("[+] Binding Successfull\n")

	e = socket.(sockfd, 10)
	if e != 0 {
		stdio.("[-] Error in Binding")
		stdlib.(1)
	}

	stdio.("[+] Listening...\n")

	var addr_size: SocklenT = SocklenT sizeof(SockAddrIn)
	var new_addr: SockAddrIn
	let sa = &new_addr
	let new_sock = socket.(sockfd, sa, &addr_size)

	let suc = write_file(new_sock)
	if suc {
		stdio.("[+] Data written in the text file")
	} else {
		stdio.("[-] Cannot write file")
	}

	return 0
}

