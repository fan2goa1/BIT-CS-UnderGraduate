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

const int MAXN = 5e3 + 15;

int a[MAXN], n, k, m, ans[MAXN], cc = 0;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	scanf("%d,%d,%d", &n, &k, &m);
	if(n < 1 || k < 1 || m < 1){puts("n,m,k must bigger than 0.");return 0;}
	if(k > n){puts("k should not bigger than n."); return 0;}
	int pos = k, cnt = 0, i = 1;
	while(cnt < n){
		pos ++; if(pos > n) pos = 1;
		while(a[pos]){
			pos ++;
			if(pos > n) pos = 1;
		}
		i ++;
		if(i == m){
			i = 0;
			a[pos] = 1;
			cnt ++;
			ans[++ cc] = pos;
		}
	}
	rep(i, 1, cc){
		printf("%d%c", ans[i], (i % 10 == 0 || i == n) ? '\n' : ' ');
	}
	return 0;
}
