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

const int MAXN = 515;

struct point{double x, y;};
point a[MAXN], b[MAXN], c;
int n, m, f[MAXN][MAXN][2];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

double cross(double x1, double y1, double x2, double y2){return (x1*y2-x2*y1);}
double compare(point a, point b, point c){return cross((b.x-a.x),(b.y-a.y),(c.x-a.x),(c.y-a.y));}
bool cmp(point a, point b){
    if(compare(c,a,b)==0)
        return a.x<b.x;
    else return compare(c,a,b)>0;
}
int main(){
	n = read(), m = read();
	rep(i, 1, n){
		scanf("%lf %lf", &a[i].x, &a[i].y);
	}
	rep(i, 1, m){
		scanf("%lf %lf", &b[i].x, &b[i].y);
	}
	clr(f, 0);
	rep(i, 1, n) f[i][0][0] = 1;
	rep(i, 1, m) f[i][0][1] = 1;
	rep(j, 1, 4){
		rep(i, 1, n){
			c.x = a[i].x; c.y = a[i].y;
			sort(b + 1, b + m + 1, cmp);
			rep(k, 1, m) f[i][j][0] |= f[k][j - 1][1];
		}
	}
	return 0;
}
