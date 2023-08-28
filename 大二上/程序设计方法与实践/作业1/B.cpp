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

int n, m, a[MAXN][MAXN], b[MAXN][MAXN], op[MAXN], ans;
int dx[5] = {0, 1, -1, 0, 0};
int dy[5] = {0, 0, 0, 1, -1};
char ch[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void pd(){
	int ret = 0;
	rep(i, 1, n) rep(j, 1, m) b[i][j] = a[i][j];
	rep(i, 1, m){
		if(op[i] == 1){ b[1][i] ^= 1; ret ++;
			rep(k, 1, 4){
				int x = 1 + dx[k], y = i + dy[k];
				if(x < 1 || x > n || y < 1 || y > m) continue;
				b[x][y] ^= 1;
			}
		}
	}
	rep(i, 2, n)
		rep(j, 1, m){
			if(!b[i - 1][j]) continue;
			ret ++;
			b[i][j] ^= 1;
			rep(k, 1, 4){
				int x = i + dx[k], y = j + dy[k];
				if(x < 1 || x > n || y < 1 || y > m) continue;
				b[x][y] ^= 1;
			}
		}
	bool flag = 1;
	rep(i, 1, m) if(b[n][i]){flag = 0; break;}
	if(flag) ans = min(ans, ret);
	return ;
}

void find(int j){
	if(j == m){pd(); return ;}
	op[j + 1] = 0; find(j + 1);
	op[j + 1] = 1; find(j + 1);
}

int main(){
	n = read(), m = read(); ans = inf;
	rep(i, 1, n){
		scanf("%s", ch + 1);
		rep(j, 1, m) a[i][j] = ch[j] - '0';
	}
	find(0);
	printf("%d\n", ans);
	return 0;
}