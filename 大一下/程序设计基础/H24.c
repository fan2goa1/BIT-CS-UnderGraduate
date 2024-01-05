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

int main(){
	char a[1015];
	scanf("%s", a + 1);
	char b[1015], ans[1015];
	gets(b + 1);
	int r = 0, z = 1, pp;
	rep(i, strlen(b + 1))
		if(b[i] == 'E' || b[i] == 'e'){pp = i; break;}
	REP(i, pp + 1, strlen(b + 1)){
		if(b[i] < '0' || b[i] > '9'){if(b[i] == '-') z = -1; continue;}
		r = r * 10 + b[i] - '0';
	}
	r *= z;
	int tmp = 0, tmp1; int n = strlen(a + 1);
	rep(i, n){
		if(a[i] == '.'){tmp = i; tmp1 = i; break;}
	}
	if(!tmp){
		a[n + 1] = '.'; tmp = n + 1; tmp1 = n + 1;
		REP(i, n + 2, n + 9) a[i] = '0';
		a[n + 10] = '\0';
		n = strlen(a + 1);
	}
	tmp += r; int cnt = 0;
	if(tmp < 2){
		ans[++ cnt] = '0'; ans[++ cnt] = '.';
		rep(i, 1 - tmp) ans[++ cnt] = '0';
		REP(i, 1, tmp1 - 1) ans[++ cnt] = a[i];
		REP(i, tmp1 + 1, n) ans[++ cnt] = a[i];
		rep(i, 8) ans[++ cnt] = '0';
	}
	else if(tmp >= n){
		REP(i, 1, tmp1 - 1) ans[++ cnt] = a[i];
		REP(i, tmp1 + 1, n) ans[++ cnt] = a[i];
		rep(i, tmp - n) ans[++ cnt] = '0';
		ans[++ cnt] = '.';
		rep(i, 8) ans[++ cnt] = '0';
	}
	else {
		REP(i, 1, tmp1 - 1) ans[++ cnt] = a[i];
		REP(i, tmp1 + 1, tmp) ans[++ cnt] = a[i];
		ans[++ cnt] = '.';
		REP(i, tmp + 1, n) ans[++ cnt] = a[i];
		rep(i, 8) ans[++ cnt] = '0';
	}
	int flag = 0, cc = 0;
	rep(i, cnt){
		printf("%c", ans[i]);
		if(ans[i] == '.') flag = 1;
		else if(flag) cc ++;
		if(cc == 8) break;

	} puts("");
	system("pause");
	return 0;
 }