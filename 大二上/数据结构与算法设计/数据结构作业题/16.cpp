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

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int now, flag, ans;

void getans(int n, int m){
	if(now > m || n <= 0) return ;
	int tmp = pow(2, now) - 1;
	if(n > tmp){
		ans += pow(2, now - 1);
		if(!flag) now ++;
		getans(n - tmp, m);
	}
	else if(n == tmp){
		ans += pow(2, now - 1);
		return ;
	}
	else if(n < tmp){
		now --;
		flag = 1;
		getans(n - 1, m);
	}
}

int main(){
	int T = read(), n, m;
	while(T --){
		n = read(), m = read();
		if(n < m + 1){puts("0"); continue;}
		else if(n == m + 1){puts("1"); continue;}
		n -= (m + 1);
		ans = 1; now = 1; flag = 0;
		getans(n, m);
		printf("%d\n", ans);
	}
	return 0;
}
