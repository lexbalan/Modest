
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */


#define port  8080

#define receive_buffer_size  1024
#define send_buffer_size  1024

#define httpHeader  (char *)("HTTP/1.1 200 OK\r\n" "Content-Type: text/html\r\n" "Connection: close\r\n\r\n")

static uint32_t pageCounter;

static void handle_request(int32_t client_socket)
{
	uint8_t buffer[receive_buffer_size];
	memset(&buffer, 0, sizeof buffer);
	const ssize_t bytes_received = read(client_socket, (uint8_t *)&buffer, __lengthof(buffer) - 1);
	if (bytes_received < 0) {
		perror("read");
		close(client_socket);
		return;
	}
	buffer[bytes_received] = 0;

	printf("Received request:\n%s\n", (char *)&buffer);

	char response[send_buffer_size];
	memset(&response, 0, sizeof response);
	sprintf((char *)&response, "%s<html><body><h1>Hello, World! (%d)</h1></body></html>", httpHeader, pageCounter);

	write(client_socket, (char *)&response, strlen((char *)&response));
	close(client_socket);
}

int32_t main()
{
	const int server_socket = socket(AF_INET, SOCK_STREAM, 0);
	if (server_socket < 0) {
		perror("socket");
		exit(1);
	}

	struct sockaddr_in server_addr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_addr = {
			.s_addr = INADDR_ANY
		},
		.sin_port = htons(port)
	};

	// Bind socket to address
	struct sockaddr *const socadr = (struct sockaddr *)&server_addr;
	int rc = bind(server_socket, socadr, sizeof server_addr);
	if (rc < 0) {
		perror("bind");
		close(server_socket);
		exit(1);
	}

	// Starting listen to connection
	rc = listen(server_socket, 5);
	if (rc < 0) {
		perror("listen");
		close(server_socket);
		exit(1);
	}

	printf("Server listening on port %d...\n", (uint32_t)port);

	// Handle input connections
	while (true) {
		struct sockaddr_in client_addr;
		struct sockaddr *const socadr = (struct sockaddr *)&client_addr;
		socklen_t client_adr_len = sizeof client_addr;
		const int client_socket = accept(server_socket, socadr, &client_adr_len);
		if (client_socket < 0) {
			perror("accept");
			continue;
		}
		handle_request(client_socket);
		pageCounter = pageCounter + 1;
	}

	close(server_socket);
	return 0;
}

