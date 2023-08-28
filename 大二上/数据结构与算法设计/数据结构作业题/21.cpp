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

const int MAXN = 15;

int p[MAXN][MAXN], q[MAXN][MAXN], a[MAXN], n; LL mx[MAXN], ans = 0, tmp = 0;
bool flag[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void find(int j){
	if(tmp + (mx[n] - mx[j]) <= ans) return ;
	if(j == n){ans = max(ans, tmp); return ;}
	rep(i, 1, n){
		if(!flag[i]){
			tmp += 1ll * p[j + 1][i] * q[i][j + 1]; flag[i] = 1;
			find(j + 1);
			tmp -= 1ll * p[j + 1][i] * q[i][j + 1]; flag[i] = 0;
		}
	}
	return ;
}

int main(){
	n = read();
	rep(i, 1, n)
		rep(j, 1, n) p[i][j] = read();
	rep(i, 1, n)
		rep(j, 1, n) q[i][j] = read();
	rep(i, 1, n){
		rep(j, 1, n) mx[i] = max(mx[i], 1ll * p[i][j] * q[j][i]);
		mx[i] += mx[i - 1];
	}
	find(0);
	printf("%lld\n", ans);
	return 0;
}
