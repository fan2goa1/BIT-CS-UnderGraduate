#include <iostream>

using namespace std;

struct Node{                    //链表节点
    int data;
    Node *nxt;
};

class CLQueue{
    public:
        CLQueue(){head = tail = NULL; sz = 0;}
        void Add(int x);
        void Remove(int x);
        int Get(int pos);
    private:
        Node *head, *tail;              //头、尾节点
        int sz;                         //循环链表长度
};

void CLQueue::Add(int x){
    Node *p = new Node;
    p -> data = x;
    if(!sz){                            //如果当前为空，直接加head
        sz ++;
        tail = head = p;
        head -> nxt = tail;
    }
    else {
        sz ++;                          //否则延长tail
        p -> nxt = head;
        tail -> nxt = p;
        tail = p;
    }
    return ;
}

void CLQueue::Remove(int x){
    if(sz == 1){                        //如果长度为1，直接删掉
        head = tail = NULL;
        sz --;
    }
    else {
        Node *tmp = head;                //否则循环寻找删掉
        bool flag = 0;
        while(tmp != head || !flag){ flag = 1;
            if(tmp -> nxt -> data == x){
                tmp -> nxt = tmp -> nxt -> nxt;
                sz --;
                break;
            }
            tmp = tmp -> nxt;
        }
    }
    return ;
}

int CLQueue::Get(int pos){
    Node *tmp = tail;
    while(pos --){              //循环pos次找到要找的位置
        tmp = tmp -> nxt;
    }
    return tmp -> data;
}

int main(){
    CLQueue q;                  //简单测试，输入n个数，m个要删除的数，然后输入pos，找第pos个位置的数
    int n; cin >> n;
    for(int i = 1; i <= n; i ++){
        int x; cin >> x;
        q.Add(x);
    }
    int m; cin >> m;
    for(int i = 1; i <= m; i ++){
        int x; cin >> x;
        q.Remove(x);
    }
    int pos; cin >> pos;
    cout << q.Get(pos) << endl;
    return 0;
}