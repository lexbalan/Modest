
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"
@c_include "unistd.h"
@c_include "arpa/inet.h"


const port = 8080

const receiveBufferSize = 1024
const sendBufferSize = 1024

const httpHeader = *Str8 ("HTTP/1.1 200 OK\r\n" + "Content-Type: text/html\r\n" + "Connection: close\r\n" + "\r\n")


var pageCounter: Nat32




func htons(x: Word16) -> Word16 {
	return (x << 8) or (x >> 8)
}


func handleRequest(client_socket: Int32) -> Unit {
	var buffer: [<str_value>]Word8
	let bytes_received = unistd.(client_socket, &buffer, lengthof(buffer) - 1)
	if bytes_received < 0 {
		stdio.("read")
		unistd.(client_socket)
		return
	}
	buffer[bytes_received] = 0

	stdio.("Received request:\n%s\n", *Str8 &buffer)

	var response: [<str_value>]Char8
	stdio.(&response, "%s<html><body><h1>Hello, World! (%d)</h1></body></html>", httpHeader, pageCounter)

	unistd.(client_socket, &response, string.(&response))
	unistd.(client_socket)
}


public func main() -> Int32 {
	let server_socket = socket.(socket., socket., 0)
	if server_socket < 0 {
		stdio.("socket")
		stdlib.(1)
	}

	var server_addr: SockAddrIn = SockAddrIn {
		sin_family = socket.
		sin_addr = {
			s_addr = socket.
		}
		sin_port = UnsignedShort htons(port)
	}

	// Bind socket to address
	let socadr = *SockAddr &server_addr
	var rc: Int = socket.(server_socket, socadr, sizeof server_addr)
	if rc < 0 {
		stdio.("bind")
		unistd.(server_socket)
		stdlib.(1)
	}

	// Starting listen to connection
	rc = socket.(server_socket, 5)
	if rc < 0 {
		stdio.("listen")
		unistd.(server_socket)
		stdlib.(1)
	}

	stdio.("Server listening on port %d...\n", Nat32 port)

	// Handle input connections
	while true {
		var client_addr: SockAddrIn
		let socadr = *SockAddr &client_addr
		var client_adr_len: SocklenT = sizeof client_addr
		let client_socket = socket.(server_socket, socadr, &client_adr_len)
		if client_socket < 0 {
			stdio.("accept")
			again
		}
		handleRequest(client_socket)
		pageCounter = pageCounter + 1
	}

	unistd.(server_socket)
	return 0
}

