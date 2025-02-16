
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"
@c_include "unistd.h"
@c_include "arpa/inet.h"


const port = 8080
const receive_buffer = 1024 * 4


func htons(x: Word16) -> Word16 {
	return x << 8 or x >> 8
}


func handle_request(client_socket: Int32) -> Unit {
	stdio.printf("handle_request()\n")

	var buffer: [receive_buffer]Word8

	let bytes_received = unistd.read(client_socket, &buffer, lengthof(buffer) - 1)
	if bytes_received < 0 {
		stdio.perror("read")
		unistd.close(client_socket)
		return
	}

	buffer[bytes_received] = 0

	stdio.printf("Received request:\n%s\n", *Str8 &buffer)

	var response: [112]Char8 = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n<html><body><h1>Hello, World!</h1></body></html>\x0"
	unistd.write(client_socket, &response, string.strlen(&response))
	unistd.close(client_socket)
}


public func main() -> Int32 {
	var server_socket: Int32
	var client_socket: Int32
	var server_addr: socket.Struct_sockaddr_in
	var client_addr: socket.Struct_sockaddr_in
	var client_len: socket.SocklenT = sizeof client_addr

	server_socket = socket.socket(socket.af_INET, socket.c_SOCK_STREAM, 0)
	if server_socket < 0 {
		stdio.perror("socket")
		stdlib.exit(1)
	}

	server_addr = {
		sin_family = socket.af_INET
		sin_addr = {
			s_addr = socket.inAddrAny
		}
		sin_port = ctypes64.UnsignedShort htons(port)
	}

	// Bind socket to address
	let soc = *socket.Struct_sockaddr &server_addr
	var rc: ctypes64.Int = socket.bind(server_socket, soc, sizeof server_addr)
	if rc < 0 {
		stdio.perror("bind")
		unistd.close(server_socket)
		stdlib.exit(1)
	}

	// Starting listen to connection
	rc = socket.listen(server_socket, 5)
	if rc < 0 {
		stdio.perror("listen")
		unistd.close(server_socket)
		stdlib.exit(1)
	}

	stdio.printf("Server listening on port %d...\n", Nat32 port)

	// Handle input connections
	while true {
		let soc = *socket.Struct_sockaddr &client_addr
		client_socket = socket.accept(server_socket, soc, &client_len)
		if client_socket < 0 {
			stdio.perror("accept")
			again
		}

		handle_request(client_socket)
	}

	unistd.close(server_socket)
	return 0
}

