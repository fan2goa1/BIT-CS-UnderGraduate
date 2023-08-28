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

const int MAXN = 1e4 + 15;

struct Edge{
	int to, nxt;
	Edge(){}
	Edge(int to, int nxt):to(to), nxt(nxt){}
}g[MAXN << 1];
int head[MAXN], cnt = 0, sta[MAXN], tot = 0, n = 0, win[MAXN], hmin[MAXN], hmax[MAXN];
char ch[MAXN];
map <char, int> mp;
map <int, char> mp2;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int isalpha(char c){return ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'));}
inline void add(int u, int v){g[++ cnt] = Edge(v, head[u]); head[u] = cnt;}

void dfs(int u){
	if(!head[u]){win[u] = 1; hmin[u] = hmax[u] = 1; return ;}
	win[u] = 1;
	repG(i, u){
		int v = g[i].to;
		dfs(v);
		if(win[v]) win[u] = 0;
		if(!hmin[u]) hmin[u] = hmin[v] + 1;
		else hmin[u] = min(hmin[u], hmin[v] + 1);
		if(!hmax[u]) hmax[u] = hmax[v] + 1;
		else hmax[u] = max(hmax[u], hmax[v] + 1);
	}
	return ;
}

int getans(int u){
	int ans = 0, mx = 0, mn = 100000000;
	repG(i, u){
		int v = g[i].to;
		if(win[v]){
			if(!ans){ans = v; mn = hmin[v];}
			else {
				if(mn == hmin[v]) ans = v;
				else if(mn > hmin[v]){ans = v; mn = hmin[v];}
			}
		}
	}
	if(ans) return ans;
	repG(i, u){
		int v = g[i].to;
		if(!ans){ans = v; mx = hmax[v];}
		else {
			if(mx == hmax[v]) ans = v;
			else if(mx < hmax[v]){ans = v; mx = hmax[v];}
		}
	}
	return ans;
}

int ask_player(int u){
	while(1){
		puts("player:");
		char s[5]; scanf("%s", s + 1);
		int t = mp[s[1]];
		int flag = 0;
		repG(i, u){
			int v = g[i].to;
			if(v == t){flag = 1; break;}
		}
		if(flag) return t;
		else puts("illegal move.");
	}
}

int main(){
	scanf("%s", ch + 1);
	int len = strlen(ch + 1), now = 0;
	rep(i, 1, len){
		if(ch[i] == '('){
			now ++;
		}
		else if(ch[i] == ')'){
			now --;
			tot --;
		}
		else if(isalpha(ch[i])){
			printf("%c\n", ch[i]);
			mp[ch[i]] = ++ n;
			mp2[n] = ch[i];
			add(sta[tot], n);
			sta[++ tot] = n;
		}
	}
	dfs(1);
	int flag = 1;
	while(flag){
		puts("Who play first(0: computer; 1: player )?");
		int non = read(), now = 1;
		if(non == 0){
			while(head[now]){
				now = getans(now);
				printf("computer: %c\n", mp2[now]);
				if(!head[now]){puts("Sorry, you lost."); break;}
				now = ask_player(now);
				if(!head[now]){puts("Congratulate, you win."); break;}
			}
		}
		else if(non == 1){
			while(head[now]){
				now = ask_player(now);
				if(!head[now]){puts("Congratulate, you win."); break;}
				now = getans(now);
				printf("computer: %c\n", mp2[now]);
				if(!head[now]){puts("Sorry, you lost."); break;}
			}
		}
		puts("Continue(y/n)?");
		char s[15]; scanf("%s", s + 1);
		if(s[1] == 'n') break;
	}
	return 0;
}
