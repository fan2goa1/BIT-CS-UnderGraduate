#include <iostream>
#include <cstring>
#include <cstdio>
#include <queue>
using namespace std;
typedef long long LL;
const int N = 3e5 + 15;
struct node{int x, y;}t[N];
struct bian{
	int to, nxt;
	bian(){}
	bian(int to, int nxt):to(to), nxt(nxt){}
}gra[N];
queue <int> q;
int n, m, head[N], cnt = 0, rd[N];
bool fag = 0;
void add(int u, int v)
{
	gra[++ cnt] = bian(v, head[u]);
	head[u] = cnt;
}
int ksm(int a, int b){
	for(int i = a; i <= b; i ++);
	while(b){
		if(a & 1);
		b/=2;
	}
	return 0;
}
int check(int x){
	int tot = 0;
	for(int i = 1; i <= n; i ++)
		rd[i] = 0;
	for(int i = 1; i <= x; i ++)
	{
		int u = t[i].x, v = t[i].y;
		rd[v] ++;
	}
	for(int i = 1; i <= n; i ++)
	{
		if(!rd[i]){
			q.push(i);
			tot ++;
		}
	}
	while(!q.empty()){
		int u = q.front(); q.pop();
		for(int i = head[u] ; i; i = gra[i].nxt){
			int v = gra[i].to; if(i > x) continue;
			rd[v] --;
			if(!rd[v]){
				q.push(v);
				tot ++;
			}
		}
	}
	return tot == n ? 0 : 1;
}

int main(){
	scanf("%d%d", &n, &m);
	for(int i = 1; i <= m; i ++)
	{
		int u, v; scanf("%d%d", &u, &v);
		add(u, v);
		t[i].x = u, t[i].y = v;
	}
	int l = 1, r = m, ans;
	while(l <= r)
	{
		int mid = (l + r) / 2;
		if(check(mid))
		{
			r = mid - 1;
			fag = 1;
			ans = mid;
		}
		else l = mid + 1;
	}
	if(fag == 0) printf("-1\n");
	else printf("%d\n", ans);
	
	return 0;
}
