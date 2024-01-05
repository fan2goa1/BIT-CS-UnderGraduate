/* PRESET CODE BEGIN - NEVER TOUCH CODE BELOW */

#include <stdio.h>
#include <stdlib.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

typedef struct sdata
{  int num;
   struct sdata *next;
} SNODE;

void movenode( SNODE *, int,int );

void setlink( SNODE * head, int n )
{   
	SNODE *p;

	while ( n > 0 )
	{   p = ( SNODE * ) malloc( sizeof( SNODE ) );
		p->num = n;
		p->next = head->next;
		head->next = p;
		n --;
	}
}

void outlink( SNODE * head )
{
	while( head->next != NULL )
	{
		head = head->next;
		printf( "%d,", head->num );
    }
	return;
}

int main( )
{   int n, m;
	SNODE * head = NULL;

	scanf("%d%d", &n, &m );
	head = ( SNODE * ) malloc( sizeof( SNODE ) );
	head->num = -1;
	head->next = NULL;
	setlink( head, n );

	movenode( head, n, m );   /* This is waiting for you. */

	outlink( head );
    printf("\n");
    return 0;
}

void movenode(SNODE *head, int n, int m){
	SNODE *p = head, *q = head -> next, *p1;
	if(m <= 1 || m > n) return ;
	rep(i, m){
		p = p -> next;
		if(i == m - 1) p1 = p;
	}
	head -> next = p; p1 -> next = p -> next;
	p -> next = q;
}