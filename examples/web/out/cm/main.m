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




func htons(x: Word16) -> Word16 {
	return (x << 8) or (x >> 8)
}


func handleRequest(client_socket: Int32) -> Unit {
	var buffer: [receiveBufferSize]Word8
	let bytes_received = unistd.read(client_socket, &buffer, lengthof(buffer) - 1)
	if bytes_received < 0 {
		stdio.perror("cannot read socket")
		unistd.close(client_socket)
		return
	}
	buffer[bytes_received] = 0

	stdio.printf("Received request:\n%s\n", *Str8 &buffer)

	var response: [sendBufferSize]Char8
	stdio.sprintf(
		&response
		"%s<html><body><h1>Hello, World! (%d)</h1></body></html>"
		httpHeader, pageCounter
	)

	unistd.write(client_socket, &response, string.strlen(&response))
	unistd.close(client_socket)
}


public func main() -> Int32 {
	let server_socket = socket.socket(socket.af_INET, socket.c_SOCK_STREAM, 0)
	if server_socket < 0 {
		stdio.perror("cannot create socket")
		stdlib.exit(1)
	}

	var server_addr: SockAddrIn = SockAddrIn {
		sin_family = socket.af_INET
		sin_addr = {
			s_addr = socket.inAddrAny
		}
		sin_port = UnsignedShort htons(port)
	}

	// Bind socket to address
	let socadr = *SockAddr &server_addr
	var rc: Int = socket.bind(server_socket, socadr, sizeof server_addr)
	if rc < 0 {
		stdio.perror("cannot bind socket")
		unistd.close(server_socket)
		stdlib.exit(1)
	}

	// Starting listen to connection
	rc = socket.listen(server_socket, 5)
	if rc < 0 {
		stdio.perror("cannot listen socket")
		unistd.close(server_socket)
		stdlib.exit(1)
	}

	stdio.printf("Server listening on port %d...\n", Nat32 port)

	// Handle input connections
	while true {
		var client_addr: SockAddrIn
		let socadr = *SockAddr &client_addr
		var client_adr_len: SocklenT = sizeof client_addr
		let client_socket = socket.accept(server_socket, socadr, &client_adr_len)
		if client_socket < 0 {
			stdio.perror("cannot accept connection")
			again
		}
		handleRequest(client_socket)
		pageCounter = pageCounter + 1
	}

	unistd.close(server_socket)
	return 0
}

