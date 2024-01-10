#include <iostream>
#include <cstring>
#include <fstream>
#include <map>
#include <algorithm>

using namespace std;

/*
对于第二问，我考虑用各名字的出现次数这一指标判断其重要程度（名+字）
结果是：
刘备 2113
诸葛亮 1852
曹操 978
关羽 452
张飞 366
孙权 331
周瑜 302
故可认为 刘备、诸葛亮、曹操更重要一些
*/

struct Figure{
    string name;
    int count;
    Figure(){count = 0;}
}sgFigure[20];              //对于三国重要人物的名字和出现次数进行记录

bool cmp(Figure a, Figure b){return a.count > b.count;}

int main(){
    ifstream sg("sanguo.txt");              //读取sanguo.txt文件
    string str, ss2 = "", ss3 = "";
    map <string, int> mp;                   //使用map容器，记录不同相连的2个字或3个字的出现次数
    int cnt = 0;
    if(sg){
        while(getline(sg, str)){
            if(!str.length()) continue;
            else {
                cnt ++;                     //对于非空行，进行统计
                for(int i = 3; i < str.length(); i ++){
                    ss2 = str.substr(i - 3, 4);
                    mp[ss2] ++;                 //记录相邻的两个字的出现
                    if(i > 4){
                        ss3 = str.substr(i - 5, 6);
                        mp[ss3] ++;             //记录相邻的三个字的出现
                    }
                }
            }
        }
        ifstream nm("sg_name.txt");                 //读取我自己记录的各人物的名和字的文件
        if(nm){
            string ss = "";
            int id = 0;
            while(getline(nm, ss)){
                sgFigure[++ id].name = ss;
                sgFigure[id].count = mp[ss];        //统计其名出现次数
                getline(nm, ss);
                sgFigure[id].count += mp[ss];          //统计其字出现次数 二者相加
            }
            sort(sgFigure + 1, sgFigure + id + 1, cmp); //按出现次数从大到小进行排序
            for(int i = 1; i <= id; i ++){
                cout << sgFigure[i].name << " " << sgFigure[i].count << endl;   //按出现次数从大到小进行输出
            }
        }
        else cout << "Error. sg_name" << endl;
    }
    else cout << "Error. sanguo" << endl;
    cout << "总非空行数: " << cnt << endl;           //输出总非空行数
    return 0;
}