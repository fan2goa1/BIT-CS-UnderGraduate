反汇编结果：

![image-20221014025157007](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014025157007.png)

![image-20221014025213341](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014025213341.png)

x /16 0x402440的结果：

![image-20221014025127674](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014025127674.png)

```c++
rsp -= 0x18
eax = 0
rcx = rsp + 0x4
rdx = rsp
esi = 0x4025cf	（%d %d）
call <sscanf>
if(eax - 0x1 <= 0) 	//eax存的是sccanf返回的参数个数，说明要求参数个数>1
	call <explode_bomb>
if(*rsp - 0x7 > 0)	// 第一个参数值<=7(网上说0x8(%rsp)才是第一个参数值，但是从实际汇编代码来看这里应该(%rsp)就是第一个参数值)
	call <explode_bomb>
eax = *rsp
跳转到0x402440 + rax * 8的位置(例如rax=1，跳转到上图中的0x400f35的位置)
if(rax == 0){
    eax = 0x121
}
if(rax == 1){
    eax = 0x235
}
if(rax == 2){
    eax = 0x1a7
}
if(rax == 3){
    eax = 0x22b
}
if(rax == 4){
    eax = 0x6c
}
if(rax == 5){
    eax = 0x2f1
}
if(rax == 6){
    eax = 0x3e
}
if(rax == 7){
    eax = 0x248
}
if(*(rsp + 0x4) - eax == 0)
    retq
```

所以这道题答案有多个，分别为：

0 289

1 565

2 423

3 555

4 108

5 753

6 62

7 584