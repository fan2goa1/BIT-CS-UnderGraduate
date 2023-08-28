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

const int MAXN = 1e4 + 15;

struct Edge{int to, nxt;}g[MAXN << 1];
int head[MAXN], cnt = 0, n, f[MAXN][2];
bool vis[MAXN];

inline void add(int u, int v){g[++ cnt] = (Edge){v, head[u]}; head[u] = cnt;}
inline void add_edge(int u, int v){add(u, v); add(v, u);}

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void treedp(int u, int fafa){
	if(vis[u]) return ;
	vis[u] = 1;
	bool flag = 0;
	repG(i, u){
		int v = g[i].to; if(v == fafa) continue;
		flag = 1;
		treedp(v, u);
		f[u][0] += f[v][1];
		f[u][1] += min(f[v][0], f[v][1]);
	}
	f[u][1] ++;
	if(!flag) f[u][0] = 0, f[u][1] = 1;
	return ;
}

int main(){
	while(~scanf("%d", &n)){
		cnt = 0; clr(head, 0); clr(vis, 0); clr(f, 0);
		int rt = 0;
		rep(i, 1, n){
			int u, d;
			scanf("%d:(%d)", &u, &d);
			if(i == 1) rt = u;
			rep(j, 1, d){
				int v; scanf("%d", &v);
				add_edge(u, v);
			}
		}
		if(n == 1){puts("1"); continue;}
		treedp(rt, -1);
		printf("%d\n", min(f[rt][0], f[rt][1]));
	}
	return 0;
}
