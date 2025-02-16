
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



#define main_port  8080
#define main_receive_buffer  (1024 * 4)


static uint16_t main_htons(uint16_t x)
{
	return x << 8 | x >> 8;
}


static void main_handle_request(int32_t client_socket)
{
	printf("handle_request()\n");

	uint8_t buffer[main_receive_buffer];
	memset(&buffer, 0, sizeof buffer);

	const ssize_t bytes_received = read(client_socket, (uint8_t *)&buffer, __lengthof(buffer) - 1);
	if (bytes_received < 0) {
		perror("read");
		close(client_socket);
		return;
	}

	buffer[bytes_received] = 0;

	printf("Received request:\n%s\n", (char *)&buffer);

	char response[112];
	memcpy(&response, &"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n<html><body><h1>Hello, World!</h1></body></html>\x0", sizeof response);
	write(client_socket, (char *)&response, strlen((char *)&response));
	close(client_socket);
}


int32_t main()
{
	int32_t server_socket;
	int32_t client_socket;
	struct sockaddr_in server_addr;
	struct sockaddr_in client_addr;
	socklen_t client_len = sizeof client_addr;

	server_socket = socket(AF_INET, SOCK_STREAM, 0);
	if (server_socket < 0) {
		perror("socket");
		exit(1);
	}

	server_addr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_addr = {
			.s_addr = INADDR_ANY
		},
		.sin_port = (unsigned short)main_htons(main_port)
	};

	// Bind socket to address
	struct sockaddr *const soc = (struct sockaddr *)&server_addr;
	int rc = bind(server_socket, soc, sizeof server_addr);
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

	printf("Server listening on port %d...\n", (uint32_t)main_port);

	// Handle input connections
	while (true) {
		struct sockaddr *const soc = (struct sockaddr *)&client_addr;
		client_socket = accept(server_socket, soc, &client_len);
		if (client_socket < 0) {
			perror("accept");
			continue;
		}

		main_handle_request(client_socket);
	}

	close(server_socket);
	return 0;
}

