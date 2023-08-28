#include<iostream>
#include<vector>
#include<ctime>
#include<cmath>
#include<algorithm>
#include <windows.h>
using namespace std;

//�洢����ʱ��
int worktime[50][15];
//�洢�����ӹ�˳��
vector<int> arr;
vector<int> ans;
//�洢ȫ�����Ž�ļӹ�˳��
vector<int> best1;
//time_current�洢��ans����Ϊ�ӹ�˳����ܼӹ�ʱ��
//time_next�洢��arr����Ϊ�ӹ�˳����ܼӹ�ʱ��
//time_bestΪȫ�����Ž���ܼӹ�ʱ��
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
		//���ȳ�ʼ��ans��arr��best1��worktime���� �Լ�ȫ������ʱ��time_best
		ans.resize(0);
		arr.resize(0);
		best1.resize(n);
		time_best = 10000000;
		memset(worktime, sizeof(worktime), 0);
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < m; j++)  cin >> j >> worktime[i][j];
		}
		clock_t start_time = clock();
		//��ʼ���ӹ�����
		initial();
		time_start = time_current;
		//����ģ���˻�
		//itΪ��������
		int it = 1;
		while (it--) {
			SA();
			time_current = time_best;
			arr.assign(best1.begin(), best1.end());
			ans.assign(best1.begin(), best1.end());
		}
		//���time_best�Ͷ�Ӧ�ļӹ�����
		clock_t end_time = clock();
		cout << "time: " << time_best << " timestart: " << time_start << endl << "arr: ";
		for (int i = 0; i < n; i++) cout << best1[i] << " ";
		cout << endl << "The run time is: " << (double)(end_time - start_time) / CLOCKS_PER_SEC << "s" << endl;
	}
	return 0;
}

//ģ���˻��㷨
void SA() {
	//TΪ�¶� aΪѧϰ��  ��ʼ������T��a
	double T, a;
	parameter_initial(T, a);
	//��Tδ���͵��趨���¶�ʱ��ѭ������
	while (T>1e-30) {
		//��������µ�ȫ������ ����ȫ������ʱ��time_best������best1
		if (time_current < time_best) {
			time_best = time_current;
			best1.assign(arr.begin(), arr.end());
			cout << "-------------next------------" << endl;
			cout << "time_next: " << time_best << "  T: " << T << endl;
		}
		//������һ����
		next();
		//��һ��������ʱ��time_nextС�ڵ�ǰʱ��time_current ֱ�Ӹ���ʱ�估ans����
		if (time_next < time_current) {
			time_current = time_next;
			ans.assign(arr.begin(), arr.end());
		}
		//��һ��������ʱ��time_next���ڵ�ǰʱ��time_current
		else{
			//ͨ����ʽ������ܸ��ӽ�ĸ���
			delta_time = time_next - time_current;
			possibility = exp(-delta_time / T);
			//���һ��[0,1]��С��
			tmp = ((double)(rand() % 10001)) / 10000.0;
			//��������С�ڵ��ڸ��� ���ܸ��ӽ� ������ans����
			if (tmp <= possibility) {
				time_current = time_next;
				ans.assign(arr.begin(), arr.end());
				cout << "-------------next------------" << endl;
				cout << "time_next: " << time_best << "  T: " << T << endl;
			}
			//����ԭarr����
			else arr.assign(ans.begin(), ans.end());
		}
		//���²���
		parameter_update(T, a);
	}
}

//��ʼ���ӹ�����
void initial() {
	//�Ȱ�˳�����
	for (int i = 0; i < n; i++) arr.push_back(i);
	int tmp = 100, tp1, tp2, p;
	//���ѡȡ�����в�ͬ�������
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
	//�����ʼ�ӹ�ʱ��
	time_current = f(n);
	return;
}

//������ʼ��
void parameter_initial(double& T, double& a) {
	T = 1000;
	a = 0.999;
	return;
}

//��������
void parameter_update(double& T, double& a) {
	T = T * a;
	return;
}

//�õ���һ����
void next() {
	int tmp1, tmp2, tmp;
	//ֱ���������ͬ�����ֲ�ֹͣ���
	while (1) {
		tmp1 = rand() % n;
		tmp2 = rand() % n;
		if (tmp1 != tmp2) break;
	}
	//�������������ļӹ�˳�� �� ���㽻�������е��ܼӹ�ʱ��
	tmp = arr[tmp1];
	arr[tmp1] = arr[tmp2];
	arr[tmp2] = tmp;
	time_next = f(n);
	return;
}

//����arr�������t����������ʱ��
int f(int t){
	for (int i = 0; i < m; i++) machine[i] = 0;
	for (int i = 0; i < t; i++) {
		//����ÿ������ �ӵ�һ̨���������һ̨�������α���
		for (int j = 0; j < m; j++) {
			if (j == 0) machine[j] += worktime[arr[i]][j];
			//��һ�������ӹ���ʱ�������������ǰһ���������мӹ����������̼ӹ��ù���
			else if (machine[j - 1] > machine[j]) machine[j] = machine[j - 1] + worktime[arr[i]][j];
			//��һ�������ӹ��꣬�������̼ӹ��ù���
			else machine[j] += worktime[arr[i]][j];
		}
	}
	//���һ��������ɼӹ���ʱ�� Ϊ �����ӹ���ʱ��
	return machine[m - 1];
}
