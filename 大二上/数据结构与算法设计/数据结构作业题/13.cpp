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

int n1, m1, k1, n2, m2, k2;
struct mar{
	int x, y, z;
}a[MAXN], b[MAXN], ans[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n1 = read(), m1 = read(), k1 = read();
	rep(i, 1, k1){
		a[i].x = read();
		a[i].y = read();
		a[i].z = read();
	}
	n2 = read(), m2 = read(), k2 = read();
	rep(i, 1, k2){
		b[i].x = read();
		b[i].y = read();
		b[i].z = read();
	}
	int cnt = 0;
	rep(i, 1, k1){
		rep(j, 1, k2){
			int x1 = a[i].x, y1 = a[i].y, z1 = a[i].z;
			int x2 = b[j].x, y2 = b[j].y, z2 = b[j].z;
			if(y1 == x2){
				int tmp = -1;
				rep(gg, 1, cnt){
					if(ans[gg].x == x1 && ans[gg].y == y2){tmp = gg; break;}
				}
				if(tmp == -1){tmp = ++ cnt; ans[cnt].z = 0;}
				ans[tmp].x = x1;
				ans[tmp].y = y2;
				ans[tmp].z += z1 * z2;
			}
		}
	}
	rep(i, 1, cnt){
		rep(j, i + 1, cnt){
			if(ans[j].x == ans[i].x){
				if(ans[i].y > ans[j].y){
					swap(ans[i].x, ans[j].x);
					swap(ans[i].y, ans[j].y);
					swap(ans[i].z, ans[j].z);
				}
			}
			else if(ans[i].x > ans[j].x){
				swap(ans[i].x, ans[j].x);
				swap(ans[i].y, ans[j].y);
				swap(ans[i].z, ans[j].z);
			}
		}
	}
	printf("%d\n%d\n%d\n", n1, m2, cnt);
	rep(i, 1, cnt) printf("%d,%d,%d\n", ans[i].x, ans[i].y, ans[i].z);
	return 0;
}
