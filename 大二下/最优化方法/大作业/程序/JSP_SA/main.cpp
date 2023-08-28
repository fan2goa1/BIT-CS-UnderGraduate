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
//存储全局最优解的加工顺序
vector<int> best1;
//time_current存储以ans数组为加工顺序的总加工时间
//time_next存储以arr数组为加工顺序的总加工时间
//time_best为全局最优解的总加工时间
int time_current, time_next, delta_time, time_best, time_start;
int machine[15];
int n, m;
double tmp, possibility;

void initial();
void SA();
void next();
int f(int);
void parameter_initial(double&, double&);
void parameter_update(double&, double&);

int main() {
	srand((unsigned)time(NULL));
	while (scanf_s("%d %d", &n, &m)) {
		//首先初始化ans、arr、best1、worktime数组 以及全局最优时间time_best
		ans.resize(0);
		arr.resize(0);
		best1.resize(n);
		time_best = 10000000;
		memset(worktime, sizeof(worktime), 0);
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < m; j++)  cin >> j >> worktime[i][j];
		}
		clock_t start_time = clock();
		//初始化加工序列
		initial();
		time_start = time_current;
		//运行模拟退火
		//it为迭代轮数
		int it = 1;
		while (it--) {
			SA();
			time_current = time_best;
			arr.assign(best1.begin(), best1.end());
			ans.assign(best1.begin(), best1.end());
		}
		//输出time_best和对应的加工序列
		clock_t end_time = clock();
		cout << "time: " << time_best << " timestart: " << time_start << endl << "arr: ";
		for (int i = 0; i < n; i++) cout << best1[i] << " ";
		cout << endl << "The run time is: " << (double)(end_time - start_time) / CLOCKS_PER_SEC << "s" << endl;
	}
	return 0;
}

//模拟退火算法
void SA() {
	//T为温度 a为学习率  初始化参数T和a
	double T, a;
	parameter_initial(T, a);
	//当T未降低到设定的温度时，循环继续
	while (T>1e-30) {
		//如果出现新的全局最优 更新全局最优时间time_best及数组best1
		if (time_current < time_best) {
			time_best = time_current;
			best1.assign(arr.begin(), arr.end());
			cout << "-------------next------------" << endl;
			cout << "time_next: " << time_best << "  T: " << T << endl;
		}
		//搜索下一个解
		next();
		//下一个解所用时间time_next小于当前时间time_current 直接更新时间及ans数组
		if (time_next < time_current) {
			time_current = time_next;
			ans.assign(arr.begin(), arr.end());
		}
		//下一个解所用时间time_next大于当前时间time_current
		else{
			//通过公式计算接受更劣解的概率
			delta_time = time_next - time_current;
			possibility = exp(-delta_time / T);
			//随机一个[0,1]的小数
			tmp = ((double)(rand() % 10001)) / 10000.0;
			//如果随机数小于等于概率 接受更劣解 并更新ans数组
			if (tmp <= possibility) {
				time_current = time_next;
				ans.assign(arr.begin(), arr.end());
				cout << "-------------next------------" << endl;
				cout << "time_next: " << time_best << "  T: " << T << endl;
			}
			//否则还原arr数组
			else arr.assign(ans.begin(), ans.end());
		}
		//更新参数
		parameter_update(T, a);
	}
}

//初始化加工序列
void initial() {
	//先按顺序插入
	for (int i = 0; i < n; i++) arr.push_back(i);
	int tmp = 100, tp1, tp2, p;
	//随机选取序列中不同的两项交换
	while (tmp--) {
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
	//计算初始加工时间
	time_current = f(n);
	return;
}

//参数初始化
void parameter_initial(double& T, double& a) {
	T = 1000;
	a = 0.999;
	return;
}

//参数更新
void parameter_update(double& T, double& a) {
	T = T * a;
	return;
}

//得到下一个解
void next() {
	int tmp1, tmp2, tmp;
	//直到随机出不同的数字才停止随机
	while (1) {
		tmp1 = rand() % n;
		tmp2 = rand() % n;
		if (tmp1 != tmp2) break;
	}
	//交换两个工件的加工顺序 并 计算交换后序列的总加工时间
	tmp = arr[tmp1];
	arr[tmp1] = arr[tmp2];
	arr[tmp2] = tmp;
	time_next = f(n);
	return;
}

//根据arr数组计算t个工件所需时间
int f(int t){
	for (int i = 0; i < m; i++) machine[i] = 0;
	for (int i = 0; i < t; i++) {
		//对于每个工件 从第一台机器到最后一台机器依次遍历
		for (int j = 0; j < m; j++) {
			if (j == 0) machine[j] += worktime[arr[i]][j];
			//上一个工件加工完时，这个工件还在前一个机器进行加工，不能立刻加工该工件
			else if (machine[j - 1] > machine[j]) machine[j] = machine[j - 1] + worktime[arr[i]][j];
			//上一个工件加工完，可以立刻加工该工件
			else machine[j] += worktime[arr[i]][j];
		}
	}
	//最后一个机器完成加工的时间 为 工件加工总时间
	return machine[m - 1];
}
