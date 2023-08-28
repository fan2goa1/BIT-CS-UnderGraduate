#include <bits/stdc++.h>

#define REP(i, n) for(int i = 1; i <= n; i ++)
#define REPG(i, x) for(int i = head[x]; i; i = g[i].nxt)

#define mem(x, y) memset(x, y, sizeof(x));

using namespace std;

typedef long long LL;
typedef double DB;

LL Max(LL a, LL b){return a > b ? a : b;}
LL Min(LL a, LL b){return a < b ? a : b;}

const int MAXN = 2e3 + 15;

struct Edge{int from, to, dis;}g[MAXN * 6];
int cnt = 0, fa[MAXN], n, m;
void add(int u, int v, int dis){g[++ cnt] = (Edge){u, v, dis};}

inline int read(){
	int r = 0, z = 1;
	char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

bool cmp(Edge x, Edge y){return x.dis < y.dis;}

int get(int x){return x == fa[x] ? x : fa[x] = get(fa[x]);}

void fre(){
	freopen(".in", "r", stdin);
	freopen(".out", "w", stdout);
}

void kruskal(){
	sort(g + 1, g + m + 1, cmp);
	int cnt = 0, ans = 0;
	for(int i = 1; i <= m; i ++){
		int u = g[i].from, v = g[i].to, dis = g[i].dis;
		int f1 = get(u), f2 = get(v);
		if(f1 != f2){
			fa[f2] = f1; ans += dis; cnt ++;
			if(cnt == n - 1) break;
		}
	}
	if(cnt < n - 1) puts("-1");
	else printf("%d\n", ans);
}

void init(){
	n = read(), m = read();
	for(int i = 1; i <= m; i ++){
		int u = read(), v = read(), dis = read();
		add(u, v, dis);
	}
	for(int i = 1; i <= n; i ++) fa[i] = i;
	kruskal();
}

int main(){
	//fre();
	init();
	return 0;
}