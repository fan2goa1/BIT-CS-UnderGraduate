/* PRESET CODE BEGIN - NEVER TOUCH CODE BELOW */

#include <stdio.h>
#include <string.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

struct nn
{  int no;   
   int num;   
};

typedef struct nn DATA;

int number( char * , DATA []);

int main( )
{   
   DATA b[100];  
   char sa[500];  
   int i, n;  
   gets( sa ); 
   n = number( sa, b ); 
   for ( i=1; i<=n; i++ ) 
       printf("%d %d\n", b[i].num, b[i].no ); 
   return 0;
}

int number(char *str, DATA ans[]){
	int m = strlen(str), n = 0;
	rep0(i, m){
		int now = 0;
		while(str[i] >= '0' && str[i] <= '9' && i < m){
			now = now * 10 + str[i] - '0';
			i ++;
		}
		ans[++ n].num = now;
	}
	rep(i, n){
		int pos = 0;
		REP(j, 1, i - 1){
			if(ans[j].num <= ans[i].num) pos ++;
		}
		REP(j, i + 1, n){
			if(ans[j].num < ans[i].num) pos ++;
		}
		ans[i].no = pos + 1;
	}
	return n;
}