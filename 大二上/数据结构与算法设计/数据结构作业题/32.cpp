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

typedef struct BiTNode{
	int data;
	struct BiTNode *lc, *rc;
}BiTNode, *BiTree;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

BiTree find(BiTree p, int key){
	if(key < p -> data){
		if(p -> lc == NULL) return p;
		else return find(p -> lc, key);
	}
	else {
		if(p -> rc == NULL) return p;
		else return find(p -> rc, key);
	}
}

void print(BiTree p, int tg){
	if(p -> lc != NULL) print(p -> lc, tg + 1);
	rep(i, 1, tg) printf("    "); printf("%d\n", p -> data);
	if(p -> rc != NULL) print(p -> rc, tg + 1);
}

void print1(BiTree p){
	if(p -> lc != NULL) print1(p -> lc);
	printf(" %d", p -> data);
	if(p -> rc != NULL) print1(p -> rc);
}

int main(){
	int x = read();
	BiTree rt = (BiTree)malloc(sizeof(BiTNode));
	rt -> data = x;
	rt -> lc = NULL; rt -> rc = NULL;
	while(scanf("%d", &x) && x){
		BiTree p = find(rt, x);
        if(x < p -> data){
            p -> lc = (BiTree)malloc(sizeof(BiTNode));
            p -> lc -> data = x;
            p -> lc -> lc = p -> lc -> rc = NULL;
        }
        else{
            p -> rc = (BiTree)malloc(sizeof(BiTNode));
            p -> rc -> data = x;
			p -> rc -> lc = p -> rc -> rc = NULL;
        }
	}
	print(rt, 0); puts("");
	print1(rt); puts("");
	return 0;
}
