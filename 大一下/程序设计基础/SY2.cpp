#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define mp(a, b) make_pair(a, b)
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

int main(){
	int non; double n; scanf("%lf%d", &n, &non);
	double p = sqrt(n);
	printf("%.8lf\n", p);
	return 0;
}
