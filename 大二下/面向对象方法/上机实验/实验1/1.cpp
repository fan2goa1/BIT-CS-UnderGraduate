#include <iostream>
#include <cstring>
#include <fstream>
#include <map>
#include <algorithm>

using namespace std;

/*
���ڵڶ��ʣ��ҿ����ø����ֵĳ��ִ�����һָ���ж�����Ҫ�̶ȣ���+�֣�
����ǣ�
���� 2113
����� 1852
�ܲ� 978
���� 452
�ŷ� 366
��Ȩ 331
��� 302
�ʿ���Ϊ ��������������ܲٸ���ҪһЩ
*/

struct Figure{
    string name;
    int count;
    Figure(){count = 0;}
}sgFigure[20];              //����������Ҫ��������ֺͳ��ִ������м�¼

bool cmp(Figure a, Figure b){return a.count > b.count;}

int main(){
    ifstream sg("sanguo.txt");              //��ȡsanguo.txt�ļ�
    string str, ss2 = "", ss3 = "";
    map <string, int> mp;                   //ʹ��map��������¼��ͬ������2���ֻ�3���ֵĳ��ִ���
    int cnt = 0;
    if(sg){
        while(getline(sg, str)){
            if(!str.length()) continue;
            else {
                cnt ++;                     //���ڷǿ��У�����ͳ��
                for(int i = 3; i < str.length(); i ++){
                    ss2 = str.substr(i - 3, 4);
                    mp[ss2] ++;                 //��¼���ڵ������ֵĳ���
                    if(i > 4){
                        ss3 = str.substr(i - 5, 6);
                        mp[ss3] ++;             //��¼���ڵ������ֵĳ���
                    }
                }
            }
        }
        ifstream nm("sg_name.txt");                 //��ȡ���Լ���¼�ĸ�����������ֵ��ļ�
        if(nm){
            string ss = "";
            int id = 0;
            while(getline(nm, ss)){
                sgFigure[++ id].name = ss;
                sgFigure[id].count = mp[ss];        //ͳ���������ִ���
                getline(nm, ss);
                sgFigure[id].count += mp[ss];          //ͳ�����ֳ��ִ��� �������
            }
            sort(sgFigure + 1, sgFigure + id + 1, cmp); //�����ִ����Ӵ�С��������
            for(int i = 1; i <= id; i ++){
                cout << sgFigure[i].name << " " << sgFigure[i].count << endl;   //�����ִ����Ӵ�С�������
            }
        }
        else cout << "Error. sg_name" << endl;
    }
    else cout << "Error. sanguo" << endl;
    cout << "�ܷǿ�����: " << cnt << endl;           //����ܷǿ�����
    return 0;
}