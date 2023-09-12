#include <stdio.h>
#include <time.h>
#include <iostream>

using namespace std;

int main(){
    srand(time(0));
    FILE* file = fopen("B.txt", "w");
    for(int i = 0; i < 300; i ++){
        for(int j = 0; j < 300; j ++){
            fprintf(file, "%d ", rand()%100 + 1);
        }
        fprintf(file, "\n");
    }
    fclose(file);
    return 0;
}