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

struct pp{
	char p[25], num[10005];
}a[1015];

typedef struct pp King;

int cmp(const void *_a, const void *_b){
	King *a = (King*)_a, *b = (King*)_b;
	int n = strlen(a -> num + 1);
	int m = strlen(b -> num + 1);
	if(n != m) return m - n;
	int flag = 1;
	rep(i, n){
		if(a -> num[i] != b -> num[i]) return b -> num[i] - a -> num[i];
	}
	return strcmp(a -> p, b -> p);
}

int main(){
	int n = read();
	rep(i, n){
		scanf("%s%s", a[i].p, a[i].num + 1);
	}
	qsort(a + 1, n, sizeof(a[0]), cmp);
	rep(i, n) printf("%s\n", a[i].p);
	system("pause");
	return 0;
 }