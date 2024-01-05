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

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

double fabs(double x){return x > 0 ? x : -x;}

int a[15], b[15], n, op, flag[15];

void pd(){
	int ans = 0;
	rep(i, n){ ans = 0;
		rep(j, i - 1) if(b[i] > b[j]) ans ++;
		if(ans != a[i]) return ;
	}
	rep(i, n) printf("%d%c", b[i], i == n ? '\n' : ' ');
}

void find(int x){
	if(x == n){pd(); return ;}
	REP(i, 0, n - 1){
		if(flag[i]) continue;
		flag[i] = 1; b[x + 1] = i;
		find(x + 1);
		flag[i] = 0;
	}
}

int main(){
	op = read(), n = read();
	rep(i, n) a[i] = read();
	if(op == 1){
		int ans = 0;
		rep(i, n){ ans = 0;
			rep(j, i - 1) if(a[i] > a[j]) ans ++;
			printf("%d%c", ans, i == n ? '\n' : ' ');
		}
	}
	else {
		clr(flag, 0);
		find(0);
	}
    system("pause");
    return 0;
}