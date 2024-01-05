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

int cmp(const void *_a, const void *_b){
	int *a = (int*)_a, *b = (int*)_b;
	return *a - *b;
}

int a[11];
int b[11];
int flag = 0;

void pd(){
	int x = b[1] * 100 + b[2] * 10 + b[3];
	int y = b[4] * 100 + b[5] * 10 + b[6];
	int z = b[7] * 100 + b[8] * 10 + b[9];
//	printf("%d %d %d\n", x, y, z);
	if(y == 2 * x && z == 3 * x){
		flag = 1;
		printf("%d,%d,%d\n", x, y, z);
	}
}

void find(int x){
	if(x == 9){pd(); return ;}
	rep(i, 9){
		if(!a[i]){
			a[i] = 1;
			b[x + 1] = i;
			find(x + 1);
			a[i] = 0;
		}
	}
}

int main(){
	int m = read();
	a[m] = 1; b[1] = m; find(1);
	if(!flag) puts("0,0,0");
	system("pause");
	return 0;
 }