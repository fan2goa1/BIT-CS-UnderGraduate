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

LL f[30][105], n;		//f[i][j]表示以'a'+i为开头，长度为j的最小字典序的串的序号
char ch[15];

void init(){
	rep0(i, 26) f[i][1] = 1ll * i + 1;
	REP(j, 2, 15){ f[0][j] = f[25][j - 1] + 1;
		rep(i, 26){
			f[i][j] = f[i - 1][j] + f[25][j - 1] - f[i][j - 1] + 1;
		}
		REP(i, 27 - j, 25) f[i][j] = f[i - 1][j];
	}
	/*
	rep(j, 2){
		rep0(i, 26) printf("%d ", f[i][j]);
		puts("");
	}
	*/
}

int pd(){
	REP(i, 2, n){
		if(ch[i] <= ch[i - 1]){
			puts("0");
			return 0;
		}
	}
	return 1; 
}

void getans(){
	LL ans = f[ch[1] - 'a'][n];
	REP(i, 2, n){
		ans += f[ch[i] - 'a'][n+1 - i] - f[ch[i - 1] - 'a' + 1][n+1 - i];
	}
	printf("%lld\n", ans);
}

int main(){
	int T = read();
	init();
	while(T --){
		scanf("%s", ch + 1);
		n = strlen(ch + 1);
		if(!pd()) continue;
		getans();
	}
	system("pause");
	return 0;
 }