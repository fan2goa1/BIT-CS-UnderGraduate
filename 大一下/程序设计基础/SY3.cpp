#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

int pd(int n){
	for(int i = 2; i * i <= n; i ++) if(n % i == 0) return 0;
	return 1;
}

int main(){
	int n = read();
	REP(i, 2, n){
		int x = i, y = n - i;
		if(pd(x) && pd(y)){printf("%d=%d+%d\n", n, x, y); break;}
	}
	return 0;
}