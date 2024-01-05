#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int main(){
	int n, m; 
	scanf("%d,%d", &n, &m);
	int ans = 0;
	for(int i = n; i <= m; i ++){
		int tt = sqrt(i);
		if(tt * tt == i) ans += i;
	}
	printf("%d\n", ans);
	return 0;
}