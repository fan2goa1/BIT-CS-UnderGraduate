#include <iostream>
#include <cmath>

using namespace std;

class CShape{
    public:
        virtual double Area() = 0; // area
        virtual double Volume() = 0; // volumn
};

class CCircle : public CShape{                  // 继承自CShape类
    public:
        CCircle(double r0 = 0){r = r0;}
        virtual double Area();                  // 重写Area()函数
        virtual double Volume(){return 0;}      // 重写Volume()函数
        friend istream& operator>>(istream& is, CCircle& cir){
            cout << "please input the radius of the circle: ";
            is >> cir.r;
            return is;
        }
    private:
        double r;                               // r为圆的半径
};
double CCircle::Area(){
    double ret;
    ret = M_PI * r * r;                         // S = pi * r^2
    return ret;
}

class CTriangle : public CShape{
    public:
        CTriangle(double a0 = 0, double h0 = 0){a = a0, h = h0;}
        virtual double Area();
        virtual double Volume(){return 0;}
        friend istream& operator>>(istream& is, CTriangle& tri){
            cout << "please input the a and h of the triangle: ";
            is >> tri.a >> tri.h;
            return is;
        }
    private:
        double a, h;
};
double CTriangle::Area(){
    double ret;
    ret = 0.5 * a * h;                           // S = 1/2 * 底 * 高
    return ret;
}

class CAD{
    private:
        CShape& shape;
    public:
        CAD(CShape& S) : shape(S){};
        double Area() { return shape.Area(); }
        double Volume() { return shape.Volume(); }
};

int main(){
    CCircle cir;
    cin >> cir;                                     // 输入圆的半径
    CAD c1(cir);
    cout << "Circle Area: " << c1.Area() << endl;
    cout << "Circle Volume: " << c1.Volume() << endl;

    CTriangle tri;
    cin >> tri;                                     // 输入三角形的底和高
    CAD c2(tri);
    cout << "Triangle Area: " << c2.Area() << endl;
    cout << "Triangle Volume: " << c2.Volume() << endl;
    return 0;
}