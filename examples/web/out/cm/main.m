import "builtin"
include "stdio"
include "stdlib"
include "string"
include "unistd"
include "socket"
include "inet"

include "libc/stdio"
include "libc/stdlib"
include "libc/string"
include "libc/unistd"
include "libc/socket"
include "libc/arpa/inet"


const port = 8080

const receiveBufferSize = 1024
const sendBufferSize = 1024

const httpHeader = *Str8 ("HTTP/1.1 200 OK\r\n" + "Content-Type: text/html\r\n" + "Connection: close\r\n" + "\r\n")


var pageCounter: Nat32


//@extern
//@c_no_print
//func htons(x: Word16) -> Word16 {
//	return (x << 8) | (x >> 8)
//}


func handleRequest (clientSocket: Int32) -> Unit {
	var buffer: [receiveBufferSize]Word8
	let bytesReceived: SSizeT = read(clientSocket, &buffer, lengthof(buffer) - 1)
	if bytesReceived < 0 {
		perror("cannot read socket")
		close(clientSocket)
		return
	}
	buffer[bytesReceived] = 0

	printf("Received request:\n%s\n", unsafe *Str8 &buffer)

	var response: [sendBufferSize]Char8
	sprintf(&response, "%s<html><body><h1>Hello, World! (%d)</h1></body></html>"
		httpHeader, pageCounter
	)

	write(clientSocket, &response, strlen(&response))
	close(clientSocket)
}


@nonstatic
func main () -> Int32 {
	let serverSocket: Int = socket(afInet, sockStream, 0)
	if serverSocket < 0 {
		perror("cannot create socket")
		exit(1)
	}

	var serverAddr = SockAddrIn {
		sin_family = afInet
		sin_addr = {
			s_addr = inAddrAny
		}
		sin_port = UnsignedShort htons(port)
	}
	let socadr: *SockAddr = unsafe *SockAddr &serverAddr
	var rc: Int = bind(serverSocket, socadr, unsafe SocklenT sizeof serverAddr)
	if rc < 0 {
		perror("cannot bind socket")
		close(serverSocket)
		exit(1)
	}
	rc = listen(socket=serverSocket, backlog=5)
	if rc < 0 {
		perror("cannot listen socket")
		close(serverSocket)
		exit(1)
	}

	printf("Server listening on port %d...\n", Nat32 port)
	while true {
		var clientAddr: SockAddrIn
		let socadr: *SockAddr = unsafe *SockAddr &clientAddr
		var clientAdrLen: SocklenT = unsafe SocklenT sizeof clientAddr
		let clientSocket: Int = accept(serverSocket, socadr, &clientAdrLen)
		if clientSocket < 0 {
			perror("cannot accept connection")
			again
		}
		handleRequest(clientSocket)
		++pageCounter
	}

	close(serverSocket)
	return 0
}

