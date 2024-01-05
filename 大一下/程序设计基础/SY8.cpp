

#include <stdio.h>

int countsub( char *str, char *ss );

main( )
{
    char s1[1000] = {0}, s2[100] = {0};
    gets(s1);
    gets(s2);
    printf("%d\n", countsub( s1, s2 ) );
}

int countsub(char *str, char *ss){
	int n = 0, m = 0, cnt = 0, ans = 0;
	while(str[n] != '\0') n ++;
	while(ss[m] != '\0') m ++;
	for(int i = 0; i < n; i ++){
		cnt = 0;
		for(int k = 1; ; k ++){
			int flag = 1;
			for(int j = 0; j < m; j ++){
				if(str[i + m * (k - 1) + j] != ss[j]){flag = 0; break;}
			}
			if(!flag) break;
			cnt ++;
		}
		ans = ans > cnt ? ans : cnt;
	}
	return ans;
}