#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "math.h"

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

int inf = 1 << 29;
int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

int main(){
	char ch[115];
	scanf("%s", ch + 1);
	int n = strlen(ch + 1);
	int now = 0, z = 1, ma = -inf, mi = inf;
	rep(i, n){
		if(ch[i] == ',' || ch[i] == '='){
			ma = max(ma, now * z);
			mi = min(mi, now * z);
			now = 0;
			z = 1;
			continue;
		}
		if(ch[i] == '-' && ch[i + 1] >= '0' && ch[i + 1] <= '9') z = -1;
		else if(ch[i] >= '0' && ch[i] <= '9') now = now * 10 + ch[i] - '0';
		else {
			if(ch[i] == '+'){
				if(ma < 0) printf("(%d) + ", ma);
				else printf("%d + ", ma);
				if(mi < 0) printf("(%d) = %d\n", mi, ma + mi);
				else printf("%d = %d\n", mi, ma + mi);
			}
			if(ch[i] == '-'){
				if(ma < 0) printf("(%d) - ", ma);
				else printf("%d - ", ma);
				if(mi < 0) printf("(%d) = %d\n", mi, ma - mi);
				else printf("%d = %d\n", mi, ma - mi);
			}
			if(ch[i] == '*'){
				if(ma < 0) printf("(%d) * ", ma);
				else printf("%d * ", ma);
				if(mi < 0) printf("(%d) = %d\n", mi, ma * mi);
				else printf("%d = %d\n", mi, ma * mi);
			}
			if(ch[i] == '/'){
				if(!mi) puts("Error!");
				else {
					if(ma < 0) printf("(%d) / ", ma);
					else printf("%d / ", ma);
					if(mi < 0) printf("(%d) = %d\n", mi, ma / mi);
					else printf("%d = %d\n", mi, ma / mi);
				}
			}
			if(ch[i] == '%'){
				if(ma < 0) printf("(%d) %% ", ma);
				else printf("%d %% ", ma);
				if(mi < 0) printf("(%d) = %d\n", mi, ma % mi);
				else printf("%d = %d\n", mi, ma % mi);
			}
		}
	}
	system("pause");
	return 0;
}