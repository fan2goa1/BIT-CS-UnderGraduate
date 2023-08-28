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

struct plane{
	int id, arrtime, usetime;
	plane(){}
	plane(int id, int arrtime, int usetime):id(id), arrtime(arrtime), usetime(usetime){}
};
struct pl{
	int usedtime, sumtime;
	pl(){}
	pl(int usedtime, int sumtime):usedtime(usedtime), sumtime(sumtime){}
};

queue <plane> land;
queue <plane> takeoff;

int plnum, landtime, takeofftime, landtep = 0, takeofftep = 0;
int nowtime = 0, landsum = 0, takeoffsum = 0, landsumtime = 0, takeoffsumtime = 0;
pl p[5015];

inline int read(){
	int r = 0, z = 1; char ch = getchar();
	while(ch < '0' || ch > '9'){if(ch == '-') z = -1; ch = getchar();}
	while(ch >= '0' && ch <= '9'){r = r * 10 + ch - '0'; ch = getchar();}
	return r * z;
}

int main(){
	plnum = read(), landtime = read(), takeofftime = read();
	clr(p, 0);
//	printf("Current Time: %4d\n", nowtime);
	while(1){
		printf("Current Time: %4d\n", nowtime);
		bool is_empty = 1;
		rep(i, 1, plnum){
			if(p[i].usedtime){
				p[i].usedtime --;
				if(!p[i].usedtime) printf("runway %02d is free\n", i);
				else is_empty = 0;
			}
		}
	//	nowtime ++;
		if(landtep >= 0 && takeofftep >= 0){
			landtep = read(), takeofftep = read();
			rep(i, 1, landtep){
				landsum ++;
				plane x;
				x = plane(landsum, nowtime, landtime);
				land.push(x);
			}
			rep(i, 1, takeofftep){
				takeoffsum ++;
				plane x;
				x = plane(takeoffsum, nowtime, takeofftime);
				takeoff.push(x);
			}
		}
		if(takeofftep < 0 && landtep < 0 && land.empty() && takeoff.empty() && is_empty) break;
		rep(i, 1, plnum){
			if(!p[i].usedtime){
				plane x;
				if(!land.empty()){
					x = land.front();
					landsumtime += (nowtime - x.arrtime);
					land.pop();
					printf("airplane %04d is ready to land on runway %02d\n", x.id + 5000, i);
					p[i].usedtime = x.usetime;
					p[i].sumtime += x.usetime;
				}
				else if(!takeoff.empty()){
					x = takeoff.front();
					takeoffsumtime += (nowtime - x.arrtime);
					takeoff.pop();
					printf("airplane %04d is ready to takeoff on runway %02d\n", x.id, i);
					p[i].usedtime = x.usetime;
					p[i].sumtime += x.usetime;
				}
			}
		}
		nowtime ++;
	}
	double aver1 = 1.0 * landsumtime / landsum;
	double aver2 = 1.0 * takeoffsumtime / takeoffsum;
	double aver3;
    printf("simulation finished\n");
    printf("simulation time: %4d\n", nowtime);
    printf("average waiting time of landing: %4.1f\n", aver1);
    printf("average waiting time of takeoff: %4.1f\n", aver2);
    int sum = 0;
    rep(i, 1, plnum){
    	printf("runway %02d busy time: %4d\n", i, p[i].sumtime);
        sum += p[i].sumtime;
    }
    double avpl = 1.0 * sum / plnum;
    aver3 = 100.0 * avpl / nowtime;
    printf("runway average busy time percentage: %4.1f%%\n", aver3);
	return 0;
}
