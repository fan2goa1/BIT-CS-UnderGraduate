/* PRESET CODE BEGIN - NEVER TOUCH CODE BELOW */

#include <stdio.h>
#include <stdlib.h>
typedef struct node
{   int         data;
    struct node * next;
} NODE;

NODE * find( NODE * , int * );
void outputring( NODE * );
void change( int , int , NODE * );
void outputring( NODE * pring )
{	NODE * p;
	p = pring;
	if ( p == NULL )
		printf("NULL");
	else
		do	{	printf("%d", p->data);
			p = p->next;
		} while ( p != pring );
	printf("\n");
	return;
}

int main()
{   int n, m;
	NODE * head, * pring;

	scanf("%d%d", &n, &m);
	head = (NODE *)malloc( sizeof(NODE) );
	head->next = NULL;
	head->data = -1;

	change( n, m, head );
	pring = find( head, &n );
	printf("ring=%d\n", n);
	outputring( pring );

	return 0;
}
NODE *st = NULL, *ed;
void change(int n, int m, NODE *head){
	NODE *p, *q, *p1, *q1;
	NODE *head1 = (NODE*) malloc (sizeof(NODE));
    int x, lst = 1; int flag = 0;
    p = head; p1 = head1; head1 -> next = NULL;
    while(!flag && lst){
    	NODE *now1 = head1, *now = head;
    	while(now1 -> next != NULL){
        	int n1 = now1 -> next -> data;
        	if(n1 == n){
        		p -> next = now -> next;
        		ed = p;
        		st = now -> next;
        		flag = 1;
        		break;
        	}
        	now = now -> next;
        	now1 = now1 -> next;
        }
    	if(flag) break;
    	q1 = (NODE *) malloc (sizeof(NODE));  
        q1 -> data = n; q1 -> next = NULL;
        p1 -> next = q1;
        p1 = q1;
        
        
        
        n *= 10;
        x = n / m;
		lst = n % m; 
        n -= x * m;
        q = (NODE *) malloc (sizeof(NODE));  
        q -> data = x; q -> next = NULL;
        p -> next = q;
        p = q;
    }  
}

NODE * find( NODE * head, int * n ){
	/*
	NODE *now = head -> next;
	int flag = 0;
	while(now != NULL){
		NODE *p = now; int cnt = 0;
		if(p -> next == p){*n = 1; flag = 1; return now;}
		p = p -> next;
		while(p != NULL){ cnt ++;
			if(p == now){
				*n = cnt;
				flag = 1;
				return now;
			}
			p = p -> next;
		}
		now = now -> next;
	}
	*/
	if(st == NULL){
		*n = 0;
		return NULL;
	}
	int cnt = 1;
	NODE *p = st;
	while(p != ed){
		cnt ++;
		p = p -> next;
	}
	*n = cnt;
	return st;
}