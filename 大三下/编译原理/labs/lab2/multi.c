#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int** readfile(char* s){
    FILE* file = fopen(s, "r");
    int** ret = (int **)malloc(sizeof(int*) * 300);
    for(int i = 0; i < 300; i ++) ret[i] = (int*)malloc(sizeof(int) * 300);
    for(int i = 0; i < 300; i ++){
        for(int j = 0; j < 300; j ++){
            fscanf(file, "%d", &ret[i][j]);
        }
    }
    fclose(file);
    return ret;
}

int** mat_mul(int** A, int** B){
    int** ret = (int **)malloc(sizeof(int*) * 300);
    for(int i = 0; i < 300; i ++) ret[i] = (int*)malloc(sizeof(int) * 300);
    for(int i = 0; i < 300; i ++){
        for(int j = 0; j < 300; j ++){
            ret[i][j] = 0;
        }
    }
    for(int i = 0; i < 300; i ++){
        for(int j = 0; j < 300; j ++){
            for(int k = 0; k < 300; k ++)
                ret[i][j] += A[i][k] * B[k][j];
        }
    }
    return ret;
}

int main(){
    int** A = readfile("A.txt");
    int** B = readfile("B.txt");
    clock_t st = clock();
    int** C = mat_mul(A, B);
    clock_t ed = clock();
    printf("total running time: %.2fms\n", (double)(ed - st) * 1000 / CLOCKS_PER_SEC);
    return 0;
}