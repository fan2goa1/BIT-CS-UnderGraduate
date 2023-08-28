#include <bits/stdc++.h>

using namespace std;

typedef long long LL;
typedef double LF;
typedef pair<int, int> pii;

const int MAXN = 2e5 + 15;

int a[MAXN], b[MAXN], n, c[MAXN], need[MAXN];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	n = read(); memset(c, 0, sizeof(c)); memset(need, 0, sizeof(need));
	for(int i = 1; i <= n; i ++) a[i] = read();
	for(int i = 1; i <= n; i ++) b[i] = read();
	int maxc = 0, s = 0;
	for(int i = 1; i <= n; i ++){
		if(b[i]) c[b[i]] = i + 1 - b[i], need[b[i]] = i + 1;
		if(b[i] == 1) s = i;
	}
	for(int i = 1; i <= n; i ++) maxc = max(maxc, c[i]);
	if(!s) printf("%d\n", maxc + n);
	else {
		bool flag = 1;
		for(int i = 1; i <= n - s; i ++){
			if(b[s + i] != 1 + i){flag = 0; break;}
		}
		if(flag){
			bool ff = 1;
			for(int i = 1; i <= s - 1; i ++){
				if(need[n - s + 1 + i] > i){ff = 0; break;}
			}
			if(ff){
				printf("%d\n", s - 1);
			}
			else printf("%d\n", n + s);
		}
		else {
			printf("%d\n", maxc + n);
		}
	}
	return 0;
}
