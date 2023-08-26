#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h>
#include <string.h>

#define NUM_CONSUMER 8

struct Buffer{      //定义缓冲池
    char s[6][11];       //6个共享区，每个存10个字符
    int head;
    int tail;
    int is_empty;
    int is_full;
};

struct SharedMemory{    //定义共享内存
    struct Buffer data;     //缓冲区
    HANDLE full;            //非空缓冲区个数，初值为0
    HANDLE empty;           //空缓冲区的个数，初值为6
    HANDLE mutex;           //访问临界区的互斥信号量，初值为1
};


//显示缓冲区数据
void CurrentStatus(struct SharedMemory *a){
    puts("Current Data: ");
    for (int i = a -> data.head;;){
        printf("%s", a -> data.s[i]);   puts("");
        i ++;
        i %= 6;
        if (i == a -> data.tail){
            printf("\n");
            return;
        }
    }
}

int main(){
    HANDLE hMap = OpenFileMapping(FILE_MAP_ALL_ACCESS, FALSE, "BUFFER");
    if (hMap == NULL){
        printf("OpenFileMapping error!\n");
        exit(0);
    }
    LPVOID pFile = MapViewOfFile(hMap, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if (pFile == NULL){
        printf("MapViewOfFile error!\n");
        exit(0);
    }
    struct SharedMemory *addr = (struct SharedMemory *) (pFile);
    HANDLE full = OpenSemaphore(SEMAPHORE_ALL_ACCESS, FALSE, "FULL");
    HANDLE empty = OpenSemaphore(SEMAPHORE_ALL_ACCESS, FALSE, "EMPTY");
    HANDLE mutex = OpenMutex(SEMAPHORE_ALL_ACCESS, FALSE, "MUTEX");
    for (int i = 0; i < NUM_CONSUMER; i++){
        srand(GetCurrentProcessId() + i);
        Sleep(rand() % 1000);
        // Sleep(rand() % 1000 + 1000);
        WaitForSingleObject(full, INFINITE);  //P(full)
        WaitForSingleObject(mutex, INFINITE); //P(mutex)

        char ch[10];
        memcpy(ch, addr -> data.s[addr -> data.head], sizeof(char) * 10);
        addr -> data.head = (addr -> data.head + 1) % 6;
        if (addr -> data.head == addr -> data.tail){        // 如果缓冲池为空，将is_empty标记记为1
            addr -> data.is_empty = 1;
        }
        else if (addr -> data.head == (addr -> data.tail + 1) % 6){     // 如果缓冲池为满，将is_full标记记为1
            addr -> data.is_full = 1;
        }
        else {
            addr -> data.is_empty = addr -> data.is_full = 0;
        }

        SYSTEMTIME time;
        GetLocalTime(&time);
        printf("\nTime: %02d:%02d:%02d:%d\n", time.wHour, time.wMinute, time.wSecond, time.wMilliseconds);
        printf("Consumer %d removing %s\n", GetCurrentProcessId(), ch);

        if (addr -> data.is_empty)
            printf("Empty\n");
        else
            CurrentStatus(addr);

        ReleaseMutex(mutex);                //V(mutex)
        ReleaseSemaphore(empty, 1, NULL);   //V(empty)
    }
    UnmapViewOfFile(pFile); //关闭已打开的内存映射
    pFile = NULL;
    CloseHandle(hMap);      //关闭句柄
    CloseHandle(mutex);
    CloseHandle(empty);
    CloseHandle(full);
    return 0;
}
