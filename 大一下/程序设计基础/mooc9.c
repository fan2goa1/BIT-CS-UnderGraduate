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

struct pp{char ch[25]; int cnt;}a[105];

typedef struct pp PP;

int cmp(const void *aa, const void *bb){
	PP *a = (PP *)aa, *b = (PP *)bb;
	if(b -> cnt != a -> cnt) return b -> cnt - a -> cnt;
}

int main(){
	int n = read();
	char cc[115];
	rep(i, n){
		scanf("%s", cc);
		int j = 0;
		while(cc[j] != ','){a[i].ch[j] = cc[j]; j ++;}
		j ++; a[i].ch[j] = '\0';
		while(j < strlen(cc)){a[i].cnt = a[i].cnt * 10 + cc[j] - '0'; j ++;}
	}
	rep(i, n){
		rep(j, n - i){
			if(a[j].cnt < a[j + 1].cnt){
				char ccc[115];
				strcpy(ccc, a[j].ch);
				strcpy(a[j].ch, a[j + 1].ch);
				strcpy(a[j + 1].ch, ccc);
				int p = a[j].cnt; a[j].cnt = a[j + 1].cnt; a[j + 1].cnt = p;
			}
		}	}
	rep(i, n){
		printf("%s,%d\n", a[i].ch, a[i].cnt);
	}
	system("pause");
	return 0;
 }