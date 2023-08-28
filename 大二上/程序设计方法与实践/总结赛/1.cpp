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

const int MAXN = 115;

int a[MAXN], b[MAXN], cnta, cntb;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	int x = read(), y = read(); bool ans = 0;
	rep(i, 2, max(x, y)){
		cnta = cntb = 0;
		int tmpx = x, tmpy = y;
		while(tmpx){
			a[++ cnta] = tmpx % i;
			tmpx /= i;
		}
		while(tmpy){
			b[++ cntb] = tmpy % i;
			tmpy /= i;
		}
		if(cnta < cntb){
			rep(j, cnta + 1, cntb) a[j] = 0;
		}
		else {
			rep(j, cntb + 1, cnta) b[j] = 0;
		}
		bool flag = 1; int n = max(cnta, cntb);
		/*
		if(i == 541){
			rep(j, 1, n) printf("%d ", b[j]); puts("");
			rep(j, 1, n) printf("%d ", a[j]); puts("");
		}
		*/
		if(n == 1) break;
		rep(j, 1, n){
			if(a[j] != b[n + 1 - j]){flag = 0; break;}
		}
		if(flag){
			ans = 1;
			printf("%d\n", i);
		}
	}
	if(!ans) puts("-1");
	return 0;
}
