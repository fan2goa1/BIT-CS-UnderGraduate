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

typedef struct Stu{
	int id;
	char name[55];
	struct Stu *next;
}student;

student *head;
int k; char ch[55], non[25] = " is not in LIST1.";

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	int n = read();
	student *p, *q;
	head = (student *)malloc(sizeof(student));
	head -> next = NULL;
	p = head;
	rep(i, 1, n){
		q = (student *)malloc(sizeof(student));
		q -> id = read();
		scanf("%s", q -> name);
		q -> next = NULL; 
		p -> next = q;
		p = q;
	}
	int m = read();
	if(!m){
		puts("the LIST2 is NULL.");
		return 0;
	}
	bool flag = 0, bh = 1;
	rep(i, 1, m){
		k = read(); scanf("%s", ch);
		p = head -> next;
		flag = 0;
		while(p != NULL){
		//	printf("p  : %d %s\n", p -> id,p -> name);
		//	printf("me : %d %s\n", k, ch);
			if(p -> id == k && !strcmp(p -> name, ch)){
				flag = 1;
				break;
			}
			p = p -> next;
		}
		if(!flag){
			strcat(ch, non);
			printf("%8d %15s\n", k, ch);
			bh = 0;
		}
	}
	if(bh == 1) puts("the records of LIST2 are all in the LIST1.");
	return 0;
}
