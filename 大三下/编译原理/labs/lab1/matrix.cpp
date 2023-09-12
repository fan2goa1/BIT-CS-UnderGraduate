#include <iostream>
#include <cstdio>
#include <fstream>
#include <ctime>

using namespace std;

int main(){
    ifstream fileA("A.txt");
    int numRowsA, numColsA, numRowsB, numColsB, numRowsC, numColsC;
    numRowsA = numColsA = numRowsB = numColsB = numRowsC = numColsC = 300;

    int** MatA = new int*[numRowsA];
    for(int i = 0; i < numRowsA; i ++){
        MatA[i] = new int[numColsA];
        for(int j = 0; j < numColsA; j ++){
            fileA >> MatA[i][j];
        }
    }

    ifstream fileB("B.txt");
    int** MatB = new int*[numRowsB];
    for(int i = 0; i < numRowsB; i ++){
        MatB[i] = new int[numColsB];
        for(int j = 0; j < numColsB; j ++){
            fileB >> MatB[i][j];
        }
    }
    
    int MatC[515][515];
    
    clock_t st = clock();

    // 矩阵乘法
    // int** MatC = new int*[numRowsC];
    for(int i = 0; i < numRowsC; i ++){
        // MatC[i] = new int[numColsC];
        for(int j = 0; j < numColsC; j ++){
            MatC[i][j] = 0;
            for(int k = 0; k < numColsA; k ++){
                MatC[i][j] += MatA[i][k] * MatB[k][j];
            }
        }
    }

    clock_t ed = clock();
    // 写出矩阵C
    ofstream fileC("C_cpp.txt");
    for(int i = 0; i < numRowsC; i ++){
        for(int j = 0; j < numColsC; j ++){
            fileC << MatC[i][j] << " ";
        }
        fileC << endl;
    }

    // 关闭文件
    fileA.close();
    fileB.close();
    fileC.close();

    cout << "total running time: " << double(ed - st) / CLOCKS_PER_SEC << "sec" << endl;

    return 0;
}