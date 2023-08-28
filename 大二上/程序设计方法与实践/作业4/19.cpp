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

const int MAXN = 2e5 + 15;

int a[MAXN], n, sta[MAXN], tot = 0, maxh;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	while(~scanf("%d", &n)){ tot = maxh = 0;
		bool flag = 1;
		rep(i, 1, n) a[i] = read(), maxh = max(maxh, a[i]);
		if(n == 1){puts("YES"); continue;}
		rep(i, 1, n){
			if(tot && sta[tot] == a[i]){
				tot --;
			}
			else {
				if(tot && a[i] > sta[tot]){flag = 0; break;}
				else sta[++ tot] = a[i];
			}
		}
		if(flag && tot == 0 || (tot == 1 && sta[tot] >= maxh)) puts("YES");
		else puts("NO");
	}
	return 0;
}
