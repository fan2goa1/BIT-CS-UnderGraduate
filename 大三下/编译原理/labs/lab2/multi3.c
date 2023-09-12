#include <stdlib.h>

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