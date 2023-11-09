
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <arpa/inet.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

/* from: https://github.com/pshashipreetham/File-Transfer-Using-TCP-Socket-in-C-Socket-Programming/tree/master */



#define BUF_SIZE  1024

void write_file(int sockfd)
{
    char *const filename = "file2.txt";

    char buffer[BUF_SIZE];

    FILE *const fp = fopen(filename, "w");
    if (fp == NULL) {
        perror("[-] Error in creating file.");
        exit(1);
    }

    while (true) {
        const ssize_t n = recv(sockfd, (void *)&buffer[0], BUF_SIZE, 0);

        if (n <= 0) {
            break;
        }

        fprintf(fp, "%s", buffer);
        bzero((void *)&buffer[0], BUF_SIZE);
    }
}


int main(void)
{
    uint32_t ip[10] = {} /*GENERIC-STRING*/;
    const uint16_t port = 8080;

    const int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("[-] Error in socket");
        exit(1);
    }

    printf("[+] Server socket created. \n");

    struct sockaddr_in server_addr = (struct sockaddr_in){
        .sin_family = AF_INET,
        .sin_port = port,
        .sin_addr = (struct in_addr){
            .s_addr = ((unsigned long)(uint32_t)inet_addr("127.0.0.1"))
        }
    };

    struct sockaddr *const a = (struct sockaddr *const)(void *)&server_addr;
    int e = bind(sockfd, (struct sockaddr *)a, sizeof(struct sockaddr_in));
    if (e < 0) {
        perror("[-] Error in Binding");
        exit(1);
    }

    printf("[+] Binding Successfull.\n");

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
    struct sockaddr *const na = (struct sockaddr *const)(void *)&new_addr;
    const int new_sock = accept(sockfd, (struct sockaddr *)na, &addr_size);

    write_file(new_sock);

    printf("[+] Data written in the text file ");

    return 0;
}

