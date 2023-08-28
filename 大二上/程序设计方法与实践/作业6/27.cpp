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

const int MAXN = 3e3 + 15;
const int MOD = 1e7;

int f[MAXN][MAXN], n, V, p[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read(); V = read();
	rep(i, 1, n) p[i] = read();
	f[0][0] = 1;
	rep(i, 1, n){
		rep(j, 0, V - 1) f[i][j] = f[i - 1][j];
		rep(j, 0, V - 1){
			int tmp = (j + p[i]) % V;
			(f[i][tmp] += f[i - 1][j]) %= MOD;
		}
	}
	printf("%d\n", (f[n][0] - 1 + MOD) % MOD);
	return 0;
}
