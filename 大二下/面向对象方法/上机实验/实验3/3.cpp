#include <iostream>
#include <cstring>
#include <stack>
#include <cmath>

using namespace std;

class CExpression{
    static bool pd(char a, char b);                             //静态布尔函数，用于判断两个操作符的优先级
    static bool isdigit(char c);                                //静态布尔函数，用于判断当前字符是否是一个数字
    public:
        CExpression();                                          //构造函数
        CExpression(const char *b);                             //拷贝构造函数
        void SetExpression(const CExpression &b);
        void PrintExpression();
        double Value();
    private:
        char ch[2015];                                           //用于存表达式
        int len;                                                 //记录表达式的字符串的长度
        stack <char> opt;                                        //利用STL中的stack（栈结构）记录当前的操作符
        stack <double> pha;                                      //利用STL中的stack（栈结构）记录当前的被操作数
};

bool CExpression::pd(char a, char b){                            //比较优先级，从高到低的顺序：), ^, * or /, + or -, (
	int x = 0, y = 0;
	if(a == '(') x = 1;
	else if(a == '+' || a == '-') x = 3;
	else if(a == '*' || a == '/') x = 5;
	else if(a == '^') x = 7;
	else if(a == ')') x = 9;
	
	if(b == '(') y = 1;
	else if(b == '+' || b == '-') y = 3;
	else if(b == '*' || b == '/') y = 5;
	else if(b == '^') y = 7;
	else if(b == ')') y = 9;
	
	if(x > y) return 1;
	if(x < y) return 0;
	if(a == '^' && b == '^') return 1;                            //这里相对于题目 增加的乘方操作
	return 0;
}

bool CExpression::isdigit(char c){
    if(c >= '0' && c <= '9') return 1;
    return 0;
}

CExpression::CExpression(){
    len = 0;                                                    //len初值为0
    while(!opt.empty()) opt.pop();                              //清空opt栈
    while(!pha.empty()) pha.pop();                              //清空pha栈
}

CExpression::CExpression(const char *b){
    len = 0;
    strcpy(ch, b);                                              //利用strcpy函数将b赋给ch
    len = strlen(ch);
    while(!opt.empty()) opt.pop();
    while(!pha.empty()) pha.pop();
}

void CExpression::SetExpression(const CExpression &b){
    len = b.len;
    strcpy(ch, b.ch);
    while(!opt.empty()) opt.pop();
    while(!pha.empty()) pha.pop();
}

double CExpression::Value(){
    double r = 0.0, z = 1.0;                                        //r用于记录当前数，z用于记录是否是负数
    for(int i = 0; i < len; i ++){
        char c = ch[i];
        if(isdigit(c)){
            r = 0;
            while(i < len && isdigit(ch[i])){                        //进行一个按位的累加
                r = r * 10 + ch[i] - '0';
                i ++;
            }
            if(ch[i] == '.'){                                        //考虑小数点后的数字的大小
                double r_dot = 0.0, base = 0.1;
                i ++;
                while(i < len && isdigit(ch[i])){
                    r_dot = r_dot + (ch[i] - '0') * base;
                    base = base * 0.1;
                    i ++;
                }
                r += r_dot;
            }
            pha.push(r * z);                                          //放入pha栈中，等待被操作
            i --; r = 0.0; z = 1.0;
            continue;
        }
        else if(c == '(') opt.push(c);
        else if(c == ')'){                                            //特判一下)的出现，这意味着()之间的内容要被优先进行计算
            while(!opt.empty() && opt.top() != '('){                  //不停的取opt栈顶的操作符和pha栈顶的两个被操作数，进行计算，result再放回opt栈中，直至算完()中的内容
                char op = opt.top();
                double a = pha.top(); pha.pop();
                double b = pha.top(); pha.pop();
                double ret = 0;
                swap(a, b);
                if(op == '+') ret = a + b;
                else if(op == '-') ret = a - b;
                else if(op == '*') ret = a * b;
                else if(op == '/') ret = a / b;
                else if(op == '^') ret = pow(a, b);
                pha.push(ret);
                opt.pop();
            }
            opt.pop();
        }
        else {                                                         //讨论除了()的操作符的情况
            if(ch[i] == '-' && (ch[i - 1] == '+' || ch[i - 1] == '-' || ch[i - 1] == '*' || ch[i - 1] == '/' || ch[i - 1] == '%' || ch[i - 1] == '^' || ch[i-1] == '(' || i == 1)){z = -1; continue;}   //负数情况
            else if(opt.empty() || pd(c, opt.top())) opt.push(c);       //直接放入栈中
            else {                                                      //如果当前操作符的优先级高于opt栈顶的操作符的优先级，那么优先弹栈计算栈中内容，直至opt栈顶的操作符优先级低于当前操作符的优先级
                while(!opt.empty()){
                    if(!pd(c, opt.top())){
                        char op = opt.top();
                        double a = pha.top(); pha.pop();
                        double b = pha.top(); pha.pop();
                        swap(a, b);
                        double ret = 0;
                        if(op == '+') ret = a + b;
                        else if(op == '-') ret = a - b;
                        else if(op == '*') ret = a * b;
                        else if(op == '/') ret = a / b;
                        else if(op == '^') ret = pow(a, b);
                        pha.push(ret);
                        opt.pop();
                    }
                    else break;
                }
                opt.push(c);
            }
        }
    }
    while(!opt.empty()){                                            //逐步计算栈中剩余数的基本操作，此时opt栈中的操作符优先级应当是相同的
        char op = opt.top();
        double a = pha.top(); pha.pop();
        double b = pha.top(); pha.pop();
        double ret = 0;
        swap(a, b);
        if(op == '+') ret = a + b;
        else if(op == '-') ret = a - b;
        else if(op == '*') ret = a * b;
        else if(op == '/') ret = a / b;
        else if(op == '^') ret = pow(a, b);
        pha.push(ret);
        opt.pop();
    }
    double ans = pha.top(); pha.pop();                              //得到最终结果
    return ans;
}

void CExpression::PrintExpression(){
    for(int i = 0; i < len; i ++) cout << ch[i];
}

int main(){
    CExpression expr("50.3-20.12+8*8/2"); 
    expr.PrintExpression();
    cout << " = " << expr.Value() << endl; // 50.3-20.12+8*8/2 = 62.18

    expr.SetExpression("(39+11)*30+10/5");
    expr.PrintExpression();
    cout << " = " << expr.Value() << endl; // (39+11)*30+10/5 = 1502
    
    expr.SetExpression("39+12*(47+33)");
    expr.PrintExpression();
    cout << " = " << expr.Value() << endl; // 39+12*(47+33) = 999
    
    expr.SetExpression("20/(112-(10*1.2))/10-1.01"); 
    expr.PrintExpression();
    cout << " = " << expr.Value() << endl; // 20/(112-(10*1.2))/10-1.01 = -0.99
    return 0;
}