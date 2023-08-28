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

vector <int> vec[1015];
queue <int> q;
priority_queue <int, vector<int>, greater<int>> pq;
bool vis[1015];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	int n = read();
	int u = read(), v;
	while(!(u == -1)){
		v = read();
		vec[u].push_back(v);
		vec[v].push_back(u);
		u = read();
	}
	while(1){
		bool flag = 0;
		rep(i, 0, n - 1){
			if(!vis[i]){
				vis[i] = 1;
				q.push(i);
				flag = 1;
				printf("%d", i);
				break;
			}
		}
		if(!flag) break;
		while(!q.empty()){
			int u = q.front(); q.pop();
			for(int i = 0; i < vec[u].size(); i ++){
				int v = vec[u][i];
				if(vis[v]) continue;
				vis[v] = 1; pq.push(v);
			}
			while(!pq.empty()){
				int now = pq.top(); pq.pop();
				q.push(now);
				printf("-%d", now);
			}
		}
		puts("");
	}
	return 0;
}
