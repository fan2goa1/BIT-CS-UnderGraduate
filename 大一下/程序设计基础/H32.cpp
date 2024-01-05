#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

typedef long long LL;
typedef double DB;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int a[1015];

int cmp(const void *_a, const void *_b){
	int *a = (int *)_a, *b = (int *)_b;
	return *a - *b;
}

int main(){
	int n, m; scanf("%d%d", &n, &m);
	rep(i, n) a[i] = read();
	qsort(a + 1, n, sizeof(a[0]), cmp);
	int s = m, cnt = 0, j = 1;
	while(a[j] < m) j ++;
	for(; j <= n; j ++){
		if(s > a[j]) continue;
		cnt ++; s += 2;
	}
	int lst = n - cnt;
	printf("%d\n", m + cnt * 2 + lst);
 	return 0;
}
