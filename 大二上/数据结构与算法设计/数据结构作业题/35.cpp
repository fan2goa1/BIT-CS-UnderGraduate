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

int a[MAXN], n, cutoff = 5, median[MAXN], cnt = 0;

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int getmid(int l, int r){
	int mid = l + r >> 1;
	int tmp[4];
	tmp[1] = a[l]; tmp[2] = a[mid]; tmp[3] = a[r];
	sort(tmp + 1, tmp + 3 + 1);
	a[l] = tmp[1]; a[r] = tmp[2], a[mid] = tmp[3];
	return tmp[2];
}

void insert_sort(int l, int r){
	rep(i, l + 1, r){
		int tmp = a[i];
		int j;
		for(j = i - 1; j >= l && a[j] > tmp; j --) a[j + 1] = a[j];
		if(j != i - 1) a[j + 1] = tmp;
	}
}

void qsort(int l, int r){
//	printf("%d %d\n", l, r);
	if(cutoff > r - l){
		insert_sort(l, r);
		return ;
	}
	median[++ cnt] = getmid(l, r);
	int pivot = a[r];
	int i = l, j = r - 1;
	while(1){
		while(i < j && a[i] < pivot) i ++;
		while(i < j && a[j] > pivot) j --;
		if(i < j){
			swap(a[i], a[j]);
			i ++; j --;
		}
		else break;
	}
	if(a[i] >= pivot){
		a[r] = a[i];
		a[i] = pivot;
	}
	qsort(l, i - 1);
	qsort(i + 1, r);
}

int main(){
	int x;
	while(scanf("%d", &x)){
		a[++ n] = x;
	}
	qsort(1, n);
	puts("After Sorting:");
	rep(i, 1, n) printf("%d ", a[i]); puts("");
	puts("Median3 Value:");
	if(!cnt) puts("none");
	else {
		rep(i, 1, cnt) printf("%d ", median[i]);
		puts("");
	}
	return 0;
}
