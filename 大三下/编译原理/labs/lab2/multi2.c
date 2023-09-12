#include <stdlib.h>
#include <stdio.h>

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