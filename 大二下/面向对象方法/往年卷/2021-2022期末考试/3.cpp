#include <iostream>   
#include <string>

using namespace std;

template <typename T> // 类模板，模板名为T
class MArray{
    private:
        T *a;
        // T类型的指针a，用于存放数组内容
        int sz;
        // 表示数组长度大小
    public:
        MArray(int n = 0){
            /*
                带有默认参数值的有参构造函数
                默认值为0
                初始化MArray对象的数组大小
            */
            sz = n;
            a = new T [sz];
            // 为a动态分配数据类型为T的 大小为sz的空间
            // 指针指向首地址
        }
        MArray(const MArray &d_arr){
            /*
                拷贝构造函数
                若不设计此函数，调用默认的赋值函数（浅拷贝）
                这会使得两个对象的T类型的指针指向同一个地址
                使得在析构的时候同一个空间被释放后还会“被释放一次”，造成错误
                所以有必要设计此拷贝构造函数
            */
            sz = d_arr.sz;
            // 将d_arr中的数组大小赋值给当前对象
            a = new T [sz];
            // 为a动态分配空间
            for(int i = 0; i < sz; i ++) a[i] = d_arr.a[i];
            // 将d_arr中的数组的数据内容赋值给当前对象
        }
        ~MArray(){
            // 析构函数
            delete [] a;
            // 回收在构造函数中为a动态分配的空间
        }
        T& operator [] (int ind){
            // 重载下标运算符，返回类型为T的引用，使得其能作为左值被修改
            return a[ind];
        }
        friend ostream& operator << (ostream &os, const MArray &d_arr){
            // 友元函数，重载流插入运算符
            for(int i = 0; i < d_arr.sz; i ++)
                os << d_arr.a[i] << ", ";
            // 从头到尾输出类对象d_arr的数组中的内容，中间用", "隔开
            return os;
        }
};

int main(){
    MArray <int> intArray(5);	 // 5 is the number of elements
	for (int i = 0; i < 5; i ++)
		intArray[i] = i * i;
	MArray <string> stringArray(2);	
	stringArray[0] = "string0";
    stringArray[1] = "string1";
	MArray <string> stringArray1 = stringArray;
	cout << intArray << endl;   // display: 0, 1, 4, 9, 16,
    cout << stringArray1 << endl; // display: string0, string1,
	return 0;
}