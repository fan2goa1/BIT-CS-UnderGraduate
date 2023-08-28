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
map <string, int> mp;
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

bool isalpha(char ch){
	if(ch >= 'a' && ch <= 'z') return 1;
	return 0;
}

int main(){
	int r = 0, z = 1;
	while(gets(ch + 1)){
		r = 0, z = 1;
		while(!opt.empty()) opt.pop();
		while(!pha.empty()) pha.pop();
		m = strlen(ch + 1);
		string str = "", str1 = "";
		if(m == 3 && ch[1] == 'e' && ch[2] == 'n' && ch[3] == 'd') break;
		if(ch[1] == '?'){
			rep(i, 3, m) str += ch[i];
			cout << str << "=";
			printf("%d\n", mp[str]);
			continue;
		}
		int tmp;
		rep(i, 1, m){
			if(ch[i] == '='){tmp = i + 1; break;}
			str += ch[i];
		}
		int flag = 1;
//		printf("%d\n", tmp);
		rep(i, tmp, m){
			char c = ch[i];
			if(isdigit(c)){
				r = 0;
				while(i <= m && isdigit(ch[i])){
					r = r * 10 + ch[i] - '0';
					i ++;
				}
			//	printf("%d\n", r * z);
				pha.push(r * z);
				i --; r = 0; z = 1;
				continue;
			}
			else if(isalpha(c)){
				str1 = "";
				while(i <= m && isalpha(ch[i])){
					str1 += ch[i];
					i ++;
				}
				pha.push(mp[str1]);
				i --; str1 = "";
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
				if(ch[i] == '-' && (ch[i - 1] == '+' || ch[i - 1] == '-' || ch[i - 1] == '*' || ch[i - 1] == '/' || ch[i - 1] == '%' || ch[i - 1] == '^' || ch[i-1] == '(' || i == tmp)){z = -1; continue;}
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
		/*
		if(flag == 2) continue;
		if(!flag){puts("error."); continue;}
		*/
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
		/*
		if(flag == 2) continue;
		else if(!flag) puts("error.");
		else {
			int ans = pha.top(); pha.pop();
			if(!pha.empty()) puts("error.");
			else printf("%d\n", ans);
		}
		*/
		int ans = pha.top(); pha.pop();
		mp[str] = ans;
	}
	return 0;
}
