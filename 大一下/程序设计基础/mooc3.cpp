#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int main(){
	char ch[115];
	scanf("%s", ch + 1);
	int n = strlen(ch + 1);
	/*
	for(int i = 1; i <= n; i ++){
		if(ch[i] >= 'A' && ch[i] <= 'Z') ch[i] = 'a' + ch[i] - 'A';
	}
	*/
	int l, r, flag = 0;
	if(!((ch[n] >= 'a' && ch[n] <= 'z') || (ch[n] >= 'A' && ch[n] <= 'Z'))){n --; flag = 1;}
	if(n % 2){l = (n+1) / 2 - 1, r = (n+1) / 2 + 1;}
	else {l = n / 2, r = n / 2 + 1;}
	while(l >= 1 && r <= n){
//		if(r == n && (ch[r] > 'z' || ch[r] < 'a')) break;
//		if(ch[l] < 'a' || ch[l] > 'z' || ch[r] < 'a' || ch[r] > 'z'){l --, r ++; continue;}
		if(ch[l] > ch[r]){
			char p = ch[l]; ch[l] = ch[r]; ch[r] = p;
		}
		l --, r ++;
	}
	printf("%s\n", ch + 1);
	return 0;
}