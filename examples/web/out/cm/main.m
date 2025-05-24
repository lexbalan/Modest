include "stdio"
include "stdlib"
include "string"
include "unistd"
include "socket"



const port = 8080

const receiveBufferSize = 1024
const sendBufferSize = 1024

const httpHeader = *Str8 ("HTTP/1.1 200 OK\r\n" + "Content-Type: text/html\r\n" + "Connection: close\r\n" + "\r\n")


var pageCounter: Nat32


func handleRequest (client_socket: Int32) -> Unit {
	var buffer: [receiveBufferSize]Word8
	let bytes_received: SSizeT = read(client_socket, &buffer, lengthof(buffer) - 1)
	if bytes_received < 0 {
		perror("cannot read socket")
		close(client_socket)
		return
	}
	buffer[bytes_received] = 0

	printf("Received request:\n%s\n", *Str8 &buffer)

	var response: [sendBufferSize]Char8
	sprintf(
		&response
		"%s<html><body><h1>Hello, World! (%d)</h1></body></html>"
		httpHeader, pageCounter
	)

	write(client_socket, &response, strlen(&response))
	close(client_socket)
}


public func main () -> Int32 {
	let server_socket: Int = socket(af_INET, c_SOCK_STREAM, 0)
	if server_socket < 0 {
		perror("cannot create socket")
		exit(1)
	}

	var server_addr: SockAddrIn = SockAddrIn {
		sin_family = af_INET
		sin_addr = {
			s_addr = inAddrAny
		}
		sin_port = UnsignedShort htons(port)
	}

	// Bind socket to address
	let socadr: *SockAddr = *SockAddr &server_addr
	var rc: Int = bind(server_socket, socadr, sizeof server_addr)
	if rc < 0 {
		perror("cannot bind socket")
		close(server_socket)
		exit(1)
	}

	// Starting listen to connection
	rc = listen(socket=server_socket, backlog=5)
	if rc < 0 {
		perror("cannot listen socket")
		close(server_socket)
		exit(1)
	}

	printf("Server listening on port %d...\n", Nat32 port)

	// Handle input connections
	while true {
		var client_addr: SockAddrIn
		let socadr: *SockAddr = *SockAddr &client_addr
		var client_adr_len: SocklenT = sizeof client_addr
		let client_socket: Int = accept(server_socket, socadr, &client_adr_len)
		if client_socket < 0 {
			perror("cannot accept connection")
			again
		}
		handleRequest(client_socket)
		pageCounter = pageCounter + 1
	}

	close(server_socket)
	return 0
}

