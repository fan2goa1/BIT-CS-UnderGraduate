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

const int MAXN = 1e3 + 15;

int hp[MAXN], n;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

void hp_modify(int x, int t){
	int i = x, j = i * 2, tmp = hp[i];
	while(j <= t){
		if(j < t && hp[j] < hp[j + 1]) j ++;
		if(tmp < hp[j]){
			hp[i] = hp[j];
			i = j;
			j = i * 2;
		}
		else break;
	}
	hp[i] = tmp;
	return ;
}

void heap_sort(){
	for(int i = n / 2; i; i --) hp_modify(i, n);
}

int main(){
	n = read();
	rep(i, 1, n) hp[i] = read();
	rep(t, 1, 3){
		heap_sort();
		rep(i, 1, n) printf("%d ", hp[i]); puts("");
		swap(hp[1], hp[n]); n --;
	}
	return 0;
}
