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

struct TNode{
	char key;
	int lc, rc;
}node[215];
int k = 0, rt = 1;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void print_pre(int now){
	printf("%c", node[now].key);
	if(node[now].lc) print_pre(node[now].lc);
	if(node[now].rc) print_pre(node[now].rc);
}
void print_in(int now){
	if(node[now].lc) print_in(node[now].lc);
	printf("%c", node[now].key);
	if(node[now].rc) print_in(node[now].rc);
}
void print_post(int now){
	if(node[now].lc) print_post(node[now].lc);
	if(node[now].rc) print_post(node[now].rc);
	printf("%c", node[now].key);
}

void print(int now, int tg){
	if(node[now].rc) print(node[now].rc, tg + 1);
	rep(i, 1, tg) printf("    "); printf("%c\n", node[now].key);
	if(node[now].lc) print(node[now].lc, tg + 1);
}

int getheight(int now, int tg){
	if(!now) return tg - 1;
	int a = getheight(node[now].lc, tg + 1);
	int b = getheight(node[now].rc, tg + 1);
	return max(a, b);
}

void L(int now){
	TNode tmp1 = node[node[now].lc], tmp2 = node[now];
	int subtmp = node[now].lc;
	tmp2.lc = tmp1.rc;
	tmp1.rc = subtmp;
	node[now] = tmp1;
	node[subtmp] = tmp2;
}

void R(int now){
	TNode tmp1 = node[node[now].rc], tmp2 = node[now];
	int subtmp = node[now].rc;
	tmp2.rc = tmp1.lc;
	tmp1.lc = subtmp;
	node[now] = tmp1;
	node[subtmp] = tmp2;
}

void LR(int now){
	R(node[now].lc);
	L(now);
}

void RL(int now){
	L(node[now].rc);
	R(now);
}

void AVL_insert(char x, int fa, int now){
	if(!now){
		node[++ k].key = x;
		if(!fa) return ;
		if(x < node[fa].key) node[fa].lc = k;
		else node[fa].rc = k;
		return ;
	}
	if(x > node[now].key){
		AVL_insert(x, now, node[now].rc);
		int l = getheight(node[now].lc, 0);
		int r = getheight(node[now].rc, 0);
		if(abs(r - l) == 2){
			if(x > node[node[now].rc].key) R(now);
			else RL(now);
		}
	}
	else {
		AVL_insert(x, now, node[now].lc);
		int l = getheight(node[now].lc, 0);
		int r = getheight(node[now].rc, 0);
		if(abs(r - l) == 2){
			if(x < node[node[now].lc].key) L(now);
			else LR(now);
		}
	}
}

int main(){
	rep(i, 0, 205){
		node[i].key = '0';
		node[i].lc = node[i].rc = 0;
	}
	char ch[215];
	scanf("%s", ch + 1);
	int n = strlen(ch + 1);
	AVL_insert(ch[1], 0, 0);
	rep(i, 2, n) AVL_insert(ch[i], 0, 1);
	
	printf("Preorder: ");
	print_pre(rt); puts("");
	
	printf("Inorder: ");
	print_in(rt); puts("");
	
	printf("Postorder: ");
	print_post(rt); puts("");
	
	puts("Tree:");
	print(rt, 0);
	
	return 0;
}
