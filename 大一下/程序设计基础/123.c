#include<stdio.h>
#include<string.h>
#include <math.h>
#include <stdlib.h>

long long t[10][26]= {0};    //查表，将最简形式的编码事先准备好 
/*

行号：  0   1    2    3    4   ...   24   25 
列号：0 a    b    c    d    e    ...   y   z  
      1 ab   bc   cd   de   ef   ...   yz  zz
      2 abc  bcd  cde  efg  ghi  ...   xyz zzz
      3
      4
      ...
      9 abcdefghij  .....           qrstuvwxyz ...zzzzz
*/
void init_table()
{
    int i,j;
    for(i=0;i<26;i++)
    {
        t[0][i]=i+1;  //对应的是 a/b/c/.../z的编码是1-26; 
    }

    for(i=1;i<10;i++)
    {
        t[i][0]=t[i-1][25]+1;  //abc 总是等于上一行（降阶） yz  +1 
        for(j=1;j<26-i;j++)
        {
            t[i][j] =  t[i][j-1] + 1 + t[i-1][25] - t[i-1][j];
            //cde - bcd = byz + 1 - bcd = 1 + yz - cd 

        }
        for(j=26-i;j<26;j++)
        {
            t[i][j]=t[i][j-1]; //因为z2、y3这些不合法，所以无增加编码，都是和前面的最简式子一样的数 
        }

    }

    return;
}
long long  lookup(char *sNum)
{
    /*
    举例： 
    bdfxz = b4 - c3 + d3 - e2 + f2 - g1 +x1 - y0 +z0

    */
    long long ret =0;
    int i,j;
    char *p = sNum;
    int n = strlen(p);
    while(n>1)
    {
        i = n-1;
        j = *p - 'a';
        ret = (t[i][j] - t[i-1][j+1]) + ret;
        n--;
        p++;
    }
    ret += t[0][*p-'a'];

    return ret;

}
int main(void)
{
    int i,j,k;
    char s1[80]="vwxyz";
    //Soloe@csdn 欢迎转载，但请保留 
    init_table();

    int n;
    cin>>n;
    while(n>0)
        {
            cin>>s1;
            cout<<lookup(s1)<<endl;
        }
        system("pause");
    return 0;
//Soloe@csdn 欢迎转载，但请保留
}
