反汇编结果：

![image-20221014115127661](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014115127661.png)

![image-20221014115142240](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014115142240.png)

x86-64传参规则：当参数个数<=6时，使用rdi，rsi，rdx，rcx，r8，r9

```c++
<phase_4>:
rsp -= 0x18
*(rsp + 0x8) = rax
eax = 0
rcx = (rsp + 0x4)
rdx = rsp
esi = 0x4025cf		(%d %d)
if(eax - 0x2 != 0){			// 说明输入的参数必须是2个
    call <explode_bomb>
}
if(*rsp - 0xe <= 0){		// 说明输入的第一个数 < 0xe = 14
    edx = 0xe
    esi = 0x0
    edi = *(rsp)
    call <func4>			// 相当于func4(*(rsp)（输入的第一个数）, 0x0, 0xe)
    if(eax - 0x3 != 0){		// 当eax==3时满足条件
        call <explode_bomb>
    }
    if(*(rsp + 0x4) - 0x3 == 0){	// 说明输入的第二个参数等于3
        retq
    }
}

<func4>: rdi = x, rsi = 0x0, rdx = 0xe
rsp -= 0x8
eax = edx - esi
ecx = esi + (((eax >> 0x1f) + eax) >> 1)
if(ecx > edi){
    edx = rcx - 0x1
    call <func4>
    eax *= 2;
    rsp += 0x8
    retq
}
else {
    eax = 0x0
    if(ecx < edi){
        esi = (rcx + 0x1)
        call <func4>
        eax = rax * 2 + 0x1
        rsp += 0x8
        retq
    }
    else {
        rsp += 0x8
        retq
    }
}
```

将func4函数写成C语言：

```c++
#include <bits/stdc++.h>

using namespace std;

int func4(int rdi, int rsi, int rdx){
	int rax = rdx - rsi;
	int rcx = rsi + (((rax >> 31) + rax) >> 1);
	if(rcx > rdi){
		rdx = rcx - 0x1;
		rax = func4(rdi, rsi, rdx);
		rax *= 2;
		return rax;
	}
	else {
		rax = 0x0;
		if(rcx < rdi){
			rsi = rcx + 0x1;
			rax = func4(rdi, rsi, rdx);
			rax = rax * 2 + 1;
			return rax;
		}
		else {
			return rax;
		}
	}
}

int main(){
	for(int i = 0; i <= 14; i ++){
		int ans = func4(i, 0x0, 0xe);
		cout << i << ": " << ans << endl;
	}
	return 0;
}
```

发现当x=12或13时，eax = 3。故答案为12 3或13 3