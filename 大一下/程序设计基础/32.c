#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
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

typedef struct{
	int a[5], b;
}CJ; CJ p[5];

int cmp_int(const void *_a, const void *_b){int *a = (int*)_a, *b = (int*)_b; return *a - *b;}
int cmp_char(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return *a - *b;}
int cmp_string(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return strcmp(a, b);}
int cmp_CJ(const void *_a, const void *_c){
	CJ *a = (CJ*)_a; CJ *c = (CJ*)_c;
	return (*c).b - (*a).b;
}

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

double fabs(double x){return x > 0 ? x : -x;}

int main(){
	rep(i, 3) rep(j, 4){p[i].a[j] = read(); p[i].b += 1.0 * p[i].a[j];}
	rep(i, 3) p[i].b /= 4.0;
	qsort(p + 1, 3, sizeof(p[0]), cmp_CJ);
	rep(i, 3){
		rep(j, 4) printf("%d%c", p[i].a[j], j != 4 ? ',' : '\n');
	}
    system("pause");
    return 0;
}