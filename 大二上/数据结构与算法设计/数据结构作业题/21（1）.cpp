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

priority_queue <pii, vector<pii>, greater<pii> > q;
const int MAXN = 1e5 + 15;

struct Edge{int to, nxt;}g[MAXN << 1];
int head[MAXN], cnt = 0, tot = 0, a[MAXN], du[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

inline void add(int u, int v){g[++ cnt] = (Edge){v, head[u]}; head[u] = cnt;}
inline void add_edge(int u, int v){add(u, v); add(v, u);}

void dfs(int u, int fafa){
	repG(i, u){
		int v = g[i].to; if(v == fafa) continue;
		du[v] = du[u] + 1;
		dfs(v, u);
	}
	return ;
}

int main(){
	int n = read();
	rep(i, 1, n){
		int x = read();
		q.push(mp(x, i)); ++ tot; a[i] = x;
	}
	while(!q.empty()){
		pii x = q.top(); q.pop();
		if(q.empty()) break;
		pii y = q.top(); q.pop();
		a[++ tot] = x.first + y.first;
		add_edge(tot, x.second);
		add_edge(tot, y.second);
		q.push(mp(a[tot], tot));
	}
	du[tot] = 0;
	dfs(tot, 0);
	int ans = 0;
	rep(i, 1, n) ans += a[i] * du[i];
	printf("WPL=%d\n", ans);
	return 0;
}
