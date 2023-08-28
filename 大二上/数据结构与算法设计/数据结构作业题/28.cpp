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
typedef double DB;

LL Max(LL a, LL b){return a > b ? a : b;}
LL Min(LL a, LL b){return a < b ? a : b;}

const int MAXN = 2e5 + 15;

struct Edge{int to, nxt, dis;}g[MAXN << 1];
int head[MAXN], cnt = 0, tot = 0;
int dist[MAXN];
bool vis[MAXN];
void add(int u, int v, int dis){g[++ cnt] = (Edge){v, head[u], dis}; head[u] = cnt;}

queue <int> q;
map <char, int> mp;

inline int read(){
	int r = 0, z = 1;
	char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void SPFA(int s){
	q.push(s); dist[s] = 0; vis[s] = 1;
	while(!q.empty()){
		int u = q.front(); q.pop(); vis[u] = 0;
		for(int i = head[u]; i; i = g[i].nxt){
			int v = g[i].to, d = g[i].dis;
			if(dist[u] + d < dist[v]){
				dist[v] = dist[u] + d;
				if(!vis[v]){vis[v] = 1; q.push(v);}
			}
		}
	}
}

void init(){
	int n, m; char ch;
	scanf("%d,%d,%c", &n, &m, &ch);
	//printf("%d %d %c\n", n, m, ch);
	mp[ch] = ++ tot; 
	for(int i = 1; i <= m; i ++){
		int d; char u, v, non1, non2, dot1, dot2;
		char gg = getchar();
		scanf("%c%c%c%c%c%d%c", &non1, &u, &dot1, &v, &dot2, &d, &non2);
	//	printf("%c %c %d\n", u, v, d) ;
		if(!mp[u]) mp[u] = ++ tot;
		if(!mp[v]) mp[v] = ++ tot;
		add(mp[u], mp[v], d);
	}
	for(int i = 1; i <= n; i ++) dist[i] = 2147483647;
	SPFA(1);
	for(int i = 0; i < n; i ++){
		char ch = 'a' + i;
		printf("%c:%d\n", ch, dist[mp[ch]]);
	}
}

int main(){
	init();
	return 0;
}