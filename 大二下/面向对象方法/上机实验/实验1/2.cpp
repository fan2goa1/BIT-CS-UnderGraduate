#include <iostream>
#include <ctime>
#include <iomanip>

using namespace std;

class CTimeInfo{                               //定义类CTimeInfo
    public:
        CTimeInfo(){                      //无参数时的构造函数
            Hour = Minute = Second = 0;
            cout << "Construct a Time object" << endl;
        }
        ~CTimeInfo(){                       //析构函数
            cout << "Destruct a Time object" << endl;
        }
        void Now();
        void Show12();
        void Show24();
    private:
        int Hour, Minute, Second;
};

void CTimeInfo::Now(){
    time_t now = time(0);                       //调用ctime库中的time_t以获得当前时间
    struct tm *ptrnow = localtime(&now);        //调用ctime库中的struct tm*转化为当地的时间
    Hour = ptrnow -> tm_hour;                   //一下将当前时间存进对象的变量中
    Minute = ptrnow -> tm_min;
    Second = ptrnow -> tm_sec;
}

void CTimeInfo::Show12(){
    Now();
    int ap = 0, h = Hour, m = Minute, s = Second;
    if(h < 12){
        ap = 0;
        if(!h) h = 12;
    }
    else {                          //Hour大于12时 要改成12时制的小时数
        h %= 12;
        if(!h) h = 12;
        ap = 1;
    }
    cout << "12-Hour Time: " << setw(2) << setfill('0') << h << ":" << m << ":" << s << " ";        //以xx : xx : xx a.m.(or p.m.)输出12时制度的时间
    if(ap == 1) cout << "p.m." <<endl;
    else cout << "a.m." << endl;
}

void CTimeInfo::Show24(){
    Now();      //调用Now()函数获得当前的时间
    cout << "24-Hour Time: " << setw(2) << setfill('0') << Hour << ":" << Minute << ":" << Second << endl;      //以xx : xx : xx输出24时制的时间
}

int main(){
    CTimeInfo T;        // 建立一个类CTimeInfo的对象T
    T.Show12();         // 调用类中函数Show12()
    T.Show24();         // 调用类中函数Show24()
    return 0;
}