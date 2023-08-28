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

const int MAXN = 105;
const int MAXW = 505;
const int inf = 0x3f3f3f3f;

struct gg{int w, v, g;}a[MAXN];
int f[3][MAXW][MAXW], n, q, W, V;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void init(){
	clr(f, -inf); f[0][0][0] = 0;
	rep(i, 1, n){
		rep(j, 0, 500){
			rep(k, 0, 500){
				f[i % 2][j][k] = max(f[i % 2][j][k], f[(i-1) % 2][j][k]);
				int w1 = j + a[i].w;
				int v1 = k + a[i].v;
				if(w1 > 500) continue;
				if(v1 > 500) v1 = 500;
				if(f[(i-1) % 2][j][k] >= 0) f[i % 2][w1][v1] = max(f[i % 2][w1][v1], f[(i-1)%2][j][k] + a[i].g);
			}
		}
	}
}

int main(){
	n = read(), q = read();
	rep(i, 1, n){
		a[i].w = read();
		a[i].v = read();
		a[i].g = read();
	}
	init();
	int ans;
	while(q --){ ans = -inf;
		W = read(), V = read();
		rep(j, 1, W)
			rep(k, V, 500){
				ans = max(ans, f[n % 2][j][k]);
			}
		printf("%d\n", ans >= 0 ? ans : -1);
	}
	return 0;
}
