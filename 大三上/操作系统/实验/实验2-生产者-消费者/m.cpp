#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h>
#include <string.h>

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

HANDLE MakeShared(){        //创建共享内存
    //创建一个临时文件映射对象
    HANDLE hMapping = CreateFileMapping(INVALID_HANDLE_VALUE, NULL, PAGE_READWRITE, 0, sizeof(struct SharedMemory), "BUFFER");
    if (hMapping == NULL){
        printf("CreateFileMapping error\n");
        exit(0);
    }
    //在文件映射上创建视图，返回起始虚地址
    LPVOID pData = MapViewOfFile(hMapping, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if (pData == NULL){
        printf("MapViewOfFile error\n");
        exit(0);
    }
    if (pData != NULL){     // 清空缓存区中的内容
        ZeroMemory(pData, sizeof(struct SharedMemory));
    }
    //解除当前地址空间映射
    UnmapViewOfFile(pData);
    return hMapping;
}

int main(){
    HANDLE hMapping = MakeShared();     // 创建一个文件映射对象
    //打开文件映射
    HANDLE hFileMapping = OpenFileMapping(FILE_MAP_ALL_ACCESS, FALSE, "BUFFER");
    if (hFileMapping == NULL){
        printf("OpenFileMapping error\n");
        exit(0);
    }
    LPVOID pFile = MapViewOfFile(hFileMapping, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if (pFile == NULL){
        printf("MapViewOfFile error\n");
        exit(0);
    }

    // 创建共享内存
    struct SharedMemory *addr = (struct SharedMemory *)(pFile);
    addr->data.head = 0;
    addr->data.tail = 0;
    addr->data.is_empty = 1;

    HANDLE empty = CreateSemaphore(NULL, 6, 6, "EMPTY");
    HANDLE full = CreateSemaphore(NULL, 0, 6, "FULL");
    HANDLE mutex = CreateMutex(NULL, FALSE, "MUTEX");

    UnmapViewOfFile(pFile);//停止当前程序的一个内存映射
    pFile = NULL;
    CloseHandle(hFileMapping);//关闭现有已打开句柄

    //子进程数组
    PROCESS_INFORMATION sub[5];

    //创建生产者进程
    for (int i = 0; i < 2; i ++){
        printf("Producer %d created.\n", i + 1);
        TCHAR szFilename[MAX_PATH];
        TCHAR szCmdLine[MAX_PATH];
        PROCESS_INFORMATION pi;
        sprintf(szFilename, "./p.exe");
        sprintf(szCmdLine, "\"%s\"", szFilename);

        STARTUPINFO si;
        ZeroMemory(&si, sizeof(STARTUPINFO));
        si.cb = sizeof(si);
        BOOL bCreatOK = CreateProcess(szFilename, szCmdLine, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);
        sub[i] = pi;
    }

    // 创建消费者进程
    for (int i = 2; i < 5; i ++){
        printf("Consumer %d created.\n", i - 1);
        TCHAR szFilename[MAX_PATH];
        TCHAR szCmdLine[MAX_PATH];
        PROCESS_INFORMATION pi;
        sprintf(szFilename, "./c.exe");
        sprintf(szCmdLine, "\"%s\"", szFilename);

        STARTUPINFO si;
        ZeroMemory(&si, sizeof(STARTUPINFO));
        si.cb = sizeof(si);
        BOOL bCreatOK = CreateProcess(szFilename, szCmdLine, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);
        sub[i] = pi;
    }

    //等待子进程结束
    for (int i = 0; i < 5; i ++){
        WaitForSingleObject(sub[i].hProcess, INFINITE);
    }
    //关闭子进程句柄
    for (int i = 0; i < 5; i ++){
        CloseHandle(sub[i].hProcess);
    }

    // 关闭现已打开的句柄
    CloseHandle(hMapping);
    hMapping = INVALID_HANDLE_VALUE;
    return 0;
}
