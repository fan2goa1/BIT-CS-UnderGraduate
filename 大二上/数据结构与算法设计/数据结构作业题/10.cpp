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
stack <char> opt, pha;
char ch[2015], ans[2015];

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
	else if(a == '*' || a == '/') x = 5;
	else if(a == '^') x = 7;
	else if(a == ')') x = 9;
	
	if(b == '(') y = 1;
	else if(b == '+' || b == '-') y = 3;
	else if(b == '*' || b == '/') y = 5;
	else if(b == '^') y = 7;
	else if(b == ')') y = 9;
//	return x >= y;
	
	if(x > y) return 1;
	if(x < y) return 0;
	if(a == '^' && b == '^') return 1;
	return 0;
	
}

int main(){
	n = read();
	while(n --){
		while(!opt.empty()) opt.pop();
		while(!pha.empty()) pha.pop();
		scanf("%s", ch + 1);
		m = strlen(ch + 1);
		rep(i, 1, m){
			char c = ch[i];
			if(c == '#') break;
			if((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) pha.push(c);
			else if(c == '(') opt.push(c);
			else if(c == ')'){
				while(opt.top() != '('){
					pha.push(opt.top());
					opt.pop();
				}
				opt.pop();
			}
			else {	//cao zuo fu
				if(opt.empty() || pd(c, opt.top())) opt.push(c);
				else {
					while(!opt.empty()){
						if(!pd(c, opt.top())){
							pha.push(opt.top());
							opt.pop();
						}
						else break;
					}
					opt.push(c);
				}
			}
		}
		while(!opt.empty()){
			pha.push(opt.top());
			opt.pop();
		}
		int cnt = 0;
		while(!pha.empty()){
			ans[++ cnt] = pha.top();
			pha.pop();
		}
		rep_(i, cnt, 1) printf("%c", ans[i]);
		puts("");
	}
	return 0;
}
