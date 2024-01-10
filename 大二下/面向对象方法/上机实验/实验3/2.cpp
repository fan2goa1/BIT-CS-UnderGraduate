#include <iostream>
#include <cstring>

using namespace std;

class CLINT{
    public:
        CLINT(){                                            // 无参数的构造函数
            len = 0;
            memset(num, 0, sizeof(num));
        }
        CLINT(string s){                                    // 传入string s的构造函数
            len = s.size();
            memset(num, 0, sizeof(num));
            for(int i = len - 1; i >= 0; i --) num[i] = s[(len - 1) - i] - '0'; // 这里采用将数倒着写进数组
        }
        CLINT Add(const CLINT& L);                          // Achieve the sum of two big numbers
        void Value();                                       // Display the big number
    private:
        int num[115];
        int len;                                            // len表示对象中的数的位数
};

CLINT CLINT::Add(const CLINT& L){
    CLINT res;                                              // 定义一个res对象作为返回值
    int n = std::max(len, L.len);                           // 取二者中更长的len
    int lst = 0;                                            // lst用于记录上一位加法后进位的数的情况
    for(int i = 0; i < n; i ++){
        res.num[res.len] = num[i] + L.num[i] + lst;         // 两数对位相加
        lst = 0;
        if(res.num[res.len] > 9){                           // 考虑进位情况
            lst = res.num[res.len] - 9;
            res.num[res.len] -= 9;
        }
        res.len ++;
    }
    if(lst > 0){                                             // 考虑最终的进位情况
        res.num[res.len] = lst;
        res.len ++;
    }
    return res;
}

void CLINT::Value(){
    for(int i = len - 1; i >= 0; i --) cout << num[i];       // 因为是倒着存的 所有倒着输出
    cout << endl;
}

int main(){
    CLINT L1("12345678900987654321"), L2("9876543210"), L3;
    L1.Value(); L2.Value();
    L3 = L1.Add(L2);
    L3.Value();
    return 0;
}