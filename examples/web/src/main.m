// Simple Web server example

include "libc/stdio"
include "libc/stdlib"
include "libc/string"
include "libc/unistd"
include "libc/socket"


const port = 8080
const receive_buffer = 1024 * 4


func htons(x: Word16) -> Word16 {
	return (x << 8) or (x >> 8)
}


func handle_request(client_socket: Int32) -> Unit {
	printf("handle_request()\n")

	var buffer: [receive_buffer]Word8

    let bytes_received = read(client_socket, &buffer, lengthof(buffer) - 1)
    if bytes_received < 0 {
        perror("read")
        close(client_socket)
        return
    }

    buffer[bytes_received] = 0

    printf("Received request:\n%s\n", unsafe *Str8 &buffer)

	var response: []Char8 = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n<html><body><h1>Hello, World!</h1></body></html>\0"
    write(client_socket, &response, strlen(&response))
    close(client_socket)
}


public func main() -> Int32 {
	var server_socket, client_socket: Int32
	var server_addr, client_addr: Struct_sockaddr_in
	var client_len: SocklenT = sizeof(client_addr)

    server_socket = socket(af_INET, c_SOCK_STREAM, 0)
    if server_socket < 0 {
        perror("socket")
        exit(1)
    }

	server_addr = {
		sin_family = af_INET
    	sin_addr = {
			s_addr = inAddrAny
		}
    	sin_port = UnsignedShort htons(port)
	}

    // Bind socket to address
	let soc = unsafe *Struct_sockaddr &server_addr
	var rc = bind(server_socket, soc, sizeof(server_addr))
    if rc < 0 {
        perror("bind")
        close(server_socket)
        exit(1)
    }

    // Starting listen to connection
	rc = listen(server_socket, 5)
    if rc < 0 {
        perror("listen")
        close(server_socket)
        exit(1)
    }

    printf("Server listening on port %d...\n", Nat32 port)

    // Handle input connections
    while true {
		let soc = unsafe *Struct_sockaddr &client_addr
        client_socket = accept(server_socket, soc, &client_len)
        if client_socket < 0 {
            perror("accept")
            again
        }

        handle_request(client_socket)
    }

    close(server_socket)
    return 0
}


