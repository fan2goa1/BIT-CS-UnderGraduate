#include <iostream>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <map>
#include <queue>
#include <cstring>
#include <ctime>
#include <stack>
#define mp(a, b) make_pair(a, b)
#define rep(i, x, y) for(int i = x; i <= y; i ++)
#define rep_(i, x, y) for(int i = x; i >= y; i --)
#define rep0(i,n) rep(i, 0, (n)-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))
#define eps 0.0000000001

typedef enum {ATOM, LIST}ListTag;

typedef struct node {
	ListTag  tag;
	union {
		char  data;
		struct node *hp;
	} ptr;
	struct node *tp;
} GLNode;

GLNode *reverse(GLNode *);
int count;

void Substring(char *sub, char *s, int pos, int len){
	s = s + pos;
	while ( len > 0 )
	{	*sub = *s;
		sub++;
		s++;
		len--;
	}
	*sub = '\0';
}

char list[1015];

void sever( char *str, char *hstr ){
    int n, i, k;
	char ch[50];
	n = strlen(str);
	i = k = 0;
	do
	{	Substring( ch, str, i++, 1 );
		if ( *ch=='(' )
			k ++;
		else if ( *ch==')' )
			k --;
	} while ( i<n && ( *ch!=',' || k!=0 ) );

	if ( i<n )
	{ 	Substring( hstr, str, 0, i-1 );
		Substring( str, str, i, n-i );
	}
	else
	{	strcpy( hstr, str );
		str[0] = '\0';
	}
}

int PrintGList( GLNode * T ){
	GLNode *p=T, *q;

	if ( p==NULL )
		printf( ")" );
	else
	{	if ( p->tag==ATOM )
		{ 	if ( count > 0 )
				printf( "," );
			printf( "%c", p->ptr.data );
			count ++;
		}
		else
		{	q = p->ptr.hp;
			if ( q == NULL )
			{	if ( count > 0 )
					printf(",");
				printf("(");
			}
			else if ( q->tag == LIST )
			{	if ( count > 0 )
					printf( "," );
				printf( "(" );
				count = 0;
			}
			PrintGList( q );
			PrintGList( p->tp );
		}
	}
	return 1;
}

void print( GLNode * L )
{
	if ( L == NULL )
		printf( "()" );
	else
	{
		if ( L->tag == LIST )
			printf( "(" );
		if ( L->ptr.hp != NULL )
			PrintGList( L );
		/*
		else
		{
			printf( "()" );
			if ( L->tp == NULL )
				printf( ")" );
		}
		*/
	}
	printf( "\n" );
}

int CreateGList( GLNode **L,  char *s){
	GLNode *p, *q;
	char sub[100],  hsub[100];

	p = *L;
	if ( strcmp(s, "()" )==0 )
		*L = NULL; 
	else
	{
		*L = ( GLNode * ) malloc( sizeof( GLNode ) );
		if ( strlen(s)==1 )
		{   (*L)->tag = ATOM;
			(*L)->ptr.data = s[0];
		}
		else
		{	(*L)->tag = LIST;
			p = *L;
			Substring( sub, s, 1, strlen(s)-2 );
			do
			{	sever( sub, hsub );
				CreateGList( &p->ptr.hp, hsub );
				q = p;
				if ( strlen(sub) > 0 )
				{	p = (GLNode *) malloc( sizeof(GLNode) );
					p->tag = LIST;
					q->tp = p;
				}
			} while ( strlen(sub)>0 );
			q->tp = NULL;
		} 
	} 
	return 1;
}

GLNode *GetHead(GLNode *L){
	L -> tp = NULL;
	return L -> ptr.hp;
}

GLNode *GetTail(GLNode *L){
	GLNode *G = L -> tp;
	L -> tp = NULL;
	return G;
}

int main(){
	GLNode *L;
	int d;
	count = 0;
	scanf("%s", list);
	CreateGList(&L, list);
	printf("generic list: ");
	count = 0;
	print(L);
	while(!(L == NULL || L -> tag == ATOM)){
		int opt;
		scanf("%d", &opt);
		if(opt == 1){
			puts("destroy tail");
			puts("free list node");
			printf("generic list: ");
			L = GetHead(L);
			count = 0;
			print(L);
		}
		else {
			puts("free head node");
			puts("free list node");
			printf("generic list: ");
			L = GetTail(L);
			count = 0;
			print(L);
		}
	}
	return 0;
}