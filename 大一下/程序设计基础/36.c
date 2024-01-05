#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
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

int cmp_int(const void *_a, const void *_b){int *a = (int*)_a, *b = (int*)_b; return *a - *b;}
int cmp_char(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return *a - *b;}
int cmp_string(const void *_a, const void *_b){char *a = (char*)_a, *b = (char*)_b; return strcmp(a, b);}

int max(int a, int b){return a > b ? a : b;}
int min(int a, int b){return a < b ? a : b;}

int main(){
    int n = read(), m = read();
    int a[115], b[115];
    rep(i, n) a[i] = read();
    rep(i, m) b[i] = read();
    qsort(a + 1, n, sizeof(a[0]), cmp_int);
    qsort(b + 1, m, sizeof(b[0]), cmp_int);
    int j = 1, ans = 0;
    rep(i, n){
        while(b[j] < a[i] && j <= m) j ++;
        if(j > m){puts("bit is doomed!"); return 0;}
        ans += b[j];
        j ++;
    }
    printf("%d\n", ans);
    system("pause");
    return 0;
}