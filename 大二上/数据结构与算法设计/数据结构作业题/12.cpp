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

const int MAXN = 5e4 + 15;

int num[MAXN], cpot[MAXN], n, m, k, now[MAXN];
struct mar{int x, y, z;}t[MAXN], ans[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read(), m = read(), k = read();
	rep(i, 1, k){
		t[i].x = read();
		t[i].y = read();
		t[i].z = read();
		num[t[i].y] ++;
	}
	rep(i, 1, m) cpot[i] = cpot[i - 1] + num[i - 1];
	rep(i, 1, m){cpot[i] ++; now[i] = cpot[i];}
	rep(i, 1, k){
		int tmp = now[t[i].y];
		ans[tmp].x = t[i].y; ans[tmp].y = t[i].x; ans[tmp].z = t[i].z;
		now[t[i].y] ++;
	}
	printf("num:");
	rep(i, 1, m) printf("%d,", num[i]); puts("");
	printf("cpot:");
	rep(i, 1, m) printf("%d,", cpot[i]); puts("");
	rep(i, 1, k) printf("%d,%d,%d\n", ans[i].x, ans[i].y, ans[i].z);
	return 0;
}
