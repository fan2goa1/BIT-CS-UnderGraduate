#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <winbase.h>
#include <psapi.h>

#define DIV 1024
#define max_process_num 1024

void printIn32bits(int num) {
	int i;
	for(i = 31; i >= 0; i--) {
		if(num & (1<<i)) printf("1");
		else printf("0");
	}
	puts("");
}

void printInTimes(char c, int times){
	while(times --) printf("%c", c);
}

void printStart(const char* content){	// 输出开始分界线
	char str[50] = {" "};
	strcat_s(str, content);
	strcat_s(str, " start ");
	printInTimes('-', 10);
	printf("%s", str);
	printInTimes('-', 10);
	printf("\n");
}

void printEnd(const char* content){		// 输出结束分界线
	char str[50] = {" "};
	strcat_s(str, content);
	strcat_s(str,  " end ");
	printInTimes('-', 11);
	printf("%s", str);
	printInTimes('-', 11);
	printf("\n\n");
}

void wchar2char(const wchar_t* wchar, char* mchar){	// type: wchar -> char
	char* m_char;
	int len = WideCharToMultiByte(CP_ACP, 0, wchar, wcslen(wchar), NULL, 0, NULL, NULL);
	m_char = new char[len + 1];
	WideCharToMultiByte(CP_ACP, 0, wchar, wcslen(wchar), m_char, len, NULL, NULL);
	m_char[len] = '\0';
	strcpy_s(mchar, strlen(m_char)+1, m_char);
}

void ShowError(){						// 显示指令错误
	printf("Invalid command!\n");
	puts("");
}

void ShowQuit(){						// 显示退出信息
	printf("Successfully quit!\n");
	puts("");
}

/* 
	显示系统信息，包括：
		系统架构（x64/arm/x86-64/Intel Itanium-based/x86）
		页面大小
		内存最低、最高地址
		活动处理器集掩码
		逻辑处理器数量
		分配粒度
*/
void ShowSystemInfo(){
	printStart("ShowSystemInfo");

	SYSTEM_INFO lpSystemInfo;
	ZeroMemory(&lpSystemInfo, sizeof(lpSystemInfo));	// 用0来填充一块内存区域，得到计算机系统信息
	GetSystemInfo(&lpSystemInfo);

	printf("Processor architecture:\t\t\t\t"); // 系统架构
	switch (lpSystemInfo.wProcessorArchitecture){
		case 9:
			printf("x64 (AMD or Intel)\n");
			break;
		case 5:
			printf("ARM\n");
			break;
		case 12:
			printf("x86-64\n");
			break;
		case 6:
			printf("Intel Itanium-based\n");
			break;
		case 0:
			printf("x86\n");
			break;
		default:
			printf("Unknown architecture.\n");
			break;
	}

	printf("Page size:\t\t\t\t\t"); // 页面大小
	printf("%lu Bytes\n", lpSystemInfo.dwPageSize);

	printf("Lowest memory address:\t\t\t\t"); // 最低地址
	printf("0x%016llx\n", (unsigned long long)lpSystemInfo.lpMinimumApplicationAddress);	// 16位16进制地址

	printf("Highest memory address:\t\t\t\t"); // 最高地址
	printf("0x%016llx\n", (unsigned long long)lpSystemInfo.lpMaximumApplicationAddress);

	printf("Active processpor mask:\t"); // 处理器集掩码
	printIn32bits(lpSystemInfo.dwActiveProcessorMask);

	printf("Number of processors:\t\t\t\t"); // 逻辑处理器数量
	printf("%lu\n", lpSystemInfo.dwNumberOfProcessors);

	printf("Allocation Granularity:\t\t\t\t");	// 分配的粒度
	printf("%lu Bytes\n", lpSystemInfo.dwAllocationGranularity);

	printEnd("ShowSystemInfo");
}


