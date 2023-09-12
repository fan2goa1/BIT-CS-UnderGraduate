#include <iostream>
#include <fstream>
#include <ctime>

using namespace std;

int main(){
    srand(time(0));
    int numRow, numCol;
    numRow = numCol = 300;

    ofstream file_OPA("A.txt");
    for(int i = 0; i < numRow; i ++){
        for(int j = 0; j < numCol; j ++){
            file_OPA << rand() % 100 + 1 << " ";
        }
        file_OPA << endl;
    }

    ofstream file_OPB("B.txt");
    for(int i = 0; i < numRow; i ++){
        for(int j = 0; j < numCol; j ++){
            file_OPB << rand() % 100 + 1 << " ";
        }
        file_OPB << endl;
    }

    file_OPA.close();
    file_OPB.close();
}