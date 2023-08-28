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

const int MAXN = 3e5 + 15;

struct aa{int s, e;}a[MAXN];

bool cmp(aa x, aa y){return x.e < y.e;}

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	int n = read();
	rep(i, 1, n){
		a[i].s = read();
		a[i].e = read();
	}
	sort(a + 1, a + n + 1, cmp);
	int now = -1, ans = 0;
	rep(i, 1, n){
		if(a[i].s >= now){
			ans ++;
			now = a[i].e;
		}
	}
	printf("%d\n", ans);
	return 0;
}
