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

int a[55], gg[100015], cc = 0;

int read(){
    int r = 0, z = 1; char ch = getchar();
    while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
    while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
    return r * z;
}

int cmp_int(const void *_a, const void *_b){int *a = (int*)_a, *b = (int*)_b; return *a - *b;}

int ay[115], am[115], cnt = 0;

int main(){ 
    int i, sum = 0, x, y = 0, z[13] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    scanf("%d", &x);
    REP(i, 1900, x - 1){
        if((i % 4 == 0 && i % 100 != 0) || i % 400 == 0) y = (y + 366) % 7;
        else y = (y + 365) % 7;
    }
    if((x % 4 == 0 && x % 100 != 0) || x % 400 == 0) z[1] = 29;
    for(i = 0; i < 11; i ++){ 
        if((sum + 13 + y) % 7 == 5) ay[++ cnt] = i + 1, am[cnt] = 13;
        sum += z[i];
    }
    printf("There %s %d Black %s in year %d.\n", cnt > 1 ? "are" : "is", cnt, cnt > 1 ? "Fridays" : "Friday", x);
    if(cnt > 1) puts("They are:");
    else puts("It is:");
    rep(i, cnt) printf("%d/%d/%d\n", x, ay[i], am[i]);
    system("pause");
    return 0;
}