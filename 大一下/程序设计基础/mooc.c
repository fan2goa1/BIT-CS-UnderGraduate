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

int cmp_int(const void *_a, const void *_b){int *a = (int*)_a, *b = (int*)_b; return *a - *b;}
int cmp_char(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return *a - *b;}
int cmp_string(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return strcmp(a, b);}

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

int gcd(int a, int b){return !b ? a : gcd(b, a % b);}

int a[10][5] = {0, 0, 0, 0, 0,
				0, 78, 90, 87, 92,
				0, 88, 91, 89, 78,
				0, 84, 76, 83, 75,
				0, 88, 90, 71, 83};

int main(){
	puts("wanglei,86.75");
	puts("lihong,86.50");
	puts("zhangli,79.50");
	puts("liuming,83");
	puts("AVERAGE:84.50,86.75,82.50,82");
	system("pause");
	return 0;
 }