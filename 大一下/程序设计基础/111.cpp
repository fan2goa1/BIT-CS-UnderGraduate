#include <bits/stdc++.h>
#define mp(a, b) make_pair(a, b)
#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

using namespace std;

typedef long long LL;
typedef double DB;
typedef pair<int, int> pii;

const int MAXN = 1e5 + 15;

LL a[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

LL gcd(LL a, LL b){return !b ? a : gcd(b, a % b);}

int main(){
	int n, x;
	while(~scanf("%d%d", &n, &x)){
		LL maxn = 0, minn = 1e9 + 7;
		rep(i, n){scanf("%lld", &a[i]);
			maxn = max(maxn, a[i]);
			minn = min(minn, a[i]);
		}
		LL p = 1ll * x * maxn, q = minn;
		LL f = gcd(p, q);
		printf("%lld/%lld\n", p / f, q / f);
		}
	return 0;
}
