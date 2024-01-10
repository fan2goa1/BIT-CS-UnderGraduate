/*
设计思想：
    Shape为基类，Circle、Triangle为派生类。
    Area()为虚函数
    PrintArea()函数中的参数类型为Shape&
*/

#include <iostream>
#include <cmath>        //  调用cmath库中的M_PI

using namespace std;

class Shape{
    public:
        virtual double Area() = 0;
};

class Circle : public Shape{
    private:
        double r;
    public:
        Circle(){r = 0;}
        Circle(double r0){r = r0;}
        ~Circle(){}
        virtual double Area(){
            return M_PI * r * r;
        }
};

class Triangle : public Shape{
    private:
        double bl, h;
    public:
        Triangle(){bl = h = 0;}
        Triangle(double bl0, double h0){bl = bl0; h = h0;}
        ~Triangle(){}
        virtual double Area(){
            return 0.5 * bl * h;
        }
};

double PrintArea(Shape& p){
    return p.Area();
}

int main(){
    Shape* p = new Circle(2); 
    cout << "The area of the circle is: " << PrintArea(*p) << endl; 
    Triangle triangle (3,4);
    cout << "The area of the triangle is: " << PrintArea(triangle) << endl;
    delete p;
    return 0;
}