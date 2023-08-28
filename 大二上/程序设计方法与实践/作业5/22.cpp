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

const int MAXN = 115;

struct castle{
	int x, y, z, t;
	castle(){}
	castle(int x, int y, int z, int t):x(x), y(y), z(z), t(t){}
};
char mp[MAXN][MAXN];
int n, m, k, T, sx, sy;
bool vis[MAXN][MAXN][55];
queue <castle> q;
int dx[10] = {0, 1, -1, 0, 0};
int dy[10] = {0, 0, 0, 1, -1};

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	T = read();
	while(T --){ clr(vis, 0);
		n = read(); m = read(), k = read();
		rep(i, 1, n){
			scanf("%s", mp[i] + 1);
			rep(j, 1, m){
				if(mp[i][j] == 'S') sx = i, sy = j;
			}
		}
//		printf("%d %d\n", sx, sy);
		while(!q.empty()) q.pop();
		q.push(castle(sx, sy, 0, 0)); vis[sx][sy][0] = 1;
		int ans = 2e9 + 7; bool flag = 0;
		while(!q.empty()){
			castle u = q.front(); q.pop();
		//	printf("%d %d %d\n", u.x, u.y, u.z);
			if(mp[u.x][u.y] == 'E'){flag = 1; ans = u.t; break;}
			rep(i, 1, 4){
				int x1 = u.x + dx[i], y1 = u.y + dy[i];
				if(x1 < 1 || x1 > n || y1 < 1 || y1 > m || mp[x1][y1] == '#' || vis[x1][y1][(u.z + 1) % k] == 1) continue;
				if(mp[x1][y1] == '*' && (u.z + 1) % k != 0) continue;
				vis[x1][y1][(u.z + 1) % k] = 1;
				q.push(castle(x1, y1, u.z + 1, u.t + 1));
			}
		}
		if(!flag) puts("-1");
		else printf("%d\n", ans);
	}
	return 0;
}
