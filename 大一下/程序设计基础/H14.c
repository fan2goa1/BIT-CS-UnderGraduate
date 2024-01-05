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

char ch[115];

int main(){
	int T = read();
	while(T --){
		int a = 0, b = 0, c = 0, d = 0;
		gets(ch + 1);
		int n = strlen(ch + 1);
		if(n < 6){puts("Not Safe"); continue;}
		rep(i, n){
			if(ch[i] >= '0' && ch[i] <= '9') a = 1;
			else if(ch[i] >= 'a' && ch[i] <= 'z') b = 1;
			else if(ch[i] >= 'A' && ch[i] <= 'Z') c = 1;
			else d = 1;
		}
		int s = a + b + c + d;
		if(s == 1) puts("Not Safe");
		else if(s == 2) puts("Medium Safe");
		else puts("Safe");
	}
	return 0;
 }