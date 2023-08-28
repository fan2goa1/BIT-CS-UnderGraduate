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

struct Edge{
	int to, nxt;
	Edge(){}
	Edge(int to, int nxt):to(to), nxt(nxt){}
}g[MAXN << 1];
int head[MAXN], cnt = 0, n, sz[MAXN], dep[MAXN];
LL ans = 0;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

inline void add(int u, int v){g[++ cnt] = Edge(v, head[u]); head[u] = cnt;}
inline void add_edge(int u, int v){add(u, v); add(v, u);}

void dfs1(int u, int fafa){
	sz[u] = 1;
	repG(i, u){
		int v = g[i].to; if(v == fafa) continue;
		dep[v] = dep[u] + 1;
		dfs1(v, u);
		sz[u] += sz[v];
	}
	repG(i, u){
		int v = g[i].to; if(v == fafa) continue;
		ans += 1ll * (n - sz[v]) * (sz[v]);
	}
	return ;
}

int main(){
	n = read();
	rep(i, 1, n - 1){
		int u = read(), v = read();
		add_edge(u, v);
	}
	dep[1] = 0;
	dfs1(1, 0);
	int cnte = 0, cnto = 0;
	rep(i, 1, n){
		if(dep[i] % 2) cnto ++;
		else cnte ++;
	}
	LL tmp = 1ll * cnte * cnto;
	ans += tmp;
	ans /= 2ll;
	printf("%lld\n", ans);
	return 0;
}
