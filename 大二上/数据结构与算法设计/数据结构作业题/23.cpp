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

const int MAXN = 11;

int n, m, l[MAXN << 1], r[MAXN << 1], col[MAXN], row[MAXN], ans = 0;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void pd(){
	rep(i, 1, n)
		rep(j, 1, n){
			if(!row[i] && !col[j] && !l[i + j] && !r[i - j + n]) return ;
		}
	ans ++;
	return ;
}

void dfs(int j, int k){
	if(m - k > n - j + 1) return ;
	if(k == m || j > n){pd(); return ;}
	rep(i, 1, n){
		if(col[i] || row[j] || l[j + i] || r[j - i + n]) continue;
		row[j] = col[i] = l[j + i] = r[j - i + n] = 1;
		dfs(j + 1, k + 1);
		row[j] = col[i] = l[j + i] = r[j - i + n] = 0;
	}
	if(m - k < n - j + 1) dfs(j + 1, k);
}

int main(){
	n = read(), m = read();
	dfs(1, 0);
	printf("%d\n", ans);
	return 0;
}
