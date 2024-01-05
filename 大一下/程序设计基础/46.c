#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

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

int cmp_int(const void *_a, const void *_b){int *a = (int*)_a, *b = (int*)_b; return *a - *b;}
int cmp_char(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return *a - *b;}
int cmp_string(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return strcmp(a, b);}

double dmax(double a, double b){return a > b ? a : b;}
int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

int gcd(int a, int b){return !b ? a : gcd(b, a % b);}

struct Node{int x, y;}d[115];

double cal(int i, int j){return sqrt((d[i].x - d[j].x) * (d[i].x - d[j].x) + (d[i].y - d[j].y) * (d[i].y - d[j].y));}

int main(){
	int T = read();
	while(T --){
		int n = read(); double ans = 0.0;
		rep(i, n){d[i].x = read(), d[i].y = read();}
		rep(i, n)
			REP(j, i + 1, n)
				REP(k, j + 1, n){
					double a = cal(i, j), b = cal(j, k), c = cal(i, k);
					double p = (a + b + c) / 2.0;
					double s = sqrt(p * (p - a) * (p - b) * (p - c));
					ans = dmax(ans, s);
				}
		printf("%.1lf\n", ans);
	}
	system("pause");
	return 0;
 }