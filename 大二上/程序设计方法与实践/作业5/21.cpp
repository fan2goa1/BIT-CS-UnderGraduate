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

const int MAXN = 1e6 + 15;

struct cy{int a, b, c, d;}t[MAXN], st, ed;
struct Edge{
	int to, nxt, dis;
	Edge(){}
	Edge(int to, int nxt, int dis):to(to), nxt(nxt), dis(dis){}
}g[MAXN];
queue <int> q;
int n, head[MAXN], cnt = 0, dist[MAXN];
bool vis[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

inline void add(int u, int v, int dis){g[++ cnt] = Edge(v, head[u], dis); head[u] = cnt;}

void spfa(){
	clr(dist, 0x3f3f3f3f);
	q.push(st.d); vis[st.d] = 1; dist[st.d] = 0;
	while(!q.empty()){
		int u = q.front(); q.pop(); vis[u] = 0;
		repG(i, u){
			int v = g[i].to;
			if(dist[v] > dist[u] + 1){
				dist[v] = dist[u] + 1;
				if(!vis[v]){
					vis[v] = 1;
					q.push(v);
				}
			}
		}
	}
}

int main(){
	n = read();
	rep(i, 1, n){
		t[i].a = read(), t[i].b = read();
		t[i].c = read(), t[i].d = read();
		add(t[i].a, t[i].d, 1);
	}
	st.a = read(), st.b = read(), st.c = read(), st.d = read();
	ed.a = read(), ed.b = read(), ed.c = read(), ed.d = read();
	if(st.a == ed.a && st.b == ed.b && st.c == ed.c && st.d == ed.d){puts("1"); return 0;}
	bool flag1 = 0, flag2 = 0;
	rep(i, 1, n){
		if(t[i].a == st.a && t[i].b == st.b && t[i].c == st.c && t[i].d == st.d) flag1 = 1;
		if(t[i].a == ed.a && t[i].b == ed.b && t[i].c == ed.c && t[i].d == ed.d) flag2 = 1;		
	}
	if(!flag1 || !flag2){puts("-1"); return 0;}
	spfa();
	if(dist[ed.a] > n) puts("-1");
	else printf("%d\n", dist[ed.a] + 2);
	return 0;
}
