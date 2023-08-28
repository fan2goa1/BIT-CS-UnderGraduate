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

const int MAXN = 1e3 + 15;

struct Pos{int x, y, dir, num;};
int n, m, sx, sy, tx, ty, a[MAXN][MAXN], nowt[MAXN][MAXN];
int dx[6] = {0, 0, 0, 1, -1};
int dy[6] = {0, 1, -1, 0, 0};
queue <Pos> q;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read(), m = read();
	rep(i, 1, n)
		rep(j, 1, m) a[i][j] = read();
	sx = read() + 1, sy = read() + 1;
	tx = read() + 1, ty = read() + 1;
	rep(i, 1, 4){
		int x = sx + dx[i];
		int y = sy + dy[i];
		q.push((Pos){x, y, i, 1});
		nowt[x][y] = 1;
	}
	while(!q.empty()){
		Pos u = q.front(); q.pop();
	//	printf("%d %d %d %d\n", u.x, u.y, u.dir, u.num);
		if(u.x == tx && u.y == ty){
			puts("TRUE");
			return 0;
		}
		rep(i, 1, 4){
			int x = u.x + dx[i];
			int y = u.y + dy[i];
			int dir = i; int num = u.dir == i ? u.num : u.num + 1;
			if(x < 1 || x > n || y < 1 || y > m || (x == sx && y == sy) || (a[x][y] && a[x][y] != a[sx][sy]) || (nowt[x][y] && num > nowt[x][y]) || num > 3) continue;
			nowt[x][y] = num;
			q.push((Pos){x, y, dir, num});
		}
	}
	puts("FALSE");
	return 0;
}