#include <iostream>
#include <cstring>

using namespace std;

class IntChar{
    public:
        IntChar(char a[]){                  //构造函数
            memcpy(ch, a, sizeof(a));
            len = num = 0;
        }
        ~IntChar(){}                        //析构函数
        void ASC_Print(){                   //输出ascii字符（原封不动输出）
            cout << ch << endl;
        }
        void Binary_Print(){                //ascii转二进制表示
            cout << "ASCII Print: "; 
            for(int i = 0; i < strlen(ch); i ++){
                char c = ch[i];
                int c_int = int(c), pos = 8;        //char转int
                while(pos){
                    bin[len + pos] = c_int % 2;     //用辗转相除法转换为二进制表示
                    pos --;
                    c_int /= 2;
                }
                len += 8;
            }
            for(int i = 1; i <= len; i ++){
                cout << bin[i];                        //输出二进制串 每4个空一格
                if(i % 4 == 0) cout << " ";
            } cout << endl;
        }
        void Int_Print(){                               //输出十进制表示
            int base = 1;
            for(int i = len; i > 0; i --){              //二进制转十进制
                num += base * bin[i];
                base *= 2;
            }
            cout << "Int Print: " << num << endl;
        }
    private:
        char ch[1015];
        int bin[5015], len;
        int num;
};

int main(){
    IntChar IC("Love");
	IC.ASC_Print();
	IC.Binary_Print();
	IC.Int_Print();
    return 0;
}