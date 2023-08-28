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

const int MAXN = 1e6 + 15;

int c[MAXN], h[MAXN], n, sta[MAXN], tot, ans;
int flag[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
//	freopen("1.txt","r", stdin);
//	freopen("1.out", "w", stdout);
	int T = read();
	while(T --){ tot = 0; ans = 0; clr(flag, 0);
		int n = read();
		rep(i, 1, n) c[i] = read();
		rep(i, 1, n) h[i] = read();
		rep(i, 1, n){
			while(tot && h[sta[tot]] <= h[i]){
				flag[c[sta[tot]]] --;
				if(!flag[c[sta[tot]]]) ans --;
				tot --;
			}
			sta[++ tot] = i; ++ flag[c[sta[tot]]];
			if(flag[c[sta[tot]]] == 1) ans ++;
			printf("%d%c", ans, i == n ? '\n' : ' ');
		}
	}
	return 0;
}
