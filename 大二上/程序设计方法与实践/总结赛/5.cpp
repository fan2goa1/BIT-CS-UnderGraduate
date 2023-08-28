#include <iostream>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <map>
#include <queue>
#include <cstring>
#include <ctime>
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

char ch[115], ans[115];
LL a, b, tt[5];
int op, n, gg[5], cnt = 0;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	scanf("%s", ch + 1);
	n = strlen(ch + 1);
	rep(i, 1, n) ans[i] = (char)(127);
	rep(i, 1, n){
		if(ch[i] == '+'){op = 1; tmp = 0;}
		else if(ch[i] == '-'){op = 2; tmp = 0;}
		else {
			tmp = tmp * 10 + ch[i] - '0';
		}
	}
	rep(i, 1, n)
		rep(j, i + 1, n)
			rep(k, j + 1, n){
				if(!isdigit(ch[i]) || !isdigit(ch[j]) || !isdigit(ch[k])) continue;
				
			}
	return 0;
}
