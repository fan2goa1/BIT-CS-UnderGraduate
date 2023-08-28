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

const int MAXN = 17;
const int inf = 0x3f3f3f3f;

char mp[MAXN][MAXN];
int ans, T, a[MAXN][MAXN], tt[7][7], gg[MAXN][MAXN], opt[7][7], tot = 0;
int vis[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

bool chk(int x, int y){
	rep(i, x + 1, x + 4){
		tot ++;
		rep(j, 1, y + 4){
			if(vis[a[i][j]] == tot)return 0;
			vis[a[i][j]] = tot;
		}
	}
	rep(j, y + 1, y + 4){
		tot ++;
		rep(i, 1, x + 4){
			if(vis[a[i][j]] == tot) return 0;
			vis[a[i][j]] = tot;
		}
	}
	return 1;
}

void rot(int x, int y){
	rep(i, x + 1, x + 4)
		rep(j, y + 1, y + 4)
			gg[4 - (j-1)%4 + x][(i-1)%4+y + 1] = a[i][j];
			
	rep(i, x + 1, x + 4)
		rep(j, y + 1, y + 4) a[i][j] = gg[i][j];
}

void dfs(int x, int y, int now){
	if(now >= ans) return ;
	if(x == 4){
		if(ans > now){
			ans = now;
			rep(i, 1, 4)
				rep(j, 1, 4) tt[i][j] = opt[i][j];
		}
		return ;
	}
	if(y == 4){
		dfs(x + 1, 0, now);
		return ;
	}
	rep(i, 0, 3){
		if(chk(x * 4, y * 4)){
			opt[x + 1][y + 1] = i;
			dfs(x, y + 1, now + i);
		}
		rot(x * 4, y * 4);
	}
}

int main(){
	T = read();
	while(T --){ clr(vis, 0); clr(tt, 0); tot = 0;
		rep(i, 1, 16) scanf("%s", mp[i] + 1);
		rep(i, 1, 16)
			rep(j, 1, 16){
				if(isdigit(mp[i][j])) a[i][j] = mp[i][j] - '0';
				else a[i][j] = mp[i][j] - 'A' + 10;
			}
		ans = inf;
		dfs(0, 0, 0);
		printf("%d\n", ans);
		rep(i, 1, 4)
			rep(j, 1, 4){
				rep(k, 1, tt[i][j]) printf("%d %d\n", i, j);
			}
	}
	return 0;
}
