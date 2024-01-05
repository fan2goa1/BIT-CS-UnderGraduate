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

int gcd(int a, int b){return !b ? a : gcd(b, a % b);}

int a[115][115], b[115][115];
int dx[15] = {0, -1, -1, -1, 0, 0, 1, 1, 1};
int dy[15] = {0, 1, 0, -1, 1, -1, 1, -1, 0};
char ch[115];

int main(){
	int n = read(), m = read(), cnt = 0;
	while(n && m){ ++ cnt;
		rep(i, n){ scanf("%s", ch + 1);
			rep(j, m){
				if(ch[j] == '.') a[i][j] = 0;
				else a[i][j] = 1;
			}
		}
		clr(b, 0);
		rep(i, n)
			rep(j, m){
				if(a[i][j]){b[i][j] = -1; continue;}
				rep(k, 8){
					int x = i + dx[k], y = j + dy[k];
					if(x < 1 || x > n || y < 1 || y > m) continue;
					b[i][j] += a[x][y];
				}
			}
		printf("Field #%d:\n", cnt);
		rep(i, n){
			rep(j, m) printf("%c", b[i][j] == -1 ? '*' : '0' + b[i][j]);
			puts("");
		}
		n = read(), m = read();
		if(n && m) puts("");
	}
	system("pause");
	return 0;
 }