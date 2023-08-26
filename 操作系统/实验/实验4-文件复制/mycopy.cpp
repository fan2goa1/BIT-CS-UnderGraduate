#include <stdio.h>
#include <utime.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <time.h>

using namespace std;

#define FILE_LEN 155 	// 定义文件路径名长度
#define Buf_Size 2000	// 定义缓冲区长度
void mycopy_main(char *sourceRoot, char *destRoot);

// 检查目标文件是否包含在源文件子目录中，若是，返回1，否则返回0
bool check_path_valid(char *sourceFile, char *destinationFile){
	char fullSrcPath[FILE_LEN] = {0};
	char fullDestPath[FILE_LEN] = {0};
	// 得到完整文件路径
	realpath(sourceFile, fullSrcPath);
	realpath(destinationFile, fullDestPath);
	printf("SourceFullPath: \t\t%s\n", fullSrcPath);
	printf("DestinationFullPath: \t\t%s\n", fullDestPath);

	bool flag = true;
	for(int i = 0; i < FILE_LEN && fullSrcPath[i]; i ++){
		if(fullSrcPath[i] != fullDestPath[i]){
			flag = false;
			break;
		}
	}
	return flag;
}

// 获取访问、修改时间
void StoreTime(timeval *time_store, struct stat stat_store){
	time_store[0].tv_sec = stat_store.st_atime;	// 存访问时间
	time_store[1].tv_sec = stat_store.st_mtime;	// 存修改时间
	time_store[0].tv_usec = 0;
	time_store[1].tv_usec = 0;
}

// 复制链接
void copy_link(char *sourceRoot, char *destRoot, struct stat *tmp_stat){
	char linkBuff[Buf_Size] = {0};
	readlink(sourceRoot, linkBuff, sizeof(linkBuff));	// 将源链接信息存入缓冲区
	symlink(linkBuff, destRoot);						// 将缓冲区信息写入目标链接
	timeval timeTmp[2];
	StoreTime(timeTmp, *tmp_stat);						// 存原链接中的时间戳写入目标链接
	int succ = lutimes(destRoot, timeTmp);
	if(succ == -1) {
		perror("Failed to change the time of the link!\n");
	}
	else {
		printf("Successfully copy the link: \t%s\n", sourceRoot);
	}
}

// 复制目录
void copy_dir(char *sourceRoot, char *destRoot, struct stat *tmp_stat){
	mkdir(destRoot, tmp_stat -> st_mode);		// 在目标路径新建一个权限相同的文件夹
	DIR *pSearchDir = opendir(sourceRoot);
	struct dirent *pSingleDir;
	while((pSingleDir = readdir(pSearchDir)) != NULL){	// 通过readdir函数检索每一项目录信息
		char dirName[FILE_LEN] = {0};
		strcpy(dirName, pSingleDir -> d_name);
		// 一个目录中有两个子目录，分别指向自己和它的父级，对于这两个我们不用复制
		if(!strcmp(dirName, ".") || !strcmp(dirName, "..")) continue;

		char sourceTmp[FILE_LEN] = {0};
		char destTmp[FILE_LEN] = {0};
		// 得到下一级的路径，并递归完成复制
		sprintf(sourceTmp, "%s/%s", sourceRoot, dirName);
		sprintf(destTmp, "%s/%s", destRoot, dirName);

		mycopy_main(sourceTmp, destTmp);
	}

	struct utimbuf timeDir;
	timeDir.actime = tmp_stat -> st_atime;
	timeDir.modtime = tmp_stat -> st_mtime;
	utime(destRoot, &timeDir);	// 更改文件时间戳
	printf("Successfully copy the dir: \t%s\n", sourceRoot);
}

// 复制文件
void copy_file(char *sourceRoot, char *destRoot, struct stat *tmp_stat){
	int srcFd = open(sourceRoot, O_RDONLY); // 只读打开
	int destFd = creat(destRoot, tmp_stat -> st_mode);	// 在目标路径新建一个权限相同的文件

	int bufferSize = 0;
	char text_buffer[Buf_Size];
	// 循环写入缓冲区，并写给目标路径的文件
	while((bufferSize = read(srcFd, text_buffer, Buf_Size)) > 0){
		write(destFd, text_buffer, bufferSize);  
	}

	struct utimbuf timeTmp;
	timeTmp.actime = tmp_stat -> st_atime;
	timeTmp.modtime = tmp_stat -> st_mtime;
	utime(destRoot, &timeTmp);	// 更改文件的时间戳
	// 关闭文件
	close(srcFd);  
	close(destFd);
	printf("Successfully copy the file: \t%s\n", sourceRoot);
}

// 判断当前文件是链接/文件夹/文件
void mycopy_main(char *source_path, char *dest_path){
	struct stat tmp_stat;
	lstat(source_path, &tmp_stat);

	if(S_ISLNK(tmp_stat.st_mode)){			// 如果是链接
		copy_link(source_path, dest_path, &tmp_stat);
	}
	else if(S_ISDIR(tmp_stat.st_mode)){		// 如果是文件夹
		copy_dir(source_path, dest_path, &tmp_stat);
	}
	else{									// 如果是文件
		copy_file(source_path, dest_path, &tmp_stat);
	}
}

int main(int argc, char* argv[]){

	double start = clock();
	
	if(argc != 3){
		printf("Error: Syntax Error.\n");
		printf("Please use command \"mycopy\" in this way: mycopy [SourceFilePath] [DestinationFilePath]\n");
		exit(1);
	}

	printf("Initializing...\n");
	char sourceFile[FILE_LEN] = {0};
	char destinationFile[FILE_LEN] = {0};
	strcpy(sourceFile, argv[1]);		// 拷贝得到源文件路径
	strcpy(destinationFile, argv[2]);	// 拷贝得到目标文件路径

	// 检查源文件是否存在
	if(access(sourceFile, F_OK) != 0){
		printf("Error: Source File doesn\'t exist!\n");
		exit(1);
	}
	printf("Source File exist.\n");

	// 检查目标文件是否在源文件下
	if(check_path_valid(sourceFile, destinationFile)){
		printf("Error: Destination path cannot be a subpath of the source path!\n");
		exit(1);
	}
	printf("Destination fath verification complete.");

	mycopy_main(sourceFile, destinationFile);

	double end = clock();

//	printf("%lf, %lf\n", start, end);

	printf("Copy Finished in %.5f seconds.\n", (end - start) / CLOCKS_PER_SEC);
	return 0;
}
