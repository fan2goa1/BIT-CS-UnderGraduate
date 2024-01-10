#include <iostream>

using namespace std;

class CMyString{
    private:
        char* str;
        int len;
    public:
        void show(){
            for(int i = 0; i < len; i ++) cout << *(str + i);
            cout << endl;
            return ;
        }
        CMyString(){len = 0;}       // 无参构造函数
        CMyString(const char* p);   // char*构造函数
        CMyString(const CMyString& s);  // 拷贝构造函数
        ~CMyString();           //析构函数

        CMyString& operator=(const char *p);        //深拷贝（拷贝char*）
        CMyString& operator=(int a);        //将int转成char*
        CMyString& operator=(double a);     //将double转成char*
        char& operator[](int pos);          
        friend CMyString operator+(const char *p, CMyString& s);  //char* + CMyString重载+
        CMyString operator+(CMyString& s);          //CMyString + CMyString重载+
        CMyString operator+(const char *p);         //CMyString + char*重载+
        friend ostream& operator<<(ostream& os, const CMyString& s);    //输出重载

        int Find(char ch);
        int Find(const char *p);
        int getlen(){
            return len;
        }
        CMyString Mid(int start, int length);
        int ToInt();
        double ToDouble();
};

CMyString::CMyString(const char* p){
    int plen = 0;
    for(int i = 0; *(p + i) != '\0'; i ++) plen ++;
    len = plen;
    str = new char[len + 1];
    for(int i = 0; i < len; i ++) *(str + i) = *(p + i);
    *(str + len) = '\0';
}

CMyString::CMyString(const CMyString& s){
    len = s.len;
    str = new char[len + 1];
    for(int i = 0; i < len; i ++) *(str + i) = *(s.str + i);
    *(str + len) = '\0';
}

CMyString::~CMyString(){
    if(len != 0){
        delete[] str;
        len = 0;
    }
}

CMyString& CMyString::operator=(const char *p){
    if(len != 0) delete[] str;                      //先delete释放原来的空间
    len = 0;
    int plen = 0;
    for(int i = 0; *(p + i) != '\0'; i ++) plen ++;
    len = plen;
    str = new char[len + 1];                    //申请新的空间
    for(int i = 0; i < len; i ++) *(str + i) = *(p + i);
    *(str + len) = '\0';
    return *this;
}

CMyString& CMyString::operator=(int a){
    int tmp = a, alen = 0;
    while(tmp){
        tmp /= 10;
        alen ++;
    }
    this -> str = new char[alen + 1];
    while(a > 0){                                           //将int诸位提出
        *(this -> str + this -> len) = (a % 10) + '0';
        a /= 10;
        this -> len ++;
    }
    for(int i = 0; i < (this -> len) / 2; i ++) swap(*(this -> str + i), *(this -> str + (this -> len - 1 - i)));       //翻转
    return *this;
}

CMyString& CMyString::operator=(double a){
    int tmp = (int)a, alen = 0;
    while(tmp){
        tmp /= 10;
        alen ++;
    }
    alen ++;
    double aa = a - (int)a;
    while(aa > 0.0001){
        aa = aa * 10.0;
        alen ++;
        aa = aa - (int)aa;
    }
    delete[] this -> str;
    this -> len = 0;
    this -> str = new char[alen + 1];
    tmp = (int)a;
    while(tmp > 0){                                         //先提小数点前的部分
        *(this -> str + this -> len) = (tmp % 10) + '0';
        tmp /= 10;
        this -> len ++;
    }
    for(int i = 0; i < (this -> len) / 2; i ++) swap(*(this -> str + i), *(this -> str + (this->len - 1 - i)));
    *(this -> str + this -> len) = '.'; this -> len ++;
    a = a - (int)a;
    while(a > 0.001){                           // 提小数点后的部分
        a = a * 10.0;
        int now = (int)a;
        *(this -> str + this -> len) = now + '0'; this -> len ++;
        a = a - (int)a;
    }
    *(this-> str + this -> len) = '\0';
    return *this;
}

char& CMyString::operator[](int pos){
    if(pos < 0 || pos >= len){
        cout << "Array index out of bounds" << endl;            //越界判断
        exit(1);
    }
    return *(str + pos);
}

CMyString operator+(const char *p, CMyString& s){
    int plen = 0;
    for(int i = 0; *(p + i) != '\0'; i ++) plen ++;
    CMyString ret;
    ret.str = new char[s.len + plen + 1];
    ret.len = s.len + plen;
    for(int i = 0; i < plen; i ++) *(ret.str + i) = *(p + i);
    for(int i = 0; i < s.len; i ++) *(ret.str + plen + i) = *(s.str + i);
    *(ret.str + ret.len) = '\0';
    return ret;
}

CMyString CMyString::operator+(CMyString& s){
    CMyString ret;
    ret.str = new char[len + s.len + 1];
    ret.len = len + s.len;
    for(int i = 0; i < len; i ++) *(ret.str + i) = *(str + i);
    for(int i = 0; i < s.len; i ++) *(ret.str + len + i) = *(s.str + i);
    *(ret.str + ret.len) = '\0';
    return ret;
}

CMyString CMyString::operator+(const char *p){
    int plen = 0;
    for(int i = 0; *(p + i) != '\0'; i ++) plen ++;
    CMyString ret;
    ret.str = new char[len + plen + 1];
    ret.len = len + plen;
    for(int i = 0; i < len; i ++) *(ret.str + i) = *(str + i);
    for(int i = 0; i < plen; i ++) *(ret.str + len + i) = *(p + i);
    *(ret.str + ret.len) = '\0';
    return ret;
}

ostream& operator<<(ostream& os, const CMyString& s){
    for(int i = 0; i < s.len; i ++) os << *(s.str + i);         //重载<< 输出char*
    return os;
}

int CMyString::Find(char ch){
    int ret = -1;
    for(int i = 0; i < len; i ++){
        if(*(str + i) == ch){
            ret = i;
            break;
        }
    }
    return ret;
}

int CMyString::Find(const char *p){
    int ret = -1, plen = 0;
    for(int i = 0; *(p + i) != '\0'; i ++) plen ++;
    for(int i = 0; (i + plen - 1) < len; i ++){             //诸位寻找
        bool flag = 1;
        for(int j = 0; j < plen; j ++) if(*(str + i + j) != *(p + j)){flag = 0; break;}
        if(flag == 1){
            ret = i;
            break;
        }
    }
    return ret;
}

CMyString CMyString::Mid(int start, int length){
    CMyString ret;
    ret.len = length;
    ret.str = new char[length + 1];
    for(int i = 0; i < length; i ++) *(ret.str + i) = *(str + start + i);
    return ret;
}

int CMyString::ToInt(){
    int res = 0;
    for(int i = 0; i < len; i ++) res = res * 10 + (*(str + i) - '0');
    return res;
}

double CMyString::ToDouble(){
    double res = 0;
    for(int i = 0; i < len; i ++){
        if(*(str + i) == '.'){
            double base = 0.1;
            for(int j = i + 1; j < len; j ++){
                res = res + base * (*(str + j) - '0');
                base = base * 0.1;
            }
            break;
        }
        res = res * 10 + (*(str + i) - '0');
    }
    return res;
}