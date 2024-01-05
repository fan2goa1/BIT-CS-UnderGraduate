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

int findf(int n){
	if(n >= 0 && n <= 4) return 1;
	if(n > 4 && n % 2 == 0) return findf(n - 1) + findf(n - 3);
	if(n > 4 && n % 2) return findf(n - 2) + findf(n - 4);
	return -1;
}

void swap(int a, int b){
	int c = b;
	b = a; a = c;
}

int main(){
	int n,s, findf( int n);  
    scanf("%d", &n);  
    s = findf(n);  
    printf("%d\n", s);
    
	system("pause");
	return 0;
 }