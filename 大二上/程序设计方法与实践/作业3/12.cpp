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

const int MAXN = 3e5 + 15;

int a[MAXN], b[MAXN], n, m, c[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int lowbit(int x){return x & -x;}
void modify(int x, int y){
	for(; x <= n; x += lowbit(x)) c[x] += y;
}
int query(int x){
	int ret = 0;
	for(; x; x -= lowbit(x)) ret += c[x];
	return ret;
}

int main(){
	n = read();
	rep(i, 1, n) b[i] = a[i] = read();
	sort(b + 1, b + n + 1);
	m = unique(b + 1, b + n + 1) - (b + 1);
	rep(i, 1, n) a[i] = lower_bound(b + 1, b + m + 1, a[i]) - b;
	LL ans = 0;
	rep(i, 1, n){
		ans += 1ll * (i - 1 - query(a[i]));
		modify(a[i], 1);
	}
	printf("%lld\n", ans);
	return 0;
}
