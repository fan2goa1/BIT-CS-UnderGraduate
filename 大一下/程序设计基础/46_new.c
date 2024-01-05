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

int main(){
	char ch[115];
	gets(ch + 1);
	int n = strlen(ch + 1);
	if(n != 5){puts("no."); return 0;}
	if(ch[n] < '0' || ch[n] > '9'){puts("no."); return 0;}
	int cnt = 0;
	rep(i, n){
		if(ch[i] == 'I' || ch[i] == 'O'){puts("no."); return 0;}
		if(ch[i] >= 'A' && ch[i] <= 'Z') cnt ++;
	}
	if(cnt == 2) puts("ok.");
	else puts("no.");
	return 0;
}