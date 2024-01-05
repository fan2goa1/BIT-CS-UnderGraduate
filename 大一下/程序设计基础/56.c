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

int min(int a, int b){return a < b ? a : b;}

int count(int m, int n, int cnt){
	if(!m){
	//	rep(i, cnt) printf("%d ", a[i]); puts("");
		return 1;
	}
	int ret = 0;
	REP_(i, n, 1){
		ret += count(m - i, min(i, m - i), cnt + 1);
	}
	return ret;
}

int main(){
	int m = read(), n = read();
	printf("%d\n", count(m, n, 0));
	system("pause");
	return 0;
 }