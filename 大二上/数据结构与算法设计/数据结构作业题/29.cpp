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

const int MAXN = 1e6 + 15;

int s[MAXN], t[MAXN], ans = 0, tmp = 0;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	int n = read();
	rep(i, 1, n) s[i] = read(), t[i] = read();
	sort(s + 1, s + n + 1); sort(t + 1, t + n + 1);
	int l = 1, r = 1;
	while(l <= n && r <= n){
		if(s[l] < t[r]){
			tmp ++; ans = max(ans, tmp);
			l ++;
		}
		else if(s[l] > t[r]){
			tmp --;
			r ++;
		}
		else {l ++; r ++;}
	}
	printf("%d\n", ans);
	return 0;
}
