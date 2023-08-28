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

const int MAXN = 5e5 + 15;

char ch;
int T, n;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	scanf("%d", &T);
	getchar();
	while(T --){
		int ans1 = 0, ans2 = 0, now = 0;
		while((ch = getchar()) != '\n'){
			if(ch == '+'){
				now ++;
				ans1 = max(ans1, now);
			}
			else if(ch == '-'){
				now --;
				ans2 = min(ans2, now);
				//ans2 = max(ans2, abs(now));
			}
		}
		printf("%d\n", ans1 - ans2);
	}
	return 0;
}
