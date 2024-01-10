#include <iostream>

using namespace std;

class CSmart{
    public:
        static int cnt;             //定义一个static int的计数器记录当前有多少个对象
        CSmart(){
            is_destruct = 0;
            cnt ++;                                    //增添一个对象
            cout << cnt << " ";
            if(cnt <= 1) cout << "object" << endl;     //0、1个对象为单数
            else cout << "objects" << endl;            //1个以上为复数
        }
        ~CSmart(){
            if(!is_destruct){
                is_destruct = 1;                        //保证每个对象的析构函数只会被调用一次
                cnt --;                                 //减少一个对象
                cout << cnt << " ";
                if(cnt <= 1) cout << "object" << endl;  //同上
                else cout << "objects" << endl;         //同上
            }
        }
    private:
        bool is_destruct;              //该bool类型变量用来表示一个对象是否被调用过析构函数 1是0否
};

void DoSomething(){
    CSmart s;
}

CSmart s1;
int CSmart::cnt = 0;                    //初始化cnt的值为0

int main(){
    CSmart s2;
    DoSomething(); 
    CSmart *s3 = new CSmart;
    delete s3;
    s2.~CSmart();
    return 0;
}