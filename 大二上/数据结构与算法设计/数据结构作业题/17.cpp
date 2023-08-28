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

using namespace std;

typedef long long LL;
typedef double LF;
typedef pair<int, int> pii;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

typedef struct Node{ 
	char data; 
	struct Node *l; 
    struct Node *r; 
}btree;

char s[10015];
int leafnum = 0;

void build_tree(btree *& T, char pre[], int &n){
	char ch = pre[++ n];
	if(ch != '#'){
		T = (btree *)malloc(sizeof(btree));
		T -> data = ch;
		build_tree(T -> l, s, n);
		build_tree(T -> r, s, n);
	}
	else T = NULL;
}

void print_tree(btree *root, int rk){
	if(root == NULL) return ;
	rep(i, 1, rk) printf("    ");
	printf("%c\n", root -> data);
	print_tree(root -> l, rk + 1);
	print_tree(root -> r, rk + 1);
	return ;
}


void printperorder(btree* head){  
    if(head == NULL) return ;  
    printf("%c",head -> data);  
    printperorder(head -> l);  
    printperorder(head -> r);  
    return ;  
}  
  
void printinorder(btree* head){
    if(head == NULL) return ;  
    printinorder(head -> l);  
    printf("%c", head -> data);  
    printinorder(head -> r);  
    return ;  
}  
  
void printpostorder(btree* head){  
    if(head == NULL)  return ;  
    printpostorder(head -> l);  
    printpostorder(head -> r);  
    printf("%c", head -> data);  
    return ;  
}  

void getleaf(btree* head){  
    if(head -> l == NULL && head -> r == NULL) leafnum ++;  
    if(head -> l != NULL) getleaf(head -> l);  
    if(head -> r != NULL) getleaf(head -> r);  
    return ;  
}  

void swap_tree(btree *root){
	if(root == NULL) return ;
	swap_tree(root -> l);
	swap_tree(root -> r);
	btree *p = root -> l;
	root -> l = root -> r;
	root -> r = p;
}

int main(){
	scanf("%s", s + 1);
	int len = strlen(s + 1), n = 0;
	btree *root;
	build_tree(root, s, n);
	
	puts("BiTree");
	print_tree(root, 0);
	
	printf("pre_sequence  : ");  
    printperorder(root);  
    printf("\n");  
    printf("in_sequence   : ");  
    printinorder(root);  
    printf("\n");  
    printf("post_sequence : ");  
    printpostorder(root);  
    printf("\n");
    
    getleaf(root);  
    printf("Number of leaf: %d\n", leafnum);
    
    swap_tree(root);
    puts("BiTree swapped");
    print_tree(root, 0);
    
    printf("pre_sequence  : ");  
    printperorder(root);  
    printf("\n");  
    printf("in_sequence   : ");  
    printinorder(root);  
    printf("\n");  
    printf("post_sequence : ");  
    printpostorder(root);  
    printf("\n");
	return 0;
}
