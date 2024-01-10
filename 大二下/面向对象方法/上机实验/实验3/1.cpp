#include<iostream>

using namespace std;

class Singleton{
    private:
        static Singleton *s;
        Singleton(){}
    public:
        static void Delete_Singleton(){                 //释放空间的函数
            if (s != nullptr){                          // s != NULL if you use in DEV C++
                delete s;
                cout << "Realease the static s." << endl;
            }
        }
        static Singleton* GetInstance(){
            if (s == nullptr){
                s = new Singleton();
                atexit(Singleton::Delete_Singleton);    //利用atexit进行注册
            }
            return s;
        }
};
Singleton* Singleton::s = nullptr;

int main(){
    Singleton *ps;
    ps = Singleton::GetInstance();
    cout << ps << endl;
    return 0;
}