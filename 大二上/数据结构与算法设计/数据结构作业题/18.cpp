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

char a[1015], b[1015];

typedef struct Node{
    char data;
    struct Node *l;
    struct Node *r;
    struct Node *next;
}btree;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void build_tree(btree *&root, int m, int n, int p, int q){
	char in = b[q];
	int pos, flag = 0;
	rep(i, m, n){
		if(a[i] == in){
			pos = i;
			flag = 1;
			break;
		}
	}
	if(flag == 0){root = NULL; return ;}
	root = (btree *)malloc(sizeof(btree));
	root -> data = a[pos];
	if(pos == m && pos == n) root -> l = root -> r = NULL;
	else if(pos == m){
		root -> l = NULL;
		build_tree(root -> r, m + 1, n, p, q - 1);
	}
	else if(pos == n){
		build_tree(root -> l, m, n - 1, p, q - 1);
		root -> r = NULL;
	}
	else {
		build_tree(root -> l, m, pos - 1, p, p + pos - m - 1);
		build_tree(root -> r, pos + 1, n, p + pos - m, q - 1);
	}
}

btree *head = NULL, *tail = NULL;

void push(btree *p){
	tail -> next = p;
	p -> next = NULL;
	tail = tail -> next;
}

void pop(){
	head -> next = head -> next -> next;
	if(head -> next == NULL) tail = head;
}

int main(){
	scanf("%s%s", a + 1, b + 1);
	int n = strlen(a + 1);
	btree *root;
	build_tree(root, 1, n, 1, n);
	head = (btree *)malloc(sizeof(btree));
	head -> next = NULL; tail = head;
	if(root != NULL) push(root);
	while(head -> next != NULL){
		btree *p = head -> next; pop();
		putchar(p -> data);
		if(p -> l) push(p -> l);
		if(p -> r) push(p -> r);
	}
	puts("");
	return 0;
}
