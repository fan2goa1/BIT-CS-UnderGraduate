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

char a[MAXN], b[MAXN], c[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	int T = read();
	while(T --){
		scanf("%s%s", a + 1, b + 1);
		int n = strlen(a + 1), m = strlen(b + 1);
		rep(i, 1, n / 2) swap(a[i], a[n + 1 - i]);
		rep(i, 1, m / 2) swap(b[i], b[m + 1 - i]);
		int now = 0, cnt = max(n, m);
		rep(i, 1, cnt){
			int tmp1 = i > n ? 0 : a[i] - '0', tmp2 = i > m ? 0 : b[i] - '0';
			int tmp = tmp1 + tmp2 + now;
			now = tmp / 2; tmp %= 2;
			c[i] = tmp + '0';
		}
		if(now > 0){
		//	puts("111");
			c[++ cnt] = now + '0';
		}
		rep(i, 1, n / 2) swap(a[i], a[n + 1 - i]);
		rep(i, 1, m / 2) swap(b[i], b[m + 1 - i]);
		rep(i, 1, cnt / 2) swap(c[i], c[cnt + 1 - i]);
		rep(i, 1, cnt + 2 - n) printf(" ");
		rep(i, 1, n) printf("%c", a[i]); puts("");
		printf("+");
		rep(i, 1, cnt + 1 - m) printf(" ");
		rep(i, 1, m) printf("%c", b[i]); puts("");
		rep(i, 1, cnt + 2) printf("-"); puts("");
		printf("  ");
		rep(i, 1, cnt) printf("%c", c[i]); puts("");
	}
	return 0;
}
