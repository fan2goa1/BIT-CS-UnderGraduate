/*
设计思想：
    利用模板template设计MyArray
    重载[]运算符和<<运算符
*/

#include <iostream>

using namespace std;

template <class T>
class MyArray{
    private:
        T* a;
        int n;
    public:
        MyArray(int m){
            if(a == nullptr) a = new T [m + 1];
            n = m;
        }
        MyArray(){n = 0;}
        ~MyArray(){delete [] a;}
        T& operator [] (int ind){return a[ind];}                    //  重载[]运算符
        friend ostream& operator << (ostream& os, const MyArray<T>& p){     //  重载<<运算符
            for(int i = 0; i < p.n; i ++) os << *(p.a + i) << ", ";
            return os;
        }
};

int main(){
    MyArray <int> intArray(10); // 10 is the number of elements in intArray
    for (int i=0; i<10; i++)
        intArray[i] = i * i;
    cout << intArray << endl;
    return 0;
}