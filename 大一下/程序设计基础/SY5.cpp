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

double fabs(double x){return x > 0 ? x : -x;}

int main(){
	int x1, y1, x2, y2;
	scanf("%d,%d", &x1, &y1);
	scanf("%d,%d", &x2, &y2);
	if(x1 != x2){
		double k = (y2 - y1) * 1.0 / ((x2 - x1) * 1.0);
		double b = y1 * 1.0 - k * x1 * 1.0;
		int n = read(), fg = 0;
		while(n --){
			int x, y; scanf("%d,%d", &x, &y);
			double tmp = k * x * 1.0 + b;
		//	printf("%.5lf %.5lf\n", y * 1.0, tmp);
			if(fabs(y * 1.0 - tmp) < 1e-6){
				printf("%d,%d\n", x, y);
				fg = 1;
			}
		}
		if(!fg){puts("NoOut.");}
	}
	else {
		int n = read(), fg = 0;
		while(n --){
			int x, y; scanf("%d,%d", &x, &y);
			if(x == x1){printf("%d,%d\n", x, y); fg = 1;}
		}
		if(!fg){puts("NoOut.");}
	}
	return 0;
}
