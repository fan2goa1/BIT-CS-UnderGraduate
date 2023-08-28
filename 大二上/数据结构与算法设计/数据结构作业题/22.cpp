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

const int MAXN = 115;

int a[MAXN], c, n, b[MAXN], g[MAXN], cnt;
LL s[MAXN], ans = 0;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void pd(int k, LL m){
	if(m > ans){
		rep(i, 1, k) g[i] = b[i];
		ans = m; cnt = k;
	}
	return ;
}

void ff(int j, int k, LL m){
	if(j > n){pd(k, m); return ;}
	if(s[n] - s[j] + m <= ans) return ;
	if(m + 1ll * a[j] <= 1ll * c){
		b[k + 1] = j;
		ff(j + 1, k + 1, m + 1ll * a[j]);
	}
	ff(j + 1, k, m);
	return ;
}

int main(){
	c = read(), n = read();
	rep(i, 1, n){a[i] = read(); s[i] = s[i - 1] + 1ll * a[i];}
	ff(1, 0, 0);
	printf("%lld\n", ans);
	rep(i, 1, cnt) printf("%d ", g[i]); puts("");
	return 0;
}
