#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
double fabs(double x){return x > 0 ? x : -x;}

int f[115][115];

void plus(int k){
	rep(i, 51){
		int sum = f[k - 1][i] + f[k - 2][i];
		f[k][i] += sum;
		f[k][i + 1] += f[k][i] / 10;
		f[k][i] %= 10;
	}
}

int main(){
	int a = read(), b = read();
	clr(f, 0);
	f[a][1] = f[a + 1][1] = 1;
	REP(i, a + 2, b) plus(i);
	int flag = 0;
	REP_(i, 51, 1){
		if(flag || f[b][i]) printf("%d", f[b][i]);
		if(f[b][i]) flag = 1;
	} puts("");
    system("pause");
    return 0;
}