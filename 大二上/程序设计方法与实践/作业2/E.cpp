#include <iostream>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <map>
#include <queue>
#include <cstring>
#include <ctime>
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

const int MAXN = 1e5 + 15;

char ch[MAXN];
int n, m, l[MAXN], r[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read(); int ans = 0, cnt = 0;
	rep(i, 1, n){ int nowl = 0, nowr = 0;
		scanf("%s", ch + 1);
		int m = strlen(ch + 1);
		rep(j, 1, m){
			if(ch[j] == '(') nowl ++;
			else {
				if(!nowl) nowr ++;
				else nowl --;
			}
		}
		if(nowl && !nowr){
			if(r[nowl]){ans ++; r[nowl] --;}
			else l[nowl] ++;
		}
		else if(!nowl && nowr){
			if(l[nowr]){ans ++; l[nowr] --;}
			else r[nowr] ++;
		}
		else if(!nowl && !nowr) cnt ++;
	}
	ans += cnt / 2;
	printf("%d\n", ans);
	return 0;
}
