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

const int MAXN = 2e3 + 15;
const int MOD = 2147483647;

int n, a[MAXN];
LL f[MAXN][MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read();
	rep(i, 0, n) a[i] = read();
	f[1][a[0]] = 1;
	rep(i, 1, n){
		rep(j, 1, n + 1){
			if(a[i - 1] == j) continue;
			int l = min(a[i - 1], j);
			int r = max(a[i - 1], j);
			if(a[i] <= l) (f[i][r] += f[i - 1][j]) %= MOD;
			else if(a[i] >= r) (f[i][l] += f[i - 1][j]) %= MOD;
			else {
				(f[i][r] += f[i - 1][j]) %= MOD;
				(f[i][l] += f[i - 1][j]) %= MOD;
			}
		}
	}
	LL ans = 0;
	rep(i, 1, n + 1) (ans += f[n][i]) %= MOD;
	printf("%lld\n", ans);
	return 0;
}
