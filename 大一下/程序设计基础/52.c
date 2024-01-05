#include <stdio.h>
#include <stdlib.h> 

int main(){
	int n; char c;
	scanf("%d %c", &n, &c);
	if(n == 1){printf("%c\n", c); return 0;}
	int tmp1 = (int)(c - 'A'); int tmp2 = (tmp1 + 3 * (n - 1) + 26 * n) % 26;
	printf("%c", c); for(int i = 1; i <= 2 * (2 * (n - 1) - 1) + 1; i ++) printf(" ");
	printf("%c\n", c);
	for(int i = 2; i < n; i ++){
		tmp1 = (tmp1 + 1) % 26;
		tmp2 = (tmp2 - 1 + 26) % 26;
		printf("%c", tmp2 + 65);
		for(int j = 1; j <= 2 * (i - 2) + 1; j ++) printf(" ");
		printf("%c", tmp1 + 65);
		for(int j = 1; j <= 2 * (2 * n - 1 - 2 * i) + 1; j ++) printf(" ");
		printf("%c", tmp1 + 65);
		for(int j = 1; j <= 2 * (i - 2) + 1; j ++) printf(" ");
		printf("%c", tmp2 + 65);
		puts("");
	}
	for(int i = 1; i <= n - 1; i ++){
		tmp2 = (tmp2 - 1 + 26) % 26;
		printf("%c ", tmp2 + 65);
	}
	for(int i = 1; i <= n; i ++){
		tmp1 = (tmp1 + 1) % 26;
		printf("%c%c", tmp1 + 65, i == n ? '\n' : ' ');
	}
	system("pause");
	return 0;
}


