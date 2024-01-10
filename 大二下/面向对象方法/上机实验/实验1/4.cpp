#include <iostream>

using namespace std;

int day[15] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};      //平年每月天数
int day1[15] = {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};     //闰年每月天数

class CDate{
    friend int pd(CDate &a, CDate &b);          //友元函数判断哪个日期在前面
    public:
        CDate(){                                //无参数构造函数，默认1900年1月1日
            Year = 1900, Month = 1, Day = 1;
            cout << "Construct a CDate" << endl;
        }
        CDate(int y, int m, int d){             //有参数构造函数
            Year = y; Month = m, Day = d;
            cout << "Construct a CDate" << endl;
        }
        void Span(CDate &b);               //函数判断两个日期的相差天数
    private:
        int Year, Month, Day;
};

int pd(CDate &a, CDate &b){                 //判断两个日期哪个在前，a在前返回1，否则返回0
    if(a.Year < b.Year) return 1;
    else if(a.Month < b.Month) return 1;
    else if(a.Day <= b.Day) return 1;
    return 0;
}

int isrun(int a){                           //判断当前年份是否是闰年，是为1，否则为0
    if(a % 400 == 0 || (a % 100 != 0 && a % 4 == 0)) return 1;
    else return 0;
}

void CDate::Span(CDate &b){
    int numday = 0;
    numday += (isrun(Year) ? day1[Month] : day[Month]) - Day;       //加上a当前月份剩余天数
    numday += b.Day;                    //加上b当前月份的已过天数
    for(int i = Month + 1; i <= 12; i ++) numday += (isrun(Year) ? day1[i] : day[i]);   //加上a剩余月份天数
    for(int i = 1; i < b.Month; i ++) numday += isrun(b.Year) ? day1[i] : day[i];       //加上b已过月份天数
    for(int i = Year + 1; i < b.Year; i ++){            //加上ab之间年份的天数
        numday += isrun(i) ? 366 : 365;
    }
    cout << numday << endl;
}

int main(){
    int y, m, d;
    cin >> y >> m >> d;
    CDate a(y, m, d);
    cin >> y >> m >> d;
    CDate b(y, m, d);
    if(pd(a, b)) a.Span(b);
    else b.Span(a);
    return 0;
}