#include <iostream>

using namespace std;

class CSet{
    public:
        CSet(){cnt = 0;}                            //构造函数
        ~CSet(){}                                   //析构函数
        void AddItem(int x);                       
        void RemoveItem(int x);
        void IsExist(int x);
        void IsEqual(const CSet &s);
        static CSet Union(CSet &s1, CSet &s2);
        static CSet Intersection(CSet &s1, CSet &s2);
        void print();                                //输出集合元素
    private:
        int elm[1005], cnt;                          //分别代表集合元素和元素个数
};

void CSet::AddItem(int x){
    for(int i = 1; i <= cnt; i ++){
        if(elm[i] == x) return ;                      //如果集合中已经存在该元素则退出
    }
    elm[++ cnt] = x;                                  //否则加入集合
    return ;
}

void CSet::RemoveItem(int x){
    for(int i = 1; i <= cnt; i ++){
        if(elm[i] == x){
            swap(elm[cnt], elm[i]);                     //将最后一个元素覆盖到当前位置，以起到删除作用
            cnt --;
            break;
        }
    }
    return ;
}

void CSet::IsExist(int x){
    bool is_exist = 0;
    for(int i = 1; i <= cnt; i ++){
        if(elm[i] == x){
            is_exist = 1;                                //如果存在 则将is_exist标为1
            break;
        }
    }
    if(is_exist) cout << x << "is exist in the set." << endl;
    else cout << x << "isn't exist in the set." << endl;
}

void CSet::IsEqual(const CSet &s){
    bool is_equal = 1;
    for(int i = 1; i <= cnt; i ++){
        bool flag = 0;
        for(int j = 1; j <= s.cnt; j ++){
            if(elm[i] == s.elm[j]){flag = 1; break;}       
        }
        if(!flag){is_equal = 0; break;}                     //如果s1中的某个元素s2没有，则二则不相等
    }
    if(is_equal) cout << "The two sets is equal." << endl;  //否则s1和s2相等
    else cout << "The two sets is NOT equal." << endl;
}

CSet CSet::Union(CSet &s1, CSet &s2){                      //输入两个集合，输出它们的并集
    CSet s;
    for(int i = 1; i <= s1.cnt; i ++){
        s.AddItem(s1.elm[i]);                               //调用AddItem接口添加元素
    }
    for(int i = 1; i <= s2.cnt; i ++){
        s.AddItem(s2.elm[i]);
    }
    return s;
}

CSet CSet::Intersection(CSet &s1, CSet &s2){                //输入两个集合，输出它们的并集
    CSet s;
    for(int i = 1; i <= s1.cnt; i ++){
        bool flag = 0;
        for(int j = 1; j <= s2.cnt; j ++){
            if(s1.elm[i] == s2.elm[j]){flag = 1; break;}     //如果s1和s2中都存在该元素，则把它add到交集中
        }
        if(flag) s.AddItem(s1.elm[i]);
    }
    return s;
}

void CSet::print(){
    for(int i = 1; i <= cnt; i ++) cout << elm[i] << " ";
    cout << endl;
}

int main(){
    //简单测试，输入两个集合，求其交集和并集
    CSet s1;
    int n; cin >> n;                            //输入s1的元素个数
    for(int i = 1; i <= n; i ++){
        int x; cin >> x;
        s1.AddItem(x);
    }

    CSet s2;                                    //输入s2的元素个数
    int m; cin >> m;
    for(int i = 1; i <= m; i ++){
        int x; cin >> x;
        s2.AddItem(x);
    }
    CSet s_union = CSet::Union(s1, s2);          //求并集
    CSet s_inter = CSet::Intersection(s1, s2);   //求交集
    cout << "Union of s1 and s2: "; s_union.print();
    cout << "Intersection of s1 and s2: "; s_inter.print();
    return 0;
}