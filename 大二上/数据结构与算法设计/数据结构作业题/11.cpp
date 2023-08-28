#include <iostream>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <map>
#include <queue>
#include <cstring>
#include <ctime>
#include <stack>
#define mp(a, b) make_pair(a, b)
#define rep(i, x, y) for(int i = x; i <= y; i ++)
#define rep_(i, x, y) for(int i = x; i >= y; i --)
#define rep0(i,n) rep(i, 0, (n)-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))
#define eps 0.0000000001

using namespace std;

typedef long long LL;
typedef double LF;
typedef pair<int, int> pii;

int n, m;
stack <char> opt;
stack <int> pha;
char ch[2015];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int pd(char a, char b){
	int x = 0, y = 0;
	if(a == '(') x = 1;
	else if(a == '+' || a == '-') x = 3;
	else if(a == '*' || a == '/' || a == '%') x = 5;
	else if(a == '^') x = 7;
	else if(a == ')') x = 9;
	
	if(b == '(') y = 1;
	else if(b == '+' || b == '-') y = 3;
	else if(b == '*' || b == '/' || b == '%') y = 5;
	else if(b == '^') y = 7;
	else if(b == ')') y = 9;
//	return x >= y;
	
	if(x > y) return 1;
	if(x < y) return 0;
	if(a == '^' && b == '^') return 1;
	return 0;
	
}

int main(){
	int r = 0, z = 1;
	n = read();
	rep(kase, 1, n){
		scanf("%s", ch + 1);
		r = 0, z = 1;
		while(!opt.empty()) opt.pop();
		while(!pha.empty()) pha.pop();
		m = strlen(ch + 1);
		int flag = 1;
		rep(i, 1, m){
			char c = ch[i];
			if(isdigit(c)){
				r = 0;
				while(i <= m && isdigit(ch[i])){
					r = r * 10 + ch[i] - '0';
					i ++;
				}
				pha.push(r * z);
			//	printf("%d\n", r * z);
				i --; r = 0; z = 1;
				continue;
			}
			else if(c == '(') opt.push(c);
			else if(c == ')'){
				while(!opt.empty() && opt.top() != '('){
					char op = opt.top();
					if(pha.empty()){flag = 0; break;}
					int a = pha.top(); pha.pop();
					if(pha.empty()){flag = 0; break;}
					int b = pha.top(); pha.pop();
					int ret = 0;
					swap(a, b);
				//	printf("%d %c %d\n", a, op, b);
					if(op == '+') ret = a + b;
					else if(op == '-') ret = a - b;
					else if(op == '*') ret = a * b;
					else if(op == '/'){
						if(!b){flag = 2; puts("Divide 0."); break;}
						ret = a / b;
					}
					else if(op == '%') ret = a % b;
					else if(op == '^'){
						if(b < 0){flag = 0; break;}
						ret = pow(a, b);
					}
					else {flag = 0; break;}
					pha.push(ret);
					opt.pop();
				}
				if(opt.empty()){flag = 0; break;}
				if(flag == 2) break;
				opt.pop();
			}
			else {	//cao zuo fu
				if(ch[i] == '-' && (ch[i - 1] == '+' || ch[i - 1] == '-' || ch[i - 1] == '*' || ch[i - 1] == '/' || ch[i - 1] == '%' || ch[i - 1] == '^' || ch[i-1] == '(' || i == 1)){z = -1; continue;}
				else if((ch[i] == '+' || ch[i] == '*' || ch[i] == '/' || ch[i] == '%') && (ch[i - 1] == '+' || ch[i - 1] == '-' || ch[i - 1] == '*' || ch[i - 1] == '/' || ch[i - 1] == '%' || ch[i - 1] == '^' || ch[i - 1] == '(')){
					flag = 0;
					break;
				}
				else if(opt.empty() || pd(c, opt.top())) opt.push(c);
				else {
					while(!opt.empty()){
						if(!pd(c, opt.top())){
							char op = opt.top();
							if(pha.empty()){flag = 0; break;}
							int a = pha.top(); pha.pop();
							if(pha.empty()){flag = 0; break;}
							int b = pha.top(); pha.pop();
							swap(a, b);
						//	printf("%d %c %d\n", a, op, b);
							int ret = 0;
							if(op == '+') ret = a + b;
							else if(op == '-') ret = a - b;
							else if(op == '*') ret = a * b;
							else if(op == '/'){
								if(!b){flag = 2; puts("Divide 0."); break;}
								ret = a / b;
							}
							else if(op == '%') ret = a % b;
							else if(op == '^'){
								if(b < 0){flag = 0; break;}
								ret = pow(a, b);
							}
							else {flag = 0; break;}
							pha.push(ret);
							opt.pop();
						}
						else break;
					}
					opt.push(c);
				}
			}
			if(flag != 1) break;
		}
		if(flag == 2) continue;
		if(!flag){puts("error."); continue;}
		while(!opt.empty()){
			char op = opt.top();
			if(pha.empty()){flag = 0; break;}
			int a = pha.top(); pha.pop();
			if(pha.empty()){flag = 0; break;}
			int b = pha.top(); pha.pop();
			int ret = 0;
			swap(a, b);
		//	printf("%d %c %d\n", a, op, b);
			if(op == '+') ret = a + b;
			else if(op == '-') ret = a - b;
			else if(op == '*') ret = a * b;
			else if(op == '/'){
				if(!b){flag = 2; puts("Divide 0."); break;}
				ret = a / b;
			}
			else if(op == '%') ret = a % b;
			else if(op == '^'){
				if(b < 0){flag = 0; break;}
				ret = pow(a, b);
			}
			else {flag = 0; break;}
			pha.push(ret);
			opt.pop();
		}
		if(flag == 2) continue;
		else if(!flag) puts("error.");
		else {
			int ans = pha.top(); pha.pop();
			if(!pha.empty()) puts("error.");
			else printf("%d\n", ans);
		}
	}
	return 0;
}
