include "ctypes64"
include "stdio"
include "stdlib"
include "socket"



const filename = "file2.txt"

const ipAddress = "127.0.0.1"
const port = 8080
const bufSize = 1024


func writeFile (sockFd: Int) -> Bool {
	var buffer: [bufSize]Char8

	let fp: *File = fopen(filename, "w")
	if fp == nil {
		perror("[-] Error in creating file")
		return false
	}

	while true {
		let n: SSizeT = recv(sockFd, &buffer, bufSize, 0)
		if n <= 0 {
			break
		}
		fprintf(fp, "%s", *[bufSize]Char8 &buffer)
		buffer = []
	}

	return true
}


public func main () -> Int {
	let sockFd: Int = socket(c_AF_INET, c_SOCK_STREAM, 0)
	if sockFd < 0 {
		perror("[-] Error in socket")
		exit(1)
	}

	printf("[+] Server socket created\n")

	var serverAddr: SockAddrIn = SockAddrIn {
		sin_family = c_AF_INET
		sin_port = port
		sin_addr = Struct_in_addr {
			s_addr = inet_addr(ipAddress)
		}
	}

	let sockAddr = *SockAddr Ptr &serverAddr
	var e: Int = bind(sockFd, sockAddr, unsafe SocklenT sizeof(SockAddrIn))
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

	var addrSize: SocklenT = unsafe SocklenT sizeof(SockAddrIn)
	var newAddr: SockAddrIn
	let sa = *SockAddr Ptr &newAddr
	let newSock: Int = accept(sockFd, sa, &addrSize)

	let suc: Bool = writeFile(newSock)
	if suc {
		printf("[+] Data written in the text file")
	} else {
		perror("[-] Cannot write file")
	}

	return 0
}

