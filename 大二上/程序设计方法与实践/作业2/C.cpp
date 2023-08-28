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

const int MAXN = 1e3 + 15;

int f[MAXN][MAXN], x;
char ch[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	x = read(); scanf("%s", ch + 1);
	if(!x){puts("0"); return 0;}
	else if(x == 1){puts("1"); return 0;}
	int n = strlen(ch + 1);
	rep(i, 1, 1000){
		f[i][0] = i; f[i][1] = 1;
		rep(j, 1, 10) f[i][1] = f[i][1] * i % 1000;
	}
	rep(i, 1, 1000){
		rep(j, 2, 1000){
			f[i][j] = f[f[i][j - 1]][1];
		}
	}
	if(n <= 1){
		int m = 0;
		rep(i, 1, n) m = m * 10 + ch[i] - '0';
		bool flag = 0; int ans = 1;
		rep(i, 1, m){
			ans *= x;
			if(ans >= 1000){flag = 1; break;}
		}
		if(!flag){printf("%d\n", ans); return 0;}
	}
	int ans = 1;
	rep(i, 1, n){
		rep(j, 1, ch[i] - '0'){
			ans = ans * f[x][n - i] % 1000;
		}
	}
	printf("%03d\n", ans);
	return 0;
}
