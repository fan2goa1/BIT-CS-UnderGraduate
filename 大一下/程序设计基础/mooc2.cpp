#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int main(){
	int a[25];
	for(int i = 1; i < 10; i ++) scanf("%d,", &a[i]); scanf("%d", &a[10]);
	int n; scanf("%d", &n);
	for(int i = 1; i <= 10 - n; i ++) a[10 + i] = a[i];
	for(int i = 10 - n + 1; i < 20 - n; i ++) printf("%d,", a[i]); printf("%d\n", a[20 - n]);
	return 0;
}