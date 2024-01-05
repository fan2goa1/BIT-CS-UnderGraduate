#include<stdio.h>  
#include<stdlib.h>  

#define REP(i, x, y) for(int i = x; i <= y; i ++)
#define REP_(i, x, y) for(int i = x; i >= y; i --)
#define rep(i, n) REP(i, 1, n)
#define rep0(i,n) REP(i, 0, n-1)
#define repG(i, x) for(int i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))

typedef struct node    
{   int  data;    
    struct node * next;    
} NODE;    
    
void output( NODE * );    
void change( int, int, NODE * );    
    
void output( NODE * head )    
{   int k=0;    
    printf("0.");    
    while ( head->next != NULL && k<50 )    
    {   printf("%d", head->next->data );    
        head = head->next;    
        k ++;    
    }    
    printf("\n");    
}    
    
int main()    
{   int n,m;    
    NODE * head;   
    scanf("%d%d", &n, &m);    
    head = (NODE *)malloc( sizeof(NODE) );    
    head->next = NULL;    
    head->data = -1;    
    change( n, m, head );    
    //output( head );    
    return 0;    
}    
  
void change(int n,int m,NODE* head)  
{  
    int quotient[5015],remainder[5015],flag=0, s, t;  
    NODE *q,*p,*start;  
    quotient[1]=(n*10)/m;  
    remainder[1]=(n*10)%m;  
    REP(i,2, 1000){
        quotient[i]=(remainder[i-1]*10)/m;  
        remainder[i]=(remainder[i-1]*10)%m;  
        if(remainder[i] == 0) break;
        REP(j, 1, i - 1){
            if((quotient[i]==quotient[j])&&(remainder[i]==remainder[j]))  //发现循环节，跳出   
            {  
            	s = j, t = i - 1;
                flag=1;  
                break;  
            }  
        }  
        if(flag) break;  
    }                             //j为第一个循环节的头，i为第二个循环节的头   
    //printf("%d,%d\n",i,j);   
    if(!flag){
    	puts("ring=0");
    	puts("NULL");
    	exit(0);
    }
    printf("ring=%d\n", t - s + 1);
    REP(i, s, t){
    	printf("%d", quotient[i]);
    }puts("");
    /*
	for(k=j-1;k>=0;k--) //倒着放置循环节前的数字   
    {  
        if(k==j-1)  
        {  
            p=(NODE*)malloc(sizeof(NODE));  //p存放循环节前一个数字   
            p->next=head->next;  
            head->next=p;  
            p->data=quotient[k];   
        }  
        else  
        {  
            q=(NODE*)malloc(sizeof(NODE)); //q存放循环节前其他数字   
            q->next=head->next;  
            head->next=q;  
            q->data=quotient[k];  
        }  
          
    }  
    if(((quotient[j]==0)&&(quotient[i]==0)&&(i==j+1))==0)//判断是否是循环小数   
    {   
        start=(NODE*)malloc(sizeof(NODE));  
        if(j==0)  head->next=start;      //判断循环节前是否有数字   
        else p->next=start;  
        start->next=start;  
        start->data=quotient[j]; // 存放第一个循环节的头   
        for(g=i-1;g>j;g--) //倒着放置循环节后的数字   
        {  
            q=(NODE*)malloc(sizeof(NODE));  
            if(g==(i-1))    q->next=start;    //循环节自身头尾相连   
            else q->next=start->next;  
            start->next=q;  
            q->data=quotient[g];  
        }  
    } 
	*/    
}  