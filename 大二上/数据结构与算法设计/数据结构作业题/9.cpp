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

const int MAXN = 1e3 + 15;

int a[MAXN], b[MAXN], n, m;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	bool flag = 0;
	while(~scanf("%d%d", &n, &m) && n + m){
		if(flag) puts("");
		rep(i, 1, n) a[i] = i;
		while(m --){
			rep(i, 1, n) b[i] = read();
			stack <int> S;
			int l = 1, r = 1;
			while(r <= n){
				if(a[l] == b[r]){
					l ++;
					r ++;
				}
				else if(!S.empty() && S.top() == b[r]){
					r ++;
					S.pop();
				}
				else if(l <= n){
					S.push(a[l]);
					l ++;
				}
				else break;
			}
			if(S.empty()) puts("Yes");
			else puts("No");
		}
		flag = 1;
	}
	return 0;
}
