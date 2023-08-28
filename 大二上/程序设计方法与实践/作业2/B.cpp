#include <iostream>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <map>
#include <queue>
#include <cstring>
#include <ctime>
#include <cstdlib>
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

const int MAXN = 2e6 + 15;

unsigned char ch[MAXN];
int tot = 0, tg[MAXN];

inline void str_read(){
	char c = getchar();
	while(c != EOF){
		ch[++ tot] = c;
		c = getchar();
	}
}

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

map <int, int> mp;
map <int, int> cs;
char sa[30], sb[30], sc[30];

int main(){
//	freopen("2.in", "r", stdin);
//	freopen("1.out", "w", stdout);
	str_read();
	rep(i, 1, tot){
		int a = (int)ch[i], b, c, d;
		int tmp1 = a >> 7;
		if(!tmp1){
		//	printf("%c\n", ch[i]);
			continue;
		}
		if((a >> 5) == 6){
			b = (int)ch[i + 1];
//			itoa(a, sa, 2); itoa(b, sb, 2);
//			printf("%s %s\n", sa, sb);
			int a1 = a & 31, b1 = b & 63;
			int tmp = (a1 << 6) + b1;
			mp[tmp] ++; cs[tmp] = i;
			tg[i] = 2;
			i ++;
		}
		else if((a >> 4) == 14){
			b = (int)ch[i + 1]; c = (int)ch[i + 2];
//			itoa(a, sa, 2); itoa(b, sb, 2); itoa(c, sc, 2);
//			printf("%s %s %s\n", sa, sb, sc);
			int a1 = a & 15, b1 = b & 63, c1 = c & 63;
			int tmp = (a1 << 12) + (b1 << 6) + c1;
			mp[tmp] ++; cs[tmp] = i;
			tg[i] = 3;
//			printf("%d\n", tmp);
			i += 2;
		}
		else if((a >> 3) == 30){
			b = (int)ch[i + 1]; c = (int)ch[i + 2]; d = (int)ch[i + 3];
			int a1 = a & 7, b1 = b & 63, c1 = c & 63, d1 = d & 63;
			int tmp = (a1 << 18) + (b1 << 12) + (c1 << 6) + d1;
			mp[tmp] ++; cs[tmp] = i;
			tg[i] = 4;
			i += 3;
		}
	}
	int maxn = 0;
	rep(i, 0, 70000){
		maxn = max(maxn, mp[i]);
	}
	if(maxn < 2){puts("No repeat!"); return 0;}
	rep(i, 0, 70000){
		if(mp[i] > 1){
			int tmp = cs[i]; //printf("%d %d %d\n", tmp, );
			if(tg[tmp] == 2) printf("%c%c 0x%04x %d\n", ch[tmp], ch[tmp + 1], i, mp[i]);
			else if(tg[tmp] == 3) printf("%c%c%c 0x%04x %d\n", ch[tmp], ch[tmp + 1], ch[tmp + 2], i, mp[i]);
			else if(tg[tmp] == 4) printf("%c%c%c%c 0x%04x %d\n", ch[tmp], ch[tmp + 1], ch[tmp + 2], ch[tmp + 3], i, mp[i]);
		}
	}
	return 0;
}
