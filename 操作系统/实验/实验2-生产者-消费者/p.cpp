#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h>
#include <string.h>

#define NUM_PRODUCER 12

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
        printf("%s", a -> data.s[i]); puts("");
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
    struct SharedMemory *addr = (struct SharedMemory *)(pFile);
    HANDLE full = OpenSemaphore(SEMAPHORE_ALL_ACCESS, FALSE, "FULL"); //为现有的一个已命名同步信号对象创建一个新句柄
    HANDLE empty = OpenSemaphore(SEMAPHORE_ALL_ACCESS, FALSE, "EMPTY");
    HANDLE mutex = OpenMutex(SEMAPHORE_ALL_ACCESS, FALSE, "MUTEX"); //为现有的一个已命名互斥信号对象创建一个新句柄。
    for (int i = 0; i < NUM_PRODUCER; i++){
        srand(GetCurrentProcessId() + i);       //设置随机种子
        Sleep(rand() % 1000 + 1000);                   //随机sleep子进程
        WaitForSingleObject(empty, INFINITE); //P(empty)
        WaitForSingleObject(mutex, INFINITE); //P(mutex)
        //向缓冲区添加数据
        char ch[10];
        for (int j = 0; j < 10; j ++){          // 产生长度为10的随机字符串
            int num = rand() % 26;
            ch[j] = (char)num + 'a';
        }
        memcpy(addr -> data.s[addr -> data.tail], ch, sizeof(char) * 10);
        addr -> data.tail = (addr -> data.tail + 1) % 6;
        addr -> data.is_empty = 0;
        if(addr -> data.head == addr -> data.tail % 6){
            addr -> data.is_full = 1;
        }
        else {
            addr -> data.is_full = 0;
        }

        SYSTEMTIME time;
        GetLocalTime(&time);
        printf("\nTime: %02d:%02d:%02d:%d\n", time.wHour, time.wMinute, time.wSecond, time.wMilliseconds);
        printf("Producer %d putting %s\n", GetCurrentProcessId(), ch);

        if (addr -> data.is_empty){
            printf("Empty\n");
        }
        else if(addr -> data.is_full){
            printf("Full\n");
        }
        else
            CurrentStatus(addr);

        ReleaseMutex(mutex);             //V(mutex)
        ReleaseSemaphore(full, 1, NULL); //V(full)
    }
    UnmapViewOfFile(pFile); //停止当前程序的一个内存映射
    pFile = NULL;
    CloseHandle(hMap); //关闭所有句柄
    CloseHandle(mutex);
    CloseHandle(empty);
    CloseHandle(full);
    return 0;
}