void ShowMemoryInfo(){					// 内存信息
	printStart("ShowMemoryInfo");

	MEMORYSTATUSEX lpMemoryInfo;
	lpMemoryInfo.dwLength = sizeof(lpMemoryInfo);
	GlobalMemoryStatusEx(&lpMemoryInfo);

	printf("Percentage of memory in use:\t\t\t%20ld%%\n", lpMemoryInfo.dwMemoryLoad); 		// 内存使用百分比
	printf("Total physical memory:\t\t\t\t%18lld KB\n", lpMemoryInfo.ullTotalPhys / DIV); 	// 物理内存大小
	printf("Free physical memory:\t\t\t\t%18lld KB\n", lpMemoryInfo.ullAvailPhys / DIV); 	// 可用物理内存大小
	printf("Total paging file:\t\t\t\t%18lld KB\n", lpMemoryInfo.ullTotalPageFile / DIV); 	// 页文件大小
	printf("Free paging file:\t\t\t\t%18lld KB\n", lpMemoryInfo.ullAvailPageFile / DIV); 	// 可用页文件大小
	printf("Total virtual memory:\t\t\t\t%18lld KB\n", lpMemoryInfo.ullTotalVirtual / DIV); // 虚拟内存
	printf("Free virtual memory:\t\t\t\t%18lld KB\n\n", lpMemoryInfo.ullAvailVirtual / DIV);// 虚拟内存可用大小

	PERFORMANCE_INFORMATION lpPerformanceInformation;
	lpPerformanceInformation.cb = sizeof(lpPerformanceInformation);
	GetPerformanceInfo(&lpPerformanceInformation, sizeof(lpPerformanceInformation));

	printf("Total physical pages:\t\t\t\t%18llu\n", lpPerformanceInformation.PhysicalTotal); 	// 物理页数量
	printf("Total committed pages:\t\t\t\t%18llu\n", lpPerformanceInformation.CommitTotal); 	// 已提交页数量
	printf("System cache:\t\t\t\t\t%18llu\n", lpPerformanceInformation.SystemCache); 			// 系统缓存
	printf("Total handles:\t\t\t\t\t%18lu\n", lpPerformanceInformation.HandleCount); 			// 句柄数量
	printf("Total processes:\t\t\t\t%18lu\n", lpPerformanceInformation.ProcessCount); 			// 进程数量
	printf("Total threads:\t\t\t\t\t%18lu\n", lpPerformanceInformation.ThreadCount); 			// 线程数量

	printEnd("ShowMemoryInfo");
}

void deletePostfix(char* str){ // 删除后缀名
	int len = strlen(str);
	for (int i = len - 1; i >= 0; i--) {
		if (str[i] == '.') {
			str[i] = '\0';
			break;
		}
	}
}

void getProcessName(HANDLE hProcess, char *process_name){ // 获取进程名
	HMODULE hMod;
	DWORD cbNeeded;
	EnumProcessModules(hProcess, &hMod, sizeof(hMod), &cbNeeded);
	wchar_t tmp_process_name[100];
	GetModuleBaseName(hProcess, hMod, (LPTSTR)tmp_process_name, sizeof(tmp_process_name));
	wchar2char(tmp_process_name, process_name);
	deletePostfix(process_name);
}

