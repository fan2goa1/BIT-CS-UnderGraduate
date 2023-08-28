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

struct poly{int x, y;}a[MAXN], b[MAXN], c[MAXN], ans1[MAXN];
int n, m, k;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	int t = read();
	if(t == 0){puts("0"); return 0;}
	n = read();
	rep(i, 1, n) a[i].x = read(), a[i].y = read();
	m = read();
	rep(i, 1, m) b[i].x = read(), b[i].y = read();
	k = read();
	rep(i, 1, k) c[i].x = read(), c[i].y = read();
	if(!n) puts("<0,0>");
	else {
		printf("<%d,%d>", a[1].x, a[1].y);
		rep(i, 2, n) printf(",<%d,%d>", a[i].x, a[i].y);
		puts("");
	}
	if(!m) puts("<0,0>");
	else {
		printf("<%d,%d>", b[1].x, b[1].y);
		rep(i, 2, m) printf(",<%d,%d>", b[i].x, b[i].y);
		puts("");
	}
	if(!k) puts("<0,0>");
	else {
		printf("<%d,%d>", c[1].x, c[1].y);
		rep(i, 2, k) printf(",<%d,%d>", c[i].x, c[i].y);
		puts("");
	}
	int ca = 1, cb = 1, cc = 1;
	int cnt1 = 0, cnt2 = 0;
	while(ca <= n && cb <= m){
		if(a[ca].y < b[cb].y){
			ans1[++ cnt1].x = a[ca].x;
			ans1[cnt1].y = a[ca].y;
			ca ++;
		}
		else if(a[ca].y > b[cb].y){
			ans1[++ cnt1].x = b[cb].x;
			ans1[cnt1].y = b[cb].y;
			cb ++;
		}
		else {
			ans1[++ cnt1].x = a[ca].x + b[cb].x;
			ans1[cnt1].y = a[ca].y;
			ca ++; cb ++;
		}
	}
	while(ca <= n){
		ans1[++ cnt1].x = a[ca].x;
		ans1[cnt1].y = a[ca].y;
		ca ++;
	}
	while(cb <= m){
		ans1[++ cnt1].x = b[cb].x;
		ans1[cnt1].y = b[cb].y;
		cb ++;
	}
	bool flag = 0;
	rep(i, 1, cnt1){
		if(!ans1[i].x) continue;
		flag = 1;
		printf("<%d,%d>", ans1[i].x, ans1[i].y);
		if(i != cnt1) printf(",");
		else {
			puts("");
		}
	}
	if(!flag) puts("<0,0>");
	
	rep(i, 1, cnt1) a[i].x = ans1[i].x, a[i].y = ans1[i].y;
	n = cnt1;
	rep(i, 1, k) b[i].x = c[i].x, b[i].y = c[i].y;
	m = k;
	
	
	ca = 1, cb = 1; cnt1 = 0;
	while(ca <= n && cb <= m){
		if(a[ca].y < b[cb].y){
			ans1[++ cnt1].x = a[ca].x;
			ans1[cnt1].y = a[ca].y;
			ca ++;
		}
		else if(a[ca].y > b[cb].y){
			ans1[++ cnt1].x = b[cb].x;
			ans1[cnt1].y = b[cb].y;
			cb ++;
		}
		else {
			ans1[++ cnt1].x = a[ca].x + b[cb].x;
			ans1[cnt1].y = a[ca].y;
			ca ++; cb ++;
		}
	}
	while(ca <= n){
		ans1[++ cnt1].x = a[ca].x;
		ans1[cnt1].y = a[ca].y;
		ca ++;
	}
	while(cb <= m){
		ans1[++ cnt1].x = b[cb].x;
		ans1[cnt1].y = b[cb].y;
		cb ++;
	}
	flag = 0;
	rep(i, 1, cnt1){
		if(!ans1[i].x) continue;
		flag = 1;
		printf("<%d,%d>", ans1[i].x, ans1[i].y);
		a[i].x = ans1[i].x;
		a[i].y = ans1[i].y;
		if(i != cnt1) printf(",");
		else {
			
			puts("");
		}
	}
	if(!flag) puts("<0,0>");
	return 0;
}
