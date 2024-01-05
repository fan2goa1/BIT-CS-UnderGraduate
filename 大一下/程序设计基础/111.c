#include<stdio.h>

struct node{int key1,key2;};

typedef struct node KK;

void swap(KK *x, KK *y){
	int h;
	h = x -> key1; x -> key1 = y -> key1; y -> key1 = h;
	h = x -> key2; x -> key2 = y -> key2; y -> key2 = h;
}

void sort(struct node a[],int l,int r){
	int i=l,j=r,mid=((l+r)>>1);
	struct node key=a[mid];
	do {
		while (key.key1<a[j].key1 || (key.key1==a[j].key1 && key.key2<a[j].key2)) j--;
		while (key.key1>a[i].key1 || (key.key1==a[i].key1 && key.key2>a[i].key2)) i++;
		if (i<=j){
			swap(&a[i],&a[j]);
			i++,j--;
		}
	} while (i<=j);
	if (l<j) sort(a,l,j);
	if (i<r) sort(a,i,r);
}
int N;
struct node a[200005];

int main(){
	scanf("%d",&N);
	for (int i=1;i<=N;i++) scanf("%d%d",&a[i].key1,&a[i].key2);
	sort(a, 1, N);
	for(int i = 1; i <= N; i ++) printf("%d %d\n", a[i].key1, a[i].key2);
	return 0;  
}