void ShowProcessVirualMemory(HANDLE hProcess, int idx){	// 虚拟地址信息
	printf("Process No. %d\n", idx);
	printf("Address\t\t\t\t\tKbytes\t\tMode\tState\t\tType\n");

	SYSTEM_INFO lpSystemInfo;
	ZeroMemory(&lpSystemInfo, sizeof(lpSystemInfo));
	GetSystemInfo(&lpSystemInfo);

	MEMORY_BASIC_INFORMATION lpMemoryInfo;
	ZeroMemory(&lpMemoryInfo, sizeof(lpMemoryInfo));

	unsigned long long pRegionStart = (unsigned long long)lpSystemInfo.lpMinimumApplicationAddress;

	while (1){
		if (VirtualQueryEx(hProcess, (LPCVOID)pRegionStart, &lpMemoryInfo, sizeof(lpMemoryInfo)) != sizeof(lpMemoryInfo)) break;

		unsigned long long pRegionEnd = pRegionStart + lpMemoryInfo.RegionSize-1;
		printf("%016llx-%016llx\t", pRegionStart, pRegionEnd);  // 块长度

		if (lpMemoryInfo.RegionSize / DIV < 10000000) printf("%llu\t\t", lpMemoryInfo.RegionSize / DIV);
		else printf("%llu\t", lpMemoryInfo.RegionSize / DIV); // 大小

		switch (lpMemoryInfo.Protect & 0x00ff) { // 保护
			case PAGE_EXECUTE:
				printf("--X");
				break;
			case PAGE_EXECUTE_READ:
				printf("R-X");
				break;
			case PAGE_EXECUTE_READWRITE:
				printf("RWX");
				break;
			case PAGE_EXECUTE_WRITECOPY:
				printf("RCX");
				break;
			case PAGE_NOACCESS:
				printf("---");
				break;
			case PAGE_READONLY:
				printf("R--");
				break;
			case PAGE_READWRITE:
				printf("RW-");
				break;
			case PAGE_WRITECOPY:
				printf("-C-");
				break;
			default:
				printf("---");
		}
		printf("\t");

		switch (lpMemoryInfo.State) { // 状态
		case MEM_COMMIT:
			printf("committed");
			break;
		case MEM_FREE:
			printf("free\t");
			break;
		case MEM_RESERVE:
			printf("reserved");
			break;
		default:
			printf("?\t");
		}
		printf("\t");

		switch (lpMemoryInfo.Type) { // 类型
		case MEM_IMAGE:
			printf("image");
			break;
		case MEM_MAPPED:
			printf("mapped");
			break;
		case MEM_PRIVATE:
			printf("private");
			break;
		default:
			printf("unknown");
		}
		printf("\n");

		pRegionStart = pRegionEnd+1;
	}
}


void ShowProcessInfo(){				// 进程信息
	printStart("ShowProcessInfo");

	char process_name[100] = {0};
	int process_id;
	printf("Please input the process id:\n");
	scanf("%d", &process_id);
	int length = strlen(process_name);
	process_name[length - 1] = '\0';

	DWORD pid_array[max_process_num], lpcbNeeded;
	EnumProcesses(pid_array, sizeof(pid_array), &lpcbNeeded);
	if(lpcbNeeded == sizeof(pid_array)) {
		printf("Larger array should be declared to save the pid array!\n");
		exit(1);
	}

	int process_num = lpcbNeeded / sizeof(DWORD);
	printf("The number of process:%d\n", process_num);

	HANDLE required_process[max_process_num];
	int required_num = 0;
	for(int i = 0; i < process_num; i++) {
		HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, pid_array[i]);
		if (hProcess == NULL) continue;

		printf("process %d\tprocess_id: %ld\n", i, pid_array[i]);

		char now_process_name[100];
		getProcessName(hProcess, now_process_name);
		if(i == process_id) {
			required_process[required_num ++] = hProcess;
		}
	}

	for(int i = 0; i < required_num; i++) {
		ShowProcessVirualMemory(required_process[i], i);
	}

	printEnd("ShowProcessInfo");
}

int main(){
	char command_str[50] = {0};
	int command_len;
	int quit = 0;

	while (1) {
		printf("Please input the command:\n");
		if (fgets(command_str, sizeof(command_str), stdin) == NULL) break;
		command_len = strlen(command_str);
		if (command_len != 2){
			ShowError();
			continue;
		}
		if(command_str[0] == 's'){
			ShowSystemInfo();
		}
		else if(command_str[0] == 'm'){
			ShowMemoryInfo();
		}
		else if(command_str[0] == 'p'){
			ShowProcessInfo();
		}
		else if(command_str[0] == 'q'){
			ShowQuit();
			quit = 1;
		}
		else {
			ShowError();
		}
		if (quit) break;
	}
	return 0;
}
