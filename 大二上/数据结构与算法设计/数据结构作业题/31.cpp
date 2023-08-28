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

int a[MAXN], n;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read(); int gg;
	rep(i, 0, n - 1) a[i] = read();
	if(a[0] < a[n - 1]){gg = 1;} else gg = 0;
	int ansl, ansr, flag = 0;
	int l = 0, r = n - 1;
	while(l <= r){
		int mid = l + r >> 1;
		if(a[mid] == mid){ansl = mid; flag = 1; r = mid - 1;}
		else if(a[mid] < mid){
			if(gg) l = mid + 1;
			else r = mid - 1;
		}
		else {
			if(gg) r = mid - 1;
			else l = mid + 1;
		}
	}
	l = 0, r = n - 1;
	while(l <= r){
		int mid = l + r >> 1;
		if(a[mid] == mid){ansr = mid; flag = 1; l = mid + 1;}
		else if(a[mid] < mid){
			if(gg) l = mid + 1;
			else r = mid - 1;
		}
		else {
			if(gg) r = mid - 1;
			else l = mid + 1;
		}
	}
	if(!flag){puts("No ");}
	else {
		rep(i, ansl, ansr) printf("%d ", i); puts("");
	}
	return 0;
}
