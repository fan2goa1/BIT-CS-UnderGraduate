#include <stdio.h>
#include <stdlib.h>

extern int** readfile(char*);
extern int** mat_mul(int**, int**);


int main(){
    int** A = readfile("A.txt");
    int** B = readfile("B.txt");
    int** C = mat_mul(A, B);
    printf("Success!\n");
    return 0;
}