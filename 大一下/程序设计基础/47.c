#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

typedef double DB;
typedef long long LL;

int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int cmp(const void *_a, const void *_b){
	int *a = (int*)_a, *b = (int*)_b;
	return *a - *b;
}

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

int a[115][115];

int main(){
	int n = read(), m = read();
	rep(i, n)
		rep(j, m) a[i][j] = read();
	int flag = 0;
	rep(i, n)
		rep(j, m){
			int maxn = -32768, minn = 32768;
			rep(k, m) maxn = max(maxn, a[i][k]);
			rep(k, n) minn = min(minn, a[k][j]);
			if(a[i][j] == maxn && a[i][j] == minn){printf("Point:a[%d][%d]==%d\n", i - 1, j - 1, a[i][j]); flag = 1; break;}
		}
	if(!flag) puts("No Point");
	system("pause");
	return 0;
 }