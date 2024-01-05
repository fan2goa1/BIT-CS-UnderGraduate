#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
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

int cmp_int(const void *_a, const void *_b){int *a = (int*)_a, *b = (int*)_b; return *a - *b;}
int cmp_char(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return *a - *b;}
int cmp_string(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return strcmp(a, b);}

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

int main(){
    char ch1[115], ch2[115];
    int a[115], b[115];
    scanf("%s%s", ch1 + 1, ch2 + 1);
    int n = strlen(ch1 + 1), m = strlen(ch2 + 1), s = 1, t = 1;
    rep(i, n){
    	if(ch1[i] >= '0' && ch1[i] <= '9') a[i] = ch1[i] - '0';
    	else a[i] = 10 + ch1[i] - 'A';
    	s = max(s, a[i]);
    }
    rep(i, m){
    	if(ch2[i] >= '0' && ch2[i] <= '9') b[i] = ch2[i] - '0';
    	else b[i] = 10 + ch2[i] - 'A';
    	t = max(t, b[i]);
    }
    int ans1 = 100, ans2 = 100;
    REP(k, s + 1, 36){
    	REP(l, t + 1, 36){
    		int mul = 1, num1 = 0, num2 = 0;
    		REP_(i, n, 1){num1 += (mul * a[i]); mul *= k;}
            mul = 1;
            REP_(i, m, 1){num2 += (mul * b[i]); mul *= l;}
            if(num1 == num2){printf("%s (base %d) = %s (base %d)\n", ch1 + 1, k, ch2 + 1, l); return 0;}
    	}
    }
    printf("%s is not equal to %s in any base 2..36\n", ch1 + 1, ch2 + 1);
    system("pause");
    return 0;
}