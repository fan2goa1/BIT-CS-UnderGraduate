#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
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
int cmp_LL(const void *_a, const void *_b){LL *a = (LL*)_a, *b = (LL*)_b; return *a - *b;}

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

double fabs(double x){return x > 0 ? x : -x;}

void swap1(LL *x, LL *y){
	LL t;
	t = *x;
	*x = *y;
	*y = t;
}

LL a[10015];

int main(){
	int n = read();
	LL ans = 0;
	rep(i, n) scanf("%lld", &a[i]);
	qsort(a + 1, n, sizeof(a[0]), cmp_LL);
	REP(i, 2, n){
		a[i] += a[i - 1];
		ans += a[i];
		REP(j, i + 1, n){
			if(a[j - 1] > a[j]) swap1(a + (j - 1), a + j);
			else break;
		}
	}
	printf("%lld\n", ans);
    return 0;
}