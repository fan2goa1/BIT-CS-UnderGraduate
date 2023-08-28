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

struct Edge{int to, nxt, dis;}g[MAXN << 1], e[MAXN << 1];
int head[MAXN], cnt = 0, head1[MAXN], cnt1 = 0, n, m, tot = -1, du[MAXN], du1[MAXN], topo[MAXN], vl[MAXN], ve[MAXN];
int ans[MAXN], num = 0, dist = 0;
map <string, int> mp1;
map <int, string> mp2;
char ch[MAXN * 10];
bool key[MAXN];
queue <int> q;
priority_queue <int, vector<int>, greater<int>> pq;

inline void add(int u, int v, int dis){g[++ cnt] = (Edge){v, head[u], dis}; head[u] = cnt;}
inline void add1(int u, int v, int dis){e[++ cnt1] = (Edge){v, head1[u], dis}; head1[u] = cnt1;}

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void dfs(int u){
	if(u == n - 1){
		cout << mp2[ans[1]];
		rep(i, 2, num){
			cout << "-" << mp2[ans[i]];
		}puts("");
		return ;
	}
	repG(i, u){
		int v = g[i].to;
		if(!key[v] || ve[u] + g[i].dis != ve[v]) continue;
		pq.push(v);
	}
	vector <int> vec;
	while(!pq.empty()){
		int now = pq.top(); pq.pop();
		vec.push_back(now);
	}
	for(int i = 0; i < vec.size(); i ++){
		ans[++ num] = vec[i];
		dfs(vec[i]);
		num --;
	}
}

int main(){
	scanf("%d,%d", &n, &m);
	scanf("%s", ch + 1);
	string str = "";
	rep(i, 1, strlen(ch + 1)){
		if(ch[i] == ','){
			mp1[str] = ++ tot;
			mp2[tot] = str;
			str = "";
			continue;
		}
		else str += ch[i];
	}
	mp1[str] = ++ tot; mp2[tot] = str;
	scanf("%*c");
	char c = getchar(); int eg[5], now = 0;
	clr(eg, 0);
	while(1){
		if(isdigit(c)) eg[now] = eg[now] * 10 + c - '0';
		else if(c == ',') now ++;
		else if(c == '>'){
			add(eg[0], eg[1], eg[2]);
			add1(eg[1], eg[0], eg[2]);
			du[eg[1]] ++; du1[eg[0]] ++;
			now = 0;
			eg[0] = eg[1] = eg[2] = 0;
			c = getchar();
			if(!isdigit(c) && c != ',' && c != '<' && c != '>') break;
		}
		else if(c == '<');
		else break;
		c = getchar();
	}
	clr(vl, 0); clr(ve, 0x3f);
	rep(i, 0, n - 1) if(!du[i]) pq.push(i);
	int tt = 0;
	while(!pq.empty()){
		int u = pq.top(); pq.pop();
		topo[++ tt] = u;
		repG(i, u){
			int v = g[i].to;
			du[v] --;
			if(!du[v]) pq.push(v);
			vl[v] = max(vl[v], vl[u] + g[i].dis);
		}
	}
	ve[n - 1] = vl[n - 1];
	rep(i, 0, n - 1) if(!du1[i]) q.push(i);
	while(!q.empty()){
		int u = q.front(); q.pop();
		for(int i = head1[u]; i; i = e[i].nxt){
			int v = e[i].to;
			du1[v] --;
			if(!du1[v]) q.push(v);
			ve[v] = min(ve[v], ve[u] - e[i].dis);
		}
	}
	if(tt != n){puts("NO TOPOLOGICAL PATH"); return 0;}
	cout << mp2[topo[1]];
	rep(i, 2, n) cout << '-' << mp2[topo[i]]; puts("");
	rep(i, 0, n - 1) if(vl[i] == ve[i]) key[i] = 1;
	ans[++ num] = 0;
	dfs(0);
	return 0;
}
