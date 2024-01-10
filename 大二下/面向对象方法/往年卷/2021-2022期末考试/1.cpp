#include <iostream>

using namespace std;

class Calculator{
    private:
        int value;
    public:
        Calculator(int val = 3){
            // 带有默认参数值的有参构造函数，默认参数值为3
            value = val;
            // 将参数值赋值给Calculator类对象的value数据成员
            cout << "Constructor value = " << value << endl;
            // 输出 Constructor value = 
        }
        ~Calculator(){
            // 析构函数
            cout << "Destructor value = " << value << endl;
            // 输出 Destructor value = 
        }
        Calculator operator + (const Calculator &a){
            // 重载 + 运算，参数为const修饰的Calculator类对象的引用
            return Calculator(value + a.value);
            // 返回二者value相加所构造的Calculator类对象
        }
        Calculator& operator = (const Calculator &a){
            /*
                重载 = 运算（赋值运算），参数为const修饰的Calculator类对象的引用
                返回类型为Calculator的引用，使得Calculator类对象在赋值时可以连等（非必需）
            */
            value = a.value;
            // 将a.value赋值给当前对象的value
            cout << "Assignment value = " << value << endl;
            // 输出 Assignment value = 
            return *this;
        }
};

int main(){
    Calculator m(5), n;
    m = m + n;
    return 0;
}