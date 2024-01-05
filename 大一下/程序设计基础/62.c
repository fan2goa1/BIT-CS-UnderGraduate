/* PRESET CODE BEGIN - NEVER TOUCH CODE BELOW */

#include <stdio.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

typedef struct buy
{  char  gname;
   int   sname;
   int   gprice;
} BUY;

int main( )
{  int i, j, n;
   int min, price[10][3];
   int findm( int n, int price[][3], BUY scheme[] );

   static BUY scheme[3]={ {'A', 0, 0}, {'B', 0, 0}, {'C', 0, 0} };

   scanf( "%d", &n );
   for( i = 0; i < n; i++ )
	for( j = 0; j < 3; j++ )
	   scanf( "%d", &price[i][j] );

   min = findm( n, price, scheme );

   printf("Total Money are : %d\nGoods-Name  Shop-Name  Goods-Price\n", min );
   for ( i=0; i < 3; i++ )
       printf("         %c:%10d%13d\n", scheme[i].gname, scheme[i].sname, scheme[i].gprice );
   return 0;
}

int findm(int n, int price[][3], BUY scheme[]){
   int ret = 100000000;
   rep0(i, n){
      rep0(j, n){
         rep0(k, n){
            if(i == j || i == k || j == k) continue;
            int sum = price[i][0] + price[j][1] + price[k][2];
            if(sum < ret){
               scheme[0].sname = i + 1; scheme[0].gprice = price[i][0];
               scheme[1].sname = j + 1; scheme[1].gprice = price[j][1];
               scheme[2].sname = k + 1; scheme[2].gprice = price[k][2];
               ret = sum;
            }
         }
      }
   }
   return ret;
}