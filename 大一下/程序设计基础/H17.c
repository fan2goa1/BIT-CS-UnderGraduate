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
	char ch[115];
	int sta[115], cnt = 0;
	gets(ch + 1);
	int n = strlen(ch + 1);
	for(int i = 1; i <= n; i ++){
		if(ch[i] < '0' || ch[i] > '9'){
			int b = sta[cnt]; cnt --;
			int a = sta[cnt]; cnt --;
			switch(ch[i]){
				case '+': sta[++ cnt] = a + b; break;
				case '-': sta[++ cnt] = a - b; break;
				case '*': sta[++ cnt] = a * b; break;
				case '/': sta[++ cnt] = a / b; break;
			}
			i ++;
		}
		else {
			int tmp = 0;
			while(ch[i] >= '0' && ch[i] <= '9'){tmp = tmp * 10 + ch[i] - '0'; i ++;}
			sta[++ cnt] = tmp;
		}
//		printf("%d\n", sta[cnt]);
	} printf("%d\n", sta[1]);
	system("pause");
	return 0;
 }