#include <stdio.h>
#include <stdlib.h>
int min(int a, int b){return a < b ? a : b;}
void reverse(char str[], int start, int end){
	end = min(end, strlen(str) - 1);
	if(start > strlen(str) - 1) return ;
	for(int i = start; i <= (start + end) >> 1; i ++){
		char p = str[i];
		str[i] = str[start + end - i];
		str[start + end - i] = p;
	}
}
int main( )
{	char str[100];
	int start, end;
	gets(str);
	scanf("%d%d", &start, &end);
	reverse( str, start, end );
	printf("%s\n", str);
	return 0;
}

