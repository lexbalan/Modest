
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


#define PORT  8080

#define RECEIVE_BUFFER_SIZE  1024
#define SEND_BUFFER_SIZE  1024

#define HTTP_HEADER  (("HTTP/1.1 200 OK\r\n" "Content-Type: text/html\r\n" "Connection: close\r\n" "\r\n"))

static uint32_t pageCounter;

//@extern
//@c_no_print
//func htons(x: Word16) -> Word16 {
//	return (x << 8) or (x >> 8)
//}

static void handleRequest(int32_t clientSocket) {
	uint8_t buffer[RECEIVE_BUFFER_SIZE];
	const ssize_t bytesReceived = read(clientSocket, (void *)&buffer, LENGTHOF(buffer) - 1);
	if (bytesReceived < 0) {
		perror(/*4*/"cannot read socket");
		close(clientSocket);
		return;
	}
	buffer[bytesReceived] = 0x0;

	printf(/*4*/"Received request:\n%s\n", /*4*/(char*)(char *)&buffer);

	char response[SEND_BUFFER_SIZE];
	sprintf(/*4*/&response[0], /*4*/"%s<html><body><h1>Hello, World! (%d)</h1></body></html>",
		/*4*/(char*)HTTP_HEADER, pageCounter
	);

	write(clientSocket, (void *)&response, strlen(/*4*/&response[0]));
	close(clientSocket);
}


int32_t main(void) {
	const int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
	if (serverSocket < 0) {
		perror(/*4*/"cannot create socket");
		exit(1);
	}

	struct sockaddr_in serverAddr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = (unsigned short)htons(PORT),
		.sin_addr = (struct in_addr){
			.s_addr = INADDR_ANY
		}
	};

	// Bind socket to address
	struct sockaddr *const socadr = (struct sockaddr *)&serverAddr;
	int rc = bind(serverSocket, socadr, (socklen_t)sizeof serverAddr);
	if (rc < 0) {
		perror(/*4*/"cannot bind socket");
		close(serverSocket);
		exit(1);
	}

	// Starting listen to connection
	rc = listen(serverSocket, 5);
	if (rc < 0) {
		perror(/*4*/"cannot listen socket");
		close(serverSocket);
		exit(1);
	}

	printf(/*4*/"Server listening on port %d...\n", (uint32_t)PORT);

	// Handle input connections
	while (true) {
		struct sockaddr_in clientAddr;
		struct sockaddr *const socadr = (struct sockaddr *)&clientAddr;
		socklen_t clientAdrLen = (socklen_t)sizeof clientAddr;
		const int clientSocket = accept(serverSocket, socadr, &clientAdrLen);
		if (clientSocket < 0) {
			perror(/*4*/"cannot accept connection");
			continue;
		}
		handleRequest(clientSocket);
		pageCounter = pageCounter + 1;
	}

	close(serverSocket);
	return 0;
}


