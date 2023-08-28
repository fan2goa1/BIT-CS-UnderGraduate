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

struct rec{
	int x, y, z, id;
	rec(){}
	rec(int x, int y, int z, int id):x(x), y(y), z(z), id(id){}
}a[MAXN];
int n, b[5];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

bool cmp(rec a, rec b){
	if(a.y == b.y && a.z == b.z) return a.x < b.x;
	else if(a.y == b.y) return a.z < b.z;
	return a.y < b.y;
}

int main(){
	n = read();
	rep(i, 1, n){
		rep(j, 1, 3) b[j] = read();
		sort(b + 1, b + 3 + 1);
		a[i] = rec(b[1], b[2], b[3], i);
	}
	int ans = 0, id1 = 0, id2 = 0;
	sort(a + 1, a + n + 1, cmp);
	int nowy = 0, nowz = 0, maxx = 0, nowid = 0;
	rep(i, 1, n){
		if(nowy == a[i].y && nowz == a[i].z){
			int tmp = min(a[i].y, min(a[i].z, maxx + a[i].x));
			if(ans < tmp){ans = tmp; id1 = nowid; id2 = a[i].id;}
		}
		maxx = a[i].x; nowid = a[i].id;
		nowy = a[i].y; nowz = a[i].z;
	}
//	printf("%d %d %d\n", ans, id1, id2);
	int opt = 2;
	rep(i, 1, n){
		if(ans < a[i].x){
			opt = 1;
			ans = a[i].x;
			id1 = a[i].id;	
		}
	}
	printf("%d\n", opt);
	if(opt == 1) printf("%d\n", id1);
	else printf("%d %d\n", id1, id2);
	return 0;
}
