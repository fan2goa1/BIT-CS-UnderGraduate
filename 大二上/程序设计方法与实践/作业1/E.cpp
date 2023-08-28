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

const int MAXN = 1e5 + 15;

int a[MAXN], n, l[MAXN], r[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	int T = read();
	while(T --){ clr(l, 0); clr(r, 0);
		n = read();
		rep(i, 1, n) a[i] = read();
		int nowmx = 0;
		rep(i, 1, n){
			l[i] = nowmx;
			nowmx = max(nowmx, a[i]);
		}
		nowmx = 0;
		rep_(i, n, 1){
			r[i] = nowmx;
			nowmx = max(nowmx, a[i]);
		}
		LL ans = 0;
		rep(i, 1, n){
			int tmp = min(l[i], r[i]);
			if(tmp < a[i]) continue;
			ans += 1ll * (tmp - a[i]);
		}
		printf("%lld\n", ans);
	}
	return 0;
}
