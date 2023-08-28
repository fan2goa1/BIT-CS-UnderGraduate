#include <iostream>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <map>
#include <queue>
#include <cstring>
#include <ctime>
#define mp(a, b) make_pair(a, b)
#define rep(i, x, y) for(LL i = x; i <= y; i ++)
#define rep_(i, x, y) for(LL i = x; i >= y; i --)
#define rep0(i,n) rep(i, 0, (n)-1)
#define repG(i, x) for(LL i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))
#define eps 0.0000000001

using namespace std;

typedef long long LL;
typedef double LF;
typedef pair<LL, LL> pii;

const LL MAXN = 3e5 + 15;

LL a[MAXN], b[MAXN], n;

inline LL read(){
	LL r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

LL chk(LL mid){
	LL lst = 0;
	rep(i, 1, n) b[i] = a[i];
	rep_(i, n, 1){
		b[i] += lst;
		lst = max(b[i] - mid, 0ll);
	}
	if(lst > 0) return 0;
	return 1;
}

int main(){
	n = read(); LL mm = 0;
	rep(i, 1, n){
		a[i] = read();
		mm = max(mm, a[i]);
	}
	LL l = 1, r = mm, ans = mm;
	while(l <= r){
		LL mid = (l + r) / 2ll;
		if(chk(mid)){r = mid - 1ll; ans = mid;}
		else l = mid + 1ll;
	}
	printf("%lld\n", ans);
	return 0;
}
