/* PRESET CODE BEGIN - NEVER TOUCH CODE BELOW */

#include <stdio.h>
#include <stdlib.h>

typedef struct node
{   int         data;
    struct node * next;
} NODE;

void output( NODE *, int );
void change( int, int, NODE * );

void output( NODE * head, int kk )
{   int k=0;

	printf("0.");
	while ( head->next != NULL && k<kk )
	{   printf("%d", head->next->data );
		head = head->next;
		k ++;
	}
	printf("\n");
}

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

int main()
{   int n, m,k;
	NODE * head;

	scanf("%d%d%d", &n, &m, &k);
	head = (NODE *)malloc( sizeof(NODE) );
	head->next = NULL;
	head->data = -1;
	change( n, m, head );
	output( head,k );
	return 0;
}

/* PRESET CODE END - NEVER TOUCH CODE ABOVE */