#include <iostream>

using namespace std;

class lit{                                                      //这个类的每个对象是一种货品
    public:
        static int num_drink, num_snack, num_cookie;            //用 static int 分别记录饮料、零食、饼干的数量
        static int pri_drink, pri_snack, pri_cookie;            //用 static int 分别记录饮料、零食、饼干的总价格
        ~lit(){}                                                //析构函数
        void get_goods(int number, int price, int type){        //赋一种货品的初值（其中，1表示饮料，2表示零食，3表示饼干）
            num = number;
            pri = price;
            tp = type;
        }
        void calc(){                                             //计算累加总数量和总价格
            if(tp == 1){num_drink += num; pri_drink += num * pri;}
            else if(tp == 2){num_snack += num; pri_snack += num * pri;}
            else {num_cookie += num; pri_cookie += num * pri;}
        }
    private:
        int num, pri, tp;
};

int cnt = 0;
lit a[1005];

int lit::num_drink = 0;                                          //static类型的变量初值为0
int lit::num_snack = 0;
int lit::num_cookie = 0;

int lit::pri_drink = 0;
int lit::pri_snack = 0;
int lit::pri_cookie = 0;

int main(){
    int x, y;
    cout << "input the number and price of the goods of drink: (0 0 indicates end)" << endl;        //输入不同每种货品的数量和单价
    while(cin >> x >> y){
        if(!x && !y) break;
        a[++ cnt].get_goods(x, y, 1);
    }
    cout << "input the number and price of the goods of snack: (0 0 indicates end)" << endl;
    while(cin >> x >> y){
        if(!x && !y) break;
        a[++ cnt].get_goods(x, y, 2);
    }
    cout << "input the number and price of the goods of cookie: (0 0 indicates end)" << endl;
    while(cin >> x >> y){
        if(!x && !y) break;
        a[++ cnt].get_goods(x, y, 3);
    }
    for(int i = 1; i <= cnt; i ++) a[i].calc();                         //计算总数量和总价格
    cout << "The total number of the goods: " << lit::num_drink + lit::num_snack + lit::num_cookie << endl;
    cout << "The total price of the goods: " << lit::pri_drink + lit::pri_snack + lit::pri_cookie << endl;
    return 0;
}