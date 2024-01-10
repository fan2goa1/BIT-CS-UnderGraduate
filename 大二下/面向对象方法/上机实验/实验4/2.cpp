#include <iostream>
#include "CMyString.cpp"

using namespace std;

class CInternetURL{
    private:
        CMyString url;
        CMyString domain;
    public:
        CInternetURL(){}
        CInternetURL(const CMyString& s){
            url = s;
        }
        CMyString GetDomain();
        CMyString GetDomainCountry();
        CMyString GetDomainType();
};

CMyString CInternetURL::GetDomain(){
    CMyString ss;
    int start = url.Find("www");                            //截头
    ss = url.Mid(start, url.getlen() - start);
    int length = ss.Find('/');                             //截尾
    domain = ss.Mid(0, length);
    this -> domain = domain;
    return domain;
}

CMyString CInternetURL::GetDomainCountry(){
    CMyString temp = domain;                         //找到最后一个 "." 后面的内容
    int start;
    while(temp.Find('.') != -1){
        start = temp.Find('.') + 1;
        temp = temp.Mid(start, temp.getlen() - start);
    }
    return temp;
}

CMyString CInternetURL::GetDomainType(){                        //网站类型通常在国家的前面，所以取国家的.的前面那个即可
    CMyString tmp1 = domain, tmp2 = domain;
    int begined = tmp1.Find('.') + 1;
    tmp1 = tmp1.Mid(begined, tmp1.getlen() - begined);
    while(tmp1.Find('.') != -1){
        begined = tmp1.Find('.') + 1;
        tmp1 = tmp1.Mid(begined, tmp1.getlen() - begined);
        begined = tmp2.Find('.') + 1;
        tmp2 = tmp2.Mid(begined, tmp2.getlen() - begined);
    }
    begined = tmp2.Find('.');                             
    tmp2 = tmp2.Mid(0, begined);
    return tmp2;
}

int main(){
    CInternetURL URL("https://www.bit.edu.cn/xww/zhxw/index.htm"), s2;
    cout << URL.GetDomain() << endl; // The result is: www.bit.edu.cn
    cout << URL.GetDomainCountry() << endl; // The result is: cn
    cout << URL.GetDomainType() << endl; // The result is: edu
    return 0;
}