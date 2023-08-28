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

const LL MAXN = 2e5 + 15;

struct node{
	LL x, y, dis;
	node(){}
	node(LL x, LL y, LL dis):x(x), y(y), dis(dis){}
};

bool operator < (node a, node b){return a.dis > b.dis;}

LL a[MAXN], l[MAXN], r[MAXN], n, m, b[MAXN], cnt = 0;
priority_queue <node> q;
bool flag[MAXN];

inline LL read(){
	LL r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read(), m = read();
	rep(i, 1, n) a[i] = read(), l[i] = i - 1, r[i] = i + 1;
	l[1] = 1, r[n] = n;
	rep(i, 1, n - 1){
		q.push(node(i, i + 1, a[i + 1] - a[i]));
	}
	while(!q.empty() && cnt < m * 2){
		node u = q.top(); q.pop();
	//	prLLf("%d %d %d\n", u.x, u.y, u.dis);
		if(flag[u.x] || flag[u.y]) continue;
		flag[u.x] = flag[u.y] = 1;
		b[++ cnt] = u.x;
		b[++ cnt] = u.y;
		if(u.x == 1 || u.y == n) continue;
		q.push(node(l[u.x], r[u.y], a[r[u.y]] - a[l[u.x]]));
		r[l[u.x]] = r[u.y];
		l[r[u.y]] = l[u.x];
	}
	sort(b + 1, b + cnt + 1);
	LL ans = 0;
	for(LL i = 1; i <= cnt; i += 2){
		ans += a[b[i + 1]] - a[b[i]];
	}
	printf("%lld\n", ans);
	return 0;
}
