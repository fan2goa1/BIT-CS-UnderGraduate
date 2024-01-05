#include <stdio.h>
#include <stdlib.h>

typedef struct numLink
{
	int no;
	struct numLink *next;
}NODE;

void movenode( NODE *head);

void SetLink( NODE *h, int n )
{
	NODE *p=NULL, *q=NULL;
	int i;
	for( i=0; i<n; i++)
	{
		p = (NODE *)malloc(sizeof(NODE));
		p->no = i+1;
		p->next = NULL;
		if( h->next == NULL )
		{
			h->next = p;
			q = p;
		}
		else
		{
			q->next = p;
			q = q->next;
		}
	}
	return;
}

int main( )
{
	int n;
	NODE *head=NULL, *q=NULL;
	scanf("%d",&n);

	head = (NODE *)malloc(sizeof(NODE));
	head->no = -1;
	head->next = NULL;

	SetLink( head, n );
	movenode( head );

	q = head;
    while (q->next){
   		printf("%d ",q->next->no);
        q = q->next;
	} 
	printf("\n");
	
	system("pause");
	return 0;
}

void movenode( NODE *head){
	if(head -> next == NULL) return ;
	NODE *p = head -> next -> next, *q = head -> next, *h = head;
	if(p == NULL || p -> next == NULL) return ;
	while(h -> next != NULL) h = h -> next;
	while(p -> no > q -> no && q -> no % 2){
	//	printf("%d %d\n", q -> no, p -> no);
		q -> next = p -> next;
		h -> next = p;
		q = p -> next;
		p -> next = NULL; h = p;
		p = q -> next;
	}
}

