/*
设计思想：
    设计一个Complex类，数据成员分别为一个复数的实部和虚部。
    能够进行复数的加法，自增，赋值等操作，具体实现通过重载运算符。
*/

#include <iostream>

using namespace std;

class Complex{
    private:
        int a, b;                                   // a为实部,b为虚部
    public:
        Complex(){a = b = 0;}                       //  默认构造函数
        Complex(int a0, int b0){a = a0; b = b0;}    //  有参构造函数
        Complex(const Complex &c){a = c.a; b = c.b;}      //  拷贝构造函数
        ~Complex(){}                                //  析构函数
        Complex& operator = (Complex);             //  重载赋值运算符
        Complex operator + (Complex&);              //  重载+运算符
        Complex& operator += (Complex&);            //  重载+=运算符
        friend ostream& operator << (ostream& os, const Complex& c){    // 重载<<
            os << c.a << "+" << c.b << "i";
            return os;
        }
};

Complex& Complex::operator = (Complex c){       // 返回类型为对象的引用
    a = c.a;
    b = c.b;
    return *this;
}

Complex Complex::operator + (Complex& c){
    return Complex(a + c.a, b + c.b);
}

Complex& Complex::operator += (Complex& c){
    a += c.a;
    b += c.b;
    return *this;
}

int main(){
    Complex C1(1, 2), C2;
    Complex C3 = C2;
    cout << " C3 = " << C3 << endl;
    C2 = C1 + C3;
    cout << " C2 = " << C2 << endl;
    C2 += C1;
    cout << " C2 = " << C2 << endl;
    return 0;
}