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

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

const int MAXN = 1e6 + 15;

char ch[MAXN];

int main(){
	bool flag = 1;
	while(gets(ch + 1)){
		int n = strlen(ch + 1);
		rep(i, 1, n){
			if(ch[i] == ' ' || ch[i] == ',' || ch[i] == '.' || ch[i] == '?' || ch[i] == '!'){
				printf("%c", ch[i]);
				if(ch[i] != ' ' && ch[i] != ',') flag = 1;
				continue;
			}
			if(flag){
				if(ch[i] >= 'A' && ch[i] <= 'Z') printf("%c", ch[i]);
				else if(ch[i] >= 'a' && ch[i] <= 'z') printf("%c", ch[i] - ('a' - 'A'));
				flag = 0;
			}
			else {
				if(ch[i] >= 'A' && ch[i] <= 'Z') printf("%c", ch[i] + ('a' - 'A'));
				else if(ch[i] >= 'a' && ch[i] <= 'z') printf("%c", ch[i]);
			}
		}
		puts("");
	}
	return 0;
}
