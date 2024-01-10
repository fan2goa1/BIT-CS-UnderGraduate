#include <iostream>
#include <cstring>      // 调用memset和memcpy函数

using namespace std;

class CStudent{
    private:
        char name[25];                  // 学生姓名
        int age;                        // 学生年龄
    public:
        CStudent(){                     // 无参数构造函数
            memset(name, '\0', sizeof(name));
            age = 0;
        }
        CStudent(const char* name0, int age0){  // 有name和age的构造函数
            memcpy(name, name0, sizeof(name0));
            age = age0;
        }
        bool operator==(CStudent stu){      // 重载==符号，如果二者的年龄相等，则返回相等；否则返回不等
            if(age == stu.age) return true;
            else return false;
        }
};

template <class T, int size>
class CList{
    private:
        T a[size];              // 数组
        int nowsz;              // 记录当前存了多少个
    public:
        CList(){
            T ini;
            for(int i = 0; i < size; i ++) a[i] = ini;  // 初始化数组
            nowsz = 0;
        }
        T &operator[](int index);               // 重载[]符号
        void Add(T s);
        void Insert(T s, int index);
};
template <class T, int size>
T& CList<T, size>::operator[](int index){
    if(index < 0) index = 0;
    if(index >= size){                          // 溢出，则报错
        cout << "Error: out of bound" << endl;
        exit(1);
    }
    return a[index];
}
template <class T, int size>
void CList<T, size>::Add(T s){
    if(nowsz >= size){
        cout << "Error: out of bound" << endl;
        return ;
    }
    a[nowsz ++] = s;                            // 在数组的最后添加新元素
}
template <class T, int size>
void CList<T, size>::Insert(T s, int index){
    if(index < 0) index = 0;
    if(nowsz >= size){
        cout << "Error: out of bound" << endl;
    }
    for(int i = nowsz - 1; i >= index; i --) a[i + 1] = a[i];       // 将index后的元素往后面错一位
    nowsz ++;
    a[index] = s;
}

int main(){
    CStudent s1("Joan", 22), s2("John", 19), s3("Jean", 19);
    CList<CStudent, 50> listStudent; // 50 is capcity of List
    listStudent.Add(s1);
    listStudent.Add(s2);
    if (listStudent[0] == listStudent[1]) // Compare their ages
    cout << "They are the same age." << endl;
    else
    cout << "They are not the same age." << endl;
    listStudent.Insert(s2, 1);
    if (listStudent[1] == listStudent[2]) // Compare their ages
    cout << "They are the same age." << endl;
    else
    cout << "They are not the same age." << endl;
    return 0;
}