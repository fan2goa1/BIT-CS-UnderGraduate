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

const int MAXN = 1e5 + 15;

int sta[MAXN], tot = 0, id[MAXN], l[MAXN], r[MAXN], n, a[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read();
	while(n){
		rep(i, 1, n){a[i] = read(); l[i] = r[i] = i;}
		tot = 0;
		rep(i, 1, n){
			while(sta[tot] > a[i]){
				r[id[tot]] = max(1, i - 1);
				tot --;
			}
			sta[++ tot] = a[i];
			id[tot] = i;
		}
		while(tot){
			r[id[tot]] = n;
			tot --;
		}
		rep_(i, n, 1){
			while(sta[tot] > a[i]){
				l[id[tot]] = min(i + 1, n);
				tot --;
			}
			sta[++ tot] = a[i];
			id[tot] = i;
		}
		while(tot){
			l[id[tot]] = 1;
			tot --;
		}
		LL ans = 0;
		rep(i, 1, n){
			LL tmp = 1ll * (r[i] - l[i] + 1) * a[i];
			ans = max(ans, tmp);
		}
		printf("%lld\n", ans);
		n = read();
	}
	return 0;
}
