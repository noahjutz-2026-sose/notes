#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>

int main() {
    int key = 123;
    int memid = shmget(key, 10 * sizeof(int), IPC_CREAT | 0666);
    int *buffer = shmat(memid, NULL, 0);
    for (int i = 0; i < 10; i++)
        buffer[i] = i * 2;
    shmdt(buffer);
}
