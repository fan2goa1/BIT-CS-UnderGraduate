#include<iostream>
#include<vector>
#include<ctime>
#include<cmath>
#include<algorithm>
#include <windows.h>
using namespace std;

//存储工作时间
int worktime[50][15];
//存储工件加工顺序
vector<int> arr;
vector<int> ans;
//存储最优解的加工顺序
vector<int> best1;
int machine[15];
int n, m;
int time_current;
int time_best;

void initial();
void initial(int);
void HillClimbing();
int next();
int f(int);

int main() {
	int tmp;
	srand((unsigned)time(NULL));
	while (scanf_s("%d %d", &n, &m)) {
		//首先初始化ans、arr、best1、worktime数组 以及全局最优时间time_best
		ans.resize(0);
		arr.resize(n);
		best1.resize(n);
		time_best = 10000000;
		memset(worktime, sizeof(worktime), 0);
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < m; j++) {
				cin >> tmp;
				cin >> worktime[i][j];
			}
		}
		clock_t start_time = clock();
		//运行登山算法
		HillClimbing();
		clock_t end_time = clock();
		//输出time_best和对应的加工序列
		cout << "time: " << time_best << endl;
		for (int i = 0; i < n; i++) cout << best1[i] << " ";
		cout << "The run time is: " << (double)(end_time - start_time) / CLOCKS_PER_SEC << "s" << endl;
	}
	return 0;
}

void HillClimbing() {
	//初始化加工序列 无参数则为随机初始化 有参数则为NEH优化
	initial();
	while (1) {
		//如果出现新的全局最优 更新全局最优时间time_best及数组best1
		if (time_current < time_best) {
			time_best = time_current;
			best1.assign(arr.begin(), arr.end());
			cout << "time_next: " << time_best << endl;
		}
		//当加工时间仍能降低时（邻域中仍存在更优解） 循环继续
		if (!next()) break;
	}
}

//sumtime为工件总共的加工时间 num为工件号
struct work {
	int sumtime, num;
};
//sum中存放n个工件的信息
vector<work> sum;

int compare(work a, work b) {
	return a.sumtime > b.sumtime;
}

//初始化加加工序列 不带优化
void initial() {
	//依次加入加工序列
	for (int i = 0; i < n; i++) arr[i] = i;
	int tmp = 100, tp1, tp2, p;
	while (tmp--) {
		//随机选取两个不同的工件交换顺序
		tp1 = rand() % n;
		tp2 = rand() % n;
		while (tp1 == tp2) {
			tp1 = rand() % n;
			tp2 = rand() % n;
		}
		p = arr[tp1];
		arr[tp1] = arr[tp2];
		arr[tp2] = p;
	}
	ans.assign(arr.begin(), arr.end());
	//计算初始序列的加工时间
	time_current = f(n);
	return;
}

//初始化加工序列 NEH启发优化
void initial(int i) {
	sum.resize(n);
	for (int i = 0; i < n; i++) {
		//初始化 sum.sumtime为0，工件号为i
		sum[i].sumtime = 0;
		sum[i].num = i;
		//从第1台机器遍历到第n台机器 计算需要的加工时间
		for (int j = 0; j < m; j++)  sum[i].sumtime += worktime[i][j];
	}
	//按sumtime进行降序排序
	sort(sum.begin(), sum.end(), compare);

	int less, tmp;
	//用ans数组存放已经确定的初始化序列，arr数组存放各个尝试
	//向ans数组中插入sum序列的第一个工件
	ans.push_back(sum[0].num);
	//接下来依次插入剩下的n-1个工件
	for (int i = 1; i < n; i++) {
		//将已经确定的序列重新赋给arr数组 然后向arr数组的后端插入下一个工件号
		arr.assign(ans.begin(), ans.end());
		arr.push_back(sum[i].num);

		less = 10000000;
		//每个工件有i+1个插入位点 依次遍历每个插入位点 得到使加工时间最小的插入位点
		for (int j = 0; j < i + 1; j++) {
			//计算插入后加工所需要的时间
			tmp = f(i + 1);
			//如果比less小 则更新在ans中
			if (tmp < less) {
				less = tmp;
				ans.assign(arr.begin(), arr.end());
			}
			//将该工件的加工顺序往前推一位
			if (i - j - 1 >= 0) {
				arr[i - j] = arr[i - j - 1];
				arr[i - j - 1] = sum[i].num;
			}
		}
	}
	//将得到的初始序列赋给arr 并 计算初始序列的总加工时间
	arr.assign(ans.begin(), ans.end());
	time_current = f(n);
	return;
}

//得到下一个解
int next() {
	//邻域中有it个可能解
	int it = n * (n - 1) / 2;
	//flag存储邻域中是否存在更优解
	int tmpt, tmp, flag = 0;
	for (int i = 0; i < n; i++){
		for (int j = i + 1; j < n; j++) {
			//交换两个位置上的工件号 并计算加工时间
			tmp = arr[i];
			arr[i] = arr[j];
			arr[j] = tmp;
			tmpt = f(n);
			//如果更优 则更新ans数组 并设置flag=1
			if (tmpt < time_current) {
				flag = 1;
				time_current = tmpt;
				ans.assign(arr.begin(), arr.end());
			}
			//否则还原arr数组
			else {
				arr.assign(ans.begin(), ans.end());
			}
		}
	}
	return flag;
}

//根据arr数组计算t个工件所需时间
int f(int t) {
	for (int i = 0; i < m; i++) machine[i] = 0;
	for (int i = 0; i < t; i++) {
		//对于每个工件 从第一台机器到最后一台机器依次遍历
		for (int j = 0; j < m; j++) {
			//上一个工件加工完时，这个工件还在前一个机器进行加工，不能立刻加工该工件
			if (machine[j - 1] > machine[j]) machine[j] = machine[j - 1] + worktime[arr[i]][j];
			//上一个工件加工完，可以立刻加工该工件
			else machine[j] = machine[j] + worktime[arr[i]][j];
		}
	}
	//最后一个机器完成加工的时间 为 工件加工总时间
	return machine[m - 1];
}