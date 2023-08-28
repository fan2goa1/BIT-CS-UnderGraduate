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
	int flag;
	struct Node *lc;
	struct Node *rc;
}btree;

char ch[100005];

int main(){
	int n = read();
	btree *tr, *p;
	tr = (btree*)malloc(sizeof(btree));
	tr -> flag = 0; tr -> lc = tr -> rc = NULL;
	int gg = 0;
	while(n --){
		scanf("%s", ch + 1);
		int len = strlen(ch + 1);
		p = tr;
		rep(i, 1, len){
			if(ch[i] == '1'){
				if(p -> lc == NULL){
					p -> lc = (btree*)malloc(sizeof(btree));
					p = p -> lc;
					p -> lc = p -> rc = NULL;
					if(i == len) p -> flag = 1;
					else p -> flag = 0;
				}
				else {
					if(p -> lc -> flag == 1 || i == len){gg = 1; break;}
					else p = p -> lc;
				}
			}
			else {
				if(p -> rc == NULL){
					p -> rc = (btree*)malloc(sizeof(btree));
					p = p -> rc;
					p -> lc = p -> rc = NULL;
					if(i == len) p -> flag = 1;
					else p -> flag = 0;
				}
				else {
					if(p -> rc -> flag == 1 || i == len){gg = 1; break;}
					else p = p -> rc;
				}
			}
		}
		if(gg) break;
	}
	if(!gg) puts("YES");
	else printf("%s\n", ch + 1);
	return 0;
}
