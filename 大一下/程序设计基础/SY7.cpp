#include <stdio.h>
#include <stdlib.h>
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

int main(){
	int n = read(); char ch = getchar();
	int now = ch - 'A'; now %= 26;
	rep(i, n){
		rep(j, n - i) printf(" ");
		int s = now;
		rep(j, i){
			printf("%c", (char)(s + 'A'));
			s ++; s %= 26;
		}
		s -= 2; s += 26; s %= 26;
		rep(j, i - 1){
			printf("%c", (char)(s + 'A'));
			s --; s += 26; s %= 26;
		}
		puts("");
		now ++; now %= 26;
	}
	return 0;
}
