
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define MAIN_PORT 8080
#define MAIN_RECEIVE_BUFFER_SIZE 1024
#define MAIN_SEND_BUFFER_SIZE 1024
#define MAIN_HTTP_HEADER "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n"
static uint32_t main_pageCounter;
//@extern
//@c_no_print
//func htons(x: Word16) -> Word16 {
//	return (x << 8) | (x >> 8)
//}

static void main_handleRequest(int32_t clientSocket) {
	uint8_t buffer[MAIN_RECEIVE_BUFFER_SIZE];
	const ssize_t bytesReceived = read(clientSocket, &buffer, LENGTHOF(buffer) - 1);
	if (bytesReceived < 0LL) {
		perror("cannot read socket");
		close(clientSocket);
		return;
	}
	buffer[bytesReceived] = 0x0;
	printf("Received request:\n%s\n", (char *)&buffer);
	char response[MAIN_SEND_BUFFER_SIZE];
	sprintf(response, "%s<html><body><h1>Hello, World! (%d)</h1></body></html>", MAIN_HTTP_HEADER, main_pageCounter);
	write(clientSocket, response, strlen(response));
	close(clientSocket);
}

int32_t main(void) {
	const int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
	if (serverSocket < 0) {
		perror("cannot create socket");
		exit(1);
	}
	struct sockaddr_in serverAddr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_addr = {
			.s_addr = INADDR_ANY
		},
		.sin_port = htons((uint16_t)MAIN_PORT)
	};
	struct sockaddr *const socadr = (struct sockaddr *)&serverAddr;
	int rc = bind(serverSocket, socadr, (socklen_t)sizeof serverAddr);
	if (rc < 0) {
		perror("cannot bind socket");
		close(serverSocket);
		exit(1);
	}
	rc = listen(serverSocket, 5);
	if (rc < 0) {
		perror("cannot listen socket");
		close(serverSocket);
		exit(1);
	}
	printf("Server listening on port %d...\n", (uint32_t)MAIN_PORT);
	while (true) {
		struct sockaddr_in clientAddr;
		struct sockaddr *const socadr = (struct sockaddr *)&clientAddr;
		socklen_t clientAdrLen = (socklen_t)sizeof clientAddr;
		const int clientSocket = accept(serverSocket, socadr, &clientAdrLen);
		if (clientSocket < 0) {
			perror("cannot accept connection");
			continue;
		}
		main_handleRequest(clientSocket);
		main_pageCounter = main_pageCounter + 1U;
	}
	close(serverSocket);
	return 0;
}

