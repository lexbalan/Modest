// ./out/c/server.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "server.h"



#define server_filename  "file2.txt"
#define server_ipAddress  "127.0.0.1"
#define server_port  8080
#define server_bufSize  1024
bool write_file(int sockfd);








bool write_file(int sockfd)
{
	char buffer[server_bufSize];

	FILE *const fp = fopen(server_filename, "w");
	if (fp == NULL) {
		perror("[-] Error in creating file");
		return false;
	}

	while (true) {
		const ssize_t n = recv(sockfd, (char *)&buffer, server_bufSize, 0);

		if (n <= 0) {
			break;
		}

		fprintf(fp, "%s", (char *)&buffer);
		memset(&buffer, 0, sizeof(char[server_bufSize]));
	}

	return true;
}

int main()
{
	const int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0) {
		perror("[-] Error in socket");
		exit(1);
	}

	printf("[+] Server socket created\n");

	struct sockaddr_in server_addr;
	server_addr = (struct sockaddr_in){
		.sin_family = AF_INET,
		.sin_port = server_port,
		.sin_addr = (struct in_addr){
			.s_addr = inet_addr(server_ipAddress)
		}
	};

	struct sockaddr *const sockaddr = (struct sockaddr *)(void *)&server_addr;
	int e;
	e = bind(sockfd, (struct sockaddr *)sockaddr, (socklen_t)sizeof(struct sockaddr_in));
	if (e < 0) {
		perror("[-] Error in Binding");
		exit(1);
	}

	printf("[+] Binding Successfull\n");

	e = listen(sockfd, 10);
	if (e != 0) {
		perror("[-] Error in Binding");
		exit(1);
	}

	printf("[+] Listening...\n");

	socklen_t addr_size;
	addr_size = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in new_addr;
	struct sockaddr *const sa = (struct sockaddr *)(void *)&new_addr;
	const int new_sock = accept(sockfd, (struct sockaddr *)sa, &addr_size);

	const bool suc = write_file(new_sock);
	if (suc) {
		printf("[+] Data written in the text file");
	} else {
		perror("[-] Cannot write file");
	}

	return 0;
}

