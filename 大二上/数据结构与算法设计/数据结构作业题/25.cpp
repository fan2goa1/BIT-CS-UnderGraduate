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

const int MAXN = 1e5 + 15;

map <char, int> mp;
map <int, char> mp2;
struct Edge{int to, nxt;}g[MAXN << 1];
int head[MAXN], cnt = 0, tot = 0, n = -1;
bool vis[MAXN];
void add(int u, int v){g[++ cnt] = (Edge){v, head[u]}; head[u] = cnt;}
void add_edge(int u, int v){add(u, v); add(v, u);}
queue <int> q;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	char ch;
	scanf("%c", &ch);
	while(1){
		char non = getchar();
		if(ch == '*') break;
		mp[ch] = ++ n;
		mp2[n] = ch;
		scanf("%c", &ch);
	}
	int u, v;
	while(1){
		u = read(), v = read();
		if(u == -1 && v == -1) break;
		add_edge(u, v);
	}
	puts("the ALGraph is");
	rep(i, 0, n){
		printf("%c", mp2[i]);
		for(int j = head[i]; j; j = g[j].nxt) printf(" %d", g[j].to);
		puts("");
	}
	printf("the Breadth-First-Seacrh list:");
	bool flag = 0;
	while(1){
		rep(t, 0, n){ flag = 0;
			if(!vis[t]){
				vis[t] = 1; q.push(t);
				flag = 1;
				break;
			}
		}
		if(!flag) break;
		while(!q.empty()){
			int u = q.front(); q.pop();
			printf("%c", mp2[u]);
			repG(i, u){
				int v = g[i].to;
				if(vis[v]) continue;
				vis[v] = 1;
				q.push(v);
			}
		}
	}puts("");
	return 0;
}
