// Simple Web server example

include "libc/stdio"
include "libc/stdlib"
include "libc/string"
include "libc/unistd"
include "libc/socket"
include "libc/arpa/inet"


const port = 8080

const receiveBufferSize = 1024
const sendBufferSize = 1024

const httpHeader = *Str8 (
	"HTTP/1.1 200 OK\r\n" +
	"Content-Type: text/html\r\n" +
	"Connection: close\r\n" +
	"\r\n"
)


var pageCounter: Nat32


//@extern
//@c_no_print
//func htons(x: Word16) -> Word16 {
//	return (x << 8) or (x >> 8)
//}


func handleRequest(client_socket: Int32) -> Unit {
	var buffer: [receiveBufferSize]Word8
    let bytes_received = read(client_socket, &buffer, lengthof(buffer) - 1)
    if bytes_received < 0 {
        perror("cannot read socket")
        close(client_socket)
        return
    }
    buffer[bytes_received] = 0

    printf("Received request:\n%s\n", unsafe *Str8 &buffer)

	var response: [sendBufferSize]Char8
	sprintf(
		&response
		"%s<html><body><h1>Hello, World! (%d)</h1></body></html>"
		httpHeader, pageCounter
	)

    write(client_socket, &response, strlen(&response))
    close(client_socket)
}


public func main() -> Int32 {
    let server_socket = socket(af_INET, c_SOCK_STREAM, 0)
    if server_socket < 0 {
        perror("cannot create socket")
        exit(1)
    }

	var server_addr = SockAddrIn {
		sin_family = af_INET
    	sin_addr = {
			s_addr = inAddrAny
		}
    	sin_port = UnsignedShort htons(port)
	}

    // Bind socket to address
	let socadr = unsafe *SockAddr &server_addr
	var rc = bind(server_socket, socadr, sizeof(server_addr))
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
		let socadr = unsafe *SockAddr &client_addr
		var client_adr_len: SocklenT = sizeof(client_addr)
        let client_socket = accept(server_socket, socadr, &client_adr_len)
        if client_socket < 0 {
            perror("cannot accept connection")
            again
        }
        handleRequest(client_socket)
		++pageCounter
    }

    close(server_socket)
    return 0
}


