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

const int MAXN = 2e5 + 15;

struct dra{
	int x, y;
	dra(){}
	dra(int x, int y):x(x), y(y){}
}a[MAXN], b[MAXN];
int n, m;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

bool cmp1(dra a, dra b){return a.x < b.x;}
bool cmp2(dra a, dra b){
	int tmp1 = a.x + a.y;
	int tmp2 = b.x + b.y;
	return tmp1 > tmp2;
}

int main(){
	int t = read(); LL ans = 0;
	rep(i, 1, t){
		int x = read(), y = read();
		if(y >= 0) a[++ n] = dra(x, y);
		else b[++ m] = dra(x, y);
	}
	sort(a + 1, a + n + 1, cmp1);
	sort(b + 1, b + m + 1, cmp2);
	LL now = 0;
	rep(i, 1, n){
		if(now < 1ll * a[i].x){ans += 1ll * a[i].x - now; now = 1ll * a[i].x;}
		now += 1ll * a[i].y;
	}
	rep(i, 1, m){
		if(now < 1ll * b[i].x){ans += 1ll * b[i].x - now; now = 1ll * b[i].x;}
		now += 1ll * b[i].y;
	}
	printf("%lld\n", ans);
	return 0;
}
