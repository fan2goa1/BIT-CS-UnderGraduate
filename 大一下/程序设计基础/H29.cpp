#include <stdio.h>
#include <string.h>
#define mp(a, b) make_pair(a, b)
#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

typedef long long LL;
typedef double DB;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

int main(){
	int a = 1, b = 10, n;
	while(1){
		char ch[15];
		n = read(); if(!n) break;
		gets(ch + 1);
		if(ch[1] == 't'){
			if(ch[5] == 'l') a = max(n + 1, a);
			else b = min(n - 1, b);
		}
		else {
			if(n >= a && n <= b) puts("Tom may be honest");
			else puts("Tom is dishonest");
			a = 1, b = 10;
		}
	}
	return 0;
}
