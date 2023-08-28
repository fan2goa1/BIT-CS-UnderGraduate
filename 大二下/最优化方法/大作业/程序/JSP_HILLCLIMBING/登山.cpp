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
//�洢���Ž�ļӹ�˳��
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
		//���ȳ�ʼ��ans��arr��best1��worktime���� �Լ�ȫ������ʱ��time_best
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
		//���е�ɽ�㷨
		HillClimbing();
		clock_t end_time = clock();
		//���time_best�Ͷ�Ӧ�ļӹ�����
		cout << "time: " << time_best << endl;
		for (int i = 0; i < n; i++) cout << best1[i] << " ";
		cout << "The run time is: " << (double)(end_time - start_time) / CLOCKS_PER_SEC << "s" << endl;
	}
	return 0;
}

void HillClimbing() {
	//��ʼ���ӹ����� �޲�����Ϊ�����ʼ�� �в�����ΪNEH�Ż�
	initial();
	while (1) {
		//��������µ�ȫ������ ����ȫ������ʱ��time_best������best1
		if (time_current < time_best) {
			time_best = time_current;
			best1.assign(arr.begin(), arr.end());
			cout << "time_next: " << time_best << endl;
		}
		//���ӹ�ʱ�����ܽ���ʱ���������Դ��ڸ��Ž⣩ ѭ������
		if (!next()) break;
	}
}

//sumtimeΪ�����ܹ��ļӹ�ʱ�� numΪ������
struct work {
	int sumtime, num;
};
//sum�д��n����������Ϣ
vector<work> sum;

int compare(work a, work b) {
	return a.sumtime > b.sumtime;
}

//��ʼ���Ӽӹ����� �����Ż�
void initial() {
	//���μ���ӹ�����
	for (int i = 0; i < n; i++) arr[i] = i;
	int tmp = 100, tp1, tp2, p;
	while (tmp--) {
		//���ѡȡ������ͬ�Ĺ�������˳��
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
	//�����ʼ���еļӹ�ʱ��
	time_current = f(n);
	return;
}

//��ʼ���ӹ����� NEH�����Ż�
void initial(int i) {
	sum.resize(n);
	for (int i = 0; i < n; i++) {
		//��ʼ�� sum.sumtimeΪ0��������Ϊi
		sum[i].sumtime = 0;
		sum[i].num = i;
		//�ӵ�1̨������������n̨���� ������Ҫ�ļӹ�ʱ��
		for (int j = 0; j < m; j++)  sum[i].sumtime += worktime[i][j];
	}
	//��sumtime���н�������
	sort(sum.begin(), sum.end(), compare);

	int less, tmp;
	//��ans�������Ѿ�ȷ���ĳ�ʼ�����У�arr�����Ÿ�������
	//��ans�����в���sum���еĵ�һ������
	ans.push_back(sum[0].num);
	//���������β���ʣ�µ�n-1������
	for (int i = 1; i < n; i++) {
		//���Ѿ�ȷ�����������¸���arr���� Ȼ����arr����ĺ�˲�����һ��������
		arr.assign(ans.begin(), ans.end());
		arr.push_back(sum[i].num);

		less = 10000000;
		//ÿ��������i+1������λ�� ���α���ÿ������λ�� �õ�ʹ�ӹ�ʱ����С�Ĳ���λ��
		for (int j = 0; j < i + 1; j++) {
			//��������ӹ�����Ҫ��ʱ��
			tmp = f(i + 1);
			//�����lessС �������ans��
			if (tmp < less) {
				less = tmp;
				ans.assign(arr.begin(), arr.end());
			}
			//���ù����ļӹ�˳����ǰ��һλ
			if (i - j - 1 >= 0) {
				arr[i - j] = arr[i - j - 1];
				arr[i - j - 1] = sum[i].num;
			}
		}
	}
	//���õ��ĳ�ʼ���и���arr �� �����ʼ���е��ܼӹ�ʱ��
	arr.assign(ans.begin(), ans.end());
	time_current = f(n);
	return;
}

//�õ���һ����
int next() {
	//��������it�����ܽ�
	int it = n * (n - 1) / 2;
	//flag�洢�������Ƿ���ڸ��Ž�
	int tmpt, tmp, flag = 0;
	for (int i = 0; i < n; i++){
		for (int j = i + 1; j < n; j++) {
			//��������λ���ϵĹ����� ������ӹ�ʱ��
			tmp = arr[i];
			arr[i] = arr[j];
			arr[j] = tmp;
			tmpt = f(n);
			//������� �����ans���� ������flag=1
			if (tmpt < time_current) {
				flag = 1;
				time_current = tmpt;
				ans.assign(arr.begin(), arr.end());
			}
			//����ԭarr����
			else {
				arr.assign(ans.begin(), ans.end());
			}
		}
	}
	return flag;
}

//����arr�������t����������ʱ��
int f(int t) {
	for (int i = 0; i < m; i++) machine[i] = 0;
	for (int i = 0; i < t; i++) {
		//����ÿ������ �ӵ�һ̨���������һ̨�������α���
		for (int j = 0; j < m; j++) {
			//��һ�������ӹ���ʱ�������������ǰһ���������мӹ����������̼ӹ��ù���
			if (machine[j - 1] > machine[j]) machine[j] = machine[j - 1] + worktime[arr[i]][j];
			//��һ�������ӹ��꣬�������̼ӹ��ù���
			else machine[j] = machine[j] + worktime[arr[i]][j];
		}
	}
	//���һ��������ɼӹ���ʱ�� Ϊ �����ӹ���ʱ��
	return machine[m - 1];
}