/* PRESET CODE BEGIN - NEVER TOUCH CODE BELOW */

#include <stdio.h>
#include <stdlib.h>

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

struct node  
{
	int data;  
    struct node * next;  
};  
  
typedef struct node NODE; 
typedef struct node * PNODE;
 
PNODE constructlist( PNODE head, int num );
void outlist( PNODE head );
void deleteneg( PNODE head ); 
  
int main ( )  
{   int num=1;  
    PNODE head;  
  
    head = (PNODE)malloc( sizeof(NODE) );  
    head->next = NULL;  
    head->data = -1;  
  
    while ( num!=0 )  
    {   scanf("%d", &num);  
        if ( num!=0 )  
           constructlist (head, num);  
    }  
    deleteneg( head );
    outlist( head );  
    return 0;  
}  
  
PNODE constructlist( PNODE head, int num )
{   PNODE p;
    p = (PNODE)malloc( sizeof(NODE) ); 
    p->data = num;
    p->next = head->next; 
    head->next = p;
    return head;
}

void outlist( PNODE head )  
{   PNODE p;  
    p = head->next;  
    while ( p != NULL )  
    {   printf("%d\n", p->data);  
        p = p->next;  
    }  
}  

void deleteneg(PNODE head){
	PNODE p = head -> next, q = head;
	while(p != NULL){
		if(p -> data < 0){
			q -> next = p -> next;
			p = p -> next;
		}
		else {
			p = p -> next; 
			q = q -> next;
		}
	}
}
