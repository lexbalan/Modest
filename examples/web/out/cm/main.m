include "stdio"
include "stdlib"
include "string"
include "unistd"
include "socket"
include "inet"
// Simple Web server example


const port = 8080

const receiveBufferSize = 1024
const sendBufferSize = 1024

const httpHeader = *Str8 ("HTTP/1.1 200 OK\r\n" + "Content-Type: text/html\r\n" + "Connection: close\r\n" + "\r\n")


var pageCounter: Nat32


//@extern
//@c_no_print
//func htons(x: Word16) -> Word16 {
//	return (x << 8) or (x >> 8)
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


public func main () -> Int32 {
	let serverSocket: Int = socket(c_AF_INET, c_SOCK_STREAM, 0)
	if serverSocket < 0 {
		perror("cannot create socket")
		exit(1)
	}

	var serverAddr: SockAddrIn = SockAddrIn {
		sin_family = c_AF_INET
		sin_addr = {
			s_addr = inAddrAny
		}
		sin_port = UnsignedShort htons(port)
	}

	// Bind socket to address
	let socadr: *SockAddr = unsafe *SockAddr &serverAddr
	var rc: Int = bind(serverSocket, socadr, unsafe SocklenT sizeof serverAddr)
	if rc < 0 {
		perror("cannot bind socket")
		close(serverSocket)
		exit(1)
	}

	// Starting listen to connection
	rc = listen(socket=serverSocket, backlog=5)
	if rc < 0 {
		perror("cannot listen socket")
		close(serverSocket)
		exit(1)
	}

	printf("Server listening on port %d...\n", Nat32 port)

	// Handle input connections
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
		pageCounter = pageCounter + 1
	}

	close(serverSocket)
	return 0
}

