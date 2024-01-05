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

int cmp(const void *_a, const void *_b){
	int *a = (int*)_a, *b = (int*)_b;
	return *a - *b;
}

char *a[15];
int ans1[15], ans2[15];

int main(){
	int n = read();
	rep(i, n){
		a[i] = (char*) malloc (sizeof(char) * 15);
		gets(a[i]);
	}
	rep(i, n){
		char ch[15];
		scanf("%s", ch);
		int idx, idy;
		rep(j, n){
			if(strlen(ch) != strlen(a[j])) continue;
			int flag = 1;
			rep0(k, strlen(ch)) if(ch[k] != a[j][k]){flag = 0; break;}
			if(flag){idx = j; break;}
		}
		int sum = read(); int T = read();
		if(!T) continue;
		int x = sum / T;
		ans1[idx] = T * x;
		while(T --){
			char b[15];
			scanf("%s", b);
			rep(j, n){
				if(strlen(b) != strlen(a[j])) continue;
				int flag = 1;
				rep0(k, strlen(b)) if(b[k] != a[j][k]){flag = 0; break;}
				if(flag){idy = j; break;}
			}
			ans2[idy] += x;
		}
	}
	rep(i, n){
		printf("%s %d\n", a[i], ans2[i] - ans1[i]);
	}
	system("pause");
	return 0;
 }