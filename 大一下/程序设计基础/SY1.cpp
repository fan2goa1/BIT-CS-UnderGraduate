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
	char ch; int n = read(); scanf("%c", &ch);
	int s = ch - 'A'; s %= 26;
	int now = s + n - 1;
	if(n == 1){printf("%c\n", ch); return 0;}
	rep(j, n - 1) printf(" ");
	rep(j, n){
		now %= 26;
		printf("%c", (char)(now + 'A'));
		now ++; now = now % 26;
	} puts("");
	REP(i, 2, n - 1){
		rep(j, n - i) printf(" ");
		int l = (s + n - i) % 26;
		printf("%c", (char)(l + 'A'));
		rep(j, n + (i - 2) * 2) printf(" ");
		printf("%c", (char)(now + 'A'));
		now ++; now = now % 26;
		puts("");
	}
	rep(i, n * 3 - 2){
		printf("%c", (char)(s + 'A'));
		s ++; s = s % 26;
	}puts(""	);
	return 0;
}
