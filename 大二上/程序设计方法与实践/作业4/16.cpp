#include <iostream>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <map>
#include <queue>
#include <cstring>
#include <ctime>
#define mp(a, b) make_pair(a, b)
#define rep(i, x, y) for(LL i = x; i <= y; i ++)
#define rep_(i, x, y) for(LL i = x; i >= y; i --)
#define rep0(i,n) rep(i, 0, (n)-1)
#define repG(i, x) for(LL i = head[x]; i; i = g[i].nxt)
#define clr(x, y) memset(x, y, sizeof(x))
#define eps 0.0000000001

using namespace std;

typedef long long LL;
typedef double LF;
typedef pair<LL, LL> pii;

const LL MAXN = 5e5 + 15;

struct PoLL{LL x, y;}a[MAXN];
LL n;
priority_queue <LL, vector <LL>, less<LL> > q1, q3;
priority_queue <LL, vector <LL>, greater<LL> > q2, q4;
LL cnt1, cnt2, cnt3, cnt4;

inline LL read(){
	LL r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	LL T = read(), kase = 0;
	while(T --){ ++ kase; cnt1 = cnt2 = cnt3 = cnt4 = 0;
		while(!q1.empty()) q1.pop();
		while(!q2.empty()) q2.pop();
		while(!q3.empty()) q3.pop();
		while(!q4.empty()) q4.pop();
		LL nowx, nowy; LL ansx = 0, ansy = 0;
		n = read();
		rep(i, 1, n) scanf("%lld%lld", &a[i].x, &a[i].y);
		printf("Case: %lld\n", kase);
		puts("0.0000"); nowx = a[1].x, nowy = a[1].y;
		rep(i, 2, n){
			if(a[i].x > nowx) q2.push(a[i].x), cnt2 ++;
			else q1.push(a[i].x), cnt1 ++;
			ansx += abs(a[i].x - nowx);
			if(cnt1 - cnt2 == 2){
				LL tmp1 = q1.top();
				q1.pop(); q2.push(nowx);
				cnt1 --; cnt2 ++;
				ansx -= abs(nowx - tmp1);
				nowx = tmp1;
			}
			else if(cnt2 - cnt1 == 2){
				LL tmp2 = q2.top();
				q2.pop(); q1.push(nowx);
				cnt1 ++; cnt2 --;
				ansx -= abs(nowx - tmp2);
				nowx = tmp2;
			}
			
			
			if(a[i].y > nowy) q4.push(a[i].y), cnt4 ++;
			else q3.push(a[i].y), cnt3 ++;
			ansy += abs(a[i].y - nowy);
			if(cnt3 - cnt4 == 2){
				LL tmp3 = q3.top();
				q3.pop(); q4.push(nowy);
				cnt3 --; cnt4 ++;
				ansy -= abs(nowy - tmp3);
				nowy = tmp3;
			}
			else if(cnt4 - cnt3 == 2){
				LL tmp4 = q4.top();
				q4.pop(); q3.push(nowy);
				cnt3 ++; cnt4 --;
				ansy -= abs(nowy - tmp4);
				nowy = tmp4;
			}
		//	printf("%.2f %.2f\n", ansx, ansy);
		//	printf("%lld %lld\n", nowx, nowy);
		//	printf("%lld %lld\n\n", ansx, ansy);
			printf("%lld.0000\n", ansx + ansy);
		}
	}
	return 0;
}