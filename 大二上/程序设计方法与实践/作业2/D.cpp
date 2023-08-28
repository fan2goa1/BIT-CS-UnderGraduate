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

const int MAXN = 2e5 + 15;

char s[MAXN], t[MAXN];

int ans[MAXN], nxt[MAXN][35], lst[35], f[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	gets(s + 1);
	gets(t + 1);
	int n = strlen(s + 1), m = strlen(t + 1);
	if(!m){puts("0"); return 0;}
	clr(lst, 0);
	rep_(i, n, 0){
		int tmp = s[i] - 'a';
		rep(j, 0, 25) nxt[i][j] = lst[j];
		lst[tmp] = i;
	}
	rep(i, 1, m) t[i + m] = t[i], ans[i] = n + 1;
	rep(i, 1, m){
		int now = 0, cc = 0, gg = 0;
		rep(j, i, i + m - 1){
			int tmp = t[j] - 'a';
			if(!nxt[now][tmp]){gg = 1; break;}
			f[++ cc] = nxt[now][tmp];
			now = f[cc];
		}
		if(gg) continue;
		bool flag = 0;
		rep(j, 1, m){
			if(f[j] > ans[j]) break;
			if(f[j] < ans[j] && f[j] != 0){flag = 1; break;}
		}
		rep(j, 1, m) if(f[j] < 1 || f[j] > n){flag = 0; break;}
		if(flag) rep(j, 1, m) ans[j] = f[j];
	}
	rep(i, 1, m) printf("%d%c", ans[i], i == m ? '\n' : ' ');
	return 0;
}
