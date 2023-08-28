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

const int MAXN = 5e5 + 15;

int n, k, m, cc = 0, l[MAXN], r[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	scanf("%d,%d,%d", &n, &k, &m);
	if(n <= 0 || k <= 0 || m <= 0){puts("n,m,k must bigger than 0.");return 0;}
	if(k > n){puts("k should not bigger than n."); return 0;}
	int pos1, pos2, cnt = 0;
	rep(i, 1, n) l[i] = i - 1;
	rep(i, 1, n) r[i] = i + 1;
	l[1] = n; r[n] = 1;
	pos1 = l[k], pos2 = r[k];
	while(cnt < n){
		rep(i, 1, m) pos1 = r[pos1], pos2 = l[pos2];
		cnt ++;
		if(pos1 == r[pos2]) l[pos1] = l[pos2], r[pos2] = r[pos1];
		else if(pos1 == l[pos2]) r[pos1] = r[pos2], l[pos2] = l[pos1];
		int l1 = l[pos1], r1 = r[pos1];
		int l2 = l[pos2], r2 = r[pos2];
		r[l1] = r1; l[r1] = l1;
		if(pos1 == pos2) printf("%d,", pos1);
		else {
			cnt ++;
			r[l2] = r2; l[r2] = l2;
			printf("%d-%d,", pos1, pos2);
		}
	} puts("");
	return 0;
}
