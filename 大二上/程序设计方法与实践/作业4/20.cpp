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
const int MAXM = 1e6 + 15;

struct Edge{
	int to, nxt;
	Edge(){}
	Edge(int to, int nxt):to(to), nxt(nxt){}
}g[MAXM << 1];
int head[MAXN], cnt = 0;
int st[MAXN], ed[MAXN], n, m, ans[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

inline void add(int u, int v){g[++ cnt] = Edge(v, head[u]); head[u] = cnt;}
inline void add_edge(int u, int v){add(u, v); add(v, u);}

void dfs(int u, int fafa){
	printf(" %d", u);
	for(int i = head[u]; i; i = g[i].nxt){
		int v = g[i].to; if(v == fafa) continue;
		dfs(v, u);
	}
}

int main(){
	n = read(), m = read();
	rep(i, 1, n) st[i] = ed[i] = i, ans[i] = 1;
	rep(i, 1, m){
		int x = read(), y = read();
		if(!st[x]) continue;
		if(!st[y]){
			st[y] = ed[x];
			ed[y] = st[x];
			ans[y] = ans[x];
			ans[x] = 0;
		}
		else {
		//	printf("1:%d %d\n", st[x], st[y]);
			add_edge(st[x], st[y]);
			st[y] = ed[x];
			ed[y] = ed[y];
			ans[y] += ans[x];
			ans[x] = 0;
		}
		st[x] = ed[x] = 0;
	}
	rep(i, 1, n){
		if(!ans[i]) puts("0");
		else {
			printf("%d", ans[i]);
			dfs(st[i], 0);
			puts("");
		}
	}
	return 0;
}
