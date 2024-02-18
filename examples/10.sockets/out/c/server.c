/* thx: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming */

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <arpa/inet.h>




#define PORT  8080
#define BUF_SIZE  1024


void write_file(int sockfd)
{
    char buffer[BUF_SIZE];

    FILE *const fp = fopen("file2.txt", "w");
    if (fp == NULL) {
        perror("[-] Error in creating file");
        exit(1);
    }

    while (true) {
        const ssize_t n = recv(sockfd, (void *)(char *)&buffer, BUF_SIZE, 0);

        if (n <= 0) {
            break;
        }

        fprintf(fp, "%s", (char *)&buffer);
        bzero((void *)(char *)&buffer, BUF_SIZE);
    }
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
        .sin_len = 0,
        .sin_family = AF_INET,
        .sin_port = PORT,
        .sin_addr = (struct in_addr){
            .s_addr = inet_addr("127.0.0.1")
        },
        .sin_zero = {}
    };

    struct sockaddr *const sockaddr = (struct sockaddr *)(void *)&server_addr;
    int e;
    e = bind(sockfd, sockaddr, sizeof(struct sockaddr_in));
    if (e < 0) {
        perror("[-] Error in Binding");
        exit(1);
    }

    printf("[+] Binding Successfull\n");

    e = listen(sockfd, 10);
    if (e == 0) {
        printf("[+] Listening...\n");
    } else {
        perror("[-] Error in Binding");
        exit(1);
    }

    socklen_t addr_size;
    addr_size = sizeof(struct sockaddr_in);
    struct sockaddr_in new_addr;
    struct sockaddr *const sa = (struct sockaddr *)(void *)&new_addr;
    const int new_sock = accept(sockfd, sa, &addr_size);

    write_file(new_sock);

    printf("[+] Data written in the text file");

    return 0;
}

