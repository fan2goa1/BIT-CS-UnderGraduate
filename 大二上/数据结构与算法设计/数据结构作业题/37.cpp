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

const int MAXN = 1e5 + 15;
const int inf = 2e9 + 7;

struct point{LF x, y;}a[MAXN], b[MAXN];
int n;

LF getdis(point a, point b){
	LF dist = (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
	return 1.0 * sqrt(dist);
}

bool cmpx(point a, point b){
	if(a.x != b.x) return a.x < b.x;
	return a.y < b.y;
}
bool cmpy(point a, point b){return a.y < b.y;}

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

LF find(int l, int r){
	if(l >= r) return inf;
	if(l + 1 == r) return getdis(a[l], a[r]);
	int mid = l + r >> 1;
	LF dist1 = find(l, mid), dist2 = find(mid + 1, r);
	LF d = min(dist1, dist2);
	int cnt = 0;
	rep(i, l, r){
		if(fabs(a[i].x - a[mid].x) <= d){b[++ cnt] = a[i];}
	}
	sort(b + 1, b + cnt + 1, cmpy);
	rep(i, 1, cnt){
		rep(j, i + 1, cnt){
			if(fabs(b[j].y - b[i].y) >= d) break;
			d = min(d, getdis(b[i], b[j]));
		}
	}
	return d;
}

int main(){
	while(scanf("%d", &n) && n > 0){
		rep(i, 1, n) scanf("%lf%lf", &a[i].x, &a[i].y);
		sort(a + 1, a + n + 1, cmpx);
		LF ans = find(1, n);
		printf("%.2lf\n", ans / 2.0);
	}
	return 0;
}
