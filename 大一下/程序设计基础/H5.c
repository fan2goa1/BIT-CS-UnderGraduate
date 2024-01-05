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

int cmp_int(const void *_a, const void *_b){int *a = (int*)_a, *b = (int*)_b; return *a - *b;}
int cmp_char(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return *a - *b;}
int cmp_string(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return strcmp(a, b);}

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

double fabs(double x){return x > 0 ? x : -x;}

int main(){
	int k = read(), a[10], b[10]; char ch1[10], ch2[10];
	scanf("%s%s", ch1 + 1, ch2 + 1);
	rep(i, 5) a[i] = ch1[i] - '0', b[i] = ch2[i] - '0';
	int sum1 = k + a[2] + a[4] + b[1] + b[3] + b[5];
	int sum2 = a[1] + a[3] + a[5] + b[2] + b[4];
	int sum = (sum1 * 3 + sum2 - 1) % 10;
	int ans = 9 - sum;
	printf("%d\n", ans);
    system("pause");
    return 0;
}