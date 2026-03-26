#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
    int fromChild[2], toChild[2];
    pipe(toChild);
    pipe(fromChild);
    if (fork() == 0) {
        char *buffer = (char *) malloc(6);
        close(fromChild[0]);
        close(toChild[1]);
        write(fromChild[1], "ping\n", 6);
        read(toChild[0], buffer, 6);
        printf("Child received: %s\n", buffer);
    } else {
        char *buffer = malloc(6);
        close(fromChild[1]);
        close(toChild[0]);
        write(toChild[1], "pong\n", 6);
        read(fromChild[0], buffer, 6);
        printf("Parent received: %s\n", buffer);
    }
}
