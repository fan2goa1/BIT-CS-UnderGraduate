#include <iostream>
#include <string>
using namespace std;
class Food
{
    string FoodName;  
    public:
        Food(string s) : FoodName(s) { };
        string GetFoodName() { return FoodName; }
};   

class Animal  // abstract class
{
    string AnimalName;
    // string类型字符串记录动物的名字
    Food &food;
    // 组合，将Food类对象的引用作为Animal类的数据成员，记录动物的食物
    public:
        Animal(string name, Food &fd):food(fd){AnimalName = name;}
        /*
            有参构造函数，其中name赋值给AnimalName
            而由于数据成员中有Food类对象的引用，故要用参数初始化列表进行初始化
            参数中采用了Food类对象的引用
        */
        virtual void Eat() = 0;
        /*
            由于Animal为抽象类，故我们设计Eat()函数为纯虚函数
            这也使得在主函数中调用Animal类的指针指向派生类对象的地址时，可以通过vtable调用派生类的Eat()
        */
        friend ostream& operator << (ostream &os, const Animal &a){
            // 重载流插入运算符，输出对象中是什么动物爱吃什么食物，为友元函数
            os << a.AnimalName << " likes to eat " << a.food.GetFoodName();
            // 输出时调用Food类中的GetFoodName()接口得到食物名称
            return os;
        }
};

class Wolf : public Animal  
// 派生类Wolf，继承自Animal类
{
    public:
        Wolf(string wname, Food &fd):Animal(wname, fd){}
        /*
            Wolf类的有参构造函数，传入参数 名字 和 食物
            通过初始化列表对基类进行初始化
        */
        virtual void Eat(){
            // 重写(override) Eat()函数
            cout << "Wolf::Eat" << endl;
        }
};

class Tiger : public Animal
// 派生类Tiger，继承自Animal类
{
    public:
        Tiger(string tname, Food &fd):Animal(tname, fd){}
        // 有参构造函数，与Wolf类类似，对Tiger类对象进行初始化
        virtual void Eat(){
            // 重写 Eat()函数
            cout << "Tiger::Eat" << endl;
        }
};

int main(){
    Food meat("meat");
    Animal* panimal = new Wolf("wolf", meat);
    // 指针指向动态分配的Wolf类对象空间

    panimal->Eat();            // display: Wolf::Eat
    cout << *panimal << endl;   // display: Wolf likes to eat meat.
    delete panimal;

    panimal = new Tiger("Tiger", meat);
    panimal->Eat();           // display: Tiger::Eat
    cout << *panimal << endl;  // display: Tiger likes to eat meat.
    delete panimal;

    return 0;
}
