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

int a[15] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
int b[15] = {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
int c[15] = {0, 3, 4, 5, 1, 2};

int main(){
	int y = read(), m = read(), d = read();
	int yy = 2012, mm = 4, dd = 9, q = 1, cnt = 0;
	while(!(yy == y && mm == m && dd == d)){
		dd ++; q ++; q %= 7;
		if(q == 1) cnt ++;
		if(yy % 400 == 0 || (yy % 100 != 0 && yy % 4 == 0)){
			if(dd > b[mm]){mm ++; dd = 1;}
		}
		else {
			if(dd > a[mm]){mm ++; dd = 1;}
		}
		if(mm > 12){mm = 1; yy ++;}
	}
	cnt /= 13;
	if(q == 0 || q == 6){puts("Free."); return 0;}
	q -= cnt; while(q <= 0) q += 5;
	printf("%d and %d.\n", c[q], (c[q] + 5) % 10);
	system("pause");
	return 0;
 }