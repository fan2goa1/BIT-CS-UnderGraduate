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

int main(){
	int n; double m; int flag = 0;
	scanf("%lf%d", &m, &n);
	for(int i = 0; 18.3 * i <= m; i ++){
		for(int j = 0; 11.2 * j <= m; j ++){
			for(int k = 0; 9.8 * (k - 1) <= m; k ++){
				if(k == 25) printf("%.15lf\n", 1.0 * i * 18.3 + 1.0 * j * 11.2 + 1.0 * k * 9.8);
				if(1.0 * i * 18.3 + 1.0 * j * 11.2 + 1.0 * k * 9.8 == m && i + j + k == n){
					flag = 1;
					printf("%d %d %d\n", i, j, k);
				}
			}
		}
	}
	if(!flag) puts("Error!");
	system("pause");
	return 0;
 }