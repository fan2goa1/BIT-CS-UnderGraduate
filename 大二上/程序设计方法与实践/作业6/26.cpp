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

const int MAXN = 5e5 + 15;
const LL inf = 0x3f3f3f3f;

LL f[MAXN][5], a[MAXN];
int n;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read();
	rep(i, 1, n) scanf("%lld", &a[i]);
	rep(i, 1, n)
		rep(j, 1, 3) f[i][j] = -inf;
	rep(j, 1, 3){
		f[j][j] = f[j - 1][j - 1] + a[j];
		LL tmp = f[j - 1][j - 1];
		rep(i, j + 1, n){
			tmp = max(tmp, f[i - 1][j - 1]);
			f[i][j] = max(tmp, f[i - 1][j]) + a[i];
		}
	}
	LL ans = -inf;
	rep(i, 1, n) ans = max(ans, f[i][3]);
	printf("%lld\n", ans);
	return 0;
}
