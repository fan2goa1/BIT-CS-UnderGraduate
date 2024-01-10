#include <iostream>
#include <cmath>

using namespace std;

#define eps 0.000000001             //定义一个可接受误差eps

class CCircle{
    public:
        CCircle(){                  //无参数的构造函数
            X = Y = R = 0.0;
            cout << "Construct a Circle" << endl;
        }
        CCircle(double x, double y, double r){  //有参数时的构造函数
            X = x; Y = y; R = r;
            cout << "Construct a Circle" << endl;
        }
        ~CCircle(){
            cout << "Destruct a Circle" << endl;
        }
        void Relationship(CCircle &b);      //成员函数Relationship
    private:
        double X, Y, R;
};

void CCircle::Relationship(CCircle &b){
    double dist = sqrt((X - b.X) * (X - b.X) + (Y - b.Y) * (Y - b.Y));      //计算得到两个圆的圆心的距离
    if(abs(dist - R - b.R) < eps) cout << "Circumscribed" << endl;          //判断外切
    else if(abs(dist - abs(R - b.R)) < eps) cout << "inscribed" << endl;    //判断内切
    else if(dist > R + b.R) cout << "Separated" << endl;                    //判断外离
    else if(dist < abs(R - b.R)) cout << "included" << endl;                //判断内含
    else cout << "intersected" << endl;                                     //判断相交
}

int main(){
    CCircle a(1.5, 2.5, 2.5);           //构造两个圆对象
    CCircle b(0.5, 5.5, 2);
    a.Relationship(b);                  //判断二者关系
    return 0;
}